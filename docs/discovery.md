# Discovery

Discover helps eligible members find open profiles they are curious about. Its ranking and distribution algorithm is an open problem requiring a separate detailed study and product-owner approval. This document records established product constraints, engineering boundaries and the study's required work; it does not select a production ranking formula.

The product owner will write the detailed Discover design separately. Until it is reviewed and incorporated through an authorized documentation task, these established constraints apply. [Delivery](delivery.md#temporary-development-implementations) permits a development fixture or fake repository for UI work without closing D7 or selecting a live-user algorithm.

## Established product constraints

Discover is city-scoped and has no mutual-match prerequisite, public compatibility percentage or desirability ranking. Shared-point chips name actual public results and interests without exposing internal scores.

Distribution must address exposure concentration and incoming contact across receivers. There is no hard receiver pending-request count limit, no capacity reservation and no contact closure triggered solely by inbox volume. The study must design and evaluate distribution rather than assume a fixed inbox cap will balance the system.

Trait Signal and boosts remain planned after the first release. The first-release algorithm does not compute a trait vector or consume a paid boost. Their later introduction requires the approved studies and integration described below; they are not removed from the product roadmap.

## Eligibility and contact

Domain and Safety own the approved pair and re-contact constraints. An existing exchange awaiting a return reply also occupies the pair. The city model and no-receiver-cap decision are settled; the ranking study remains open.

Discovery owns selection and order. Identity, Safety and Messaging own the authoritative facts that limit visibility and contact. Use their batch APIs; do not read their tables directly.

| Fact | Discover behavior |
|---|---|
| Viewer not eligible to browse | Reject the feed request |
| Same account | Exclude |
| Inactive, suspended, banned or deleted candidate | Exclude |
| Incomplete minimal profile or unsupported city | Exclude |
| Different selected city | Exclude in the city-scoped release |
| Account-level block or active pair re-contact restriction | Exclude |
| Existing pending request, active conversation or conversation awaiting a return reply for the pair | Exclude without explaining or exposing that exchange |
| Profile-required door | Keep eligible; show the applicable mode at contact |
| Many pending requests for the candidate | No receiver-count admission limit; distribution treatment belongs to the study |
| Viewer has completed no quiz | Browsing remains available; creating a request does not |

An exclusion is enforced on current authoritative data at the read's authorization point, not only on a cached projection. This does not erase information already downloaded by a client or recall a response already in flight. A later send always rechecks its own authorization.

Do not expose an eligibility reason that identifies an anonymous exchange or a private report. Reachability through a profile deep link follows the same profile-access rules and still requires separate contact admission. Discovery cannot grant contact permission or turn a ranking signal into an undocumented safety restriction.

## Open study: ranking and distribution

The study must define and compare alternatives for:

1. Candidate selection and traversal: city population size, freshness, sampling bias, new-member opportunities and the size of the pool considered for each response.
2. Ordering objectives and tradeoffs: useful introductions, variety, repeated exposure and distribution of incoming requests. Define how receiver load may influence exposure without creating a pending-request admission cap.
3. Sparse populations and changing supply: cold start, empty or exhausted pools, repeat visits, returning members and deliberate refresh behavior.
4. Pagination and consistency: page size, query budget, duplicate handling, candidate continuation, stable navigation, changed eligibility and whether server-side session state is justified.
5. Exposure measurement and data: what qualifies as an impression, event deduplication, untrusted client reports, the history needed for ranking, retention and privacy.
6. Evaluation: controlled scenarios and suitable offline analysis followed by a measured pilot; assess relevance, exposure concentration, incoming-request distribution, receiver experience, reports and query cost together.
7. Integration boundaries for later Trait Signal and boosts: distinguish the first-release algorithm from future inputs without inventing their weights, vector model or paid allocation mechanism now.

No priority order, weighting, scan count, batch/page size, exposure-history window, session lifetime or impression threshold is selected here. Those choices must follow the study's tradeoffs and evidence. An arbitrary deterministic formula does not become the product algorithm merely because it is easy to test.

Completion evidence is a product-owner-approved algorithm specification, worked examples and edge cases, a data/retention plan, the required feed contract, and an evaluation plan with explicit measures and acceptance criteria. Record the selected behavior in this document when approved. A development fixture cannot satisfy the first-release ranking decision.

## Engineering boundaries

Profile supplies candidate identifiers and permitted public summaries. Discovery obtains additional eligibility, pair-state, collection or load facts through the owning modules' batch APIs as required by the approved design. Bound database work; a separate module call for every returned card is not the intended read architecture.

Begin with direct batch reads rather than a mandatory event-fed projection. This is a data-access starting point, not a chosen candidate-selection or ranking algorithm. Reconsider it if the study and measured query cost justify a projection; cached ranking material cannot replace authoritative access checks.

Feed contracts document caller-scoped cursors, continuation and changes between pages after the study settles their behavior. Do not discard unreturned eligible candidates silently or claim the city is exhausted merely because a bounded or filtered read returned no cards. Recheck eligibility on subsequent authorized reads. Refresh never resets blocks, re-contact restrictions or sender allowances.

Keep exposure data separate from message content and within the approved data purpose. Retention follows [Safety](safety.md), with any changes required by the study reviewed before collection. Do not create unused vector fields, weight schemas or a generic recommendation framework in the bootstrap.

## Sparse populations and failure

An empty city, an exhausted traversal and a dependency failure are distinct states. Offer an honest explanation and the permitted recovery or quiz destination. Do not fabricate new people, silently widen the city, show blocked members or label stale cards as newly available. The study settles repeat exposure and refresh mechanics within these boundaries.

A failed authorization dependency returns a recoverable service error; it cannot fall back to unchecked cached candidates. Profile visibility and contact availability use their separate authoritative checks even when the member arrives through a deep link instead of Discover.

## Verification and later studies

Verify the eligibility table, anonymous-identity nondisclosure and current access after a block or account change. Include a receiver with many pending requests whose pending count alone cannot reject an otherwise eligible send. Add algorithm-specific ordering, pagination and exposure tests only from the approved study. Inspect query counts with realistic PostgreSQL fixtures.

Trait Signal's study in [Content](content.md) defines the answer-derived model. Its Discover integration must evaluate how it affects introductions and distribution without public compatibility claims. Subscriptions and boosts remain in [Product](product.md); their later study defines paid exposure without overriding contact protections or purchasing a better compatibility assessment.
