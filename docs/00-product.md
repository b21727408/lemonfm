# 00 — Product

## What Lemon.fm is

<!-- agent-summary -->
A social discovery app built on quizzes. People solve quizzes and earn
**results** that collect on their profile. They browse **Discover**, a
single-column feed of real open profiles with no swipe and no scores. When
someone catches their attention they write, and **the message is anonymous
unless the receiver has asked otherwise**. Anonymity is asymmetric and
permanent: where it applies the sender stays masked for the whole conversation,
the receiver is open, and nobody is anonymous to the platform. 18+, dark-only,
Turkish and English at launch, city-scoped launches.
<!-- /agent-summary -->

A social discovery app built on quizzes. You solve quizzes and earn **results**
that collect on your profile. You browse **Discover** — a single-column feed of
real, open profiles: no swipe, no scores, no compatibility percentage. When
someone catches your attention you write to them, and **you write anonymously
unless they have asked otherwise**. They read the message and decide, the way an
Instagram message request works.

Anonymity is **asymmetric and permanent**: where it applies, the sender stays
masked for the whole conversation, the receiver is open, and nobody is anonymous
to the platform.
Discover shows real, open profiles — with a photo, an avatar or nothing at all,
because a blank representation is a choice and not an empty slot. This is not an
anonymous network with an anonymous population — it is an open network where **approaching someone
is anonymous**, so that a first message costs its sender nothing but nerve, and
nothing that happens afterwards takes that back.

## What the quizzes are for
Attraction does most of the work. People reach out because of a photo far more
often than because of a result, and this product does not pretend otherwise.

Quizzes do two things a photo cannot. They give you **something to say** — a
first message can start from a result you both have, or a line someone wrote,
instead of a blank field. And they give a profile **depth that outlives the
first impression**, so there is a reason to keep talking after the first
exchange.

And they quietly feed **Discover**. Answers contribute to a trait signal, and
ranking uses the distance between two people's signals to surface those more
likely to get along. Two layers, deliberately separate: what shows on your
profile is **expression**, what feeds ranking is **signal**, and they are not
the same thing — your results are yours to show, your signal is never displayed.

**Ranking is allowed; ranking as judgement shown to a person is not.** The system
orders a feed — every feed is ordered — but it never surfaces the ordering as a
verdict about two people. No percentage, no score, no "you two are a 92%". The
only claim the product ever makes is "here is someone worth reading", because a
number would be both unprovable and the exact performance metric this product
exists without.

## Who it is for
Gen-Z-leaning, **18+**, globally. The age floor is a law, not a preference; the
reasoning and its consequences live in `06-safety.md`.

The condition this answers is exhaustion with being ranked and judged. Roughly
80% of Gen-Z report dating-app burnout — the tiredness of performing, of being
scored, of a catalogue that treats people as a stack to sort. **Nothing in this
product shows a person a rank, a score or a compatibility judgement about
another.** The feed is ordered, as every feed is; the ordering is never
surfaced as a verdict.

Launches are city-scoped, one dense market at a time, because anonymous-adjacent
social needs local liquidity before it needs reach. The first market is a
founder call. Nothing in code, schema or content may assume any market.

Languages: TR and EN complete at launch, each written natively.

## The two loops
They are separate systems and must not be described as one.

**Acquisition, outside the app.** Quiz → result → share card → seen on social →
deep link into *that same quiz* → new account. The share card is the only growth
surface that does not cost money.

**Retention, inside the app.** A message arrives from someone you have not met →
you read it and reply → the conversation continues → you solve more quizzes, alone or with the
person you are talking to → your profile deepens → Discover has more to work
with.

They meet at the quiz: it is both the thing that gets shared and the thing that
gives you something to say.

### What retention depends on
The reason to open the app tomorrow is that
someone wrote to you. That makes Discover's scoring load-bearing rather than an
optimisation: it has to spread conversations across people instead of pooling
them on a few, and it has to keep recently-active profiles visible so a new
account is not invisible on day two. A thin inbox in a thin city is the failure
mode, and it is a distribution problem, not a content problem.

## Vocabulary
One word, one job. These are the only names the product uses for these things,
in code, in copy and in these documents.

| Word | What it is |
|---|---|
| **Quiz** | the thing you solve |
| **Sonuç** (result) | what a quiz gives you; the celebration beat, and what gets shared |
| **Koleksiyon** (collection) | where your results live on your profile |
| **Duo quiz** | a quiz two people in a conversation take together |
| **İstek** (request) | a first message, before the receiver has replied |
| **Anchor** | the shared result or profile line a message was written from, carried with it |
| **Door** | a person's setting for how first messages may reach them; "Kimler yazabilir?" in the interface |

**Every result is equal.** The collection is a shelf, not a podium: nothing is
featured, nothing is chosen as a headline, and no result drives a colour,
gradient or profile theme. A profile is neutral and typographic. Ranking your
own identities would be the same performance this product exists without.

