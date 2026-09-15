# Experience

This document owns journeys and visible states. Permissions and identity come from [Domain](domain.md); styling comes from [Design](design.md). A journey can use several screens or one adaptive screen without changing its behavior.

## Entry and return

The landing introduces the quiz payoff and then the possibility of conversation. Show one sample question and a clearly labeled example result before requesting a phone number; this preview earns no result and exposes no member profile. A quiz deep link keeps its destination through the entire entry flow. Before sending a phone number, explain why verification is needed and that it does not make the number public.

Age eligibility is checked before account registration. An ineligible visitor cannot continue to phone verification. A self-entered date of birth is an age declaration; copy must not describe that input alone as verified age. Collect age-related information only as required by the chosen assurance process. Do not claim that no technical data was processed merely because no account was created. The launch age-assurance decision and its required interface are tracked in [Delivery](delivery.md).

Phone entry supports country names and dial codes. Its short privacy explanation says the number is not shown to other members; it does not imply the platform or its verification provider never processes it. Verification uses native text input with paste, autofill and screen-reader support. A code may look segmented while remaining one logical input. It has an explicit change-number action, invalid-code state, resend waiting state and provider-unavailable state. A disabled button alone is not a rate-limit explanation. Do not expose whether a phone already belongs to an account before ownership is verified.

New members choose a nickname, city and representation. Group nickname and self-selected city in the same profile-details step. Nickname helper text and validation use the limits in [Contracts](contracts.md). Blank is a full representation choice, labeled “Görselsiz” in Turkish so it does not imply an incomplete profile. Nickname availability is shown only after a response for the current value; save can still report a conflict. Representation selection makes clear that adding an image is optional, explains when a photo is processing or rejected and permits continuing with blank. Avatar and photo choices affect the public profile representation; they do not select the identity mode of a message.

After the minimal profile, show a quiz and example result before asking the person to play. “Önce keşfet” opens browsing. Interests remain an optional edit-profile action with one dismissible invitation on the first Discover visit.

Use a progress indicator only where the remaining steps are known. Derive its total from the actual defined journey once the age-assurance process is selected. An avatar picker or a correction within a step does not add another main step. Returning members resume the authenticated destination or the login flow, rather than repeating successful onboarding choices.

After an interruption, derive completed onboarding steps from the account's saved state. An expired verification challenge requires an explicit resend; reopening the app does not send another SMS. Retain only the authorized destination through login, never a previous account's private screen contents.

## Quiz journey

Quiz home shows published quizzes, useful categories and a device's unfinished attempts. Avoid an empty featured slot if there is no editorial feature. No “finish everything” meter or streak is shown.

The player displays one question at a time, question progress, back navigation and the selected answer. Selecting an answer does not complete the attempt. The final action submits the complete answer set and enters a completing state. A successful response opens the result; a timeout keeps the same attempt and operation identity available for reconciliation.

Persist unfinished selections locally, encrypted and scoped to the account. Leaving the player preserves an in-progress attempt; restarting or explicitly discarding it abandons it. Resuming on another device can recover the attempt and pinned quiz version but starts with no selections from the first device. Explain that limit if needed. Expired or withdrawn attempts explain why they cannot finish; a replacement quiz or fresh attempt requires an explicit action.

The result screen shows the authored expression and whether it was newly added or already held. Both are normal outcomes. Sharing exports a clean 1:1 or 9:16 card with the same quiz destination. The card includes no account identifier or profile link. Sharing is explicit and uses the native share interface.

When a quiz was opened to satisfy the contact prerequisite, keep the originating profile and selected anchor as return context. The result screen offers a return-to-profile action; it does not skip the result or send a message. Recheck profile access and contact context on return. If the person or anchor is unavailable, explain that state and offer Discover without substituting another recipient.

## Discover and profile

Discover is a single-column feed. Pagination, refresh behavior and whether a shuffle action belongs in the experience are decided through the D7 study in [Discovery](discovery.md), not assumed implementation defaults. The feed handles first load, partial load, retry, no eligible profiles, exhausted current results and an unavailable service separately. A timeout is not “nobody is here.” Sparse-population behavior follows Discovery.

Profile detail shows representation, nickname, city, collection, bio, prompts and interests. Optional empty sections are omitted without shame copy. Results remain equally styled. A result or prompt answer can open the composer with that anchor; the general contact action opens it without one.

Profile editing distinguishes the current published values from a submitted change. If a save needs review, explain that its changes are waiting together while the current permitted profile stays visible. The owner can inspect, cancel or explicitly replace that submission. A valid current change publishes automatically after approval; show the actual publication outcome when available. A nickname or revision conflict preserves the proposed edit for correction. A pending first profile does not appear ready merely because it was submitted.

The composer entry explains an unmet quiz prerequisite and offers a direct path to a quiz. Private contact restrictions use the same general unavailable wording. A profile-required door remains a valid preference; it does not hide the person from the feed or add a warning badge.

## First contact

Contact-context changes preserve the draft and require another explicit send. Human-review continuation follows Domain. Review durations, staffing and operational response promises remain under D5; do not display an invented completion deadline.

Before the first keystroke, show “Bu mesaj anonim gidiyor” or “Bu mesaj profilinle gidiyor,” with equivalent English copy. The send label reinforces the mode. There is no mode switch or routine confirmation dialog.

