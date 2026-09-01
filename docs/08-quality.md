# 08 — Quality

What this document owns: everything that makes it hard to write bad code here,
and everything that ships it once it is good.

The premise: **most of the code in this repository is written by an AI and
reviewed by one person.** Quality cannot come from care at the keyboard. It has
to come from a repository where the wrong thing fails loudly, immediately, and
without anyone having to notice.

The test applied to every rule in this document set: **"how is this enforced?"**
If the answer is "the developer will remember", the rule is not designed yet.

---

## Three classes of quality, and when each arrives

Not everything belongs on day one, and the mistake in both directions is
expensive. Sorting by *what it costs to add later* rather than by how
sophisticated it sounds:

**1 · Preventive — the wrong code cannot be written.** Module boundaries,
package boundaries, null semantics, design-token boundaries, generated
contracts, real-database persistence. **All of this is day zero.** Adding
architecture tests to thirty thousand lines of Spring means opening a report
with eighty-seven violations and then spending a week on archaeology. Adding
generated clients after six months of hand-written DTOs means rewriting them.
Adding Testcontainers after a year of mocked repositories means discovering the
persistence layer was never tested against Postgres semantics.

**2 · Verification — the wrong behaviour cannot be merged.** Tests, contract
checks, migration replay, goldens. **Arrives with the first behaviour it
verifies**, not before and not later.

**3 · Operational — you can tell when a running system degrades.** Mutation
testing, load testing, benchmarks, service objectives, device-farm matrices.
**Arrives when there is something to observe.** Mutation testing says nothing
about a test suite that does not exist; a benchmark needs a hot path; a service
objective needs production behaviour.

**The scaffold is timeboxed to three working days.** At the end of it, the first
real vertical slice starts. A repository that spends three weeks on tooling
before its first screen has made setup the project.

## Day zero

**Backend.** Gradle Kotlin DSL with convention plugins in `build-logic/` ·
Spring Boot modular monolith with business-capability modules ·
Spring Modulith verification · ArchUnit for intra-module rules · PostgreSQL ·
Flyway · jOOQ · Testcontainers · Spotless with google-java-format · Checkstyle
with a small configuration · Error Prone · NullAway with JSpecify, packages
marked null-safe · forbidden-apis · OpenAPI spec-first with both sides
generated.

**Flutter.** pub workspace · feature packages · `lemon_ui` with tokens ·
`api_client` generated · a small `foundation` · strict analysis · format ·
`lemon_lints` with a handful of rules.

**Repository.** CI · dependency locking and verification · update policy ·
secret scanning ·
`architecture/modules.yaml` and the generators that read it · the `AGENTS.md`
generation mechanism · the `./lemon` command surface.

Phase-zero development infrastructure is PostgreSQL only. WireMock is
test-local. Object storage, generic concurrency harnesses and runtime
external-I/O transaction proxies arrive only with behaviour that consumes them;
the structural `@ExternalIo` rule and real-Postgres test base are established
now.

Then stop. **Not on day zero:** mutation testing, load testing, benchmarks,
service objectives, native end-to-end frameworks, additional static analysers
that overlap what is already there.

## Formatting and static analysis

Nothing about formatting is a discussion. It is applied, checked in CI, and
never reviewed by a human.

**Flutter.** `dart format` enforced. Analyzer with strict casts, strict
inference and strict raw types, warnings fatal — a warning nobody has to fix is
a warning everybody stops reading.

**Java.** Spotless with google-java-format. Checkstyle only for what formatting
cannot express, starting from a small configuration so the two never argue.
Error Prone for suspicious constructs. NullAway with JSpecify so nullability is
a compile error rather than a production discovery. **forbidden-apis** for the
ambient calls an AI reaches for by reflex: `System.out`, `new Date()`,
`System.currentTimeMillis`, `Math.random`, `Thread.sleep`, default locale,
default time zone. Each has an injected alternative.

**One tool, one job.** SpotBugs, PMD and a quality dashboard are deliberately
absent: they overlap heavily with what is above, and a tool that does not
produce high-signal findings only produces CI noise that people learn to skip.
A tool enters when it catches a class of bug the existing ones demonstrably
miss.

