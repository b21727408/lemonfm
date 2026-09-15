# Working on Lemon.fm

## Authority and protected documents

The user's explicit instructions govern the task. Ordinary coding tasks do not authorize documentation or product changes. Hand-authored documentation, agent instructions and authored contracts are read-only unless the user explicitly authorizes the corresponding change. This includes README.md, AGENTS.md, docs/**, reviews/** and contracts/**. Do not add, edit, remove or rename these artifacts, create alternative specifications or instructions, or change a formatter/generator to rewrite them incidentally. An approved exception applies only to its stated scope; do not ask again for the same approval.

General instructions to improve quality, simplify architecture, build a feature or fix tests do not authorize changing core behavior, release scope, anonymity, contact/safety policy, monetization or an open product decision. A passing build is not permission to change the specification. Generated bindings and ordinary implementation/build files can change within the assigned task; generated output is never manually repaired.

## Read for the task

Start with this file, [README](README.md), the assigned scope and acceptance criteria, and the relevant rows in [Decisions](docs/decisions.md). Inspect the actual repository and existing diff. A new session has no assumed knowledge of previous work. Write task prompts intended for Codex in English.

Read [Product](docs/product.md) and the owning [Domain](docs/domain.md) sections when implementing user behavior. Otherwise use the sections below, following additional references only when needed to resolve the task. Do not concatenate the entire documentation set, generated sources or build logs into context.

| Task | Starting sections |
|---|---|
| Bootstrap | Backend: Runtime and repository; Business modules; HTTP adapters and technical wiring; Persistence and code generation. Quality: Tools and responsibilities; Establish the checks; When a check becomes required; Commands and CI. Relevant ADRs. |
| Java feature | Its Domain rules; Backend's owning module, transaction/integration sections; corresponding Quality cases. |
| Flutter feature | Mobile: package layout, composition and the feature's state/storage rules; the matching Experience journey and needed Design components. |
| HTTP generation | Contracts: Authored interfaces; HTTP conventions; Audiences and disclosure; Compatibility and verification. ADR 3 and the schemas actually exercised. |
| HTTP implementation | The operation and transitive schema references in OpenAPI; its linked docs/protocols reference; Contracts errors/retry rules; owning Domain/Safety sections. |
| Contact or moderation | The affected Domain/Safety transition; Contracts protocol; Backend ordering; Mobile recovery; corresponding Quality cases. |
| Quiz or Discover | Content or Discovery, the owning Domain sections and Decisions' D6–D9 rows. For prototypes, Delivery: Temporary development implementations. |

Search headings and identifiers first, then read coherent sections including their exceptions. Tools may parse the complete OpenAPI while returning only the relevant operations and referenced schemas. reviews/** records decisions for reference; it is not an additional implementation specification or mandatory reading for every task.

## Decisions and blockers

Resolve routine technical choices within the approved behavior and architecture. Naming, local decomposition and compatible build configuration normally need no new approval. A missing product rule, contradictory requirements or a consequential architectural departure does.

When such an issue affects the task:

1. Identify the exact files and headings or operation IDs, the conflict or missing decision, and the behavior it affects.
2. Explain the consequence and a concrete recommended resolution. Present proposed document text for review when useful; do not apply it without authorization.
3. Pause the affected implementation and ask a specific question. Continue independent authorized work. A nonblocking editorial observation belongs in the final report, not a blanket stop.

Do not choose whichever conflicting source is easiest to implement, invent a production default, silently weaken a requirement or fabricate approval. Decisions identifies what each open question blocks. D6 scoring and D7 ranking require their dedicated studies. D8 Trait Signal and D9 paid features remain planned after the first release. Candidate retention periods are not approved defaults. Development substitutes are permitted within Delivery's explicit limits; they do not settle these decisions or satisfy production acceptance. Settled product approvals remain settled.

## Implement

Keep one reviewable objective per task. Identify its owning module/feature and a nearby working example; state a short plan for substantial work. Implement the required negative and retry paths alongside success.

Use standard framework facilities and established project patterns. Introduce an abstraction for a real caller, boundary, invariant or meaningful duplication. Do not add speculative layers, placeholder services or a custom platform to satisfy an imagined future need. Preserve module APIs and persistence ownership; keep authoritative permissions on the server.

Quality defines the engineering principle and stage-specific gates. Decisions records unanswered questions; ADRs record consequential architectural choices and their tradeoffs. Do not turn a proposal into an accepted ADR or add a new mandatory document for routine progress.

Generate bindings from the authored specification. If correct generation would require changing it, report the incompatibility under the blocker procedure. Never patch generated output or weaken privacy to accommodate a tool. Explain necessary dependencies and verify compatible versions. Preserve unrelated user changes and keep credentials, private conversations and real-user data out of source, fixtures and diagnostics.

## Verify and hand off

Use commands that actually exist in README or build configuration. Run checks required for the affected risks; do not claim an unavailable tool or skipped gate passed. Do not remove assertions, weaken authorization or suppress useful analysis just to obtain a green build.

Record the starting revision and pre-existing changes. Before finishing, compare the task's diff and protected-file contents against that starting state, including additions and removals. Report any unauthorized change and stop delivery until resolved; do not reset someone else's edits. This comparison detects changes; instructions alone are not a filesystem lock.

Report the outcome, changed implementation paths, actual commands/results, unrun checks and material limitations. Provide a short handoff with the current revision or patch, unresolved blockers and the next bounded task. Keep transient progress in that handoff or change description, not in protected reference documents. Documentation existence does not establish security, performance or release readiness.