**Who decides whether a message is anonymous: the receiver, never the sender.**
Every profile has a door — *first messages may arrive anonymously* or *first
messages must arrive with a profile* — and it is open by default. The sender is
told which one applies and has no choice in it.

This is the whole design, and the reason is that a sender-side choice destroys
the mechanic. The moment a sender can pick, not picking becomes information:
*they could have shown themselves and didn't*. Anonymous becomes the suspicious
lane, receivers learn to ignore it, and within months the channel is a spam
folder. No product has ever survived per-message sender-chosen anonymity. Taking
the choice away from the sender is what keeps anonymity ordinary rather than
shady.

**What an anonymous request carries.** The receiver sees the message, **the
thing it was written from** — the shared result or profile line the sender
tapped, so it arrives already anchored — and **legitimacy rather than identity**: the
results and interests the two of them actually share, shown as the things
themselves.

<!-- agent-law:id=measurement.legitimacy-named-not-counted -->
Shown as things, never as counts. "Eight shared points" is a compatibility
score wearing a different hat, and "solved 36 quizzes" is a reputation score —
both are exactly the measurement this product refuses. Naming what is shared
gives a receiver something to judge; counting it gives them something to rank.
<!-- /agent-law --> There is no sender card, no alias, no curated
self-description, and no way for the sender to dress themselves up. When nothing
is shared, the message stands alone, and that is correct: then the message is
the only thing being judged.

**Identity state is always visible and never reversible.** Before writing, while
writing, and inside the conversation forever after, the sender can see whether
they are anonymous. There is no confirmation dialogue — a dialogue trains people
to tap through it, and it would frame writing openly as a dangerous act when the
receiver deliberately asked for it. Once a message is sent, its identity state
cannot be changed.

<!-- agent-law:id=vocabulary.no-match -->
**The word "match" is banned in every locale, everywhere in the product.** A
product refusing the swipe category cannot borrow the word that defines it, and
a word that survives in one badge spreads to every screen inside a month.
<!-- /agent-law -->

## Positioning
The anti-performance social app: anti-catalogue, anti-swipe, and **unmeasured**.

No compatibility percentage. No follower or like counts. No online dots. Read
receipts off by default. **No number shown to anyone ranks one person against
another** — the feed is ordered, as every feed is, but the ordering is never
surfaced as a verdict. Nobody has to perform to be worth talking to.

The register is curiosity: the app is interested in you, and interested in the
next person. It is calm without being sombre, and it never speaks to the user as
though something needs fixing.

## Voice
The writing voice is one of the three channels the brand speaks through, and the
only one produced at volume — mostly drafted, then passed through the founder's
ear. It is written as rules rather than as an adjective, because "warm and
plain" is not something anyone can check.

- Second person, present tense. Short sentences. Say the thing, then stop.
- No hype, no exclamation marks.
- **No therapy register.** The product does not diagnose the reader, comfort
  them, or imply something needs fixing.
- **Never coy about mechanics.** If a decline is silent, say so plainly. A rule
  softened into a hint is a rule nobody uses.
- Errors are literal and blame-free: what happened, what to do next. No apology
  theatre.
- **Every locale is written natively.** A string that reads like a translation is
  a bug, not a nuance.

The other two channels are typography and palette, and both live in `03`. There
is no mascot: an illustrated character would carry personality the writing and
the type are already carrying, and it would pull the register younger than the
product wants.

Result and quiz copy has its own additional rules in `07`.

## KPIs
- **North star:** weekly count of mutual conversations reaching ≥10 messages.
- D1 ≥ 40% · D30 ≥ 15% · activation = 1 quiz + 1 messaging action on day 0.
- Share rate ≥ 12% of quiz completions · request accept rate ≥ 35%.
- **Inbound is distributed, not pooled — a first-class metric, not a fairness
  note.** Every dead app in this category died of the same failure: a small
  group receives far too much, their accept rate collapses, they leave, and the
  product becomes people writing into a void. Measured without demography:
  concentration of inbound requests, accept rate by inbound volume band, and
  retention by inbound volume band. These work from the first week and depend on
  nobody declaring anything.
- **Women's weekly share ≥ 40%**, measured from an **optional, private,
  self-declared** field. It is never shown to anyone, never used in ranking,
  never leaves aggregate reporting, and asking is not a condition of using the
  product. Inference from a photo or a name is forbidden outright. Because the
  field is optional, this metric informs but never triggers — the tripwire binds
  to the distribution measures above, which are always available.
- Paid 3–5% of WAU by month 6.
- **Pre-committed tripwire:** accept rate below 25%, inbound concentration
  rising, or door-closure crossing its threshold → tighten first-message
  ceilings the same day via remote configuration (`06` §Tripwire). Committed in
  advance so it is not a debate held while a metric is falling.
  **Every trigger is behavioural and always observable.** The declared share
  above is a strategic diagnostic that informs a decision and never fires one,
  because an automated same-day action cannot depend on a field people may
  decline to fill.
