# Safety

## Protection and disclosure

Protect receivers through admission checks, manageable inbound load, blocking, reporting and accountable moderation. Treat reports as allegations and automated classifications as fallible signals. Payment cannot relax a protective restriction. Anonymous accounts remain accountable to the platform within purpose-limited access; they are not anonymous to every system component.

The application does not expose an anonymous sender-to-profile link. It cannot prevent recognition from writing, rare shared items, screenshots, voluntary identification or observations of changed contact availability. Pushes, exports, error responses and blocked lists obey the same disclosure rule as the conversation UI. No staff role grants unrestricted casual browsing of messages.

## Entry and access

The product is 18+ and requires phone verification before browsing. A declaration and an SMS code do not prove age. The real-user age-assurance and recovery decisions in [Delivery](delivery.md) must be settled before the external pilot. Do not create a mixed adult/minor pool or describe an installation identifier as proof of a person.

Rate-limit verification by normalized phone key and network source, with global spend control and provider failure monitoring. Keep account existence private before successful verification. Initial local limits are five verification guesses per challenge, a 60-second resend interval, five sends per number per hour and twenty sends per network address per hour. Provider limits can be stricter. These are operating defaults that require pilot monitoring, particularly on shared networks.

A banned account loses consumer access and active sessions. Restricted appeal access uses a narrow identity-bound path; it is not an ordinary session that can browse or send. Reinstalling an app does not clear server-side restrictions. A different phone or device can evade weak identifiers, so durable bans must not be described as impossible to evade.

## First contact and public text

Human review remains a moderation capability. An item waiting for review is not an admitted request and must not be shown as sent. [Domain](domain.md) defines how approved first messages and profile changes continue, including cancellation and replacement; [Experience](experience.md) defines their presentation. Provider failure is a separate outcome. Contact information in a first message may inform review but does not alone impose an account penalty.

Safety records an assessment of the submitted version; the owning module controls publication or admission after current authorization and version checks. A human content approval cannot edit the member's wording beyond required normalization or authorize a different target, text or purpose. Rejection is not a recipient refusal or, by itself, an account penalty. D5 still governs providers, operational review handling, trust/enforcement details, thresholds, appeals and staff coverage. Unpublished candidates and their review evidence need their own purpose/lifetime decision under D4; an admitted request's retention period does not implicitly govern them.

Classify first-message text and public nickname, bio and prompt text before publication. Decisions are allow, nudge, reject or queue for human review; service unavailable is a separate failure outcome. A nudge permits an explicit acknowledgement tied to that exact normalized text and current policy. Rejection or unavailable service creates no request/public update. A new text revision needs its own decision.

Keyword filters and a restricted sender can route an otherwise admitted request to the receiver's filtered folder. The request remains accessible. Classifier-rejected text is not hidden there as if delivered. Pending-request volume alone neither rejects new contact nor moves valid messages out of the main inbox. There is no hard receiver pending-request limit; exposure and inbound distribution are addressed through the dedicated Discover study.

Keyword matching uses normalized, case-folded text with literal substring matching; no regular expressions or user-supplied code. The receiver sees which own filter routed a request; the sender does not learn the keyword or folder. A keyword alone does not create a misconduct finding against an account.

For first contact, external prechecks happen before the guarded admission transaction. Current blocks, door, account state, pair restrictions and limits are rechecked during admission as specified in [Backend](backend.md). Profile can first register a private candidate and durable checking work in its own short transaction; external checks remain outside transactions and precede final application. Candidate registration grants no publication permission. A hosted classifier timeout cannot silently grant cold-contact permission or publish a profile change.

Profile photos are public-to-members content. Decode and validate the upload against [Contracts](contracts.md), strip embedded metadata and inspect it before publication. Reject explicit sexual imagery and graphic violence on this surface; quarantine suspected child exploitation material for restricted specialist handling under the applicable operating policy. A classifier result alone is not a permanent-ban decision. Unsupported or unreviewable images stay private, with a retry or replacement path; the member can keep a blank representation. Do not accept an arbitrary external URL as an upload substitute.

## Limits and re-contact

Refusal-based restrictions protect the original receiver from renewed approaches by the original sender. They do not prevent the receiver from changing their mind and initiating contact. An original sender ending the conversation adds no cooldown by itself. A receiver closing a pending request by reporting it records a refusal, without an automatic misconduct finding or account penalty. Domain defines the two receiver-return paths; an account-level block is a separate bilateral restriction.