## Build infrastructure is locked

**Gradle Kotlin DSL**, chosen over Maven because this build is not a normal
Spring build: formatting, static analysis, null checking, architecture tests,
module verification, jOOQ generation, contract generation, drift detection,
Testcontainers suites, migration suites, property tests, mutation runs and
security tasks all have to compose, and expressing that in Maven lifecycle
phases and executions becomes verbose and cross-wired. This decision is written
down as an architecture decision record, including why not Maven, so that in six
months nobody arrives proposing a migration to something simpler.

Gradle's cost is that build scripts are code, and code is a surface an AI can be
creative on. That cost is removed by locking the surface rather than by
accepting it:

**All build logic lives in `build-logic/` convention plugins.** A project's own
build file is a plugin list and nothing else:

```kotlin
plugins {
    id("lemon.java")
    id("lemon.spring")
    id("lemon.quality")
    id("lemon.testing")
    id("lemon.database")
    id("lemon.contracts")
}
```

Six plugins is the ceiling for now. The "boring infrastructure" rule applies to
the build system too — no custom task frameworks, no plugin factories.

Four rules, each enforced:

1. **No version literal in a project build file.** Dependencies come from
   `gradle/libs.versions.toml` by alias. A hardcoded version is a version that
   drifts from every other module's.
2. **Repositories are declared once, in settings.** A project cannot add one.
3. **No dynamic versions.** No `+`, no `latest.release`, no snapshots. Builds
   are reproducible or they are not builds.
4. **Build logic is owned separately.** `build-logic/`, `settings.gradle.kts`
   and `gradle/` sit behind code ownership, and **a feature task may never
   change build logic, dependency policy or a quality gate.** A task that needs
   to change build infrastructure is a build-infrastructure task, and says so.

The mechanical plugin-list gate treats the root aggregator build, convention
plugin implementations under `build-logic/`, and Flutter-managed Android runner
builds as explicit build-infrastructure exceptions. Backend and repository
tooling project build files contain only their `plugins` block.

**Dependency locking and dependency verification are both on**, because they
answer different questions: locking asks whether today's dependency graph is the
same as yesterday's; verification asks whether the artefact downloaded is the
artefact expected. The Gradle wrapper and the Java toolchain are pinned, so a
build never depends on whatever JDK a machine happens to have.

Existing Flyway migration files are append-only. Pull-request comparison with
the merge base rejects modifications, deletions, renames and type changes;
adding a new versioned migration remains allowed. Refreshing dependency locks or
verification metadata is an explicit maintenance/generation action and never a
side effect of `./lemon check`.

## Boundaries

The boundary definitions live in `architecture/modules.yaml`, which is
**declarative rather than prose** — a policy expressed in English would have to
be re-implemented inside the generator, and then there would be two sources of
truth again. The file validates against `architecture/modules.schema.json`
before anything reads it, and an unknown field fails the build: a typo in a
boundary definition must not silently disable a boundary.

The enforcement below is generated from it, so a boundary changes in one place
and every mechanism follows. The file also records **which mechanism enforces
which policy**, so a claim in a document can be checked against something that
exists.

**Spring Modulith plus the generated typed-dependency verifier** — Modulith's
documented public model supplies discovered modules, exposed interfaces and
dependency types. Component and ordinary static API dependencies are checked
against declared `calls`; event-listener dependencies are checked against
declared `subscribes`. Only the synchronous `calls` graph is acyclic. A
subscription may point back toward a caller and never grants call permission.
The repository does not use unqualified `ApplicationModules.verify()` as the
graph gate because its combined cycle model cannot represent this policy.
The selected Modulith version's companion `DEFAULT` fact for an event payload is
treated as subscription coupling only when its source type, target type and
target module exactly match an `EVENT_LISTENER` fact; structural fixtures prove
that classification. Other `DEFAULT` facts require call permission.

**ArchUnit** — inside a module: `domain` importing no Spring, no jOOQ, no
Jackson, no HTTP, no other module; layer direction `infrastructure → application
→ domain`, and `domain` depending on nothing.

