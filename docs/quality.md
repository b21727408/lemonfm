# Quality

## Standard of completion

The governing principle is **enterprise discipline, not enterprise complexity**: explicit ownership, reproducible builds, narrow changes, secure defaults and evidence for consequential behavior. A tool or abstraction needs an identifiable failure it prevents or a current boundary it serves. Complexity is justified by the product's actual behavior and measured operating needs.

A change is complete when its intended behavior is implemented, relevant failure cases are handled, required checks pass and reviewers can understand its cost. File count, class count, a coverage percentage or the number of tools is not a substitute for that evidence.

Keep hand-written code, generated bindings, platform boilerplate and test fixtures distinguishable. Generated files can legitimately be numerous. The backend's initial module metadata establishes ownership. Do not fill those declarations with speculative classes, generic managers, forwarding layers or placeholder implementations to make the repository appear complete.

## Tools and responsibilities

The tools below are selected requirements. Their presence in this document is not evidence that they are installed or passing. The milestone table defines when each check must work; build configuration and recorded runs establish its actual coverage.

| Area | Tool or approach | Scope |
|---|---|---|
| Java formatting | Spotless with google-java-format | Hand-written Java; automated fixes |
| Small Java source rules | Checkstyle | Avoid star imports, internal JDK imports and multiple top-level classes per file |
| Java bug/null checking | Error Prone and NullAway with JSpecify annotations | Supported first-party code; exclude generated sources |
| Module boundaries | Standard Spring Modulith verification | Acyclic graph, declared dependencies and public APIs |
| Additional architecture | Small ArchUnit suite | Persistence/API ownership, HTTP adapter direction and permitted package roots |
| Dart | dart format, strict analyzer settings and flutter_lints | Hand-written Dart and declared package dependencies |
| Feature dependencies | Small pubspec workspace check | No dependency between feature packages |
| HTTP | OpenAPI validation, generation and oasdiff compatibility checks | Authored specification and actual bindings |
| Database | Flyway, jOOQ, JUnit and Testcontainers PostgreSQL | Real constraints, migrations and transactional behavior |
| Flutter behavior | Controller/repository tests, widget tests, selected integration flows | State, interaction and API integration |
| Visual regression | Selected goldens and Widgetbook | Stable shared components and useful documented states |
| Dependencies and secrets | Version locks, Gradle verification and Gitleaks | Reproducible resolution and accidental secret additions |
| Known dependency vulnerabilities | Audit mechanism selected under E5 | Resolved Gradle/Pub dependencies, explicit coverage and finding triage |

