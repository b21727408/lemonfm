# 06 — Safety

What this document owns: what must never happen to a person using this product,
and the system rules that hold it. Enforcement mechanics that are code-shaped
live in `08`; the domain objects they act on are defined in `01`.

## Principles

**Consent-first contact.** Nobody receives anything from a stranger they did not
leave a door open for.

**Receiver supremacy.** Every ambiguous case resolves in favour of the person
receiving, never the person sending. Where the two conflict, the sender loses.

**Women-first defaults.** Every default is chosen as if the person setting it up
is the one most likely to be harassed, because they are. A default that is
merely neutral is a default that has quietly chosen the sender.

**Protection lives in system rules, never in a victim's vigilance.** If safety
depends on someone noticing, blocking or reporting in time, it is not safety.

**Safety is never sold**, and a paid tier never relaxes a restriction (`01`
§Commerce).

## What anonymity does and does not change

The sender is anonymous **to the receiver**. They are fully known to the
platform: verified phone, account history, trust state, solved quizzes, prior
reports. Moderation is not working blind.

**The receiver is the one who is blind**, and that is the whole difference. In an
open product, a receiver does their own filtering — they look at a profile and
form a judgement before replying. Here that judgement is unavailable, so the
work it used to do falls entirely to the system.

**Consequence: the trust ladder is the primary defence, not a backstop.** In an
open product it catches what users miss; here there is nothing else to miss it
first. Everything in Layer 4 is load-bearing.

## Layer 1 — Entry

**Age gate first, before any data is collected.** A person under 18 leaves
having stored nothing. The gate produces a single-use, installation-bound grant
that is consumed when a phone challenge is created — one valid date of birth
cannot mint unlimited attempts, and a leaked grant cannot skip the gate.

**Phone verification, inside onboarding.** The phone is held as a deterministic
keyed hash, which is what makes a ban survive a reinstall (`04`). It is
collected before an account exists rather than deferred to first contact;
deferring it is what turned every dead app in this category into a revolving
door.

**Browse-only entry ("Önce keşfet")** may skip the first quiz but never
verification, and cannot send anything.

**New-account probation: 72 hours** of reduced quotas (5 first messages a day)
and reduced Discover reach, until at least one quiz and a completed profile.

## Layer 2 — Pre-send

Every first message passes a synchronous classifier before it exists: allow ·
**nudge** · block · queue for human review. The nudge is friction, not
prevention — "are you sure you want to send this?" — and it works because most
bad first messages are impulsive rather than determined.

**The classifier is strict on cold contact and narrow inside an accepted
conversation.** Before a reply there is no consent and the system is the only
judge. After a reply the boundary changes shape, and it is worth stating
honestly rather than with a comfortable slogan:

**Ordinary consensual adult conversation is not moderated. A small, named set of
critical safety classes remains protected regardless of consent.** Those classes
are grooming and any indication of a minor, credible threats of violence,
coordinated scam patterns, and self-harm signals — the last support-routed and
never punished. Nothing else in an accepted conversation is classified, scored,
or looked at.

The honest version matters because "what two adults say is not our business" is
not true and cannot be: a product that stops looking entirely after the first
reply is a product where grooming happens on the second message. What is true is
that the list is short, closed, and written down.

The same classifier runs on profile free text at save time — nickname, bio,
prompt answers — because a profile is a broadcast surface.

**Contact information in a first message** is a spam signal and down-ranks the
sender. Inside an accepted conversation it is ignored — consensual exchange is
not ours to police, and that includes not measuring it. Knowing how often people
move to another platform would be useful; reading accepted conversations to find
out would contradict this rule, so the product does not know and accepts not
knowing.

## Layer 3 — Asynchronous classification

Message traffic is scanned after delivery **only for the critical classes named
in Layer 2** — grooming and indications of a minor, credible threats, scam
patterns, self-harm. It is not general content moderation and it does not read
for tone, topic, sentiment or language.