**Persistence ownership** — ArchUnit rejects another module's generated jOOQ
types, and repository policy rejects raw schema-qualified SQL and string-based
jOOQ identifiers in first-party application sources. Persistence code uses its
owned generated jOOQ schema and table types. Raw SQL is confined to Flyway
migrations or a separately approved infrastructure boundary, so replacing a
generated table reference with `"profile.person"` cannot evade the module gate.

**The pubspec dependency graph, checked against `modules.yaml`** — this is the
real Flutter boundary. Dart does not hide `lib/src/`; what stops messaging from
using profile is that profile is not in its dependencies, and an undeclared
dependency fails the check. An AI that adds one to make an import work has put
the violation in a diff.

**`lemon_lints`**, an official analyzer plugin, for what the package system
cannot express. Start with five, because twenty lints written up front is its
own project:

- Flutter or Riverpod imported inside `domain/`
- a raw colour, text style, radius, spacing or duration outside `lemon_ui`
- a user-facing string literal in a widget
- a direct analytics or vendor SDK call from a feature
- `DateTime.now()`, `Random()` or `Platform.*` in `domain/` or `application/`

**Grow the list from observed mistakes, not imagined ones.** When the same
mistake appears in two pull requests, it becomes a lint. A rule invented for a
mistake nobody has made costs maintenance and catches nothing.

**Repository-wide scans that fail the build:** the word "match" in any locale
file (`00` §Vocabulary) · any `PROVISIONAL` marker · any hand-edited generated
file. Checksum-pinned Gitleaks owns secret scanning; the repository policy tool
does not maintain a competing partial secret detector. Checksum-pinned `oasdiff`
owns OpenAPI breaking-change detection, with Lemon-specific orchestration only.

<!-- agent-law:id=quality.dependency-approval -->
**A new dependency requires explicit approval** and never arrives inside a
feature slice. A dependency added quietly is a decision nobody made.
<!-- /agent-law -->

## Tests

| Concern | Flutter | Backend |
|---|---|---|
| Unit | domain and application, ≥80% | domain and application, ≥80% |
| Property-based | — | jqwik on policy composition |
| Component isolation | Widgetbook | — |
| Visual regression | goldens | — |
| Module integration | — | Testcontainers, one module bootstrapped |
| Migrations | — | every migration replayed from empty |
| Contract | generated client against a mock server | responses validated against the spec |
| Vendors | fakes | WireMock |
| Content | schema validation | same schemas |
| End-to-end | device flows, separate slower workflow | service-level integration |

**Coverage is measured on domain and application only.** Coverage on
presentation measures whether widgets were instantiated, which is not
information.

**What may be mocked is a rule, not a preference**, because the fastest way to a
green suite that proves nothing is to mock everything:

- **Domain: no mocks at all.** It has no dependencies to mock.
- **Application:** only external ports.
- **Persistence:** real Postgres, always. Never an in-memory database — it has
  different semantics, and a test that passes against it is a test about the
  wrong database.
- **Vendors:** an in-process WireMock fixture in the test that needs it.
- **Module integration:** the real Spring module.

**Property-based testing for policy composition.** An example test checks that a
free account stops at ten messages. A property test checks that across *any*
sequence of door changes, blocks, declines, cooldowns and subscription changes,
money never bypasses a block. That is where the invariants in `01` actually
live, and generated sequences find the ordering nobody thought of.

**Concurrency is tested against a real database when the first concurrent
behaviour arrives.** Two simultaneous sends with the same idempotency key must
eventually produce exactly one row. That is not provable with a mock, but a
generic concurrency framework with no behaviour to consume it proves nothing.
The day-zero Testcontainers PostgreSQL base is the required foundation.

**Goldens must be deterministic:** real fonts in the harness, pinned surface and
pixel ratio, animations disabled, fixed locale, generated and verified on one
platform only. Font rasterisation differs across operating systems, and a
golden that passes locally and fails in CI is worse than none because people
learn to ignore it. The matrix is representative, not exhaustive: Turkish and
English, normal and large text scale, small and large phone.

