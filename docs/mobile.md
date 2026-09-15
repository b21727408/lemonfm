# Mobile

## Workspace and applications

Use Flutter and Dart with a Pub workspace and one shared dependency resolution and root lockfile. Pin compatible stable Flutter/Dart and package versions during bootstrap. apps/mobile is the consumer application. Add apps/widgetbook when shared components need a catalog and apps/moderation when staff report handling is implemented. A directory is created with working code, not an empty application to satisfy a topology diagram. [Dart Pub workspaces](https://dart.dev/tools/pub/workspaces)

The consumer app composes routes, application lifecycle and platform adapters around Auth's session state. Business features are packages under packages/features. Their public entry points expose screens, route arguments or factories needed by the host. Their internal implementation remains under lib/src. Mobile packages follow user journeys; they do not mirror backend modules one for one.

| Feature | Responsibilities |
|---|---|
| auth | Entry, verification, consumer session lifecycle and logout |
| quiz | Catalog, player, local answer draft, completion, result and share |
| profile | Own profile, profile detail, collection display/removal and profile editing |
| discovery | Feed state, pagination, impressions and profile navigation requests |
| messaging | Inbox, request composer, thread, retries and history reconciliation |
| safety | Door controls, reports, block contexts, account restrictions and appeals |

Feature packages may depend on api_client, lemon_ui, approved platform libraries and their own declared dependencies. They do not depend on another feature package. The host connects a profile selection to a profile route or a thread report action to the safety flow. Do not create a generic event bus to avoid passing a route argument or callback.

Confirmed changes use explicit callbacks and public refresh boundaries. After quiz completion, the host refreshes the affected profile collection and completion prerequisite. After a block, it invalidates affected discovery and messaging views. Each feature updates its own state; the host does not copy scoring, eligibility or message rules into its wiring. Implement these connections with their flows.

The host opens Safety with a known exchange ID and, for a message report, that exchange's message ID. It passes no inferred anonymous profile/account mapping or copied evidence as authority. Safety renders blocked contexts without grouping them by guessed person; UNAVAILABLE context is not an unblocked state. After a confirmed report, refresh the current exchange: a pending request may have closed, while a reply that won the race means the conversation remains open. Report registration is shown as received, never as reviewed or punished. The actual reason catalog and outcome interfaces remain subject to D5.

Use standard analyzer checks for imports from undeclared packages and another package's implementation. A small workspace check verifies the no-feature-to-feature dependency rule in pubspec files. This is a bounded rule over manifests, not a second machine-readable architecture catalog or custom analyzer plugin.

Quality names the explicit analyzer rules and acceptance checks. Discovery prototypes can inject a synthetic repository into the development host under Delivery's temporary-implementation rules; they do not require a production feed contract or a dependency on a sibling feature.

## Data and presentation

Riverpod owns reactive state and dependency injection. Use handwritten Notifier controllers for synchronous interaction state and AsyncNotifier controllers when initial state requires asynchronous data. Start without Riverpod code generation; the API and localization generators serve separate needs. go_router owns navigation in the host. Avoid a second service locator or a state-management abstraction wrapping Riverpod. [Riverpod generation options](https://riverpod.dev/docs/concepts/about_code_generation)

Each feature separates presentation from data access. Widgets render state and send user actions to a controller; repositories coordinate the generated client and any feature-owned cache or draft store. A controller should not contain raw HTTP requests or platform-channel calls. Focus, animation and text-editing controllers remain widget-local; durable draft content and submission state belong to the feature.

Provider initialization and widget builds may load data but never send an SMS, complete a quiz or send a message. Mutations run through explicit controller actions. Disable provider-level automatic retry by default; add bounded retries only for identified safe reads. Transport and provider retries must not multiply each other. Riverpod can retry failed provider computations, so its defaults are part of the implementation review. [Riverpod retry behavior](https://riverpod.dev/docs/concepts2/retry)

Add a domain/use-case layer when complex or repeated logic needs an independent home. Do not insert a class that only forwards one method because every feature is expected to have four layers. Flutter's architecture recommendations distinguish the UI/data separation from a conditional domain layer. [Flutter architecture recommendations](https://docs.flutter.dev/app-architecture/recommendations)

Use immutable state. Prefer ordinary Dart classes or sealed types where they are sufficient. Use Freezed for concrete equality/copy/union needs, with generation limited to those models. Map transport models when presentation meaning differs or transport changes would spread through widgets; do not duplicate every generated object automatically.

Business authorization and quiz scoring remain server-authoritative. The app can validate missing input and explain a known prerequisite. It cannot infer permission from a cached profile, compute the official result or trust a local quota counter.

## Composition and API access

The generated api_client contains HTTP bindings and transport types only. It does not import auth, Riverpod feature controllers or consumer screens. The host configures transports, credentials, timeouts and feature dependencies. Auth owns credentials and session transitions. Verification, refresh and single-family logout use a transport that bypasses the authenticated retry interceptor, with bindings from the same generated package. Logout-all sends the captured current bearer but also bypasses automatic refresh/retry. Other features receive the authenticated transport; api_client never depends back on Auth.

Feature repositories receive a configured client or a narrow boundary appropriate to the feature. Public provider overrides or factories let tests substitute that boundary. Introduce an interface when it isolates external behavior or supports a real test seam; avoid an interface/implementation pair for every widget helper.

Generated files are regenerated from the authored HTTP specification. Additional transport configuration belongs outside generated output. Staff bindings use a separate package included only by the moderation application; server authorization still controls staff access.

## State and failure

Represent loading, loaded data, empty data and error separately. During a refresh, existing authorized content may remain visible with a refresh indicator; after account change or lost authorization it must not remain as another user's state. An unsuccessful request must not become an empty list. Treat temporary connectivity loss separately from a server-confirmed invalid session.

The host replaces authenticated feature state on logout or session replacement. Requests and storage writes capture the initiating session generation and resource identity; late completions cannot install credentials, update a view or recreate cleared drafts in a later session. Cancel obsolete reads and subscriptions where possible, and still reject stale completions. Cancellation after a mutation was dispatched does not prove the server rolled it back. Dispose unused parameterized screen state rather than caching every visited profile indefinitely.

Mutation state distinguishes editing, submitting, accepted, rejected and outcome unknown. A timeout after a POST is not proof of rejection. Preserve the operation identity and reconcile before creating another operation. Automatic retry is permitted only where Contracts defines it and where it cannot silently change identity or selected context.

For retryable content submissions, persist the immutable payload, operation identity, account, destination and draft revision together before dispatch. If persistence fails, keep the draft and do not send an operation that cannot be recovered after a crash. Editing a draft cannot change that in-flight operation. A confirmed response clears only the matching submitted draft revision, not newer text. Scope drafts by account and destination as specified in [Experience](experience.md). OTPs and refresh credentials are not stored as content-submission records.

On restart, reconcile a pending submission through the feature's authenticated read-back path in [Contracts](contracts.md). Restoring a record does not automatically send it. Exchange actions retain their operation kind, target and observed lifecycle revision with the action identity; state-only decline/end also need recovery after a lost response. A committed receipt proves that action, not the exchange's current state. Recovery-data lifetimes require D4 approval; Safety's candidate periods are not implementation defaults. After the replay window, preserve uncertainty and require reconciliation or explicit user action rather than minting a new retry key. Do not promise indefinite recovery after local data has expired or been cleared.

A door or anchor conflict preserves the user's text and requires a fresh explicit send. UI prevention of double taps improves experience; the server's idempotency and constraints still protect duplicate operations.

Persist protective action identities before dispatch, including a block with no text. Report drafts retain the selected target/reason revision and optional context separately from the immutable submitted action. On a changed reason catalog, keep the text and require a fresh deliberate submission; on an unknown outcome, reconcile the original key first. No report draft or action identity belongs in analytics. A report receipt is a historical registration fact, so it cannot determine current conversation state or moderation outcome.

Messaging renders private preferences only for the current participant. Only the original receiver sees the conversation-label editor; keep the permanent identity-mode explanation alongside any label. Hidden rows remain accessible in the explicit hidden view; a message does not silently restore them to ordinary groups, and hiding is not a notification-mute setting. PATCH uses the observed private revision. After conflict or a lost response, read current values and preserve newer local edits; never claim a state-only edit succeeded from an optimistic label alone.

Keep submitted moderation candidates distinct from local drafts and admitted/published objects. Read candidate status through the owning feature with author authorization, including after restart; no local restore or notification handler sends an approved first message. Profile approval can publish a still-current save automatically, so reconcile against the committed profile before replacing a candidate. Cancel/replace actions retain their operation and version context and show the authoritative outcome if publication/admission wins the race. These states do not create a generic offline queue.

For Profile, 201 confirms candidate registration, not completed setup or publication. Recover an uncertain creation by its original operation identity; use the latest retained change when there is no local identity, without treating an absent result as proof of failure. Display the saved profile and pending edit separately. Within the same changeId, ignore a lower stateVersion using integer comparison; use request/session generations to discard obsolete latest-candidate reads because versions cannot order different candidates. A newer projection that withholds changes clears previously displayed candidate content and disables acknowledgement.

Replacement sends a complete new patch against the saved revision and explicitly names the old pending candidate. Preserve intended pending edits in that patch. If registration fails, explain that the previous submission remains pending; if the outcome is unknown, reconcile before reporting it canceled or replaced. An acknowledgement uses the currently displayed candidate and warning token, never edited text or an automatically refreshed warning. After APPLIED, refresh saved fields and readiness; do not reconstruct the current profile from a historical patch.

For first messages, recover creation using the original operation key or the author-only submission list; recover subsequent actions by the known submission ID. A 201 or successful continuation does not move a draft to sent unless state is SENT. AWAITING_REVIEW and READY_TO_SEND are distinct; notification handlers and restored state never invoke Send. Before acknowledgement or post-review Send, obtain and display current identity/anchor context. If the anchor changed, preserve text for an explicit replacement; do not silently remove it. A new door mode requires the user's fresh action. Keep submitted text immutable and reject lower stateVersion or stale session/request responses. Receiver decline cannot be inferred from submission status or timestamps.

Refresh credentials are used through one in-flight refresh operation per session generation. Waiting requests observe the same result. Persist the rotated refresh credential before treating rotation as complete; a stale response cannot overwrite a later session. Refresh failure never recursively triggers refresh. Retry an eligible request at most once after successful renewal, keeping its original payload and operation identity. A 403 is not a refresh signal. If rotation completion or credential persistence is uncertain, require login according to Backend rather than reusing a consumed credential.

Explicit logout invalidates the session generation and clears local credentials, drafts and private views even if the network is unavailable. Retain only the in-flight credential needed for the chosen revocation call, not a persistent logout queue. A successful server response confirms the operation's documented revocation scope; a lost response leaves remote completion unconfirmed. Do not report all other devices as logged out merely because this device cleared its state or its bearer now receives 401. Never let a refresh response arriving after logout restore the discarded session.

## Local data and lifecycle

Quiz drafts are device-local; cross-device draft sync and full offline messaging are outside the first release. Draft lifetimes remain subject to D4. Follow Backend for refresh recovery. Storage isolation, protection and rejection of stale-session writes are required.

Use flutter_secure_storage behind the credential and draft storage boundaries, with a version compatible with the pinned platform targets. Keep access credentials in memory where possible. Scope private records to the account, and clear them on explicit logout, account deletion and account switching. Configure backup/restore and device-access options for the chosen Android/iOS version; do not copy obsolete platform settings or fall back to plaintext when secure storage fails. Debug logs, crash attachments and analytics cannot contain credentials or private-message bodies. [Secure storage package](https://pub.dev/packages/flutter_secure_storage)

Quiz selections and composer drafts are small versioned encrypted records in platform-protected storage, not a new general-purpose offline database. Serialize writes per record so an older save cannot overwrite a newer revision. Apply only lifetimes approved through D4 and recorded in Safety. Reauthentication may recover unexpired drafts only after confirming the same account; temporary loss of authorization never makes them readable to a different member. Do not persist the phone input or verification code after the verification step. Backend attempt identity and local selected answers are separate; another device does not automatically obtain unfinished selections.

The first release keeps downloaded conversation messages in memory. After restart, load INITIAL history with its participant view and matching recovery cursor; a saved cursor alone cannot restore an empty transcript. OLDER pages prepend permitted history without replacing lifecycle or recovery progress. Full offline messaging and a background send queue are outside the release. A failed foreground send retains its draft and operation identity so the member can retry deliberately. Account-scoped storage avoids carrying a draft into another person's session.

Messaging owns socket parsing and history reconciliation; the host supplies session and foreground/background signals. Reconnect, foregrounding, thread return and socket notifications schedule/coalesce HTTP changes from the last confirmed recovery cursor. Serialize authoritative history/view reads per exchange, including older pages; reject completions from obsolete session/reset generations. Socket payloads do not install text or lifecycle independently. Apply a changes page fully before advancing its cursor, continuing while hasMore even when no visible item is returned. Render by integer message creation sequence and deduplicate stable IDs.

An upsert replaces the currently permitted body; UNAVAILABLE clears it and REMOVE_MESSAGE removes its entry. Repair older loaded messages too, without adding unrelated old messages to the visible window. On HISTORY_CURSOR_RESET_REQUIRED, discard downloaded history and bootstrap again while preserving unsent drafts and action identities. A fresh participant view repairs lifecycle independently of message text. Refresh the first list page when returning to a mutable inbox; pagination is not a stable snapshot. A disposed screen listener must not be the only recovery path. None of these reads signals human reading to the peer.

## Navigation, localization and UI

Routes carry only the identifiers and revisions needed to resolve authorized content. Deep links are parsed from an allowlisted shape; a shared quiz destination survives onboarding. Arbitrary incoming URLs cannot request staff pages, inject a navigation stack or carry consumer credentials.

Route guards consume explicit restoration, signed-out, profile-required and ready states, with a recoverable restoration-error state. Loading saved credentials must not briefly show private content or redirect through a login loop. Redirects select a destination; they do not send verification codes or perform profile mutations. Keep cross-feature route definitions in the host and pass typed arguments and actions through feature entry points. [go_router redirection](https://pub.dev/documentation/go_router/latest/topics/Redirection-topic.html)

The host retains an optional return context when contact leads into the first quiz. The quiz feature reports completion and offers the host's return action without importing Profile or Messaging. The host reopens the originating profile through current authorization; stored return context is never permission to send.

Use Flutter's standard localization workflow with ARB resources and generated accessors for interface text. Each feature owns its strings and exports its localization delegate; the host registers those delegates and owns app-navigation strings. Use distinct generated class names. Shared components receive feature-specific labels without importing the consumer app. Server-served quiz content is localized authored content, not an interface error string. Unknown error codes have a safe, actionable fallback. [Flutter localization](https://docs.flutter.dev/ui/internationalization)

Build visual surfaces with lemon_ui's semantic theme and components. Platform behavior remains available inside those components. Test Turkish, English, large text, keyboard overlap, screen-reader navigation and reduced motion in the core flows described by [Design](design.md).

## Verification

Controller tests exercise state transitions, stale responses, timeouts and account changes. Include an old response after logout, concurrent requests needing one refresh, process restart after a lost submission response, secure-storage failure before dispatch, and returning to an interrupted conversation. Verify that rebuilds do not repeat mutations and that confirmed quiz completion refreshes the profile collection. Repository tests cover mapping and boundary failures; widget tests cover meaningful actions and states. Introduce each case with its feature. A small integration set proves entry, quiz completion and later anonymous contact against the real API.

Keep generated-client validation separate from product authorization tests. Run feature tests in isolation without constructing the entire application or every sibling feature. [Quality](quality.md) defines build gates; [ADR 4](adr/0004-flutter-structure.md) records the package and layer tradeoffs.
