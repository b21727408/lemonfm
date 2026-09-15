# Domain

This document owns entities, permissions and state transitions. [Experience](experience.md) owns their presentation, [Safety](safety.md) owns protective policies, and [Backend](backend.md) owns persistence and transaction mechanics.

## Accounts and profiles

An account identifies a member to the platform. Phone verification establishes control of a number at a particular time; it does not prove a unique human, a legal identity or an age. Age assurance, number recovery and credential handling follow Safety and Backend.

Account access, profile readiness and contact eligibility are separate. An active verified account with a nickname and a supported city may browse. Its representation can be blank, an authored avatar or an approved photo. Bio, interests and prompt answers are optional. Completing a quiz is required before creating a request, not before browsing or replying to one.

An account can be active, suspended, banned or deleted. Suspension and banning stop ordinary access and messaging; a restricted support or appeal path may remain available. Deleted is terminal for that account identity. Account recreation must not restore deleted data or bypass retained enforcement decisions.

The profile contains the member's nickname, representation, bio, selected interests and prompt answers. Its collection is read from quiz-owned results. Public profile access means access by eligible authenticated members. Sharing a quiz does not publish an account directory or expose profiles to unauthenticated visitors.

Nickname uniqueness uses a server-defined normalized key. A nickname check is advisory until the update commits. Clients cannot claim a nickname merely because an earlier availability request succeeded. Storage identifiers are independent of nickname and locale.

## Moderated submissions

A submitted content candidate is distinct from a published profile or an admitted request. Profile owns its change candidates; Messaging owns first-message candidates. Each submission identifies its author, immutable content version, intended target/purpose and relevant base revision. Safety owns the associated content assessment and review case. A submitted candidate is readable only through the author's authorized view and purpose-limited review access; it is not exposed in ordinary member profiles or the recipient's inbox. This does not add synchronization of unsent device-local drafts.

| Content decision | First message | Profile change |
|---|---|---|
| Automatic allow | Continue the original send through current admission checks | Apply the explicit save if current and valid |
| Human review pending | No request, sent state or accepted-send usage | Current permitted profile stays visible; submitted changes stay private |
| Human allow | Wait for the sender's explicit Send action in current context, then run admission checks | Publish the still-current, valid save automatically; no second Save action |
| Reject or provider unavailable | No request or receiver refusal | No publication or partial application of that save |

Human approval of a first message cannot send it later without that explicit action. Approval remains bound to the same author, recipient, content and purpose and cannot bypass a changed policy, block, account restriction or other admission rule. Only actual request admission consumes an accepted-send allowance. A failed final allowance check never schedules automatic sending when a later window opens. Contact-context and pair rules below govern admission; Safety owns rolling 24-hour allowance accounting and the remaining restricted-account amount.

A single profile save is atomic across the fields it changes. If one changed field needs review, that save waits as a whole. The client need not resubmit every unchanged profile field. Before publication, recheck the saved base revision, current account access, nickname validity/uniqueness, active catalog references and ready owned media. A queue entry does not reserve a nickname; a conflict keeps the proposed edit available for correction without a generated suffix, silent merge or partial publication. Unapproved profile values cannot satisfy onboarding readiness or restore content removed by a safety action. Other features' safety settings, blocks and account deletion do not wait for this save.

There is one current pending profile change per account. An explicit replacement submission supersedes a still-pending candidate and uses a new content version. Local typing alone does not cancel a server submission. If the earlier change has already published, the next save must be reconciled against the current revision. A rejected, canceled or superseded version's decision cannot apply to another version. First-message candidates reserve neither a pair nor a receiver slot; only admission creates the exclusive open exchange. Explicit replacement identifies the author's exact still-live candidate for the same target. Distinct candidates still face the same pair check at admission, and cannot create a second open exchange.

The author can cancel a candidate before publication or admission commits. Cancellation and commit have one authoritative outcome: if cancellation wins, late decisions cannot activate it; if commit wins, the app cannot report successful cancellation. An admitted message follows the existing no-unsend rule; a published profile can be changed through a new edit. Duplicate submissions or review decisions cannot create another candidate, publication, request or quota charge. After a lost response, reconcile the originating operation instead of inferring rejection or creating a replacement automatically.

## Quiz and attempt

A quiz has a stable identifier and immutable published versions. An attempt belongs to an account and one published version. The result-calculation method, scoring data and any tie handling are unresolved in the dedicated [Content](content.md) study. Once approved, the calculation definition is versioned with the quiz and the server produces the authoritative outcome. Replaying a completed attempt returns its stored outcome without recalculation.

| Attempt state | Meaning | Allowed next action |
|---|---|---|
| In progress | No result has been earned | Complete or abandon |
| Completed | One accepted submission produced one result | Read outcome or start a new attempt |
| Abandoned | Explicitly discarded or restarted, or its draft lifetime ended | Start a new attempt |
| Invalidated | Its version was withdrawn from completion | Read the reason category and choose available content |

