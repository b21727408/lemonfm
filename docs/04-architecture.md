# 04 — Architecture

What this document owns: how the system is divided, what owns what data, and
what may depend on what.

**The boundaries themselves live in `architecture/modules.yaml`**, which is the
generated source for Spring Modulith configuration, ArchUnit rules, Flutter
lint rules and the tables below. This document explains the shape; that file
enforces it. If they disagree, the file is right and this document is stale.

What it does not own: interfaces between the two systems (`05`), quality gates
(`08`), domain rules (`01`).

---

## The governing bias

**Boring infrastructure, hard boundaries.**

Cleverness is spent on domain logic and nowhere else. No microservices, no
external broker, no orchestration platform, no ORM with lifecycle magic. Every
piece of plumbing that could be interesting is deliberately dull.

The reason is not purity. With one reviewer and generated code, every
additional deployable, every additional runtime, every piece of framework
behaviour that happens invisibly is a place where something can be silently
wrong and nobody notices for a month.

But the *inside* of the monolith is divided harder than most distributed
systems are. **The goal is that three years from now, an AI working on
messaging cannot accidentally reach into safety** — not because someone will
catch it in review, but because the repository refuses it. The honest form of
that promise is "cannot be merged", not "cannot be typed"; where the difference
matters, this document says which.

## Repository

```
lemonfm/
├── apps/
│   ├── mobile/               the shipped app; owns routing and composition
│   ├── widgetbook/           component catalogue, dev only
│   └── moderation/           internal review console (see §Moderation)
├── packages/
│   ├── lemon_ui/             design system
│   ├── lemon_lints/          the analyzer plugin that enforces boundaries
│   ├── api_client/           generated from the spec; never hand-edited
│   ├── admin_api_client/     generated from the admin spec
│   ├── telemetry/            typed analytics; the SDK lives only here
│   ├── realtime_client/      socket envelope, dedupe, reconnect, reconciliation
│   ├── secure_store/         keystore access; the only place vendor crypto lives
│   ├── foundation/           domain-neutral primitives only
│   └── features/
│       ├── identity/  profile/  quiz/
│       └── discovery/ messaging/ safety/ commerce/
├── backend/                  Spring Boot modular monolith
├── contracts/                every typed boundary (see 05)
├── architecture/modules.yaml the boundary definition
├── design/tokens/            design tokens as data (see 03)
├── content/                  quizzes, interests, taxonomy
├── infra/                    deployment
├── tooling/                  the ./lemon command surface
└── docs/
```

<!-- agent-law:id=arch.no-shared-package -->
**There is no `core`, `common` or `shared` package.**
<!-- /agent-law --> Those names attract
everything, and within months hold three unrelated responsibilities and every
piece of business logic nobody knew where to put. `foundation` exists in their
place with a hard rule: **no business concept lives there.** `Clock`,
`IdGenerator`, `Outcome`, pagination primitives — nothing that knows what a
profile or a request is.

Three technical packages sit beside it, and they exist because a rule demands
them rather than because a folder looked untidy. A feature may not call an
analytics SDK, open a socket, or touch a platform keystore — so each of those
needs a home, and `foundation` cannot be it without stopping being
domain-neutral. `telemetry` turns generated event types into vendor calls;
`realtime_client` owns the envelope, deduplication, reconnection and
reconciliation in one place; `secure_store` is the only package that knows what
a keychain is. **Each has one job and an independent lifecycle**, which is the
test for being a package rather than a folder.

**Moving something to a shared package is more expensive than duplicating it.**
The same fifteen lines in two features is often better than one wrong
abstraction that both must now bend around. A concern leaves `foundation` and
becomes its own package when it earns an independent lifecycle, not when it
gets large.

## Backend

**Spring Boot modular monolith, Java 21+, one container, managed Postgres.**
The exact language and framework versions are pinned in the build, not written
here — a version in an architecture document is a version that goes stale
silently.

### Modules are business capabilities, not layers

```
fm.lemon
├── identity   profile   quiz    discovery
└── messaging  safety    commerce  content  media  notification
```

Each module is internally layered:

```
<module>/
├── api/              the only package another module may import
├── application/      transactions and orchestration
├── domain/           rules; depends on no framework and no other module
└── infrastructure/   persistence, HTTP clients, vendors
```

