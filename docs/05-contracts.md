# 05 — Contracts

What this document owns: every interface between two systems that can be
released independently. The mobile app and the backend meet here and nowhere
else.

What it does not own: what the systems do internally (`04`), the rules the data
represents (`01`), or how drift is caught (`08`).

**One rule above all others: the specification is the interface.** Neither side
reads the other's code, guesses a shape, or hand-writes a client. If two sides
disagree, the build fails before anyone runs the app.

---

## Authored, then generated

The distinction runs through this whole document:

```
AUTHORED — written by hand, reviewed, versioned
  contracts/http/public-v1.yaml
  contracts/http/admin-v1.yaml
  contracts/realtime/*.schema.json
  contracts/analytics/*.yaml
  contracts/config/*.schema.json
  contracts/content/*.schema.json
          │
          ▼  generate
GENERATED — never edited, regenerated on every change
  packages/api_client/          Dart, from public-v1
  packages/admin_api_client/    Dart, from admin-v1
  backend generated interfaces  Java, from both
  typed analytics and config accessors
```

Generator and round-trip proof uses separate authored specifications under
`contracts/fixtures/http/`. Their Java and Dart bindings exist only in test
build directories, and their controllers exist only in backend test source.
Fixture operations never enter either production specification, production
Spring component scanning, or the two production client packages.

<!-- agent-law:id=contracts.authored-vs-generated -->
Contracts are authored. **Bindings** are generated. Editing a generated file is
a build failure; editing a contract is a reviewed decision.
<!-- /agent-law -->

## Two HTTP surfaces, not one

`contracts/http/public-v1.yaml` is what the app uses.
`contracts/http/admin-v1.yaml` is what the moderation console uses.

<!-- agent-law:id=contracts.admin-separate -->
They are separate specifications generating separate clients, and the shipped
mobile binary is built **only** from the public one.
<!-- /agent-law --> The consequence is the
point: `banUser`, `reviewReport` and `viewEvidence` are not functions the app
declines to call — they do not exist inside the artefact at all. Security that
depends on "the endpoint exists but rejects you" is one authorisation bug away
from being no security.

Staff authentication is a separate realm from consumer authentication, with its
own roles and its own audit log. A user token can never reach an admin path,
because they are not the same kind of token.

**Both sides are generated from each specification.** The Dart client lands in
`packages/api_client`; the Java server implements generated interfaces, so a
controller whose signature has drifted from the specification does not compile.
Regenerating must produce no diff, and CI fails on one. **A generated file is
never edited by hand** — the edit survives until the next generation and then
vanishes, taking whatever depended on it with it.

The backend also validates its responses against the specification in tests.
Every direction is checked because each one alone can lie: a signature can match
while a body does not.

**Breaking changes are detected mechanically.** The specification on a branch is
compared against the one on main, and a removed field or a narrowed type fails
the build. "A field disappeared and nobody noticed" stops being a category of
mistake.

## Versioning

**Path-based major versions: `/v1/...`.**

Old app versions stay installed for months and a store update cannot be forced,
so running two generations side by side has to be trivial. Path routing also
makes logs, metrics, rollout and deprecation legible in a way a header does not.

Compatible additions stay in `v1`. A breaking change opens `v2`, and both run
until the old clients are gone. Within a major version: fields may be added,
never removed or repurposed; enums may gain members, so **clients must tolerate
an unknown enum value** rather than crashing on it.

## Shape

The domain is action-shaped in places and resource-shaped in others, and the
paths follow whichever is true rather than forcing one on the other. Verifying a
code is an action, not a resource; a profile is a resource.

Paths are lowercase and hyphenated. Actions read as what they do:
`/v1/auth/otp/verify`, not a contrived noun.

## Errors

Every error body is **machine-readable only**:

```json
{ "code": "AUTH_OTP_CODE_INVALID", "requestId": "..." }
```

plus `violations` for validation failures and `retryAt` for rate limits.

<!-- agent-law:id=contracts.no-backend-copy -->
**The backend never sends user-facing text.**
<!-- /agent-law --> Every string lives in slang, so a
message from the server would make a locale depend on a server release and would
arrive untranslated for anyone the backend did not anticipate. The client owns
what the person reads; the server owns what happened.