**Self-harm is support-routed and never punished** — the person sees
locale-appropriate resources, and nothing about their account changes.

Each shipped language carries its own labelled evaluation set of roughly 500
samples including that language's obfuscation patterns. **An evaluation set is a
repository artefact and a release gate: a locale cannot ship without its set
green** (`08`).

## Layer 4 — Trust ladder

A hidden reputation with five states: **normal → restricted → warned →
suspended → banned.** Restriction is silent — reduced reach, reduced quotas —
and the person is never told, because a visible penalty teaches evasion rather
than behaviour.

Inputs: report velocity and severity, classifier flags, reply rate at volume,
and positive signals such as long mutual conversations and completed duo
quizzes.

**Movement is faster in this product than it would be in an open one.** An open
product can be slow because a sender risks their visible reputation; here a
sender risks nothing socially, so deterrence has to be entirely systemic. A
sender drawing heavy inbound reports is restricted within hours, silently.

The motto: **fast checks, cautious judgement, decisive bans.** Automatic
restriction happens quickly and reversibly. A permanent ban requires
confirmation, because a wrong restriction costs someone a quiet week and a wrong
ban costs them the product forever.

Bans anchor on the phone hash and the installation, and **survive account
deletion** (`01`).

## Layer 5 — Humans

A review queue with severity lanes. Critical categories — threats, minors,
self-harm — carry a 24-hour service level. Reporters are told the outcome.
Appeals exist, are answered by a person, and are not a formality.

## Quotas

There are **two different kinds of ceiling**, and conflating them is how "money
never relaxes a safety restriction" quietly becomes false.

- A **plan cap** is commercial. Free accounts stop at 10 first messages a day,
  paid at 25. This is a product packaging decision and commerce owns it.
- A **safety cap** is protective. It applies to everyone at 25, drops to 5
  during probation, and drops further under a restricted trust state. Safety
  owns it, and **safety never learns who paid** — the module cannot see
  commerce at all (`architecture/modules.yaml`).

<!-- agent-law:id=safety.quota-composition -->
The effective ceiling is the **minimum of every cap that applies**: plan,
safety, trust, probation.
<!-- /agent-law --> A paying account restricted for reports gets 5, not
25. Paying removes a commercial limit and can never lift a safety one, and this
is structural rather than remembered: the module enforcing safety has no way to
know whether money was involved.

Replies and accepted conversations are never metered — a limit that interrupts a
real conversation is punishing the outcome the product exists for.

**No visible counters.** A limit speaks only when it is actually reached. A
counter is a scoreboard and an optimisation target; the absence of one is why
most people never discover the ceiling exists. Honest progress — a step
indicator, a quiz stepper, a resend timer — is not a counter in this sense.

**Quotas are not the real protection.** They cap one sender; they do nothing
about a receiver drawing inbound from many. The thing that actually protects a
receiver is **distribution** — Discover spreading impressions rather than
pooling them on a few profiles (`00` §What retention depends on, and the
discovery document). Quotas are a backstop for the pathological case.

## The door — "Kimler yazabilir?"

A receiver's controls, all of them silent to senders:

- **First messages may arrive anonymously** (default on) — or must arrive with a
  profile. The sender is told which applies and has no say (`01` §Door).
- **Effort floor:** at least one solved quiz.
- **Keyword mute.**
- **Low trust is filtered.**

**Filtering is by signal, never by volume.** A message from a low-trust sender
or one the classifier flagged goes to a filtered folder. A legitimate message is
never buried for arriving on a busy day — somebody wrote it.

<!-- agent-law:id=safety.admission-not-burial -->
**Volume is handled by admission control instead: do not bury after creation,
control admission before it.**
<!-- /agent-law --> A receiver has a capacity, and as it fills, their
exposure in Discover falls and the entry to writing closes for new senders.
Requests that were never created cannot drown anyone, and everything that does
arrive stays visible.

