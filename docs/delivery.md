# Delivery

## Implementation sequence

Declare all first-release backend module boundaries during bootstrap, then build coherent vertical slices. Each slice adds the contracts, data and behavior it needs. Additional application shells and speculative implementations are not prerequisites. The first release boundary is in [Product](product.md).

| Stage | Work | Exit evidence |
|---|---|---|
| 1. Bootstrap | Compatible pinned Java/Flutter toolchain, all backend module declarations, PostgreSQL, Gradle, Pub workspace, basic checks and generation | Clean setup runs; standard Modulith discovery finds all declared modules; one real table generates before compilation; boundary checks reject a representative violation |
| 2. Identity and minimal profile | Verified account flow, revocable sessions, nickname, city, blank representation, initial UI components | Authorized and unauthorized API paths tested; Flutter can retain and revoke a session |
| 3. Quiz slice, after D6 | One reviewed bilingual quiz, approved scoring method and content schema, immutable versions, attempt, collection and result screen | Flutter completes a quiz against the backend using the approved method; PostgreSQL stores one authoritative result; retry and invalid-answer cases pass |
| 4. Profile and discovery, ranking after D7 | Profile editing, interests/prompts, photo pipeline, collection management and the approved city-feed design | Real batch queries, eligibility, pagination, distribution and sparse-city states verified against the approved study |
| 5. Contact and safety, restricted-account enforcement after D10 | Door, requests, replies, text history, block/report, staff queue, enforcement and appeals | Privacy payloads, applicable sender allowances and concurrency tests pass; a reported anonymous exchange can be handled without disclosing identity |
| 6. Delivery and data lifecycle | Realtime repair, generic push, result sharing/deep links, export, deletion, retention and operations | End-to-end contact survives disconnect; providers, deletion jobs and restore drill verified |
| 7. External pilot | Launch content catalog, configured city, real-data review, staffing and device checks | Named operator accepts pilot gates and monitors the defined metrics |

Bootstrap ends at stage 1. Foundation acceptance ends at stage 3 and proves a real authenticated quiz behavior and the ability to add a feature with the chosen boundaries. Later stages implement the product; they are not additional reasons to keep infrastructure preparation indefinitely unfinished.

The scoring and discovery studies can run alongside bootstrap and independent identity/profile work. Scoring approval is required before production calculation and its method-specific schema; discovery approval is required before production ranking and its algorithm-specific feed contract. A placeholder calculation or shuffled fixture cannot turn an unresolved product decision into a completed acceptance gate.

## Temporary development implementations

Development-only placeholders are permitted to unblock UI, integration seams and controlled demonstrations while a product study remains open. Use synthetic data and an explicit local/test configuration. For Discover, a fixed fixture feed or a small fake repository can exercise loading, empty, retry and navigation states. Its ordering is test data, not an adopted ranking algorithm. The product owner will supply the detailed D7 design separately.

Keep the substitute behind the narrow boundary used by the current feature. Record its purpose, location, open-decision ID and removal condition in the task handoff and a concise code comment. Do not create a configurable ranking engine, guessed public endpoint or durable algorithm-specific schema for the placeholder. No authentic completion, entitlement, admission permission or safety verdict can be fabricated for real accounts.

Production composition must not activate synthetic providers or substitute behavior when configuration is missing. Before the affected feature ships, replace the placeholder, prove the real behavior and verify that production cannot select the fake. A temporary live-user algorithm would itself be a product decision requiring explicit approval; development permission does not select one.

The accepted design replaces the fixture through the same feature boundary where useful. Delete obsolete prototype wiring and constants. A fixture cannot satisfy D6/D7 or foundation/release acceptance; unaffected work proceeds without waiting for those studies.

## Scope through the first slice

Through stage 3, implement Identity, Profile and Quiz, plus only the Safety behavior those flows actually call, such as public nickname checks. Media, Discovery, Messaging and Notification already have module declarations; their behavior arrives with its first use. Durable event infrastructure arrives with a required retryable side effect; an unused event demo is not a foundation gate.

## Foundation acceptance

From a clean checkout and documented prerequisites, another developer can start PostgreSQL, generate bindings, build the backend and launch Flutter without copying an existing developer database. README contains the exact working commands.

The quiz flow authenticates, retrieves a published version, submits valid answers, stores an authoritative result calculated by the approved method and displays it in the collection. It also demonstrates an unauthorized request, invalid answers, repeat submission and conflict with changed answers. Test credentials and provider doubles are confined to test or explicit local-development configuration and cannot authorize production traffic.

The repository has the checks in [Quality](quality.md), a usable first set of UI components and all backend module declarations. Generated outputs are reproducible. Known local tool limitations are recorded in verification evidence, not disguised as passed tests. Standard Modulith checks discover the declared module set and verify actual dependencies and encapsulation; declarations alone do not prove a feature works.

## Open decisions and dedicated studies

[Decisions](decisions.md) owns the D1–D10 product work, D12 pilot measurement, settled approval references and E1–E4 engineering proofs. Read the rows relevant to the task; an open decision blocks only its named milestone. D6 remains required for foundation acceptance and D7 for production Discover behavior.

The next technical proof is the pinned Java/Dart generator configuration and independent bootstrap sequence, with its actual schema features exercised before broad implementation. Remaining contract authoring follows approved feature decisions; it is not another prerequisite to beginning independent bootstrap. D4 must cover recovery journals, context-scoped block records and report receipts/evidence as well as content, and D5 live-operation requirements still apply before using real personal data. Authored contracts do not establish that generated clients, database behavior or realtime delivery already work.

## Planned work after the first release

Trait Signal, subscriptions, boosts, duo quizzes, saved profiles and reactions remain planned after the first release. D8 and D9 cover the signal and paid-feature studies; other feature designs are scheduled separately. Typing indicators and read receipts are excluded from the product and must not return as roadmap items or optional settings.

The initial backend module map covers the first release. Add Commerce and any new model-specific ownership through the approved feature design when that work is scheduled. Preserve the product capability in documentation without unused billing code, placeholder signal storage or speculative API bindings.

## Review and handoff

For a whole-product review, start with Product and Domain, then Backend and Mobile. For one implementation task, use AGENTS to select the affected rules, protocols and checks; unrelated documents are not required reading.

Before a material product or scope change, follow the product-owner approval rule in [AGENTS](../AGENTS.md). Architecture simplification does not by itself authorize removing a feature, changing a contact policy or closing an open study. Apply decisions already authorized without asking for them again.

Implementation evidence belongs with its change: actual commands, results, screenshots where useful and unresolved limitations. Avoid copying transient progress into reference documents. Propose a sequence change when a concrete dependency warrants it; applying a change to this document requires the authorization defined by AGENTS.

Use one bounded, reviewable objective per implementation session. Each task supplies its goal, acceptance evidence, permitted write scope and relevant document sections. Begin from the actual checkout, revision and existing diff; a fresh session must verify a prior handoff instead of treating it as proof. Start with the generator compatibility proof above, then continue the remaining bootstrap work. Do not implement all authored operations as a generator demonstration.

At session end, report the current revision or patch, changed paths, exact checks and results, unrun gates, unresolved blockers and the next proposed task. Verify protected documents against the starting state. Keep the handoff in the task response or change description, not a growing collection of mandatory progress files. The next prompt is prepared from reviewed evidence; it does not assume the previous task succeeded. An unresolved product dependency pauses only the work that depends on it.

After foundation acceptance, use the first completed feature as a code example. Add infrastructure when the next feature or a measured operational need calls for it. A smaller or larger file count alone does not change the acceptance decision.