| Policy | Rule and scope |
|---|---|
| New-account period | First 72 hours from verified account creation |
| Free-plan cap | At most 10 accepted first requests per day; all first-release accounts use this plan |
| Paid-plan cap | At most 25 accepted first requests per day; planned with subscriptions after the first release |
| Ordinary protective cap | At most 25 accepted first requests per day, independent of payment |
| New-account protective cap | At most 5 accepted first requests per day during the new-account period |
| Restricted-account protective cap | Reduced allowance; the amount requires the contact-policy decision in Delivery |
| Re-contact cooldown | The original sender cannot send that receiver a new request for 14 days after the receiver declines or ends their conversation |
| Repeated receiver refusal | The same receiver's second refusal prevents future new requests from the original sender to that receiver |

Commercial and protective caps are separate. The effective allowance is the minimum of the plan cap and every applicable protective cap. Ten is the free-plan cap, not a universal safety ceiling. Payment can change the commercial allowance but cannot raise a protective cap. Daily accounting uses accepted requests in the rolling previous 24 hours, measured by server admission time. At admission instant t, count prior admissions in (t minus 24 hours, t]; an admission exactly 24 hours old is outside the window. Device time, calendar midnight and timezone changes do not reset usage. D10 retains only the restricted-account amount; do not select it as an implicit default.

Rejected attempts, pending moderation candidates and canceled unsent submissions do not consume an accepted-request allowance. Recipient decline, filtering or later closure does not refund a successfully admitted request. Replies and active-conversation messages have no product quota, but still have technical abuse limits and account authorization. Limits do not appear as a remaining-message scoreboard. These sender allowances do not establish a receiver inbox cap.

Messaging owns accepted-send counts, atomic allowance enforcement and pair state. Safety owns protective policy and cannot inspect commercial entitlements. The free-plan cap is a simple first-release plan policy; future Commerce supplies paid entitlements separately. A decline or ending by the original receiver records that receiver's refusal. Closing a pending request by reporting counts as one receiver refusal, even if the report is retried. Ending by the original sender creates no new cooldown and clears no existing refusal restriction.

The original receiver may initiate a return despite a refusal-based cooldown or repeated-refusal restriction. This does not authorize a profile lookup for an anonymous sender, reverse an exchange's identity mode, lift a block or bypass account restrictions. The initiating receiver's action alone does not clear refusal history or grant the original sender new-request permission. Use Domain's explicit return reply after a declined request, or its single return message followed by the original sender's reply after a receiver-ended conversation. Reopening an existing exchange does not erase the original direction or refusal history. These paths require current account access and cannot bypass a newer open exchange for the pair.

No user unblock action exists in the first release. Blocks apply at account level in both directions. The blocked list exposes only the identity context the blocker already knew. Retained histories are read-only, and reporting remains available for the retained exchange.

## Accepted conversations and moderation

Accepted text is not analyzed for attraction, sentiment, ordinary adult intimacy or commercial conversion. A narrow critical-safety scan covers credible threats, indications of a minor or grooming, coordinated scam patterns and self-harm support needs. Explain that scope in the privacy experience; do not say private messages are never processed.

Self-harm signals route supportive, locale-appropriate information and human escalation where warranted; that signal alone does not cause account punishment. Classification of critical cases can fail. An unavailable asynchronous scanner leaves durable pending work and alerts operators; it is not described as completed protection.

Retain an internal trust assessment and the named normal, restricted, warned, suspended and banned states. Identity owns suspension/ban access enforcement; Safety owns the protective assessment and review. No member, including the account owner, sees a trust score or hidden trust-state label. Low reply rate or inferred desirability alone does not justify punishment. Explain an unavailable action when necessary without exposing reporters or private evidence.

Temporary-restriction inputs, positive trust signals, disclosure details, duration and human review/extension behavior are defined with D5. Do not invent numeric thresholds or automatically expire an unreviewed restriction after 24 hours. New-account exposure treatment belongs to D7. Reports remain allegations and permanent enforcement requires accountable review.

Reviewers can inspect only assigned or explicitly claimed cases and the minimum relevant evidence. Evidence from a reported message is resolved through the owning module after participant authorization. Safety stores the submitted snapshot rather than acquiring general query access to Messaging. Permanent enforcement and appeals record the actor, reason category, evidence references and timestamps.

