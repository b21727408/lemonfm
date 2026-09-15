# Content

This document owns authored quizzes, results, interests and prompts. [Domain](domain.md) owns the effect of completion. [Contracts](contracts.md) owns serialization conventions, and [Safety](safety.md) owns moderation.

## Writing

A quiz should be enjoyable to answer, produce a recognizable observation and give two people something to talk about. A result describes a behavior in a situation. Prefer a specific detail over generic praise or a grand personality category.

Use warm self-recognition rather than humiliation. Do not diagnose, infer protected characteristics or describe a person as more desirable than another. Avoid fortune-telling, identity stereotypes and interchangeable result copy. A funny title still needs an explanation that follows from the answers.

Questions should offer plausible choices. Avoid an obviously admirable option surrounded by absurd alternatives. An answer must not be attractive only because it is kinder, smarter or safer than the rest. People should be able to recognize themselves in more than one option without feeling forced into an insult.

Turkish and English versions preserve result identity, question meaning and scoring while using natural phrasing. A language can change the joke without silently changing what an answer means. A result is not accepted merely because a translation is grammatical.

## Quiz definition

A published quiz contains a stable quiz identifier, immutable version, category, localized title and description, ordered questions, answer options and result definitions. Its scoring representation is finalized through the study below. The schema contains no executable expressions, scripts or arbitrary remote URLs.

## Open study: quiz result scoring

Quiz scoring is not decided. It requires a dedicated, detailed product and content study, separate from Discover ranking and Trait Signal. No weighted-sum formula, integer-weight requirement, tie order or question/option count is a production default. The product owner approves the study's outcome before the method and its data schema are implemented.

The study must address:

1. What each quiz is trying to express, what distinguishes its results, and how plausible answers support those meanings.
2. Candidate calculation methods, their tradeoffs and worked examples on complete authored quizzes. An illustrative method is not a selected method.
3. Answer representation, question/option/result counts, contribution rules, ties or ambiguity where applicable, and the intended repeatability of results.
4. Result reachability and distribution, including degenerate cases, dominant outcomes, weak distinctions and sensitivity to small answer changes.
5. Turkish/English semantic consistency, editorial calibration and human review of whether a result follows from the answers.
6. Versioning, regression examples, server calculation, invalid submissions and the validation strategy that fits the selected method.

Completion evidence is an approved method specification, complete reviewed quiz examples, worked answer-to-result cases, the required content schema and a verification plan that covers ordinary and edge outcomes. The foundation's real quiz slice depends on this decision. Isolated test or design fixtures may exercise storage and presentation, but cannot choose the production method or count as an accepted product quiz.

## Validation

| Property | Required check |
|---|---|
| Identity | Unique identifiers; every referenced option and result exists |
| Localization | Both launch locales contain all required semantic fields |
| Answer shape | Every question has selectable options and one answer is required |
| Scoring data | Matches the approved method and schema; no unsupported expression or reference |
| Reachability | Each advertised result is reachable under the approved method; demonstrate this using its verification strategy |
| Regression | Authored answer cases satisfy the approved calculation and repeatability rules |
| Presentation | Longest strings are inspected in player, result and share card |
| Voice and safety | Human review of meaning, stereotypes, clarity and moderation |

Quiz length and option/result counts follow the scoring and editorial study. Select a verification approach suited to the approved method and answer space; exhaustive enumeration is an option where practical, not a constraint that dictates the product's format.

Synthetic answer combinations and observed human answers provide different evidence. Evaluation must distinguish them. A skewed real distribution can be valid and is not automatically corrected by hiding results or manipulating answers.

## Results, versions and withdrawal

Once published, a quiz version is immutable. Corrections publish another version. Copy-only corrections preserve result identities and meaning. A semantic change creates a new identity or a separately specified migration; it does not reinterpret existing completions silently.

New attempts use the current published version. Active attempts retain their pinned version for their draft lifetime. Quiz-owned publishing state distinguishes active, retired for new attempts and withdrawn for safety. Retirement permits valid active attempts to finish; withdrawal does not.

Historical completions keep the version they used. Public collection cards may use a current copy-only wording for the same stable result. Accepted request snapshots keep the wording that was admitted. A safety withdrawal can hide an affected result or redact a snapshot through the responsible module's removal handler.

The publication tool validates the whole bundle, imports immutable versions and atomically selects the active version. It runs without a mobile release. Failed imports do not replace the active bundle. Reverting publication selects an earlier available version; withdrawn material is not restored accidentally. No general CMS is required for this workflow.

## Interests and prompts

Select final launch-catalog quantities through the content study. Planning inputs are twelve quizzes, roughly 120 interests across eight groups and 15–20 prompts; these are not fixed schema limits or a substitute for editorial review. Members select at most five interests and answer at most three prompts.

Profile owns the interest and prompt catalogs. Interests use stable identifiers and localized labels; members select from the catalog rather than entering arbitrary tags. Prompts invite a short, specific answer. Their answers are user content and follow the profile moderation path.

Start with enough distinct interests and prompts to support meaningful choice; there is no mandatory count of 120 interests or twenty prompts. Retire an entry by stopping new selection and hiding its current public chip or question. Existing selections remain attributable for controlled deletion and export, without continuing to appear as new shared points.

## Publishing and editorial operations

The content workflow is draft, editorial review, automated validation, preview and versioned publication. AI may draft content and suggest answer paths. A human checks whether the result is worth reading and whether the scoring makes sense. The founder performs the final voice review for the first publication catalog; assigning that final approval to an editor requires the founder's explicit authorization.

After scoring approval, finish one bilingual quiz for the first slice. Before the public release, prepare a small coherent catalog and demonstrate a repeatable publication process. Catalog size and cadence should follow editorial capacity and pilot completion behavior; an arbitrary launch quantity does not establish quality.

## Open study: Trait Signal after the first release

Trait Signal remains a planned product capability. Its answer-derived, hidden nature and retake invariant are defined in [Domain](domain.md). It is separate from the visible result calculation and from Discover's full ordering algorithm. The first release does not compute, store or activate it.

Its study defines the intended signal and axes, answer contributions, normalization across quizzes and retakes, handling of sparse answers, version changes and retirement, comparison between accounts, and evidence that the signal helps discovery. It also defines purpose, access, retention, deletion of raw answers and derived contributions, and the consequences of recalibration. Do not collect placeholder vectors or add empty weight fields to first-release content in anticipation of that study.

Product-owner approval of the model and its data lifecycle precedes implementation. Discovery then needs its own approved integration and evaluation of that signal; completing the quiz-scoring study alone does not authorize hidden inference or change feed ordering.
