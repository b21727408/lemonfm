# Profile changes

[Contracts](../contracts.md) owns shared HTTP conventions; [OpenAPI](../../contracts/http/public-v1.yaml) owns the wire shapes. This reference owns the following cross-operation behavior. Read only the sections needed for the feature.

## Profile-change protocol

An active verified owner can submit before profile readiness or quiz completion. Registration atomically stores a normalized immutable patch, its operation identity and durable processing work. A new submission receives 201 and a Location pointing to its change resource; this confirms creation of the candidate. Its state determines whether the save subsequently applied. A replay returns 200 for the same candidate with its current permitted projection. [HTTP resource creation](https://www.rfc-editor.org/rfc/rfc9110.html#section-15.3.2)

| Candidate state | Meaning and next action |
|---|---|
| PROCESSING | Automatic checks or final application work remain; read state, cancel or explicitly replace |
| AWAITING_ACKNOWLEDGEMENT | Show the readable candidate and current warning; acknowledge explicitly, cancel or replace |
| AWAITING_REVIEW | Human assessment remains; current permitted profile stays visible; cancel or replace |
| APPLIED | The entire save committed; read own profile for current fields/readiness |
| REJECTED | Content decision prevented application; correct through a new explicit save |
| NOT_APPLIED | A technical failure or current publication predicate prevented application; show the safe problem and reconcile/correct |
| CANCELED / SUPERSEDED | This version cannot apply; do not restore it after a late assessment |

Terminal states do not reactivate. APPLIED records a save, not a guarantee that onboarding is complete or those values are still current. No-op saves may retain the profile revision. A technical check failure after registration is NOT_APPLIED with SERVICE_UNAVAILABLE, not a content rejection or fabricated human-review queue. HTTP failure to read or register a resource remains a separate ApiError.

Each submission carries the saved expectedRevision. Its changes are a complete patch against that saved profile: omitted fields preserve saved values, null clears only bio, empty arrays clear their lists and BLANK clears representation. A replacement includes every pending edit intended to survive, rather than implicitly merging the old candidate. The explicit replacesChangeId prevents another device's pending save from being silently superseded. Failure before registration leaves that old candidate intact; after successful replacement it never resumes, even if the replacement later fails.

Read-by-operation resolves an uncertain creation using the original creation key; read-by-ID resolves a known candidate's actions. The latest resource aids recovery without a local candidate ID, including on another device, but is not draft synchronization or a history list. An absent lookup during an in-flight registration is inconclusive. Acknowledgement and cancellation use separate action keys bound to that change ID; neither targets whichever candidate happens to be latest.

Owner responses may omit withheld candidate content; omission does not clear the saved profile. A nudge requires readable content and a current author/content/policy-bound token. Replays and stale responses cannot restore withheld content or acknowledge a new prompt automatically. stateVersion orders visible updates within one candidate, independently of saved-profile revisions and session/request generations. The YAML defines the exact conditional response shape; authorization and atomic transitions require implementation tests.
