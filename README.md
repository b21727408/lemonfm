# Lemon.fm

Lemon.fm brings people together through quizzes, curiosity and anonymous conversation. Quiz results collect on open profiles. A receiver chooses whether new requests arrive anonymously or with a profile; a reply starts a conversation whose identity mode stays fixed.

## Read the project

For a product overview, read [Product](docs/product.md) and [Domain](docs/domain.md). For implementation, use the task and section map in [AGENTS.md](AGENTS.md); the whole set is not required context for each session.

| Document | Responsibility |
|---|---|
| [Product](docs/product.md) | Promise, audience, release scope and learning goals |
| [Domain](docs/domain.md) | Vocabulary, permissions, state transitions and acceptance examples |
| [Experience](docs/experience.md) | Journeys and user-visible states |
| [Design](docs/design.md) | Visual language, components and accessibility |
| [Backend](docs/backend.md) | Java architecture, persistence, identity and integrations |
| [Mobile](docs/mobile.md) | Flutter packages, state, navigation and device storage |
| [Contracts](docs/contracts.md) | HTTP, realtime and content conventions, plus the authored operation inventory |
| [Safety](docs/safety.md) | Contact protection, moderation, evidence and retention |
| [Content](docs/content.md) | Authoring, localization, publishing and the open scoring/trait studies |
| [Discovery](docs/discovery.md) | Eligibility constraints and the open ranking/distribution study |
| [Quality](docs/quality.md) | Checks, testing, review and release verification |
| [Delivery](docs/delivery.md) | Implementation sequence, temporary development behavior and acceptance |
| [Decisions](docs/decisions.md) | Unresolved product work and engineering proofs, with owners and blocking milestones |

[AGENTS.md](AGENTS.md) gives task-specific reading guidance and working rules. Architectural decisions and their tradeoffs are recorded in [Modular backend](docs/adr/0001-modular-backend.md), [Persistence](docs/adr/0002-persistence.md), [HTTP contracts](docs/adr/0003-http-contracts.md), [Flutter structure](docs/adr/0004-flutter-structure.md), and [HTTP adapter boundary](docs/adr/0005-http-adapter-boundary.md).

Contracts links to the detailed [profile-change](docs/protocols/profile-changes.md), [first-message](docs/protocols/first-messages.md), and [exchange/history/protection](docs/protocols/exchanges.md) protocols. These are feature references, not mandatory context for every task. ADRs explain a consequential choice, alternatives and costs; they do not duplicate protocol rules or store unanswered product questions.

[Consumer OpenAPI](contracts/http/public-v1.yaml) defines forty-six operations: existing-session access/revocation, profile reads/changes, contact preferences, first-message submission, participant exchanges and history, exchange blocking/report registration, and private list/label controls. [Contracts](docs/contracts.md) identifies the remaining entry, moderation, notification and content interfaces. Application code and generated Java/Dart bindings are not present yet.

[Product-policy review](reviews/product-policy-review.md) records the accepted product, contact/re-contact and rolling-window decisions. Settled rules live in their owning documents; this review is not an additional implementation specification.

[Moderation flow review](reviews/moderation-flow-review.md) records the accepted continuation, publication and cancellation decisions. Their rules live in Domain, Safety and Experience; Delivery identifies the remaining dependencies for live moderation.

## Build the first slice

Follow the bootstrap and foundation sequence in [Delivery](docs/delivery.md). Foundation acceptance is an authenticated quiz completion saved in PostgreSQL and displayed in Flutter, using the outcome of the approved scoring study. Bootstrap and independent identity/profile work can proceed while scoring and Discover ranking remain open. Trait Signal, subscriptions and boosts remain planned after the first release. Exact working setup and verification commands belong here through an explicitly authorized documentation update after implementation; until then, report verified commands in the task handoff. The tool responsibilities are defined in [Quality](docs/quality.md).

Each rule has one owning document. Source code, migrations and authored contracts supply executable details; documents explain the behavior and constraints that those implementations must satisfy.

Coding sessions treat documentation and authored contracts as read-only under AGENTS. Report discrepancies and request a scoped decision instead of changing the specification to fit an implementation. Decisions identifies unresolved work; Delivery permits bounded development substitutes and defines acceptance. Codex task prompts are written in English. Quality defines the engineering principle: enterprise discipline, not enterprise complexity.