## Contracts

Contracts are **authored**; bindings are **generated** (`05`). The gates cover
both directions.

- Every contract validates, including `modules.yaml` against its own schema.
- **Both** clients regenerate with no diff — Dart client and Java server
  interfaces. A server implementing a generated interface cannot drift from the
  specification without failing to compile.
- Breaking-change detection compares the specification against the main branch
  and fails on a removed field or a narrowed type. "A field disappeared and
  nobody noticed" stops being possible.
- Analytics events, remote configuration, realtime frames, deep links and
  content all validate against their schemas.

**Typed analytics matter more than they look.** Without a contract, the same
event arrives as `profile_open`, `profileOpened`, `profile_viewed` and
`opened_profile`, and six months of data is unusable. A generated event type
makes the name unwritable.

## Design tokens as data

The token values live in `design/tokens/*.json`, and the Dart token layer is
**generated** from them. `03` explains what the system means; the JSON is what
the values are.

The consequence: a raw colour is not merely discouraged by review, it is a lint
failure with a generated alternative sitting right there.

## The `PROVISIONAL` protocol

A session that needs a value the documents do not supply has exactly two legal
moves, and inventing one is not among them.

<!-- agent-law:id=quality.provisional -->
It writes `// PROVISIONAL: <question>` at the point of use, puts the question in
the pull request, and builds the rest of the slice. **CI fails on the marker**,
so this is not a way to defer work — it is a build failure the session declares
on itself, and only an answer clears it.
<!-- /agent-law -->

A plausible invented number is worse than a red build, because it silently
becomes a decision nobody remembers making.

For a **structural** decision — where state lives, which module owns something,
a schema or contract change — the session stops before writing code and asks.

## Generated policy

`AGENTS.md` is **generated**, not written.

The canonical documents mark their binding rules:

```md
<!-- agent-law:id=area.short-name -->
**The law, stated once, in the document that owns it.** …
<!-- /agent-law -->
```

The generator ignores fenced code blocks, so an example like the one above is
not collected as a law. It found this out the hard way: an earlier draft used a
real id in this example, and generation failed on a duplicate — which is the
mechanism working rather than a bug in it.

`./lemon generate` collects them into `AGENTS.md`; CI regenerates and fails on a
diff. An AI reads one file for the rules while every rule still has exactly one
source. Without this, `AGENTS.md` becomes a second copy of half the product
laws, and the two drift apart quietly — which is the exact failure the
one-fact-one-place rule exists to prevent.

**Two block types are collected, not one.** `agent-summary` marks the product
paragraph and `agent-law` marks each invariant. Exactly one `agent-summary` must
exist across all documents — zero or two is a generation failure — and it is
copied byte for byte. Anything short of byte-for-byte is how a paraphrase
becomes a second product definition: an earlier draft of `AGENTS.md` said "said
otherwise" where the source said "asked otherwise" and dropped a qualifier, and
nobody noticed until a review caught it. That single word is the difference
between a receiver having chosen something and a receiver having been asked.

Three more rules make it a governance mechanism rather than a script:

1. **An id is semantic and permanent.** The wording of a law may change; its id
   should not, so history stays traceable across rewrites.
2. **A duplicate id fails generation.** Two laws with one name is two laws
   nobody can cite.
3. **`AGENTS.md` is never edited by hand.** It carries a generated header, and
   CI fails on a manual change.

**Not every important paragraph is a law.** A marker is for an invariant an AI
must carry while building anything, whose violation has real consequences —
roughly thirty of them. Mark more and the file becomes an encyclopedia, the
signal-to-noise ratio collapses, and it stops being read carefully, which is
worse than having no constitution at all.

## One command surface

```
./lemon check      everything CI runs
./lemon test
./lemon fix        format and autofix
./lemon generate   clients, tokens, AGENTS.md, boundary rules
./lemon dev
```

`lemon.cmd` is the Windows entry point and delegates to that same implementation;
it is not a second command graph.