**`api` is not the top of the layer chain — it sits outside it.** It may depend
on the JDK, on `foundation`, and on its own types, and on nothing else: not
domain, not application, not infrastructure. `application` implements the
interfaces `api` declares.

The reason is compile coupling. If `MessagingApi` returns a type that lives in
`messaging.domain`, then every module compiling against the contract is also
compiled against messaging's internals — the import line looks clean and the
dependency is real. Keeping `api` self-standing is what makes "another module
may import only `api`" mean something.

<!-- agent-law:id=arch.modules-are-capabilities -->
**Layers are not modules.**
<!-- /agent-law --> A previous version of this document called `api`,
`domain` and `infra` the modules, which made "a module owns its tables"
unanswerable — nobody could say which module owned `profiles`. Vertical
modules make ownership a fact rather than a convention.

**Full clean-architecture ceremony is not wanted.** A simple operation stays a
method. There is no `CreateProfileUseCase` + `Impl` + `Input` + `Output` +
`Mapper` for something that inserts a row. Abstraction appears where a real
boundary exists, and Java enterprise cosplay is its own kind of generated
sludge.

### Enforcement

**Spring Modulith** discovers the modules, their exposed interfaces and their
typed dependencies. A repository verifier built on its documented public API
then checks those facts against `architecture/modules.yaml`. Component and
ordinary static API dependencies are synchronous-call edges; event-listener
dependencies are subscription edges. The synchronous graph must be acyclic.
The subscription graph is checked independently and may point back toward a
caller. A subscription is never permission to call the publisher.

The repository deliberately does not use an unqualified
`ApplicationModules.verify()` as its graph gate. That method treats all module
dependencies as one cycle graph, which cannot express the distinction above.
The custom verifier does not filter violation messages or use framework
internals: it consumes Spring Modulith's public dependency type, source type,
target type and target-module model.

**ArchUnit** verifies the inside of a module: `domain` importing no framework,
layer direction, no cross-module type references.

Both read their rules from `architecture/modules.yaml`. Adding a dependency
means editing that file, which is a visible decision in a pull request rather
than an import somebody added.

### Auth and sessions

Phone OTP through an SMS provider port, with a global default and per-market
local providers for cost and deliverability.

The session mechanism is fixed here even though its numbers are not. In a
product built on permanent anonymity and durable bans, the session layer is what
makes a ban mean anything.

- A **short-lived access credential** carrying a session id, so a revoked
  session is rejected on the next request rather than surviving until expiry.
- A **rotating refresh credential**, device-bound, belonging to a **session
  family**.
- **Reuse detection:** presenting an already-rotated refresh credential revokes
  the whole family. Without it, rotation is decoration.
- **Server-side revocation**, with per-device logout and log-out-everywhere —
  the second is what somebody reaches for after losing a phone.
- **Credentials are hashed at rest**, and signing keys rotate with an overlap
  window so a rotation does not sign everyone out.
- **On the device**, credentials live in the platform keystore through
  `secure_store` and nowhere else.
- **OTP anti-enumeration:** a wrong number and a wrong code are
  indistinguishable from outside, and a ban is disclosed only after a correct
  code (`05`).
- **Rate limits per number and per address.** The attack on an OTP system is
  the SMS bill.

**Only the numbers are `PROVISIONAL`** — lifetimes, attempt counts, backoff
curves. Whether rotation exists, whether reuse revokes a family, whether
revocation is server-side: none of those are open, because discovering later
that sessions cannot be revoked would mean a ban is a suggestion.

**Staff authentication is a separate realm, not a role.** The moderation console
authenticates through its own mechanism with its own credentials, its own
session lifetime and its own audit log. A consumer credential can never be
escalated into a staff one, because they are not the same kind of credential —
"an admin flag on a user account" is one authorisation bug away from a stranger
reading private conversations.

### Data

**One Postgres, with a schema per module.**

```
identity.*   profile.*   quiz.*    discovery.*   messaging.*
safety.*     commerce.*  content.* media.*      notification.*
```

