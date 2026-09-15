# Product

## Promise

Lemon.fm is a social discovery app built on quizzes, curiosity and anonymous conversation. People complete quizzes, collect expressive results on their profiles, discover people they are curious about and send a first message. The receiver's reply starts a conversation.

The receiver controls whether new requests arrive anonymously or with the sender's profile. The sender sees the applicable identity mode before writing. That mode stays fixed for the resulting request and conversation; Lemon.fm has no identity-reveal feature.

Quizzes are an experience people can enjoy independently. A good result describes a recognizable behavior and gives someone something to show or talk about. It is not a psychological assessment. Meeting someone is another reason to return, alongside new quizzes and existing conversations.

## Audience and launch

The initial audience is adults interested in a playful, low-pressure way to discover people. The product is 18+, supports Turkish and English, and starts with a city-scoped population. A dark interface, distinctive typography and a yellow accent establish its visual identity; there is no mascot.

Phone verification precedes browsing. A member can choose “Önce keşfet” and postpone their first quiz, but must complete a quiz before creating a first request. Blank profile representation is valid. A photo, interests and a bio are optional.

The first city, external-service accounts and real-user operating requirements are tracked in [Delivery](delivery.md). A city is a coarse, self-selected discovery area. The app does not collect precise location or advertise verified proximity.

## Main loop

1. Complete a quiz and receive a result with a specific observation.
2. Keep results in the collection and optionally share a result card.
3. Browse open profiles in Discover. Results, interests and prompt answers provide context.
4. Read the applicable identity mode and send a request, optionally anchored to a result or prompt answer.
5. The receiver replies, declines or uses safety controls. A reply creates a conversation.
6. Continue the conversation, discover new profiles or return for another quiz.

A shared result links back to its quiz. The destination survives entry and verification so a visitor can reach the content that interested them. An unavailable quiz is explained honestly rather than replaced without notice.

## Product boundaries

Discover uses a single-column feed of profiles. It has no swipe-to-match mechanic, mutual-match prerequisite, compatibility percentage or public desirability ranking. Shared points show actual named results and interests. There are no follower totals, like totals, popularity counters, streaks or online-presence indicators.

Results have equal presentation status. There is no pinned or headline result and no personality-derived profile theme. Completing a quiz again can add another distinct result. The planned Trait Signal counts each quiz's contribution once; repetition cannot increase its influence.

Anonymous contact hides the sender-to-profile link from the receiver. The platform still associates the exchange with accounts for delivery and authorized safety work. This does not prevent self-identification or inference from what people choose to say. [Domain](domain.md) owns the visibility rules and [Safety](safety.md) owns access and protection policy.

## First public release

The release includes verified entry; a minimal editable profile; quizzes and result sharing; collections; city-scoped Discover; anonymous or open first requests; text conversations; ending, blocking and reporting; contact preferences; profile photos; generic push notifications; account export and deletion; and staff handling of reports and appeals.

Foundation acceptance proves a smaller authenticated quiz flow after the quiz-scoring study is approved. The full release adds the remaining capabilities in [Delivery](delivery.md), including the discovery study and safety operations required before strangers can contact each other.

Trait Signal, subscriptions, boosts, duo quizzes, saved profiles and message reactions are planned after the first release. User-authored quizzes and media inside messages are also outside the first release. Deferred features do not need empty implementations, disabled screens or speculative contracts. A future duo quiz can show two results without introducing a compatibility score.

Typing indicators and read receipts are excluded from Lemon.fm, including later releases. They create pressure to reply and are not optional settings or deferred roadmap items. A committed-send acknowledgement and history synchronization are delivery facts; neither reports that another person is typing or has read a message.

## Planned capabilities and research

Quiz result scoring and Discover ranking are separate open studies. No scoring formula, tie rule, ranking priority or balancing algorithm is selected by this foundation. [Content](content.md) and [Discovery](discovery.md) define the questions and evidence needed before product-owner approval. The initial Discover algorithm must distribute exposure and incoming contact across receivers; there is no hard pending-request count limit that closes a receiver's contact entry.

**Trait Signal** is the planned hidden contribution of quiz answers to Discover, separate from the expressive results displayed on profiles. Its intended purpose is to help discover people likely to get along. Axes, answer contributions, normalization, comparison, evaluation and data lifecycle require dedicated study. It is not computed, stored or used in the first release. Deferral does not remove it from the product. It never becomes a public trait display, distance or compatibility score.

**Subscriptions and boosts** remain part of the planned monetization model after the first release. A subscription can provide commercial entitlements; a boost increases exposure without purchasing a better compatibility assessment or bypassing receiver protections. Neither can buy an anonymous identity, override a door or block, or loosen a safety restriction. Packaging, price, entitlement lifecycle and boost distribution require their own product work. The existing plan-cap distinction is retained in [Safety](safety.md); first-release accounts use the free plan without a billing implementation.

## Voice

Use direct, concrete language. Explain what happened and what the user can do next. Keep interface text short, while giving identity and data decisions enough explanation to be understood. Avoid generic praise, diagnosis, marketing exaggeration and jokes that humiliate someone.

Write Turkish and English naturally while preserving the same behavior and result meaning. Interface terminology is Quiz, Result/Sonuç, Collection/Koleksiyon, Discover/Keşfet, Request/İstek and Conversation/Sohbet. “Match” does not describe a Lemon.fm relationship. Reserve Result for quiz outcomes in first-party domain terminology; use a different name for a generic operation outcome.

## Learning goals

Inbound distribution and receiver protection guide product evaluation, with attention to harassment burden on women. The initial pilot does not collect a demographic field; later collection requires a separate purpose and product-owner decision. Do not infer demographics from names or images. Population metrics prompt operator review, not automatic quota tightening.

Measure whether people reach the quiz payoff, find context worth approaching someone about, receive welcome requests and continue mutually wanted exchanges. These questions guide learning; a high message count alone does not establish a good experience.

For the first pilot, report onboarding and quiz completion, requests with a first reply within seven days, seven-day return activity, reports per accepted request, and inbound distribution. Show denominators and cohort age. A seven-day reply measure excludes requests whose observation window is incomplete; system failures and rejected sends are not accepted requests.

A candidate sustained-conversation measure counts distinct conversations with messages from both participants and at least ten accepted messages in an ISO week, using UTC reporting boundaries. It is assessed alongside reports and receiver load. Collection and dashboard details belong to the relevant feature work, with the data minimization rules in Safety.

No fixed success percentage or automatic safety intervention is justified solely by this product hypothesis. The pilot must establish usable cohorts and operational review. Discovery's first-release algorithm requires the separate study and approval described in Discovery; Trait Signal and paid boost activation belong to later work.
