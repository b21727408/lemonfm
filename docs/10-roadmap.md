# 10 — Roadmap

What this document owns: the order things are built in, and why that order.

What it does not own: progress. **Nothing here records what is finished.** A
document that tracks status goes stale within a week and every session pays to
read it; git and the pull request list already know.

**This document is a plan, not a law.** Every other document in this set states
rules a session follows; this one states an order a session may argue with. If a
slice turns out to depend on something later in this list, or a phase is
obviously better split or merged, say so in the pull request and propose the
change — that is ordinary work, not an escalation. Changing the order is still
the founder's call, but noticing that it is wrong is everybody's job.

---

## The shape

Two things run in parallel and neither blocks the other:

**The build**, below.

**The content and matching study** (`07`), founder-led. It blocks the *content*
of phase 3, never its mechanics. Starting it late is the single most likely way
for the code to finish and the launch to wait.

## Phase 0 — Scaffold

Everything in `08` §Day zero, **timeboxed to three working days**. Longer and
setup has become the project.

Success is not "the app runs". Success is **seven deliberate violations, seven
red builds**:

| Violation | Gate that must fail |
|---|---|
| a feature imports another feature's `src/` | pubspec graph check + lints |
| a module queries another module's schema | ArchUnit |
| `domain` imports Spring | ArchUnit |
| a raw colour in a widget | `lemon_lints` |
| the API spec changes without regeneration | contract job |
| a law is edited in `AGENTS.md` instead of its source | generation diff |
| a project build file pins a version literal | build policy check |

Each one is broken on purpose, watched failing, and reverted. **A gate that has
never failed on purpose is decoration** (`08`).

## Phase 1 — Design system core

Tokens generated from `design/tokens/*.json`, then the components in `03`:
LfButton · LfInput · LfFieldGroup · StepperPill · OnboardingScaffold · LfNavBar ·
LfSheet · LfToast · LfAvatar · EmptyState. Every state, every golden, all in
Widgetbook.

First, because the tokens-only law makes it the only legal place to start:
anything built before it will contain raw values that then have to be found.

## Phase 2 — Identity, end to end

The first real vertical slice, and the one that proves the whole stack:
`contracts/http/public-v1.yaml` → identity module → generated clients → the
mobile identity feature → the six onboarding screens.

Chosen first because everything else needs a session, and because it exercises
every mechanism at once — spec-first generation, module boundaries, jOOQ,
Testcontainers, migrations, `secure_store`, the design system. If something in
the scaffold is wrong, this is where it shows.

The session protocol in `04` §Auth is fixed; its numbers are decided here.

## Phase 3 — Quiz, result, share card

The growth engine (`00` §Two loops). Content pipeline and schema validation ·
quiz module and trait signal · quiz player · result screen · `ResultShareCard`
with 9:16 and 1:1 export · deep links that survive onboarding.

**Ships with placeholder content if the study has not landed.** The mechanics
are testable without it; what waits is whether anybody shares the result.

## Phase 4 — Profile

Profile module · edit profile · collection · representation including photo
upload through `media` · the interests picker and its first-Discover prompt.

Before Discovery, because a feed of empty profiles proves nothing about ranking.

## Phase 5 — Discovery

**Requires `09-discovery`.** Candidate projection and its event handlers · bulk
hard eligibility · ranking · the feed · profile detail · shuffle · pool
exhaustion.

The one phase that cannot start from these documents alone.

## Phase 6 — Messaging and safety

Requests · conversations and handles · chat over WebSocket with reconciliation ·
the door · trust ladder · quotas and capacity · classifier pipeline · reports,
blocks and appeals · the moderation console.

**Safety ships with the surface it protects, never after it.** These are one
phase precisely so that cannot slip: there is no version of this where messaging
lands and moderation follows next sprint.

## Phase 7 — Commerce and system

Subscriptions · boost · paywall · the empty/error/offline system · store
preparation · content freeze in both locales with evaluation sets green.

---

## How a session prompt is derived from this

Name the documents to read, the slice, then **"Done means"** and **"Verify by"**
(`08`). Verification is mechanical: a grep, a command, a deliberate break.

**Plan first** when being wrong is expensive — the scaffold, the token layer,
auth, anything touching a schema or a contract.

One slice, one pull request, sized to be reviewed in an afternoon.