Spotless runs google-java-format and owns Java layout. Checkstyle adds only the small source rules in the table; do not import a full style preset that duplicates formatting or imposes blanket Javadoc, method-length or class-size quotas. Error Prone checks bug patterns during compilation. NullAway is its nullness-checking plugin; JSpecify supplies annotations, not another analysis engine. Configure the checked first-party scope and nullness mode explicitly, and prove the selected compiler/annotation combination under E2. Keep exceptions narrow and justified. These checks do not establish runtime authorization or eliminate every possible null failure. [Checkstyle](https://checkstyle.org/) [Error Prone](https://errorprone.info/) [NullAway](https://github.com/uber/NullAway) [JSpecify](https://jspecify.dev/docs/user-guide/)

Enable Dart's strict-casts, strict-inference and strict-raw-types modes in shared analysis options. CI treats analyzer errors, warnings and info diagnostics in first-party code as failures. Keep generated-source exclusions targeted; do not hide first-party findings with blanket ignores. [Dart strict type checks](https://dart.dev/tools/analysis#enabling-stricter-type-checks)

Explicitly enable implementation_imports and depend_on_referenced_packages; do not assume the selected lint bundle enables every boundary rule. Together with the manifest check, verify a real sibling-feature violation and a package-internal import are reported. A package boundary is checked by tooling and review, not a Dart runtime security barrier. [Dart implementation imports](https://dart.dev/tools/linter-rules/implementation_imports)

Pin Gitleaks and oasdiff and verify downloaded tool artifacts. Keep secret-scanner output redacted. Compatibility findings still require review of behavior and privacy; a passing diff does not establish either. [Gitleaks](https://github.com/gitleaks/gitleaks) [oasdiff](https://www.oasdiff.com/)

### Not selected for the initial setup

These are deliberate omissions, not a backlog of tools that must eventually be installed. A later addition needs a specific uncovered risk and evidence that its benefit justifies configuration, findings and maintenance. Different analyzers can find different defects; overlap does not make them equivalent.

| Tool or policy | Why it is not an initial requirement | Reason to reconsider |
|---|---|---|
| PMD, SpotBugs and a Sonar platform | No additional rule set or reporting need has been identified beyond the selected checks; stacking defaults creates another findings/configuration workload | A useful uncovered defect class or an actual cross-repository reporting need |
| A custom Dart analyzer plugin or generated architecture-policy engine | Standard import diagnostics and a small pubspec check cover the chosen feature dependency rule | A recurring, consequential boundary violation those checks cannot detect |
| Riverpod code generation | Handwritten controllers meet the current state/composition needs without another generator; [Mobile](mobile.md#data-and-presentation) owns the choice | Repeated real provider boilerplate with a demonstrated maintenance benefit; OpenAPI and localization generation remain selected |
| Lombok and mandatory generation of every Dart model | Records, constructors and ordinary immutable types are sufficient defaults | A concrete model need; Mobile permits Freezed for useful equality/copy/union behavior, without requiring it globally |
| Universal coverage percentages, size quotas and mandatory Javadoc on every declaration | These do not prove the product's important failure cases and can reward filler tests/comments or artificial splitting | Coverage reports or focused metrics that reveal a real testing/maintenance gap; no repository-wide percentage gate is selected |
| Broad regex bans and a custom task engine | Names and raw words do not establish behavior; ordinary build tools can run the selected checks | A specific missed invariant or execution need that cannot be handled by a small direct check/task |

Business time should be injectable where tests need control; this does not justify banning every time API throughout platform code. Freezed and property-based test libraries are conditional implementation choices, not promised later milestones. Selected goldens, device checks and feature tests instead become required when their milestones below apply.

## Test behavior by risk

Pure tests cover validation, collection behavior and state-machine decisions. Quiz-scoring tests use the method and any tie handling approved through the Content study; a test must not silently choose an unresolved product rule. They should be readable examples, including representative invalid cases. Property-based testing is useful for genuine invariants such as collection uniqueness or plan/protective-cap composition, not a mandatory dependency for every feature.

Use actual PostgreSQL for queries, migrations, uniqueness and concurrency. H2 and mocked repositories cannot establish that a PostgreSQL constraint prevents a pair race. Testcontainers runs a compatible pinned PostgreSQL image. A feature test can use a small test dataset without starting unrelated mobile or staff applications.

At the first cross-module write, force a failure after both modules have written and assert full rollback through the real transaction boundary. When durable events arrive, prove rollback leaves no publication, a failed consumer can recover, and redelivery does not duplicate its owned work. Verify that an external provider call has no active database transaction.

Privacy and authorization tests send requests as the wrong account, an unrelated account, an anonymous peer and a staff/consumer credential with the wrong audience. Assert response payloads and observable navigation targets, not only the HTTP status. Include exports, notifications and blocked contexts where hidden identity can escape.

For messaging, exercise lost responses, duplicate requests, opposite-direction creates, door changes, block ordering, duplicate replies and reply-versus-decline. Coordinate concurrent transactions with barriers or latches; a test that sends calls one after another does not demonstrate race handling. Do not use arbitrary sleeps as the synchronization mechanism.

For sessions, exercise concurrent refresh, consumed-token reuse, refresh versus single-family/logout-all revocation, and late credential installation after logout. Verify that family expiry never slides and expired access cannot outlive the family. For profile reads, verify setup readiness without a quiz/photo, caller and target access independently, and absence of self-only identifiers and anonymous-exchange associations in member-visible responses. Schema fixtures cannot replace these runtime and client-lifecycle checks.

For moderated submissions, exercise approval after app exit, approval versus cancellation/replacement, stale profile revisions and nickname conflicts, duplicate submissions/decisions, and final message admission against current blocks and allowances. Human approval alone must never send a first message; a single profile save must not publish only some changed fields. A lost queue-creation response must recover the same candidate without reporting an admitted request. Cover the approved contact predicates; the restricted-account cap still requires D10 before its concrete enforcement cases.

For the profile-change contract, verify registration before an interrupted check, failed replacement before versus after registration, and a provider failure without publication or resurrection of the old edit. Cover acknowledgement with a stale/withheld prompt, cancellation after application, and action-key reuse against another candidate. Client cases include late lower stateVersion responses and an old latest-read response after replacement; a 201 alone never marks the profile saved or ready. Schema examples cover response shapes, while these races require the real feature implementation.

For first-message contracts, prove that registration/continuation retries cannot admit another request or consume another allowance. Exercise both automatic approval and human review followed by explicit Send, a second human review after Send, changed door/anchor, old provider decisions after replacement, and lost responses for creation/actions. Compare author submission payloads/list position before and after receiver decline/filter/read: those changes must not be observable there. Use actual PostgreSQL races for opposite-direction sends and a return competing with a new request. Verify the rolling boundary at exactly 24 hours, no midnight/device-time reset, no decline refund and the new-account period boundary; a denied attempt cannot schedule later sending. Receiver-return tests preserve anonymous roles and withhold additional returner messages until the other participant replies.

For exchange contracts, compare the sender's request shape, list position and history cursor before/after silent decline. Test anonymous views through both return paths and every fallback, foreign action-receipt lookup, ordinary reply after decline, duplicate close/refusal recording and lost action responses. Race return against a new open pair and verify that delayed sends/ends cannot act on a reopened cycle. The returning receiver cannot send again or accept their own return offer while waiting. Schema fixtures establish permitted shapes; these authorization and transition claims require implemented feature tests.

History tests must cover a message committed during bootstrap, older paging during recovery, removal of an old loaded message, historical upserts after redaction and stale reads after a reset/session change. A removed body cannot reappear; an OLDER page cannot advance recovery; no shared cursor can expose private receiver activity. Verify empty continuation pages and authorized cursor expiry that resets the transcript while preserving drafts/action IDs. Exercise real PostgreSQL read boundaries and the Flutter reconciler when implemented, rather than claiming these properties from OpenAPI validation.

Protective-action implementation tests cover block versus send/return, blocking from old history with a newer open pair, an already-blocked/deleted peer, and lost block/report responses. Two unlinked contexts for one anonymous account must not share public block IDs, pair timestamps or identity fields; a peer-only block must not appear in the caller's list. Verify report target parent/peer authorship, snapshot versus withdrawal, duplicate report/decline closure, report versus first reply and old-report isolation from a newer exchange. D5 catalog fixtures remain synthetic and establish no production taxonomy or penalty. Reporter receipts cannot expose staff decisions or evidence.

Private-preference tests cover wrong-role label edits, null/omitted/empty values, Unicode limits, no partial write on conflict and old responses after account changes. Hiding leaves pair/admission/reporting and the peer's list unchanged; hidden rows are recoverable through HIDDEN and do not reappear automatically on a peer message. Compare both participants' shared history progress before/after hiding or labeling. The receiver's label must be absent from sender views, shared events and evidence, including after restart and return flows.

Use Flutter controller tests for stale responses, duplicate actions, session changes and outcome-unknown states. Widget tests verify visible identity, field errors, loading and deliberate resend. A small integration set proves the real quiz flow and later the core contact flow. Ordinary accessors and generated serialization need no hand-written tests that mirror their implementation.

## Establish the checks

During bootstrap, assert that standard Modulith discovery finds the complete declared module set, prove a representative invalid dependency fails verification and stale generated bindings fail the contract check. Retain compact fixtures when they protect a custom rule against regression. There is no quota of deliberate violations and no requirement to maintain a fixture for every formatter preference.

Keep the additional Java checks focused: a module cannot use another module's persistence; public module APIs cannot expose persistence/internal/HTTP types; business modules cannot depend on technical HTTP/configuration packages; technical adapters can use only module APIs, with business code confined to its declared roots. Include generic API signatures and generated-type references where relevant. Do not exclude an entire package merely because one generated class needs a narrow analysis configuration.

Generated Dart API bindings are checked in for a straightforward Flutter bootstrap; their inputs and generator version are pinned. Generated Java interfaces and jOOQ types are build outputs regenerated before compilation. Disable generated sample tests/docs that are not used. Generated output is never manually repaired, and generated sources are excluded from first-party style rules. Such exclusions do not remove compilation, generator compatibility, contract drift or applicable runtime response/privacy checks.

The database generation proof starts from empty storage, applies migrations and compiles code using at least one generated table. Changing a migration to introduce a new referenced field must not require compiling stale application tests first. Maintain that dependency ordering in the build graph.

## When a check becomes required

| Milestone | Required evidence | Why at this point |
|---|---|---|
| First generator proof | Pinned inputs/configuration, Java/Dart compilation, relevant serialization/validation behavior and deterministic regeneration; no product endpoints implemented | Generator incompatibility must surface before application code depends on its output |
| Bootstrap | Formatting and strict analysis, module/package boundary checks, OpenAPI validation and drift checks, clean PostgreSQL/Flyway/jOOQ generation, dependency locks/verification, dependency-vulnerability audit under E5, secret scan, protected-document diff check and a buildable consumer shell | These checks protect all subsequent work; the resolved dependency graphs make a meaningful audit possible |
| First affected feature | Its positive/negative authorization, real database integrity, retry/concurrency and Flutter state/widget tests; durable-event tests only when that feature needs durable work | A shell cannot demonstrate the behavior of an unimplemented feature; these tests arrive with its code, not at the end of the project |
| First stable shared UI | A small useful component catalog and selected goldens, alongside real text and accessibility checks; no empty catalog application as a gate | Useful visual baselines need real components and states; ordinary widget and accessibility work starts with the affected UI |
| External pilot | Applicable provider, data-lifecycle, staff-access, device, backup/restore and operational checks below, plus the approved product decisions in Decisions | Live configuration, supported devices and realistic data/workload evidence are required before exposing users; synthetic bootstrap checks cannot substitute |

Each applicable gate must pass; later feature and pilot gates do not delay unrelated bootstrap work. Check results name the actual feature and environment. A mock feed is evidence for its UI states only, not ranking quality or completion of the discovery stage.

## Commands and CI

Provide a thin repository command wrapper when scaffold implementation begins. It delegates to ordinary Gradle and Flutter/Dart tasks and returns their real exit codes. The interface is format, generate, check-fast and check. Avoid a custom task engine or architecture-policy generator.

check-fast runs formatting verification, static analysis, architecture checks, unit/widget tests and inexpensive contract validation. check adds required database and integration checks. Tests needing unavailable tools fail with an actionable setup error or are explicitly reported as unrun; a skipped mandatory gate must not be reported as success.

check-fast does not promise a database-free clean checkout: Java compilation needs generated jOOQ types, and clean generation needs PostgreSQL. Document that prerequisite and build dependency explicitly. Reuse valid generated build inputs when safe; never accept stale output merely to make the fast command succeed.

CI runs independent backend, Flutter, contract and database work in parallel where useful. Each expensive check runs once. A final required-status aggregation does not rerun the complete suite. Cache dependency downloads and safe generated build inputs without sharing mutable test databases across jobs.

For app changes, compile the Android target in routine CI and validate iOS on an available macOS runner before its release. Introducing an iOS plugin requires iOS compilation evidence, not an assumption based on Android success. Record platform-specific checks that could not run.

Dependency updates occur in focused, reviewable changes. Lock direct and transitive resolution and verify downloaded Gradle artifacts. Locks control resolution, artifact verification checks accepted bytes, and Gitleaks detects likely secrets; none establishes that dependencies have no known vulnerabilities. Select the dependency-vulnerability audit mechanism under [Decisions E5](decisions.md#engineering-proofs-and-bounded-questions) once Gradle and Pub resolve, run it before bootstrap acceptance and on dependency changes, and refresh its evidence before an external pilot. Record the actual ecosystem/transitive coverage and any unsupported portion; an unsupported graph cannot be reported as clean. A vulnerability finding is triaged for affected versions and actual exposure, with a patch or explicit time-bound treatment; adding a scanner alone is not the security outcome.

## Review

Review the rule, data ownership, failure behavior, authorization, generated diff and test evidence. Ask whether each new abstraction has an actual caller or boundary, whether the query can grow into per-card work, and whether a retry can duplicate a consequential action.

The author explains what changed and how it was verified. AI assistance does not waive human review of consequential behavior. Do not make blanket dependency-approval pauses, prescribed class sizes or keyword bans the primary defense against poor code.

When implementation reveals a flawed rule, follow AGENTS: explain the exact problem, affected behavior and proposed correction; pause the affected implementation for a required decision. Documentation and authored-contract changes require explicit authorization, including technical corrections. Routine implementation choices consistent with approved rules can proceed. Do not weaken a valid rule just to obtain a green build. An approved lasting architectural decision can receive an explicitly authorized ADR; ordinary implementation details belong in the change description.

Ordinary code changes must leave protected documentation, instructions and authored contracts unchanged. During bootstrap, add a small diff check against the reviewed task base that catches edits, additions, removals and renames in those paths. An explicitly approved document/contract update is reviewed in its own scoped change. A path check detects writes; it neither proves semantic correctness nor grants its own exception. Do not build a policy engine for this rule.

## Release and operation

Before real users, validate actual SMS delivery, live moderation configuration, provider data handling, staff access, export and deletion. No production profile can enable test authentication or allow-all content checks. Backups, secrets, monitoring and support coverage are configured for the environment that will serve users.

Perform a restore drill and replay the deletion register before opening restored data to traffic. Exercise a migration against a representative prior schema and a rollback or forward-fix path appropriate to that change. Verify that delayed upload, notification and event handlers cannot restore deleted accounts or bypass a new block.

Measure cold startup, representative API latency, query counts, feed scans and background backlog on a realistic small dataset. Record the results and environment; do not claim enterprise-scale throughput from a smoke test. Set alerts with actionable ownership, including failed deletion, SMS spend and stuck safety work.

Foundation acceptance is defined in [Delivery](delivery.md). Once those conditions pass, infrastructure work continues only for a concrete feature need, required release gate or observed problem.
