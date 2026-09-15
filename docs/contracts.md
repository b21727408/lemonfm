# Contracts

## Authored interfaces

The consumer HTTP source is [public-v1.yaml](../contracts/http/public-v1.yaml). Its forty-six operations cover contact preferences, existing sessions, profile reads/changes, first-message submission, participant exchanges and history, exchange blocking/report registration, and private list/label controls. Backend endpoints and generated bindings are not implemented yet. This document owns shared conventions; the authored specification owns operation paths, inputs, response models, security requirements and machine-readable errors. Generate the Dart client and Java server interfaces when implementing the reviewed feature. Controllers implement the interfaces and add authorization and behavior; generated signatures do not prove correct runtime responses.

Create contracts/http/staff-v1.yaml with the moderation feature. Generate a separate staff client that the consumer application does not include. Staff paths use a separate authentication audience and authorization chain. Absence from a mobile binary reduces accidental coupling; it does not protect an endpoint from a caller who constructs HTTP requests.

The authored specification uses OpenAPI 3.1.1. The Java and Dart generator/configuration versions remain to be pinned and proven during bootstrap; schema validation alone does not establish that compatibility. Exercise optional fields, enum fallback, dates, lists and errors on a real operation before broad generation. dart-dio is an available supported client generator. [OpenAPI Generator](https://openapi-generator.tech/docs/generators/dart-dio/)

Author a contract after its feature behavior is settled; generate and implement it with that feature. Do not populate dozens of future endpoints or generate an unused staff SDK during the quiz scaffold. JSON schemas for quiz content arrive with the first authored quiz; realtime schemas arrive with messaging. Analytics can begin with a small typed event catalog rather than its own code-generation platform.

The quiz-scoring and Discover studies in [Decisions](decisions.md) precede their algorithm-specific content schemas and feed contracts. Do not freeze weight/tie fields, ranking inputs, discovery-session behavior or pagination parameters while those decisions are open. The contact and rolling-window decisions in [Review](../reviews/product-policy-review.md) are approved. D10 retains only the restricted-account amount. Trait Signal and paid-feature contracts arrive only with their approved later work.

## Authored operation set

| Operation | Purpose | Owner |
|---|---|---|
| GET /v1/me/session | Read the current authorized session and private own-account identity, without credentials | Identity |
| POST /v1/auth/refresh | Rotate an existing refresh credential under the fixed family lifetime | Identity |
| POST /v1/auth/logout | Revoke the family identified by a refresh credential, including after access expiry | Identity |
| POST /v1/me/sessions/logout-all | Revoke the caller's existing consumer session families, including the current one | Identity |
| GET /v1/me/profile | Read saved own-profile fields and setup readiness, including before setup | Profile |
| POST /v1/me/profile/changes | Register an immutable save; explicitly name a pending candidate to replace it | Profile |
| GET /v1/me/profile/changes/latest | Recover the latest retained submission, including its terminal outcome | Profile |
| GET /v1/me/profile/changes/by-operation/{operationId} | Recover creation using its original Idempotency-Key when the response was lost | Profile |
| GET /v1/me/profile/changes/{changeId} | Read the owner's current candidate state and permitted content | Profile |
| POST /v1/me/profile/changes/{changeId}/acknowledge | Explicitly acknowledge the current content-bound warning | Profile |
| POST /v1/me/profile/changes/{changeId}/cancel | Cancel the identified still-pending save | Profile |
| GET /v1/profiles/{profileId} | Read currently permitted member-visible Profile-owned fields | Profile |
| GET /v1/profiles/{profileId}/contact-context | Read current displayed identity and optional anchor context | Messaging |
| POST /v1/me/first-messages | Register immutable text for checking and admission; optionally replace a named live submission | Messaging |
| GET /v1/me/first-messages | Recover the author’s retained live and terminal submissions | Messaging |
| GET /v1/me/first-messages/by-operation/{operationId} | Recover an uncertain creation by its original action key | Messaging |
| GET /v1/me/first-messages/{submissionId} | Read author-only processing state and historical admission | Messaging |
| POST /v1/me/first-messages/{submissionId}/acknowledge | Acknowledge the current warning with displayed contact context | Messaging |
| POST /v1/me/first-messages/{submissionId}/send | Explicitly send a human-reviewed candidate in current context | Messaging |
| POST /v1/me/first-messages/{submissionId}/cancel | Cancel the identified unsent candidate | Messaging |
| GET /v1/me/exchanges | Read an authorized incoming, outgoing, conversation or archive group | Messaging |
| GET /v1/exchanges/{exchangeId} | Read the current participant's request or conversation view | Messaging |
| GET /v1/exchanges/{exchangeId}/messages | Bootstrap recent history or load an older page | Messaging |
| GET /v1/exchanges/{exchangeId}/changes | Repair message changes and recover current permitted lifecycle | Messaging |
| POST /v1/exchanges/{exchangeId}/reply | Reply to a pending received request | Messaging |
| POST /v1/exchanges/{exchangeId}/decline | Silently decline a pending received request | Messaging |
| POST /v1/exchanges/{exchangeId}/return-reply | Explicitly reply after the receiver's earlier decline | Messaging |
| POST /v1/exchanges/{exchangeId}/return | Send the receiver's one return message after their own ending | Messaging |
| POST /v1/exchanges/{exchangeId}/resume | Reply to the receiver's return message and resume | Messaging |
| POST /v1/exchanges/{exchangeId}/messages | Send text in the observed active conversation | Messaging |
| POST /v1/exchanges/{exchangeId}/end | End the observed active or waiting conversation | Messaging |
| GET /v1/exchanges/{exchangeId}/operations/{operationKind}/{operationId} | Recover only the caller's committed action | Messaging |
| POST /v1/exchanges/{exchangeId}/block | Block the known peer at account level and close affected contact atomically | Messaging, using Safety's block API |
| GET /v1/me/blocks | List the caller's known blocked contexts without hidden account grouping | Messaging, composing Safety records |
| GET /v1/me/blocks/by-operation/{operationId} | Recover the caller's committed block action | Safety |
| GET /v1/me/blocks/{blockId} | Resolve the caller's block context with current permitted identity | Messaging, composing Safety records |
| GET /v1/report-reasons | Read the configured target-specific reason catalog | Safety |
| POST /v1/exchanges/{exchangeId}/reports | Register an allegation about a known exchange | Messaging, submitting authorized evidence to Safety |
| POST /v1/exchanges/{exchangeId}/messages/{messageId}/reports | Register an allegation about a retained peer message | Messaging, submitting authorized evidence to Safety |
| GET /v1/me/reports | List the reporter's registration receipts | Safety |
| GET /v1/me/reports/by-operation/{operationId} | Recover the reporter's uncertain registration | Safety |
| GET /v1/me/reports/{reportId} | Read the reporter's retained registration receipt | Safety |
| GET /v1/exchanges/{exchangeId}/private-preferences | Read the caller's hidden state and permitted private label | Messaging |
| PATCH /v1/exchanges/{exchangeId}/private-preferences | Conditionally edit the caller's own list/header preferences | Messaging |
| GET /v1/me/contact-preferences | Read the authenticated member's door, private keyword filters and edit revision | Safety |
| PATCH /v1/me/contact-preferences | Change the door and/or replace filters atomically, conditional on the observed revision | Safety |

Existing-session, profile and preference operations remain independent of scoring/ranking and contact policy. First-message operations use the approved contact rules and Quiz’s completion fact through its owned API, without selecting a scoring method. Their live implementation still requires the applicable provider, data and enforcement decisions in Delivery. A self-profile revision covers Profile-owned edits; a contact-preference revision covers Safety-owned preferences. Neither is a sender's admission context. Wire examples, absence/clearing behavior, errors and recovery are in the YAML. The application must verify authorization, normalization and transaction behavior when implementing the features; validating the file cannot prove them.

Existing-session contracts do not supply registration, SMS challenge issuance, verification or account recovery. Those interfaces must represent the age and recycled-number decisions in D3 and the provider integration in D2. Use controlled identities for implementation proofs until real-account entry is approved; do not substitute a phone/code-only login contract that implicitly bypasses those decisions.

Profile reads expose the currently saved, approved profile fields; the owner's change resources expose submitted edits separately. Catalog delivery and authorized media resolution are defined with those features. The complete profile screen also needs Quiz's collection view after D6 settles its content contract; no empty collection or false completion flag is fabricated to fill that gap. This separation does not prescribe an extra client round trip or prevent server composition through Quiz's API.

First-message candidate creation and the author's post-review Send are distinct outcomes: replaying successful review registration cannot admit a request. Participant exchange operations implement the approved reply, silent-decline and return flows in Domain. Exchange-origin block/report and participant-private hiding/labels are authored. Profile-origin safety controls, reporter outcomes, appeals, staff and notification interfaces remain feature work; the existing receipt endpoints do not silently select their behavior. D5's operational decisions do not reopen the approved consumer return behavior.

## Profile-change protocol

See [Profile-change protocol](protocols/profile-changes.md#profile-change-protocol) for the complete protocol. Shared conventions below also apply.

## First-message protocol

See [First-message protocol](protocols/first-messages.md#first-message-protocol) for the complete protocol. Shared conventions below also apply.

## Exchange views and actions

See [Exchange views and actions](protocols/exchanges.md#exchange-views-and-actions) for the complete protocol. Shared conventions below also apply.

## History and recovery

See [History and recovery](protocols/exchanges.md#history-and-recovery) for the complete protocol. Shared conventions below also apply.

## Protective actions and private preferences

See [Protective actions and private preferences](protocols/exchanges.md#protective-actions-and-private-preferences) for the complete protocol. Shared conventions below also apply.

## Operation review and dependencies

An operation is ready for authoring when its actor, purpose, allowed input, audience-specific output, state transition, failure/disclosure behavior, retry semantics and relevant decision dependencies are known. Document these alongside the operation; a list of paths alone is not a contract.

| Surface | Review now | Decision-dependent details |
|---|---|---|
| Entry and sessions | Separation of anonymous entry from authenticated member/staff access; no account enumeration; revocation and secret handling | D2/D3 provider and age/recovery; settled session protocol in Backend |
| Profile and collection | Own edits versus permitted member reads; approved submission/publication flow; no generic account DTO | Domain/Safety for consumer behavior; D5 operational moderation; D6 collection content contract; D4 lifecycle |
| Quiz | Account-owned attempt, stored completion replay, immutable content version and permitted result view | D6 scoring/schema and launch content; D4 draft lifetime |
| Discover | Authorized candidate representations, caller-scoped pagination and no hidden identity links | D7 algorithm and feed semantics; approved Domain/Safety pair exclusions |
| Contact and history | Identity-safe views, approved human-review continuation, server commit acknowledgement and history repair | Approved Domain/Safety contact rules; D5 operational moderation; D10 restricted-account amount |
| Safety and data | Participant-authorized report/block targets; separate staff audience; private exports | D5 detailed enforcement and moderation; D4 retention |
| Deferred features | Preserve the product capability and its privacy invariants | D8 Trait Signal; D9 commerce; other planned-feature designs when scheduled |

Preparing these boundaries does not authorize implementation of a proposed business rule. Independently settled operations can proceed when coding is scheduled; do not create placeholder production paths to make the specification look complete.

## HTTP conventions

Use /v1 for consumer paths and /staff/v1 for staff paths. Resource paths are lowercase and hyphenated; explicit actions such as verify, complete or reply are acceptable when they describe the operation. Identifiers are opaque strings, never embedded phone numbers or authorization claims.

Use RFC 3339 UTC timestamps for instants. Content identifiers and public profile identifiers are separate from private account and credential identifiers. Conversation responses use participant-scoped representations so an anonymous sender account cannot leak through a generic user DTO.

JSON sequence values used for durable message ordering are non-negative canonical decimal strings, parsed as integers for comparison, never lexicographically or through floating-point conversion. Small bounded quantities remain JSON integers. This keeps a database sequence from silently exceeding a client's exact numeric range. Document each numeric field's range; do not expose a database type merely because generation accepts it. [JSON numeric interoperability](https://www.rfc-editor.org/rfc/rfc8259.html#section-6)

Collection-page envelopes use items and an optional nextCursor, absent when that traversal is exhausted. A page may be empty and still have a continuation; the client must not infer global emptiness from items alone. Each operation documents ordering, bounds and mutable-data behavior. A cursor is scoped to the authenticated caller and query and cannot grant access to another viewer's results. Generic envelope conventions do not decide Discover's page size, candidate window, session model or refresh behavior.

Optional and nullable are distinct in schemas. Updates explicitly distinguish an omitted field from clearing it. Reject unexpected mutation fields instead of mass-assigning them into domain records. Clients tolerate unknown response fields and handle unknown enum values with a safe fallback.

Every object has explicit properties and required fields. Use operation-specific inputs rather than accepting a serialized response model. Never accept caller-supplied owner identity, role, trust state, calculated result, accepted timestamp or permission flags as authoritative. OpenAPI readOnly/writeOnly annotations do not replace runtime allowlists and authorization. Pin the supported schema dialect and generation behavior rather than mixing OpenAPI 3.0 and 3.1 null syntax. [OpenAPI schemas](https://spec.openapis.org/oas/v3.1.1.html#schema-object)

For an approved partial update, omission preserves a field, null clears it only if clearing is allowed, and an empty list explicitly replaces a list with no entries. Document whole-list replacement or item operations rather than leaving merge behavior implicit. A mutable edit carries the owner's expectedRevision where concurrent overwrite must be prevented; a stale revision produces 409 REVISION_CONFLICT without a write. Do not apply this client-edit protocol to server-only enforcement state. If an operation instead uses HTTP If-Match, follow its standard precondition semantics and 412 response; do not label that header check as an application 409. [HTTP conditional requests](https://www.rfc-editor.org/rfc/rfc9110.html#section-13.1.1)

Unknown presentation enums can fall back safely. Unknown identity modes, authorization states or consequential lifecycle states cannot default to open, allowed or accepted; disable the affected action and reconcile without sending a guessed value. Configure and test the generated client's unknown-enum handling; the option's existence is not runtime proof. [Dart generator enum options](https://openapi-generator.tech/docs/generators/dart-dio/)

## Audiences and disclosure

The consumer specification is not synonymous with unauthenticated access. Member profiles and exchanges require the access defined in Domain. Only explicitly anonymous entry or sample/share operations can opt out of member authentication; they cannot expose an account directory or private profile association.

| Representation | Permitted content | Must not contain |
|---|---|---|
| Member's own account/settings | Fields required for that authorized self-service operation | Staff evidence, another member's private data or an unapproved hidden trust display |
| Accessible open profile | Approved public-to-members fields and collection context | Phone keys, credentials, internal account state or anonymous-exchange links |
| Anonymous incoming request | Message, permitted anchor/shared items and request identity | Sender profile identifier, nickname, photo, full collection or reusable sender alias |
| Anonymous conversation | Permitted history, conversation-scoped handle and identity-mode information | A link from that handle to the sender's profile or another conversation |
| Open exchange | Authorized participant history and permitted profile representation | Private reports or fields unrelated to the exchange |
| Staff case | Assigned/claimed case facts and minimum authorized evidence | Unrestricted bulk browsing or consumer-token access |

Use separate purpose-specific schemas for anonymous and open views, with explicit allowed fields. If oneOf and a discriminator represent the variants, verify both branches with the chosen Java/Dart generator. A discriminator helps select a schema; it is not an access check or a guarantee that forbidden fields are absent. Unknown variants must not deserialize into a more revealing fallback. [OpenAPI discriminator](https://spec.openapis.org/oas/v3.1.1.html#discriminator-object)

Authorize identifiers in paths, bodies, batch inputs and parent/child relationships. A participant-scoped private conversation label is returned only to its owner; it cannot be reused as the other participant's identity. Test error bodies, headers, links, nested objects and reconnect payloads as well as ordinary successful responses. Do not return raw persistence or general account objects and rely on the app to hide fields.

Use TLS for external traffic and ordinary bearer credentials in Authorization, not in URLs. Refresh and verification secrets use only their dedicated request channels and are excluded from logs. Auth, private profile/exchange, staff and export responses use Cache-Control: no-store. Account-scoped local draft storage remains a separate deliberate feature, not an HTTP-cache exception. Nonpersonal published content can define its own versioned cache policy, subject to withdrawal handling. Expiring upload/export grants are explicit capability URLs with restricted purpose and must also be excluded from logs. [HTTP no-store semantics](https://www.rfc-editor.org/rfc/rfc9111.html#section-5.2.2.5)

## Text and field limits

These are the first-release user-input limits. Encode them consistently in minLength/maxLength/pattern, upload rules and runtime validation when the operations are implemented. Count Unicode scalar values after NFC normalization and trimming outer whitespace; this is distinct from UTF-16 code units and user-perceived graphemes and requires shared fixtures. Credentials and opaque identifiers are never subjected to user-text normalization. Java String length and client widget counters alone do not prove equivalent Unicode counting.

| Field | Limit or rule |
|---|---|
| Nickname | 3–24 characters; Unicode letters/digits and single separators dot, underscore or hyphen; no leading/trailing separator |
| Bio | Up to 280 characters |
| Prompt answer | 1–160 characters |
| First message | 1–500 characters |
| Conversation message | 1–2,000 characters |
| Report context | Up to 1,000 characters |
| Private conversation label | 1–80 characters; original receiver only; null clears it |
| Keyword filters | Up to 20 entries, each 2–40 characters |
| Profile photo upload | JPEG, PNG or WebP; at most 5 MiB and 4,096 pixels on either decoded axis; animated/multiframe images rejected |

Nickname uniqueness uses NFC plus locale-independent Unicode case folding, with a database uniqueness key. Visual confusables are a moderation concern, not a promise that every lookalike can be removed by normalization. All clients and the server use shared validation fixtures for Turkish characters, combining marks and emoji. Future limit changes include compatibility review for installed clients.

## Errors and disclosure

Error bodies contain code and requestId, with violations for safe field errors and retryAt only for a disclosed waiting period. UI wording is localized by the client. Authored quiz/result text can still be served by the backend; the no-server-error-copy rule does not prohibit localized content.

Validation violations identify an allowed field and machine-readable reason without echoing rejected message text, phone input, tokens or private identifiers. requestId correlates to restricted, redacted diagnostics; errors never return stack traces or SQL. Unknown error codes produce a generic recoverable explanation, not a guessed successful result.

Use conventional statuses: 400 invalid input, 401 authentication required, 403 forbidden, 404 unavailable resource, 409 state/context conflict, 429 disclosed rate limit and 5xx service failure. An inaccessible private exchange is indistinguishable from a missing exchange to a nonparticipant.

| Condition | Public code behavior |
|---|---|
| Private pair restriction, block or undisclosable existing exchange | CONTACT_UNAVAILABLE; no cause, peer identity, thread identifier or private expiry |
| Displayed door or selected anchor is stale | CONTACT_CONTEXT_CHANGED; refresh authorized context and require explicit resend |
| Same operation identity, changed payload | OPERATION_CONFLICT |
| Stale expectedRevision for an approved mutable edit | REVISION_CONFLICT; no silent overwrite |
| Inaccessible exchange or ungranted original role | EXCHANGE_UNAVAILABLE without private closure or counterpart details |
| Stale visible exchange cycle or action incompatible with that visible phase | EXCHANGE_CONTEXT_CHANGED; refresh and require an appropriate deliberate action |
| No retained action in this caller/kind/exchange scope | EXCHANGE_OPERATION_UNAVAILABLE; not proof an in-flight command failed |
| Authorized history can no longer repair a cursor | HISTORY_CURSOR_RESET_REQUIRED with HTTP 410; bootstrap history without resending |
| Inaccessible report source/message or invalid parent/author association | REPORT_TARGET_UNAVAILABLE without target details |
| Report reason catalog changed or reason withdrawn | REPORT_REASON_CHANGED; refresh choices, preserve context and require explicit resubmission |
| No retained own block/report record or action | BLOCK_UNAVAILABLE / REPORT_UNAVAILABLE; not a peer-state lookup |
| Quiz version withdrawn | QUIZ_UNAVAILABLE |
| Wrong, expired or otherwise invalid verification attempt | AUTH_VERIFICATION_INVALID without account-existence disclosure |
| Content needs explicit acknowledgement | CONTENT_NUDGE_REQUIRED, with safe reason category and text-bound challenge |
| Content rejected | CONTENT_NOT_ALLOWED, with permitted category |
| External check unavailable | SERVICE_UNAVAILABLE; no fake acceptance |

CONTACT_CONTEXT_CHANGED and private pair-conflict behavior implement the approved contact rules. The first-message submission state represents human review explicitly; it cannot be collapsed into SERVICE_UNAVAILABLE. Every authored operation fixes both HTTP status and code for its approved outcomes. Private contact-unavailability reasons share the same external status/code/body shape; a more specific status or retryAt must not reveal a block, refusal or anonymous existing exchange. Disclosed 429 responses can use Retry-After consistently with retryAt.

The contact-context protocol never gives the sender an anonymity selector. An allowed link to an existing exchange must satisfy Domain's known-association rule; the generic conflict model cannot carry a hidden thread as optional debug detail. The receiver's return uses the retained known exchange and Domain's two explicit transitions, never a reverse-create API that reveals an anonymous participant as an open recipient.

## Idempotency and ordering

Require an Idempotency-Key for retryable creations and state-changing submissions, including profile submission/acknowledgement/cancellation, attempt creation/completion, request creation, first reply, message send and report creation. Scope it to account and operation kind. Store a payload digest and the committed outcome atomically with the mutation.

Bind the digest to the operation's target resource and every consequential input, including the approved context/revision fields. The same key cannot be replayed against another recipient or resource. Keys are opaque, nonpersonal operation identities. Never derive them from a phone number or treat their possession as authorization.

The same key and normalized payload return the same outcome while authorized; changed payload conflicts. Access revocation or retention can make a previously readable outcome unavailable, but never authorizes a duplicate mutation. Simultaneous duplicate submissions wait for or observe the winning transaction.

Recheck current authorization before replay and return a currently permitted projection of the same committed outcome. A stored response body cannot restore safety-redacted content or a removed identity link. A known committed replay is resolved before a now-stale edit revision or spent send allowance is treated as a new operation. The mutation and replay reference roll back together. Pre-admission rejection, a moderation nudge and a provider failure are not a committed request; do not permanently cache them as successful delivery. Profile candidate registration is its own committed outcome, independent of later application; replaying it returns that same candidate even after rejection or cancellation.

Keep the response replay record for 24 hours. Durable uniqueness on profile/first-message candidate actions, attempt, pair and message operation identities remains for the corresponding record lifetime. The client retains the identity across automatic retries and does not automatically retry after the replay window. An expired uncertain operation needs reconciliation or an explicit new user action, never a newly generated key hidden inside a retry loop.

The 24-hour replay window is a transport recovery setting, not permission to discard a product record or a substitute for the data lifecycle decided under D4. Do not retain raw sensitive request bodies merely to recognize a retry. Pre-account verification and refresh use their explicit Identity protocol rather than an account-scoped creation key: reopening a screen does not send another SMS, and an uncertain refresh is not blindly retried. Backend defines the user-facing refresh recovery choice.

Each retryable mutation specifies an authenticated read-back path using its operation identity or a known resource identity. It must work after the app restarts without the create response: for example, reading an attempt's accepted outcome or resolving the sender's own submitted request. Scope operation lookup to its originating account and retain the domain's privacy rules; it cannot reveal another caller's anonymous exchange. An absent read-back result while submission may still be running is not proof of rejection. This path is part of the feature contract, not a new generic operation-management service.

Conditional desired-state edits such as contact preferences can use expectedRevision plus an authorized read of their known resource instead of an idempotency replay record. Document this choice per operation. After a lost response, the read establishes current values, not which earlier write produced them; the client must not silently overwrite newer edits. Creations, message sends, reports and other operations with distinct durable outcomes still need their operation identities and reconciliation semantics above.

Session revocation also uses its explicit operation protocol instead of a generic replay record. Repeating single-family logout can only revoke that family; logout-all invalidates the bearer that authorized it. Never obtain a new session automatically to retry either logout. Refresh rotation has no ordinary read-back recovery: an uncertain rotation requires login again. This exception must be configured in the transport rather than inferred from a shared SERVICE_UNAVAILABLE code.

Responses return server identifiers and sequence values. An accepted message means database commit, not push delivery, socket receipt or human reading. Handle the lost-response case as part of each mutation's integration tests.

## Realtime

Messages are created through HTTP. An authenticated WebSocket notifies the consumer of committed changes using versioned JSON schemas. Frame authoring remains messaging implementation work. Each event includes type, version, eventId, exchangeId, sequence and occurredAt, with a participant-safe payload. Its sequence orders shared changes within the exchange; it is distinct from a message's creation sequence. It includes no hidden account-to-handle map or receiver-private inbox activity.

The socket schedules HTTP recovery using the protocol above. Only an INITIAL page establishes a recovery boundary; only applied changes pages advance it. Older-history pages and socket sequences cannot replace it. Duplicate notifications can be coalesced and do not create messages. Access is checked for the socket session, every subscription and every delivered exchange update. Revocation ends access; already delivered client data cannot be recalled.

Define frames only for required committed messaging and conversation state. Typing indicators and read receipts are excluded from the product: no typing/read-receipt endpoint, socket frame, peer read timestamp or related analytics event is introduced. History cursors acknowledge synchronization, not human reading. Unknown event types are ignored safely and can trigger HTTP reconciliation where needed.

A dropped state notification must be repairable through an authorized read of the exchange and its history; history text alone cannot restore a changed access or lifecycle state. Scope sequences to their exchange and use the decimal-string encoding above. Log neither payload bodies nor hidden participant associations.

## Compatibility and verification

Within v1, preserve field meanings and error codes. Evaluate additions too: a required input or an enum a client cannot tolerate can break compatibility even when nothing was removed. Use a mechanical breaking-change comparison plus review of privacy and behavior. A major version needs a supported-client migration plan.

Validate authored specs, compile generated bindings, check deterministic regeneration and exercise real response bodies against the schema. Do not edit generated files or hide generator drift by committing a manual patch. [Quality](quality.md) defines the gates and [ADR 3](adr/0003-http-contracts.md) records the tradeoff.

The first implemented contract proof covers the schema features actually used: omitted/null/empty update values, Unicode validation, unknown enums, representation variants and profile stateVersion strings. Exercise conditional state/metadata rules in actual responses; do not assume the generator enforces JSON Schema if/then or allOf restrictions. With messaging, prove participant/identity variants, operation-specific receipts, INITIAL/OLDER history discrimination and decimal message sequences above the floating-point exact range. Behavior tests cover cross-account access, cross-target key reuse, simultaneous duplicate writes, replay after revocation/redaction, a lost commit response and stale edit revisions. Include the approved rolling-window, pair, context and return behavior as its feature is implemented; do not invent the remaining restricted-account amount.