A normal content publication does not reinterpret an active attempt. The pinned version remains usable for its allowed lifetime. A safety withdrawal invalidates unfinished attempts on that version and must be reported as unavailable. Completed results are removed or redacted only through an explicit content or safety action.

There is at most one in-progress attempt per account and quiz. Resuming retrieves that attempt; explicitly restarting abandons it and creates another. Devices may share the attempt identity, but unfinished selections are device-local. Two devices can submit the same attempt; only one payload can complete it. The other receives the same outcome for an identical submission or a conflict for different answers.

Completion validates question identifiers, allowed options, answer count, ownership, version availability and the operation identity. Missing or invalid answers create no result. A completed attempt cannot be edited. Re-solving creates a separate attempt and may earn another result.

The quiz module retains the fact that an account has completed at least one quiz independently of answer-history retention. Deleting answers or removing every displayed result does not revoke that contact prerequisite.

## Results and collection

A result is a stable authored expression, not a diagnosis or a compatibility judgment. Its identity is independent of localized titles. Copy changes preserve meaning; materially different meanings use a new result identity. A completed attempt retains the version and result it produced.

The collection contains distinct results the member currently displays. The same result cannot appear twice. A retake can add a different result without removing earlier distinct ones. Re-earning an already-held result does not change its collection position.

All collection items have equal presentation status. There is no featured, pinned or headline slot, rarity order, completion meter or result-based theme. The stable order is most recently added to the current collection first, then result identifier as a tie-breaker.

Removing a result removes it from the current public collection and new shared-point calculations. It does not erase quiz completion, retained answers or previously accepted message context. It is not silently restored. A later explicit completion can earn it again and create a new collection-added time.

Answer history and account deletion are separate controls governed by Safety.

## Trait Signal — planned after the first release

Trait Signal is a hidden contribution derived from quiz answers, not from the result displayed in a collection. It is intended to inform Discover ordering. Visible expression and internal inference are distinct; neither is substituted for the other.

Each quiz contributes at most once per account, normalized so that retakes replace that quiz's contribution without increasing its weight. No member-facing surface, export about another member or public API exposes internal axes, a signal vector, pairwise distance or a compatibility score derived from the signal. Permitted shared-point labels still name actual public results and interests.

The model is not implemented or populated in the first release. Its axes, normalization method, comparison, ownership details and treatment of retakes, version changes, answer deletion and account deletion are part of the dedicated study in [Content](content.md). Deleting retained raw answers and retaining a derived signal cannot acquire an implicit policy through an implementation choice.

## Commerce — planned after the first release

A subscription grants commercial entitlements; a boost increases a profile's exposure. Neither changes an anonymous exchange's identity mode nor overrides consent, blocks, cooldowns or protective restrictions. Boosting cannot purchase a better compatibility assessment. Detailed entitlements and the boost allocation method remain subject to product study.

Commercial plan caps and protective caps are distinct and compose as specified in Safety. First-release accounts use the free plan. Billing, paid entitlement state and boost activation are deferred; their absence from the initial runtime module set does not remove these product capabilities.

## Interests, prompts and shared points

A member selects at most five active interests from an authored catalog and answers at most three active prompts. Interests are identifiers with localized labels; prompt answers are moderated free text. Retired catalog items cease appearing in current profiles and new shared points. Historical message snapshots follow their separate retention rules.

Shared points are named results or interests both people currently display. They are never shown as a count, score or claim of compatibility. The receiver of anonymous contact can learn these permitted shared items without receiving the sender's profile or full collection. Specific shared items can still support inference; the product does not claim inference-proof anonymity.

## Door and contact context

The receiver's door determines the identity mode of new requests:

| Door | New request |
|---|---|
| Anonymous allowed, default | Anonymous sender and open receiver |
| Profile required | Open sender and open receiver |

The sender has no mode selector. Before writing, the server supplies the currently applicable mode and a contact-context revision. The submission is conditional on what was displayed. Both anonymous-to-open and open-to-anonymous changes require a refreshed context and another explicit send; the app preserves the draft and never retries under a changed mode automatically.

Door identity, keyword filtering and safety restrictions are distinct. A profile-required door does not exclude the profile from Discover. Completing a quiz does not override an account restriction, block or re-contact rule. Discover eligibility is not a grant to send.

The door applies when a request is admitted. Later changes do not rewrite that request or any resulting conversation. The authoritative ordering of a send against a door change, block or account deletion follows Backend's transaction rules.

## Request