**Codes are stable within a major version.** Never renamed, never repurposed,
only added. The client needs to distinguish a wrong code from an exhausted
attempt limit from a banned number, and an HTTP status alone cannot carry that —
which is exactly the distinction that decides whether the app shows a retry, a
cooldown, or nothing at all.

**Disclosure order is part of the contract.** A ban is revealed only after a
submitted code is correct. Otherwise the endpoint becomes an oracle for
enumerating which numbers are banned, and the contract has leaked something the
product spent a whole safety document protecting.

Statuses stay conventional: 400 for malformed, 401 for authentication, 403 for
forbidden, 404 for missing, 409 for conflict, 429 for rate limits, 5xx for our
fault. **Nothing exotic** — an unusual status sends a generated client down a
branch nobody wrote.

## Idempotency

Any request that creates something and could be retried carries an idempotency
key: sending a message, creating a request, starting a purchase. A retry with
the same key returns the original result rather than creating a second thing.

Mobile networks retry. Without keys, a person on a lift ride sends the same
first message three times, and in a product where a first message is a
consequential act that is not a cosmetic bug.

## Real-time

WebSocket frames are part of the contract and are versioned in the repository
alongside the HTTP specification. A frame type is documented before it is sent.

The socket carries **delivery and typing**, not authority. Anything that matters
— that a message exists, that a request was created — is confirmed over HTTP.
A dropped socket must never lose data, only immediacy.

## Everything typed lives together

`contracts/` holds every boundary in the system, not only HTTP:

```
contracts/
├── http/         public-v1.yaml · admin-v1.yaml
├── realtime/     frame envelope and payload schemas
├── errors/       the code enumeration
├── analytics/    event definitions
├── config/       remote configuration schema
├── deep-links/   route definitions
└── content/      quiz, interest and taxonomy schemas
```

Each is validated in CI and, where it makes sense, generates code.

**Typed analytics are not a nicety.** Without a contract the same event arrives
as `profile_open`, `profileOpened`, `profile_viewed` and `opened_profile`, and
six months of data is unusable retroactively. A generated event type makes the
wrong name unwritable rather than merely discouraged.

## Realtime frames

Every frame carries the same envelope, and every payload validates against a
schema:

```json
{ "type": "message.created", "version": 1, "eventId": "...",
  "conversationId": "...", "sequence": 184,
  "occurredAt": "...", "payload": { } }
```

`eventId` gives **deduplication**. `sequence` gives **ordering**, and the two are
not the same problem — a socket that redelivers is survivable, a socket that
reorders a conversation is not.

Reconciliation follows from it. After a reconnect the client asks for what it
missed by cursor:

```
GET /v1/conversations/{id}/messages?after=183
```

The socket carries immediacy; **HTTP carries authority and repair**. A dropped
connection costs latency, never data — which is the same rule stated earlier,
made operable.

JSON rather than a binary format, deliberately: debuggability is worth more
today than bytes, and a binary protocol is a conversation for when traffic makes
it one.

## Content contracts

`content/` is a contract too, even though only our own systems read it.

Every file validates against a JSON schema in CI. Content is **versioned and
served**, not bundled, so a quiz can be corrected in minutes without a release
(`04`).

Content carries **text and weights, never behaviour**. A quiz cannot introduce a
rule, a threshold or a screen. The moment content can change behaviour it is
code that skipped every gate — no review, no tests, no rollback.

Schemas live beside the content they validate, and a schema change is a contract
change: additive within a version, breaking changes get a new version, and the
serving layer keeps both until nothing asks for the old one.

## Remote configuration

The config endpoint is a contract with the same rules: additive within a
version, every key documented, every value with a safe default the client uses
when the key is missing.

**A client must run correctly with an empty configuration response.** Config
tunes behaviour; it does not enable it. A feature that only works when a remote
key is present is a feature that breaks the first time the endpoint is slow.

## What CI guarantees

- The specification is valid.
- Regenerating the client produces no diff.
- Test-only clients generated with the production generator configuration
  round-trip against a mock server derived from their fixture specification.
- Backend responses validate against the specification.
- Every content file validates against its schema.

Mechanics in `08`. The point here is that **none of these are conventions** —
each one fails a build, and each has been proven to fail by deliberately
breaking it once.
