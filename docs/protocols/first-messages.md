# First-message submissions

[Contracts](../contracts.md) owns shared HTTP conventions; [OpenAPI](../../contracts/http/public-v1.yaml) owns the wire shapes. This reference owns the following cross-operation behavior. Read only the sections needed for the feature.

## First-message protocol

The composer reads an authorized contact context before writing. For an anchor, it supplies the observed kind, resource identity and revision together; changing or removing that item is a conflict, not permission to discard it. The server binds the returned token to the author, recipient, displayed door and exact optional anchor. The token must not expose private account identities or restriction reasons, even if decoded. Its possession reserves neither contact permission nor capacity.

Submitting creates an author-only immutable record and durable checking work. A new record receives 201; a committed replay returns 200 for the same record. Only SENT and its admission receipt establish that the first message was accepted. Registration and continuation are separately recoverable commits; neither can be replayed as a new send. A known failure before registration creates no candidate; a failure after registration remains readable on that candidate.

| State | Meaning and next action |
|---|---|
| PROCESSING | Checking or authorized admission work remains; read, cancel or explicitly replace |
| AWAITING_ACKNOWLEDGEMENT | Show readable content, current warning and identity context; explicitly acknowledge, cancel or replace |
| AWAITING_REVIEW | Human assessment remains; no receiver request, notification or allowance usage |
| READY_TO_SEND | Human approval is available; inspect content/current context, explicitly Send, cancel or replace |
| SENT | Historical admitted first message; read the permitted receipt, not the receiver’s private inbox state |
| REJECTED | Content was rejected; correction requires a new explicit submission |
| NOT_SENT | A technical or current admission check failed; preserve text and reconcile before a deliberate new action |
| CANCELED / SUPERSEDED | This version cannot admit a request; late decisions cannot reactivate it |

Ordinary automatic approval continues the original send without another routine confirmation. Human approval always waits for an explicit Send. Acknowledgement after human review does not substitute for that Send. A later explicit Send can finish automatically if its current checks allow; if it enters human review again, that approval again requires Send. No worker or app restoration schedules a denied message to send when a later allowance window opens.

An explicit Send or acknowledgement binds the newly displayed context to the same immutable target and anchor. It may consent to a changed door mode; changing/removing the anchor or editing text requires a new submission. Replacement names the exact owned live candidate for that target and supersedes it only when registration commits. Failure before registration leaves the previous candidate live; failure after replacement cannot restore it. Independent unsent candidates do not reserve the pair. Admission rechecks pair exclusivity atomically.

The author can list retained submissions or recover a creation by its original operation key. Later actions use the known submission ID and their own action keys. Read/list/replay never send. stateVersion orders author-visible changes within one submission. Receiver decline, reading or folder changes cannot change this resource’s state, timestamps, receipt, list ordering or availability. Its D4 lifetime must be defined independently of the receiver’s private inbox lifecycle. SENT remains the historical send fact. Permitted conversation updates belong to separate participant views.

CONTACT_UNAVAILABLE conceals target/pair restrictions without hidden thread links or private retry times. REQUEST_LIMIT_REACHED describes a disclosed own allowance failure; it exposes no remaining count or trust label. Retry guidance is conditional on current known policy. The remaining restricted-account amount changes enforcement configuration, not the wire shape. D4 still governs the lifetime of candidates and recovery identities; a missing in-flight lookup never proves rejection.