Use labeled Turkish and English evaluation cases, including obfuscation, benign quoted text and false-positive challenges. Before enabling a classifier in real-user traffic, record per-class results and the operating thresholds chosen by the responsible reviewer. A fixed sample count or a green schema check does not establish detection quality. Staffing and response commitments are an external-pilot gate; do not promise a 24-hour human response without actual coverage.

## Data retention and deletion

The table contains candidate retention periods pending D4. Newly specified durations are not approved implementation defaults or user promises. Do not implement time-based deletion or promise these durations before the data-purpose and operating review. Established account deletion, protection of retained participant history and no automatic pending-request expiry remain product constraints.

| Data | Proposed lifetime and deletion behavior; approval required |
|---|---|
| Phone lookup keys and account metadata | Account lifetime; remove ordinary account association on deletion after cleanup |
| Active session material | Session lifetime; revoke immediately on logout/access loss and purge expired credential records within 7 days |
| OTP metadata and network abuse keys | Up to 7 days; no plaintext code or routine raw-number logs |
| Unfinished quiz attempts and local quiz/composer drafts | 7 days since last activity; clear local drafts on logout or account change |
| Completed answer sets | 90 days after completion; explicit answer-history deletion removes them earlier |
| Completion prerequisite and current collection | Account lifetime; independent of retained answer sets |
| Pending request content | While pending; no time-based request expiry |
| Closed, unaccepted request content | 180 days after closure; sender projection still does not disclose a decline |
| Conversation content and admitted snapshots | While active, then 180 days after ending, severing or account deletion closes the exchange |
| Reports and evidence | Case lifetime and 180 days after final resolution, unless a documented hold applies |
| Ban lookup identifiers | Up to 1 year after enforcement, with a documented review before any extension |
| Device push registration | Until logout, provider invalidation or account deletion |
| Feed exposure events | 30 days; longer reporting uses aggregates without viewer/profile identifiers |
| Content-free operational logs | 14 days; sensitive security audit records restricted to 180 days |
| Backups | 30-day rolling retention; restores replay the deletion register before serving traffic |

Deletion immediately revokes sessions, marks the account unavailable and stops new contact. Each owner then runs retryable cleanup for profile data, collections, media, device tokens and local event references. Close its active/pending exchanges without exposing a new identity. The proposed ordinary-data cleanup target is 7 days, pending D4; failures alert operators and remain visible to the deletion workflow.

Delivered history retained for another participant keeps only what that feature and retention policy require. A private enforcement association may remain separately. Do not claim that every identity link has been irreversibly destroyed while evidence still retains one. Deleting an answer set does not retract a result already shown in someone else's accepted snapshot.

Operational metadata also needs retention: proposed cleanup targets are 7 days for completed event publications/provider delivery records and 24 hours for abandoned uploads, pending D4. Discovery's study must define any temporary pagination/session state, its expiry and cleanup; this document does not require a particular session architecture. Failed jobs remain restricted until resolved or explicitly discarded under an audited policy. Media is private while processing; deleting or replacing a photo removes obsolete objects through retryable cleanup.

Trait Signal is absent from first-release storage. Its later study must explicitly define retention and deletion of derived contributions alongside raw-answer deletion; the current answer-retention period does not authorize retaining a hidden signal indefinitely.

Exports contain the member's own data and permitted participant history. They do not expose an anonymous peer's account, other reporters or hidden enforcement evidence. Require recent authentication and an expiring private download; the proposed artifact lifetime is 24 hours, pending D4. Required external processing, hosting region, special legal holds and report duties are resolved through the real-data review, not guessed from generic legal slogans.

## Operations

Population metrics trigger operator review; they do not automatically tighten sender quotas. Preserve receiver-first protection and evaluate harassment burden on women without inferring demographics or collecting a new demographic field by default. Monitoring and incident controls remain required.

Use a severity-ordered review queue, a visible case state and an appeal path. Reporters receive a permitted outcome category without private evidence. Staff accounts use a separate authentication realm and least-privilege roles; evidence reads and exports are audited.

Monitor verification spend, rejected first contact, receiver load, report backlog, classifier failures, false positives and deletion backlog. A low reply rate alone cannot automatically tighten safety policy or penalize an account. Incident controls can disable new contact, stop uploads or pause discovery independently while preserving reporting and support access.