Before the first anonymous send, a brief inline explanation states that the receiver will not receive the sender's profile link, may see the permitted shared points, and that the platform still associates the message with an account. The full explanation remains accessible from the identity label. Show it before submission rather than introducing the disclosure only in an outgoing request confirmation.

Keep a selected anchor visible without turning it into editable quoted text. Short, authored conversation suggestions may help with a blank composer; generating messages with a hosted model is outside the release scope. The member writes and owns the submitted message.

| Send result | Presentation |
|---|---|
| Accepted | Open the outgoing request showing that it was sent |
| Outcome unknown | Preserve the draft and operation; reconcile before a separate send |
| Door or anchor changed | Preserve text, refresh context, explain the change and require another send |
| Nudge required | Explain the concern; allow editing or explicit acknowledgement for that text |
| Human review pending | Explain that the message has not been sent and will need an explicit Send after review; offer cancellation |
| Human approval available | Let the sender inspect the message and current context, then explicitly send; opening the app does not send it |
| Content rejected | Give a safe reason category and editing path; do not describe it as the receiver declining |
| Private contact restriction | General unavailability, with no private reason or thread link |
| Own rate limit | Explain when another attempt is allowed, without a remaining-message counter |
| Service unavailable | Keep the draft and offer retry |

An ordinary automatically allowed send has no additional post-review confirmation step. The recipient sees no request or notification while the first-message candidate waits for review or the author's Send action. General review-update notifications go only to the author and contain no message text, target identity or evidence; opening one reads the owning feature's current state. Content approval alone must not be announced as successful delivery or profile publication.

Cancellation is available before the operation commits. If a concurrent send/publication has already completed, show that actual result and its normal next actions. Do not show canceled for a committed message or treat a new local draft as a canceled server submission.

The first incoming request explains silent decline and links to the door settings. The contextual explanation does not add a separate tutorial sequence.

## Inbox and conversation

Chat home separates active conversations from incoming and outgoing requests. The filtered folder is accessible and labeled; filtering does not make accepted requests disappear. A sender cannot see the receiver's folder or decline state.

A request preview shows the message, optional anchor and named shared points. Replying accepts it. Decline closes it silently. Reporting a request explains that the request will also close. For an active conversation, reporting explains that ending and blocking are separate controls.

Before the first reply, explain that replying starts the conversation while preserving its identity mode. A failed reply keeps its text; an uncertain reply outcome is reconciled before another acceptance attempt. The sender's request view says it was sent, with no read, declined or “still in their inbox” claim.

For a declined request with no conversation yet, offer the receiver an explicit return reply from the retained request. The sender sees the reply without learning that the request was previously declined. For a conversation ended by its original receiver, that receiver can send one return message; explain that further messages wait for the original sender's reply. That reply resumes the conversation. Keep the original anonymous/open identities and use the known exchange rather than exposing a hidden profile. Ordinary late replies cannot silently reopen closed exchanges, and a block prevents either return path.

The conversation header states its identity mode throughout its lifetime. The receiver in an anonymous conversation sees the sender's assigned handle; participants in an open conversation see the permitted profile representation. Sending, accepted and failed message states are visually distinct. No screen displays typing or read-receipt information, and Settings has no toggle to enable either. Reconnection repairs history through the server without duplicating bubbles.

The receiver can set, change or clear a private conversation label for their own list and header. Keep the identity-mode explanation visible alongside it; a private label must not imply a verified identity or alter the other participant's view.

Ending explains that ordinary messaging stops; the receiver's explicit return flow remains available where Domain permits it. Blocking explains that contact stops in both directions and that the first release has no unblock action. These consequential actions use clear confirmation. A read-only archived exchange retains reporting access for its retention period. Its anonymous identity remains anonymous.

## Profile, settings and safety

Edit profile handles nickname, city, bio, representation, interests and prompt answers. Collection removal explains that it changes what is displayed; deleting answer history is a separate data control. Preview shows the public profile view, not the anonymous-request view.

Settings includes notification preference, active sessions, logout, logout everywhere, door controls, blocked contexts, export and deletion. Anonymous block entries show the known conversation context without revealing a profile. The safety centre shows the member's report outcomes, applicable account restrictions and appeal access.

Explain an applicable restriction when needed to understand why an action is unavailable. Do not display a trust score, hidden trust state, reporter identity or private evidence. Precise temporary-restriction disclosure and review timing are defined with D5.

Deletion explains immediate loss of access, removal of the profile, retained participant history and restricted records in [Safety](safety.md). It requires recent authentication and explicit confirmation. Export access also requires recent authentication and a private download; it is never sent as an ordinary push attachment.

## Cross-cutting states

Onboarding, quiz play and composing are focused flows without bottom navigation. The primary destinations are Quizzes, Discover, Chats and Profile. System back preserves a recoverable draft or asks about discard where loss would be unexpected.

Drafts belong to a specific account and quiz attempt, recipient or exchange. Opening a different profile must not carry over the previous person's message. Resuming a draft refreshes its identity and anchor context before enabling send. Remove only the submitted draft after its send is confirmed; a late response must not erase newer text. Explicit logout, account switching and deletion clear private local drafts under [Mobile](mobile.md).

Use skeletons for predictable list shapes, a progress indicator for a submitted operation, and actionable errors. No universal rule requires a spinner-free UI or a retry button for permanent unavailability. Preserve meaningful text enlargement and keyboard visibility. Identity, destructive-action and privacy explanations must not be truncated to preserve a fixed layout.