A request is a first message admitted by the server and awaiting the receiver's reply. Server admission records a successful send; the receiver's first reply starts the conversation. Sender and receiver must be different accounts. At most one pending request or active conversation can exist for an unordered account pair. Opposite-direction requests and anonymous handles do not create exceptions.

The caller supplies the target profile, message, contact-context revision, operation identity and optional anchor reference. Server code resolves accounts, permissions and content. A client-provided profile identifier never authorizes access to that profile or to an exchange.

An anonymous request exposes no sender nickname, photo, public profile identifier, full interest set or reusable alias. The receiver sees the message, permitted shared points and optional anchor. After the receiver's first reply, a conversation-scoped handle identifies the anonymous participant. The sender cannot choose or preview a public-facing persona for that handle.

### Anchor

An anchor is optional from the profile's general contact action. When writing from a result or prompt answer, the selected item and its revision must still belong to the receiver and be visible at admission. A changed or removed item causes a context conflict, preserves the draft and requires a new explicit send. The app does not silently drop or substitute the anchor.

Accepted anchors and shared points become snapshots. Subsequent edits do not rewrite the historical message context. Snapshot content can be restricted or redacted for safety or retention; “snapshot” does not confer permanent publication rights.

### Admission

Pair exclusivity covers both directions and any conversation waiting for a return reply. A candidate, content approval or contact-context read cannot reserve that pair. Refusal handling follows Safety; an unavailable pair must never reveal a hidden identity association or produce a fabricated successful send.

Admission checks current account access, profile readiness, the sender's completion prerequisite, door revision, safety eligibility, pair state, applicable sender rate limits and anchor validity. A rejected operation creates no request and consumes no accepted-request allowance. External content checks run before the short admission transaction; their decision must apply to the submitted text.

Accepted filtered requests still exist and are readable by the receiver in the filtered folder. Requests requiring a nudge acknowledgement or blocked by a classifier have not been accepted. A receiver's number of pending requests does not reject an otherwise eligible request, close contact entry or move valid requests to a hidden folder. Balancing exposure and inbound distribution belongs to the Discover study; it does not create a receiver admission cap.

| Current state | Action | Outcome |
|---|---|---|
| No open exchange | Eligible first send | One pending request |
| Pending | Receiver's first reply | One active conversation containing both messages |
| Pending | Receiver declines | Closed request and re-contact restriction |
| Pending | Receiver reports | Closed request, refusal recorded, report opened |
| Pending | Either participant blocks | Closed request and bilateral account-level block |
| Pending | Either account is deleted | Closed request; retained history follows Safety |
| Closed after receiver decline, no conversation yet | Receiver explicitly returns with a reply | Conversation starts with the original identity mode; no prior-decline disclosure |
| Other closed state | Ordinary late reply | No implicit reopening |
| Pending, active or awaiting return reply | Another create for the pair | No second exchange |

A reply and decline racing for a request have one authoritative outcome. Repeating the first reply does not create another conversation or message. Pending requests do not expire simply because the receiver has not replied. Hiding one is not a decline and does not change its pending state.

Pair deduplication must not reveal an anonymous sender. If a receiver tries to contact the open profile behind an anonymous incoming request, return general contact unavailability. Do not return the anonymous thread identifier, redirect to it or describe the account-to-thread relationship. An existing exchange may be linked only when that caller already knows the same profile-to-exchange association through it.

### Silent decline and re-contact

A decline sends no notification and exposes no declined or read state to the sender. The sender's outgoing view reports the historical fact that the request was sent; it does not expose the receiver's private inbox state. A successful send must never be fabricated for an operation the server rejected.

Further contact can become unavailable under Safety's cooldown and refusal rules. Private restriction reasons share a general response. Observing changed availability can still support inference; silence means absence of an explicit disclosure, not impossibility of deduction.

The original receiver can change their mind and initiate contact with the original sender despite those refusal-based restrictions. Preserve the established visibility relationship: an anonymous sender stays anonymous to that receiver, including when the receiver initiates the return. A return must not expose a hidden profile identifier, turn the anonymous participant into an open recipient through role reversal, or lift an account-level block. If the receiver declined before a conversation began, their explicit return reply starts that conversation like an ordinary first reply. The sender receives the reply without a previous-decline label or special rejection-history payload. If the receiver ended an established conversation, their explicit return sends one message into that retained exchange and waits for the original sender's reply; no additional receiver messages are admitted while waiting. That reply reopens the conversation. A stale ordinary reply cannot invoke either return path implicitly.

## Conversation and messages

A conversation begins with the receiver's first reply and inherits the request's identity mode permanently. No reply, duration, paid feature or mutual action reveals an anonymous profile.

