# AGENTS.md — Lemon.fm

<!-- GENERATED FILE — DO NOT EDIT -->
<!-- Produced by ./lemon generate from agent-summary and agent-law blocks in docs/. -->
<!-- Change a rule where it is written; CI regenerates this file and fails on a diff. -->

Read this file at the start of every session. It is law, not guidance.

When this file and improvisation disagree, this file wins. When this file and a
prompt disagree, this file wins and the session says so. When this file and the
founder disagree, the founder wins — and then the **source document** is
updated and this file is regenerated.

## The product in one paragraph

A social discovery app built on quizzes. People solve quizzes and earn
**results** that collect on their profile. They browse **Discover**, a
single-column feed of real open profiles with no swipe and no scores. When
someone catches their attention they write, and **the message is anonymous
unless the receiver has asked otherwise**. Anonymity is asymmetric and
permanent: where it applies the sender stays masked for the whole conversation,
the receiver is open, and nobody is anonymous to the platform. 18+, dark-only,
Turkish and English at launch, city-scoped launches.

Source: `00-product.md` §What Lemon.fm is — copied byte for byte.

## Where to look

| Question | Document |
|---|---|
| What is this, who is it for, what do we call things | `docs/00-product.md` |
| What is the system made of, what rules must hold | `docs/01-domain.md` |
| Which screens exist, how do they behave | `docs/02-experience.md` |
| What does anything look like | `docs/03-design-system.md` |
| How is the system divided, what owns what data | `docs/04-architecture.md` |
| What is the interface between the apps | `docs/05-contracts.md` |
| What must never happen to a person | `docs/06-safety.md` |
| Quizzes, results, interests, how they are written | `docs/07-content.md` |
| Tests, lints, gates, how we ship | `docs/08-quality.md` |
| Ranking, fatigue, distribution | `docs/09-discovery.md` |
| What gets built next, and why in that order | `docs/10-roadmap.md` |
| Which module may call which, subscribe to what, own what data | `architecture/modules.yaml` |

**A fact lives in exactly one document.** If two disagree, the owner of that
subject wins and the other is wrong — report it rather than picking one.

---

# Laws

### `measurement.legitimacy-named-not-counted`

Shown as things, never as counts. "Eight shared points" is a compatibility
score wearing a different hat, and "solved 36 quizzes" is a reputation score —
both are exactly the measurement this product refuses. Naming what is shared
gives a receiver something to judge; counting it gives them something to rank.

Source: `00-product.md`

### `vocabulary.no-match`

**The word "match" is banned in every locale, everywhere in the product.** A
product refusing the swipe category cannot borrow the word that defines it, and
a word that survives in one badge spreads to every screen inside a month.

Source: `00-product.md`

### `collection.results-equal`

**Every result in it is equal.** Nothing is featured, promoted, pinned or
selected as a headline, and no result drives a colour, gradient or profile
theme. A profile is neutral and typographic. This is not a visual preference: a
chosen headline identity is a ranking of your own selves, and the product does
not rank.

Source: `01-domain.md`

### `signal.resolve-cannot-inflate`

And **re-solving updates a quiz's contribution to the trait signal without
increasing its weight**: each quiz contributes once, normalised, however many
times it is taken. Otherwise a person could dominate an axis by repetition, and
the signal would measure persistence rather than personality.

Source: `01-domain.md`

### `vocabulary.result-reserved`

**The word "Result" is reserved for this, in code as well as in copy.** A generic
success-or-failure wrapper is named `Outcome`, never `Result`

Source: `01-domain.md`

### `signal.never-surfaced`

**Invariant: no surface anywhere may render a trait signal, a distance between
two signals, or anything computed from them.** Ranking may use it. Nothing may
display it.

Source: `01-domain.md`

### `identity.sender-never-chooses`

The door belongs to the receiver. **A sender never chooses, never sees the
setting, and never negotiates it** — they are told which one applies to the
person they are writing to, and that is all.

Source: `01-domain.md`

### `identity.state-frozen`

Its identity state — anonymous or open — is **decided by the receiver's door at
the moment the request is created, and frozen forever after**.

Source: `01-domain.md`

### `identity.anonymity-permanent`

**A conversation inherits the request's identity state and keeps it forever.**
An anonymous conversation stays anonymous through its thousandth message. There
is no reveal action, no mutual unmask, no milestone that suggests one, and no
way for a receiver to request one.

Source: `01-domain.md`

### `duo.no-score`

**A duo quiz produces two results, never a score.**

Source: `01-domain.md`

### `message.no-edit-no-unsent`

**A message cannot be edited or unsent.**

Source: `01-domain.md`

### `commerce.no-identity-purchase`

**Money never buys identity.** No tier, at any price, reveals who an anonymous
sender is, or exposes a trait signal, or unmasks anything the free product
hides.

Source: `01-domain.md`

### `deletion.ban-anchors-survive`

**Ban identifiers survive deletion.**