<!-- agent-law:id=arch.schema-ownership -->
**No module queries another module's schema.** Ever, in any query, for any
reason. Cross-module reads go through the owning module's `api`.
<!-- /agent-law -->

To be precise about the guarantee: jOOQ generates a separate package of types
per schema, which makes a cross-schema query *visible* — but on a single
classpath it does not make it impossible. An ArchUnit rule forbids a module's
infrastructure from referencing another schema's generated types, so the honest
claim is **not "it does not compile" but "it cannot pass `./lemon check`".**

That distinction matters everywhere in this document set. Pushing every boundary
into the compiler would mean separate build modules and separate codegen
classpaths, and the operational cost of that exceeds what it buys. **The
requirement is that wrong code cannot be merged, not that it cannot be typed.**

**Framework tables live in `platform.*`.** The Modulith event publication
registry, Flyway's metadata and anything else a framework needs are not business
data and have no business owner. No module queries them; they belong to the
runtime.

**Remote configuration is stored centrally and owned semantically.** One `config`
table holds every tunable, but a shared table is not shared ownership: a ranking
weight belongs to discovery, a classifier threshold to safety, a plan cap to
commerce. Each module reads and validates only its own keys, through a typed
provider. Otherwise the config table quietly becomes the one place where every
boundary in this document set can be bypassed.

**jOOQ rather than an ORM.** This product reaches ranking queries, inbox
queries, cursor pagination and exposure fatigue within its first months, and
in exactly those an ORM stops being an advantage and becomes invisible
behaviour. More to the point: **an AI's SQL can be reviewed. An AI's lazy-loading
graph cannot.** Queries are visible, N+1 is visible, and nothing happens because
of an annotation somebody did not read.

**Flyway migrations, append-only.** An applied migration is never edited; a
mistake is corrected by a new one. Every migration is replayed from empty
against a real Postgres in CI.

**Schema changes are expand/contract**, because the mobile app stays installed
for months and a store update cannot be forced:

```
release A   add the new column, nullable; old and new code both work
release B   backfill, switch reads
release C   remove the old column
```

Three releases to rename a field is the price of not breaking a version of the
app that somebody is still running.

### Transactions

One rule, because transaction boundaries invented ad hoc become an invisible
consistency model nobody can reason about:

<!-- agent-law:id=arch.transaction-boundary -->
> **The outermost transactional operation owns the transaction. Synchronous
> calls into other modules join it. No outbound external I/O happens inside
> it.**
<!-- /agent-law -->

Some work has to happen before the transaction opens. The first-message
classifier is a hosted model, so it is outbound network I/O and cannot sit inside
one — which makes request creation two-phase:

```
PREFLIGHT  (no transaction)
  safety:   classify the message; block or nudge before anything is written

BEGIN
  safety:   re-check door, block, cooldown, capacity; return the safety cap
  commerce: return the plan allowance
  messaging: take the minimum, resolve and snapshot the anchor, insert
  insert the event publication
COMMIT
  → push, asynchronous scanning, projection update, outbound vendor calls
```

**The re-check inside the transaction is not redundant.** Whatever preflight
decided is stale by the time the transaction opens, and a block placed in
between must win — so authoritative checks happen where the write happens, and
preflight only decides whether it is worth getting that far.

An outbound call to an SMS provider, a payment provider or a push service
**never** runs inside an open transaction; a vendor having a slow afternoon must
not hold database locks. An inbound webhook is a different thing and is not the
concern here — it arrives, and its own handler owns whatever transaction it
opens.

**The rule is made structural before it is verified.** An architecture test
cannot watch for network calls at runtime, so the shape is arranged so the test
has something to check: every outbound adapter is marked
`fm.lemon.architecture.ExternalIo`, and a transactional application operation
may not depend directly or transitively on an API or port carrying that mark.
The marker is capability/interface-scoped, not module-wide. A module may expose
transaction-safe synchronous APIs beside a separate marked preflight or hosted
API without making the whole module external. External work happens outside the
transaction, commonly in an event listener after commit. The same pattern
applies wherever a guarantee sounds stronger than a tool can deliver — arrange
the code so the property is structural, then let the tool verify the structure.

