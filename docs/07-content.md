# 07 — Content

What this document owns: everything a person reads that is not interface
furniture — quizzes, results, interests, prompt questions — plus how it is
written, reviewed, versioned and shipped.

What it does not own: the schema's technical contract (`05`), how content
reaches a device (`04`), or the words on buttons and error states (`00` §Voice).

**Content is the product's only free growth surface.** A share card gets posted
because the result was worth posting. Everything in this document exists to make
that likelier.

---

## What a quiz is for

Three jobs, in this order:

1. **Produce a result somebody wants to post.** If nobody screenshots it, the
   acquisition loop does not run and the app grows only by paying.
2. **Give two strangers something to write from.** A shared result is an anchor
   for a first message (`01` §Request).
3. **Feed the trait signal** that ranks Discover, silently and invisibly.

A quiz that does the third but not the first is dead weight. Ranking works fine
on content nobody shares, and then nobody arrives.

## Tone

The register is **fun, specific and self-aware**. A result names a *behaviour or
a moment*, not a personality category. "Night Owl Philosopher" is two clichés
stacked and nobody posts it. What gets posted is oddly specific enough that
somebody says *this is literally me* and sends it to a group chat.

Rules:

- **A behaviour, not a type.** Name something a person does, at a time, in a
  situation — not a category they belong to.
- **Specific beats grand.** The smaller and stranger the observation, the more it
  lands. Nobody relates to "adventurous"; everybody relates to a particular
  three-in-the-morning habit.
- **Funny, and slightly at the person's expense — never at their cost.** Warm
  self-recognition, not a diagnosis and not an insult. The test: would somebody
  post this about themselves?
- **No mysticism.** No animals-as-personalities, no elements, no colours-as-souls,
  no zodiac cosplay. The category is full of it and it reads as filler.
- **No flattery.** A result that only compliments is not a result, it is a
  horoscope, and it says nothing about the person holding it.
- **Nothing derived from identity.** Never gendered, never about appearance,
  never about wealth, ethnicity, orientation or belief. It is about behaviour
  because behaviour is chosen and the rest is not.

**Every locale is written natively.** A result is not translated — the same quiz
gets a different result written for each language, because the joke, the rhythm
and the reference do not survive translation. A string that reads like a
translation is a bug.

**Questions are as good as results, or the results do not land.** A flat question
list produces flat results however well the results are written, and it is the
questions a person actually spends their time on.

## Interests

A fixed authored list of roughly 120 entries across eight groups. **Never free
text**, in any locale, ever — free text produces a thousand spellings of the
same thing and zero overlap, and overlap is the entire point.

A person picks at most five.

**Entries are chosen to produce overlap, not to catalogue niches.** The list's
job is to make two strangers share something. An entry so specific that only one
person picks it has failed even if it describes them perfectly.

Retiring an entry hides its chips without deleting anyone's data.

## Prompt questions

A curated bank of roughly 15–20 fill-in questions. A person answers at most
three, in free text, and the answers are moderated at save time (`06` §Layer 2).

A good prompt question is **answerable in one line and impossible to answer
generically**. "What are you passionate about" produces nothing; a question with
a specific situation in it produces a sentence somebody can reply to.

Prompt answers are anchors too: a person tapping one carries it into the
composer as the thing their message is written from.

## The content and matching study

Some structure here is **not designable in passing** and belongs to a dedicated
founder-led study. Nothing may be invented in its place, and no session may fill
these in:

- The trait axes, and how answers weight them.
- Scoring rules, and how a set of answers resolves to a result.
- Result-count norms per quiz, and how distribution is kept from collapsing onto
  one result.
- The calibration loop: per-quiz distribution dashboards and staged rollout.

Until the study lands, quizzes ship with **weight-sum scoring as an explicit
placeholder** and empty trait weights. The placeholder is documented as a
placeholder in the content itself, so nobody later mistakes it for a decision.

**Everything else in this document holds regardless of the study.** Tone, the
interests rule, the localisation rule and the pipeline are not waiting on it.

## Launch content

Twelve quizzes at launch, in both locales, plus the interest list and the prompt
bank.

Twelve is chosen for a specific reason: a person who finishes everything in the
first week has nothing left, and results are what keep a profile worth reading.
Fewer than about ten and the shelf looks empty; many more and the quality drops,
because quality here is entirely a function of how much attention each one got.

**New quizzes arrive after launch as a steady drip, not a burst.** A quiz that
lands on a Thursday is a reason to open the app that is not a message, which
matters in a product whose only other reason to return is that somebody wrote.

## Pipeline

```
draft (AI) → founder voice pass → schema validation (CI) → versioned publish
```

**The founder's voice pass is the quality gate**, and it is not delegable. A
draft that reads as competent-but-generic passes every automated check and fails
the only test that matters, which is whether somebody posts it.

**Content publishes without an app release** (`04`). A result can be rewritten
in minutes. <!-- agent-law:id=content.no-behaviour -->
What content still cannot do is change behaviour — it carries text
and weights, never rules
<!-- /agent-law --> (`05`).

## Moderation of content

Everything a person writes — nickname, bio, prompt answers — passes the same
classifier as messages, at save time. A profile is a broadcast surface, and a
slur in a bio reaches more people than a slur in a message.

Each shipped language carries its own labelled evaluation set, and **a locale
cannot ship without its set green** (`06` §Layer 3). Adding a language is
therefore three pieces of content work — strings, quizzes, and an evaluation set
— and never code work.