**CI runs the same commands.** A session is told "run `./lemon check`" rather
than being handed forty tool invocations, and "it passed locally but failed in
CI" stops being a category of problem.

## Continuous integration

Layered, so a fast mistake fails fast. Every box is a scope of the same root
command rather than an independent CI implementation:

```
policy — schema first, semantic graph, repository policy
   ├── backend-fast
   ├── flutter-fast
   ├── generated-drift
   └── repository-security — secrets, locks, verification metadata
            ↓
contracts — authored specs, both generated sides, breaking-change diff
            ↓
postgres-integration — Testcontainers, migration replay, schema ownership
            ↓
build-smoke — declared runtime and Flutter targets
            ↓
final-verification — generate, drift, test, complete local check
            ↓
pr-gate
```

**Nightly, not per pull request:** mutation testing, full device end-to-end,
deeper security analysis and dependency audit. Expensive checks on every pull
request are their own kind of bad engineering — they slow the loop and get
ignored.

<!-- agent-law:id=quality.gates-proven -->
**Every gate must be proven to bite.**
<!-- /agent-law --> A check is not known to work until it has
been deliberately broken once and observed failing: add a forbidden import and
watch Modulith go red, change a token and watch goldens go red, remove a field
from the specification and watch the contract job go red. **A gate that has
never failed on purpose is decoration.**

## Definition of done

Ideally the whole list is `./lemon check`. What is left for a human is what a
machine cannot judge.

**Machine:** all workflows green · generated files current · no raw design
values · no user-facing literal · boundaries intact · contract unchanged or
regenerated · no `PROVISIONAL` · no new dependency without approval · goldens
for every changed state, including the longest Turkish *and* English string.

**Human:** does this match the intent · is the copy right in both locales · does
the composition read the way it should on a device · was a safety rule touched.

## Releases

Standard store cadence. **No over-the-air patching** — anything that must move
faster lives in remote configuration (`04`), audited.

Migrations run as a deployment step before rollout, expand/contract, append-only
(`04`).

Backups verified monthly by an actual restore.

## Observability

Structured logs, metrics and traces. Every request carries an id that reaches
the client's error body (`05`), so a person reporting a problem carries the
identifier that finds it.

**Never logged, at any level:** phone numbers, tokens, message bodies, bios,
prompt answers, one-time codes. Redaction goes through a typed logging wrapper
rather than through discipline — a log containing a message body is a database
nobody secured.

Three separate dashboards, never one: **product** metrics from `00`,
**infrastructure** health, **safety** signals. The safety tripwire is an alert,
not a meeting topic (`06`).

## Rules not yet enforced by anything

The audit list. It should shrink toward zero, and an entry leaves by acquiring
a test rather than by being deleted.

| Rule | Where | Mechanism |
|---|---|---|
| No number ranks one person against another | `00`, `01` | contract test: no response carries a score, percentage or rank |
| A sender never chooses their own visibility | `00`, `01` | contract test: no request path accepts a visibility argument |
| A trait signal never reaches a surface | `01` | lint on the signal type in presentation code |
| Identity state is immutable after request creation | `01` | domain test |
| Declines are silent — nothing observable to the sender | `01`, `06` | integration test: identical responses either way |
| Money never relaxes a restriction | `01` | property test over policy composition |
| Money never buys identity | `01` | integration test: no paid path returns sender identity |
| Messages cannot be edited or unsent | `01` | the endpoint's absence, asserted |
| Deleting an account preserves ban identifiers | `01` | integration test |
| Every result is equal — no featured slot | `01` | schema constraint |
| Re-solving cannot inflate a quiz's signal weight | `01` | domain test |
| A duo quiz never produces a score | `01` | contract test on the response shape |
| A saved person is never notified | `01` | integration test |
| Browse-only cannot send | `02`, `06` | integration test |
| No visible quota counter | `06` | contract test: ceilings absent from responses |
| A cooldown never fakes a successful send | `06` | integration test on the availability gate |
| A feature slice never alters build logic | `08` | code ownership plus a path check in CI |
| `AGENTS.md` matches its sources | `08` | regenerate and diff |