Application and product code may not explicitly introduce `REQUIRES_NEW` or an
equivalent independent transaction. The one framework-owned exception is the
transaction semantics Spring Modulith applies through
`@ApplicationModuleListener`; permitting that annotation does not create a
general application allowlist.

### A module's `api` may not leak its insides

Another module may import `<module>.api` and nothing else — but that is
worthless if the API hands back domain objects.

<!-- agent-law:id=arch.api-no-domain-leak -->
**Public signatures and event payloads may expose API-owned types, JDK types
and foundation primitives. Never domain, application, infrastructure or
generated persistence types.**
<!-- /agent-law --> An ArchUnit rule enforces it. Without it,
`ProfileApi.get()` returning a `ProfileEntity` puts profile's internals into
every caller, and the boundary exists only on the import line.

### Events

**In-process, durable, transactional.** No external broker.

Spring Modulith writes event publications to the database inside the same
transaction as the change that caused them, so nothing is lost between a commit
and a side effect — the only property a broker was going to provide at this
scale. **Retry is configured, not magical:** resubmission of incomplete
publications, staleness handling and cleanup are explicit settings, and leaving
them at defaults means a failed listener sits in a table nobody reads.

Four invariants, because "at least once" quietly breaks things that assume
otherwise:

- **Delivery is at-least-once, never exactly-once. Every handler is
  idempotent.** A handler that is only correct when run once is a bug waiting
  for a retry.
- **Every event carries `eventId`, `aggregateId`, `aggregateVersion` and
  `occurredAt`.**
- **A projection never applies version N after it has applied N+1.** Without
  this, a retried `ProfileUpdated v42` arriving behind v43 restores an old
  nickname — silent, and invisible until somebody complains their name changed
  back.
- **Retry has a ceiling, a backoff and an alert.** A publication that will
  never succeed must page somebody rather than accumulate.

**An event with no consumer is not published.** An event API kept for an
imagined future is maintained forever and called never
(`architecture/modules.yaml`).

The line between synchronous and asynchronous is a rule, not a preference:

<!-- agent-law:id=arch.sync-vs-event -->
> **"May this happen?" is a synchronous call. "This happened" is an event.**
<!-- /agent-law -->

These form two different directed graphs. Only synchronous/component/static API
calls participate in the acyclic call graph. Event subscriptions are declared
and verified independently, may point toward a module that calls the subscriber,
and grant no synchronous permission. Thus `messaging` may synchronously ask
`safety` for an authoritative decision while `safety` asynchronously consumes a
`messaging` event without creating a synchronous cycle.

Sending a request checks contact eligibility, the door, the cooldown and the
quota synchronously, because a wrong answer is a product invariant broken.
Push delivery, projection updates and asynchronous moderation are events,
because a late answer is only late.

**Eventual consistency never sits inside a product invariant.**

If these events ever need to leave the process, the same events are published
to a broker and no module changes. That is the point of putting them here now.

### Discovery reads through a projection

Discovery cannot call four modules per card — that is an N+1 across module
boundaries, and it is the query pattern most likely to make the main surface of
the product slow.

Instead `discovery` maintains its own **candidate projection**, updated from the
events other modules publish. It is a read model and never a source of truth:
every field in it is owned by whichever module published the event that set it.

**Projections may be stale. Hard eligibility may not.** Before ranking,
discovery makes one synchronous call — `safety.filterDiscoverable(viewer, ids)` —
with the whole candidate batch, and safety consults identity's authoritative
active set alongside blocks, bans and hard cooldowns. One call, not fifty, and
authoritative to the bottom.

**Visibility and contactability are separate questions with separate methods.**
`filterDiscoverable` decides who appears; `contactPolicy(sender, receiver)`
decides what happens when someone tries to write. A receiver who requires a
profile is fully visible — that setting decides a request's identity state, not
whether they exist — and a browse-only person can read every profile without
being able to write to any. One method answering both would eventually remove
people from the feed for adjusting a preference.

Without that last part the guarantee would be hollow: an account deleted or
banned half a second ago would still sit in the projection, and the one class of
exclusion that must never be eventual would be exactly as eventual as everything
else. The ranking itself belongs to the discovery document.

## Mobile

**Flutter, with pub workspaces.** One lockfile, one dependency resolution.