| State | Sending | History |
|---|---|---|
| Active | Both participants, subject to account and safety checks | Participant-scoped |
| Ended | No ordinary sends; original receiver may explicitly return after their own ending | Retained under Safety policy |
| Awaiting return reply | Only the original sender can reply to resume; no additional messages from the returning receiver | Participant-scoped retained history, including the return message |
| Severed | No new messages or new contact across the blocked pair | Read-only archive and reporting access under Safety |

Either participant may end a conversation, including while it awaits a return reply. Ending does not delete delivered messages. The re-contact policy distinguishes a receiver refusal from a sender ending their own exchange. Hiding an exchange affects only the member's list; it cannot change state, remove evidence or affect the other member.

Each accepted message has a stable identifier and server-assigned sequence within its exchange. Requests and the first reply remain part of that ordering. Retried submissions and repeated socket deliveries are not additional messages. Device time and network arrival order do not determine authoritative order.

No user can edit or unsend an accepted request or message. Safety redaction and retention deletion are separately authorized operations. A sending indicator means the outcome is not yet known; sent means committed by the server, not read by the other person. After a lost response, the client reconciles or retries the same operation before offering a separate send.

The anonymous handle is stable within one conversation and unrelated across conversations. The receiver can report or block that participant through the exchange without learning their public identity. First-release messaging is text-only; reactions are deferred. Typing indicators, read receipts and online presence are excluded from the product.

The receiver may give any conversation a private label visible only to that receiver. It does not rename the sender, change the system handle or appear to the other participant, in notifications to them or in shared data.

## Planned social capabilities

Saved profiles are private bookmarks. The saved person is not notified and does not receive a saved-by list or count. Duo quizzes belong to an existing conversation: participants solve independently, one finished side is withheld until both finish, and the pair sees two results without a compatibility score. Ignored invitations expire without a nudge; the expiry duration remains feature work. Saved and duo are planned after the first release.

Reactions and message media remain later work; media needs its own consent, blur, moderation and disclosure design before implementation. None of these features can reveal an anonymous profile or loosen a block. Typing indicators and read receipts are not future capabilities.

## Visibility and access

| Data | Receiver of anonymous contact | Participant in open contact | Unrelated member | Platform |
|---|---|---|---|---|
| Sender profile through the exchange | No link or identifier | Allowed while profile access remains valid | No exchange link | Purpose-limited association |
| Message and accepted snapshot | Own exchange only | Own exchange only | No access | Delivery and authorized safety purposes |
| Conversation handle | Own anonymous exchange only | Not a substitute identity | No access | Scoped delivery and safety use |
| Full quiz answers or internal signals | No access | No access to the other person's data | No access | Quiz function and permitted retention |
| Phone, credentials or private reports | No access | No access | No access | Restricted functions only |

Opening a profile through a separate legitimate route must not expose its association with an anonymous exchange. The same rule applies to exports, push payloads, attachment metadata, errors, analytics and staff-to-user responses. No generic account serialization is suitable for every audience.

## Block, report and deletion

Blocking applies to both directions at account level, including existing handles. The first release has no user unblock operation. A block initiated from an anonymous exchange appears in the blocked list using that known context, without a newly exposed profile link.

A report is an allegation, not a finding. Reporting a pending request closes it; closure by its receiver also records that receiver's refusal once. Reporting an active conversation does not itself end the conversation. Ending and blocking remain separate actions. Report outcomes disclose a permitted category, never the accused person's hidden identity or another person's evidence.

Account deletion revokes sessions and removes the profile from new discovery and access. Retained delivered messages can remain in the other participant's history for the defined lifetime. An open profile link becomes unavailable; an anonymous exchange gains no new identity. Restricted enforcement records and backups follow Safety's retention matrix. Exporting one's data does not expose an anonymous peer or confidential reports.

## Acceptance examples

| Scenario | Required result |
|---|---|
| Complete an attempt twice with identical answers | One completion, same result |
| Reuse that operation with different answers | Conflict, unchanged completion |
| Retake and earn an already-held result | No duplicate or position bump |
| Remove the only displayed result | Collection empty, completion prerequisite still satisfied |
| Publish a new quiz version mid-attempt | Original version and scoring retained |
| Withdraw the pinned version | Explicit unavailable outcome; no new result |
| Change the door before admission | No send under the stale identity context |
| Remove the selected anchor before admission | No silent context substitution |
| Block commits before admission | No new request |
| Send in both directions concurrently | At most one open exchange |
| Send to a receiver with many pending requests | Pending count alone does not reject an otherwise eligible request |
| Contact a profile linked internally to an anonymous incoming request | Generic unavailability; no thread link |
| Reply twice or race reply with decline | One valid transition and no duplicate message |
| Decline a request | No declined/read disclosure to its sender |
| Disconnect after message commit | Recover the same accepted message |
| Block through an anonymous thread | Contact stops; blocked list reveals no profile |
| Delete an anonymous participant's account | No new identity link; retention rules applied |
