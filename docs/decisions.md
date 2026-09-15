# Decisions and implementation questions

This register separates approved behavior, unresolved product work and engineering evidence still needed. An open row is not an instruction to invent a default. [AGENTS](../AGENTS.md) governs approval; [Delivery](delivery.md) owns sequencing. Only the affected work is blocked.

Use ADRs for consequential architectural choices that have been made, including their alternatives and costs. Use this register for unanswered questions. A proposal or synthetic fixture is not an accepted ADR or product decision. Documentation changes require the scoped approval defined by AGENTS.

## Open decisions and dedicated studies

The following decisions remain open. D6 and D7 require separate detailed studies; their methods are not routine implementation defaults. D8 and D9 preserve planned product capabilities after the first release and do not block bootstrap or first-release acceptance. Each decision blocks only the work named in its row.

| ID | Decision or study | Resolve before | Owner |
|---|---|---|---|
| D1 | First city and eligible recruitment group; start with one defined adult cohort, no silent geographic expansion | External recruitment | Product owner |
| D2 | SMS provider/account and sending market; select on supported verification flow, delivery evidence, spend controls and processing terms | Live identity integration | Engineering + product owner |
| D3 | Age assurance and recycled-number/recovery policy; do not grant an existing private account to a newly controlled number without the chosen additional checks | Real-account registration/login | Product owner + identity/security review |
| D4 | Hosting region and processor terms, approved retention/deletion periods, required notices and jurisdiction-specific handling; include unpublished moderation candidates and their review evidence, and evaluate candidate periods in Safety before implementation or promises | Real personal data | Operator + appropriate legal/privacy review |
| D5 | Remaining moderation work: approved report reason taxonomy/translations and reporter outcome categories, provider, case claim/priority and recovery procedures, trust inputs/transitions, temporary-restriction duration/disclosure, evaluation thresholds, appeals, staff identity and coverage; no unsupported response-time pledge | Live moderation and staff/enforcement/outcome interfaces affected by those decisions; catalog/registration wire shapes can be authored, and the consumer continuation/publication flow is settled in Domain | Product owner for product behavior; safety operator + engineering for operations |
| D6 | Quiz result-scoring and content study: semantics, method alternatives, answer/result mapping, any ties, calibration, schema, verification and final launch catalog; see [Content](content.md) | Production scoring, method-specific content schema and foundation acceptance | Product owner, with content + engineering study |
| D7 | Discover study: candidate selection, ranking, distribution without a pending-request cap, pagination, measurement, evaluation and data requirements; see [Discovery](discovery.md) | Production ranking, algorithm-specific feed contract and discovery acceptance | Product owner supplies the separate Discover design; engineering supports evaluation |
| D8 | Trait Signal study: hidden answer-derived model, normalization, retakes, versioning, comparison, data lifecycle and Discover integration | Implementation, collection or activation of Trait Signal after the first release | Product owner, with content/discovery + privacy study |
| D9 | Subscriptions and boosts: packaging, prices, entitlements, payment lifecycle and exposure allocation while preserving protective restrictions | Paid-feature implementation after the first release | Product owner + engineering |
| D10 | Restricted-account protective cap amount, evaluated with D5 enforcement policy; rolling 24-hour accounting and the existing free/paid/protective distinction are settled in [Safety](safety.md) | Enforcement for restricted accounts; not the shape of a limit error or ordinary-account accounting | Product owner + safety/engineering |
| D12 | Pilot measurement: evaluate Product's candidate sustained-conversation definition, choose useful aggregation and success criteria, and approve event collection with D4/D7. The candidate message threshold is not a selected launch target or an automatic intervention rule. | Production analytics collection and pilot evaluation commitments | Product owner + engineering/operator |

D11 is resolved: sender ending alone adds no cooldown; reporting a pending request records the receiver's refusal; pair exclusivity and explicit resend on changed context apply; the receiver can return through the two flows in Domain. Rolling 24-hour accounting is approved as well. [Review](../reviews/product-policy-review.md) records the decisions. The rows above retain only their remaining work and do not reopen settled approvals.

The M1–M3 moderation-flow decisions are approved and recorded in [Review](../reviews/moderation-flow-review.md); Domain, Safety and Experience own their operative rules. The consumer contract contains forty-six operations, including profile/first-message submissions, participant exchanges and history, exchange-origin block/report registration and private list/label controls. D10's remaining amount does not block their transport design. Report registration receipts are separate from the reporter outcomes, enforcement and appeals that require D5; no example reason defines production policy. Profile-origin safety controls, entry, media/content, notification and data-lifecycle interfaces remain feature work.

D3 is a real user-journey decision, not a missing formatter option. The acceptance demonstration can use controlled identities, but public access remains disabled until it is resolved. Independent stages can proceed using isolated provider doubles and synthetic accounts without claiming that these operational questions are settled.

An approved study is incorporated into its owning document and this register through an explicitly authorized documentation task. Do not leave both an open row and a conflicting production default elsewhere. Implementation sessions follow AGENTS and report the required update instead of editing these documents automatically. Do not add tentative method-specific schemas, product endpoints or a generic algorithm framework to work around an unresolved study.

## Engineering proofs and bounded questions

These are implementation questions, not reasons to reopen approved product behavior. Compatible versions, local naming and wiring can be selected under the assigned technical task. Report evidence in its handoff. A change to an accepted architecture or authored contract requires explicit approval.

| ID | Question or evidence needed | Resolve before | Owner |
|---|---|---|---|
| E1 | Pin Java/Dart generators and prove compilation, variant handling, omission/null semantics, safe unknown values and conditional validation. Verify generated API grouping can delegate to the declared business owners through the HTTP adapter. | Broad generated-code integration; first bounded proof | Engineering |
| E2 | Pin the compatible application/compiler/database toolchain. Prove all eight annotated modules are discovered, named API access is enforced, generated tables precede compilation, and clean generation does not depend on stale application tests. | Bootstrap acceptance | Engineering |
| E3 | Select supported Android/iOS targets and verify secure storage, backup/restore behavior, localization and accessibility on the supported platforms. | Platform-dependent feature acceptance; device evidence before external release | Engineering + product owner for audience/support tradeoffs |
| E4 | Turn workload and provider evidence into request/lock/provider deadlines, connection-pool bounds, worker batch/concurrency settings, retry budgets and operational alerts. No universal numerical defaults are selected here. | The corresponding live integration or workload; not an empty bootstrap | Engineering + operator |

The per-account guard deliberately trades write concurrency for simple ordering; measure wait time and contention with the contact slice. The HTTP generator proof establishes tool compatibility, not privacy or business authorization. Module declarations establish discoverable boundaries, not implemented capabilities.

## Unclear language and provisional work

When a statement affects observable behavior but admits materially different interpretations, report its exact location, the competing interpretations, impact and recommended resolution. Under an authorized documentation task, give it a stable row here with an owner and a blocking milestone; ordinary coding sessions report it without editing this register. Resolve a row by linking the approved owning rule or implementation evidence, not by copying a second specification into the table.

Terms such as compatible, bounded and measurable describe engineering obligations whose evidence is supplied by E1–E4. Candidate retention periods and candidate product metrics remain hypotheses until their existing product/data decisions are approved. They must not become production constants or launch claims by inference.

Temporary development implementations are permitted under [Delivery](delivery.md#temporary-development-implementations). D7 remains open while a Discover screen uses synthetic fixtures. The product owner will supply the separate detailed Discover design; integrating that design and its contracts is an explicitly authorized documentation task. D6, D8 and D9 retain their separate studies.