<!-- agent-law:id=arch.features-are-packages -->
**Every feature is a real package, not a folder.**
<!-- /agent-law --> The boundary that actually
holds is the **pubspec dependency graph**: messaging cannot use profile because
profile is not among its dependencies. Dart does not truly hide `lib/src/` — an
import of `package:profile/src/…` is possible and merely linted against — so the
package manifest is the real wall, and a lint is the second line.

An AI that wants a cross-feature import has to add the dependency to a pubspec
to make it work, and **a CI check compares the pubspec graph against
`architecture/modules.yaml`** and fails on anything undeclared. The wrong move
is therefore visible in a diff rather than buried in an import list.

Each feature is layered inside:

```
domain/         pure Dart. No Flutter, no Riverpod, no HTTP.
application/    use cases
data/           HTTP, cache, DTO mapping
presentation/   Riverpod controllers, screens, widgets
```

**No feature depends on another feature.** They still need to reach each other —
discovery opens a profile, a profile opens the composer — and `apps/mobile`
owns that: a feature exposes routes and emits navigation intents, and the shell
wires them. The shell is the only thing that depends on everything.

**Riverpod is composition, not architecture.** It handles reactive state and
controller lifecycle. A `domain/` file importing Riverpod fails the build.

**Determinism is enforced.** `DateTime.now()`, `Random()` and `Platform.*` are
forbidden in `domain` and `application`; a `Clock` and an `IdGenerator` are
injected instead. An AI reaching for the ambient clock is the single most
common way a test becomes flaky, and the ban makes it impossible rather than
discouraged.

**Strings through slang.** No user-facing literal in a widget. Adding a locale
is content work, never code work.

**Deep links.** A share-card link carries its target quiz id, and that id
survives the whole onboarding flow, consumed on completion (`02`
§Cross-cutting). Without it the only free growth loop leaks at its last step.

## Media

Binary never touches the database.

```
app → backend: request upload
backend → app: signed URL
app → object storage: upload
storage → backend: processing, moderation, variants
app ← CDN: read
```

The `media` module holds keys and state — owner, object key, dimensions,
moderation state — and the storage provider sits behind an interface so it
never appears in any other module.

## Moderation

`apps/moderation` is a web-only internal Flutter console: report queue with severity lanes,
evidence, enforcement actions, appeals, and an audit history.

It exists from the start, even minimal, because `06` promises human review — and
without a surface, human review means running SQL against production, in a
product where the rows in question are people's private messages. Its API lives
under a separate path with its own role-based access and its own audit log, and
shares nothing with user authentication.

## Configuration

A versioned config table read at runtime: ranking weights, quota ceilings,
classifier thresholds, price flags, tripwire limits. Its shape is a typed
contract (`05`), and every change is written to an audit trail.

**This is the replacement for over-the-air patching, which the product does not
do.** Releases go through the stores normally; anything that must move faster
lives here.

## Environments

Development runs the *dependencies* in containers and the *code* natively:

```
docker compose up postgres
./lemon dev
```

Rebuilding a container on every backend change slows the loop for no benefit. A
full-stack compose path exists for smoke testing. Object storage arrives with
the first media behaviour that consumes it. WireMock is created inside tests and
is not a persistent development service.

Staging and production run the same image with different configuration.
Migrations run as a **deployment step before rollout**, not on application
start, so a failed migration stops a deploy instead of a booting instance.

Secrets come from a host secret store. Backups use managed point-in-time
recovery, **verified monthly by an actual restore** — an untested backup is a
belief.

## Scaling path

The shape does not change under load; things get added beside it.

```
now        load balancer → one app instance → Postgres
next       several instances behind the balancer, read replicas
later      Redis for hot counters and socket fanout, CDN, a broker
```

**Every one of those enters behind an interface a module already talks to,
after a measurement.** The module graph is unchanged in all three pictures,
which is the property being bought.

## Fixed identifiers

`fm.lemon` is the Android application id, the iOS bundle id and the Java base
package. **Irreversible after the first store submission** — changing it later
means a new listing and losing every install.

The shipped mobile app supports Android API 24 and newer and iOS 15.0 and newer.
`apps/moderation` has no Android or iOS runner. `apps/widgetbook` is a
development-only application.