Source: `01-domain.md`

### `saved.never-notified`

**The saved person is never notified and can
never learn they were saved.**

Source: `01-domain.md`

### `experience.identity-state-visible`

**Identity state is never inferred.** Every surface where a person could be
uncertain whether they are anonymous states it outright — before writing, while
writing, and in the conversation forever after.

Source: `02-experience.md`

### `design.behaviour-not-appearance`

**Use the framework's behaviour; never let its appearance escape.**

Source: `03-design-system.md`

### `design.one-accent-two-grammars`

- **Filled yellow means action.** The primary button, and nothing else.
- **Outlined yellow, or yellow text, means signal.** A shared-point chip, a
  proximity badge, the active navigation destination, a focus ring.

Source: `03-design-system.md`

### `arch.no-shared-package`

**There is no `core`, `common` or `shared` package.**

Source: `04-architecture.md`

### `arch.modules-are-capabilities`

**Layers are not modules.**

Source: `04-architecture.md`

### `arch.schema-ownership`

**No module queries another module's schema.** Ever, in any query, for any
reason. Cross-module reads go through the owning module's `api`.

Source: `04-architecture.md`

### `arch.transaction-boundary`

> **The outermost transactional operation owns the transaction. Synchronous
> calls into other modules join it. No outbound external I/O happens inside
> it.**

Source: `04-architecture.md`

### `arch.api-no-domain-leak`

**Public signatures and event payloads may expose API-owned types, JDK types
and foundation primitives. Never domain, application, infrastructure or
generated persistence types.**

Source: `04-architecture.md`

### `arch.sync-vs-event`

> **"May this happen?" is a synchronous call. "This happened" is an event.**

Source: `04-architecture.md`

### `arch.features-are-packages`

**Every feature is a real package, not a folder.**

Source: `04-architecture.md`

### `contracts.authored-vs-generated`

Contracts are authored. **Bindings** are generated. Editing a generated file is
a build failure; editing a contract is a reviewed decision.

Source: `05-contracts.md`

### `contracts.admin-separate`

They are separate specifications generating separate clients, and the shipped
mobile binary is built **only** from the public one.

Source: `05-contracts.md`

### `contracts.no-backend-copy`

**The backend never sends user-facing text.**

Source: `05-contracts.md`

### `safety.quota-composition`

The effective ceiling is the **minimum of every cap that applies**: plan,
safety, trust, probation.

Source: `06-safety.md`

### `safety.admission-not-burial`

**Volume is handled by admission control instead: do not bury after creation,
control admission before it.**

Source: `06-safety.md`

### `safety.no-fake-delivery`

**A silent decline is not a fake successful send.**

Source: `06-safety.md`

### `content.no-behaviour`

What content still cannot do is change behaviour — it carries text
and weights, never rules

Source: `07-content.md`

### `quality.dependency-approval`

**A new dependency requires explicit approval** and never arrives inside a
feature slice. A dependency added quietly is a decision nobody made.

Source: `08-quality.md`

### `quality.provisional`

It writes `// PROVISIONAL: <question>` at the point of use, puts the question in
the pull request, and builds the rest of the slice. **CI fails on the marker**,
so this is not a way to defer work — it is a build failure the session declares
on itself, and only an answer clears it.

Source: `08-quality.md`

### `quality.gates-proven`

**Every gate must be proven to bite.**

Source: `08-quality.md`

---

# Session workflow

1. Read the documents for the area you are touching before writing code.
2. Small vertical slices, sized to be reviewed in an afternoon. Every slice ends
   green: `./lemon check`.
3. **Plan first when being wrong is expensive** — the scaffold, the token layer,
   auth, anything touching a schema or a contract. Post the plan and stop.
4. Conventional commits (`feat:`, `fix:`, `safety:`, `content:`).
5. Definition of Done in `docs/08-quality.md` before any pull request.
6. **Never weaken a rule to make a test pass.** Flag the conflict instead.
7. **Inventing a missing value is the violation.** Mark it
   `// PROVISIONAL: <question>`, ask in the pull request, build the rest. A
   structural decision stops the session before code.
8. Product, design, safety and content decisions belong to the founder. Purely
   technical form is proposed with reasoning and sanity-checked in review.
9. **The real failure mode is not refusal — it is not noticing that a decision
   was made.** When unsure whether something counts, it counts.

# Repository

```
apps/           mobile · widgetbook · moderation
packages/       design system, generated clients, technical boundaries, features
backend/        Spring Boot modular monolith
contracts/      every typed boundary, authored
architecture/   modules.yaml — the boundary definition
design/         token values as data
content/        quizzes and interests
tooling/        the ./lemon command surface
docs/           the source of truth
```

The exact package list and every dependency between them lives in
`architecture/modules.yaml`. It is not repeated here.

`fm.lemon` is the Android application id, the iOS bundle id and the Java base
package. Irreversible after the first store submission.