This exists because distribution alone is not enough. However good ranking is, a
boost, a viral share, a small city pool, a deep link from outside or a ranking
bug can all deliver a flood — and receiver supremacy means the inbox needs a
floor of its own.

**Capacity is authoritative here, not in ranking.** "Can this person accept
another request right now?" is a contact-authorisation question, and it is
answered synchronously at request creation alongside the door, the block and the
cooldown. Discovery consumes capacity *pressure* as a ranking input and lowers
exposure as it fills, but it never decides admission — a ranking system deciding
who may be contacted would put an eventually-consistent projection inside a
safety invariant.

There are no visible "creep scores" anywhere. The ladder does its work invisibly.

## Re-contact

A declined request, or a conversation the receiver ended, puts that pair into a
**14-day cooldown**. A second refusal from the same receiver is **permanent**.

Both are enforced **before a message is written, never after it is sent.**
During a cooldown the receiver does not appear in that sender's Discover at all;
if the sender reaches the profile another way, the entry to writing is closed
with a plain line — *"Bu kişiye şu anda yeni bir istek gönderemezsin"* — that
gives no reason. Decline, cooldown, door, block and trust all produce the same
sentence, so nothing can be inferred by elimination.

<!-- agent-law:id=safety.no-fake-delivery -->
**A silent decline is not a fake successful send.**
<!-- /agent-law --> Accepting a message,
showing it as sent, and discarding it would be lying to a person about what the
product just did — and this product's own voice rule forbids being coy about
mechanics (`00` §Voice). Not disclosing *why* is protection; pretending
delivery is deception.

**Anonymity does not weaken this.** The platform knows the sender is the same
person even though the receiver cannot; the receiver never has to recognise
anyone for the rule to work.

**Blocking is absolute and account-level**, in both directions, permanent, and
survives every handle and every future conversation.

## Media — v2, blur-first

Not in v1. When it arrives:

Every image, including drawings rendered to bitmap, passes a nudity classifier
before delivery. **Cold contact:** consent does not exist yet, so the system
judges — high-confidence sexual imagery is blocked without anyone having to
report it. **Accepted conversation:** the receiver judges — flagged media
arrives blurred with view, delete and report, and consent is the receiver's tap.

Enforcement runs through the ladder rather than single-detection bans: a false
positive costs one tap, a wrong permanent ban costs a person forever.

**Absolute exception — minors.** A single confirmed detection is an immediate
device and phone ban plus mandatory legal reporting, and industry hash-matching
runs on every stored image as a legal obligation. Published policy stays "no
sexual content"; blur-first delivers adult privacy in practice without
advertising it.

## Tripwire — committed in advance

These thresholds are committed **now**, so they are not debated while a metric is
falling. Every one of them is measured without demography, so none depends on
anybody having declared anything:

- Request accept rate below **25%** → tighten first-message ceilings the same
  day via remote configuration.
- **Receivers closing their door above 50%** → the anonymity hypothesis is
  failing and the product decision reopens.

- **Inbound concentration** rising past its band → distribution is pooling
  rather than spreading, which is the mechanism that kills products in this
  category. Same action.

Dashboards: accept rate by inbound volume band, retention by inbound volume
band, inbound concentration, filtered-folder volume, door-closure rate, and —
diagnostically, never as a trigger — the optional self-declared share (`00`).

## Legal

GDPR-grade baseline everywhere, not only where required: minimal personal data,
EU-region hosting minimum, phone held hashed, export and delete flows in
settings.

Per-market legal review gates the opening of every market — KVKK for Türkiye,
then each new regime in turn.

**18+ only in v1.** This is provisional in the sense that it may be revisited,
not in the sense that it may be relaxed casually. A declared-age mixed pool is
not an option: self-declared age is not age assurance, and an anonymous channel
containing minors and adults is the single highest-risk configuration in this
category — the one that closed Omegle and produced regulatory action against
several others. Any change reopens this entire document and requires verified
age assurance, separate pools, separate moderation thresholds and per-market
legal review.
