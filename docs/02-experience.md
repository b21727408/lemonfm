# 02 — Experience

What this document owns: which screens exist, how they behave, what states each
must handle, and how a person moves between them.

What it does not own: visual values (`03`), domain rules (`01`), safety
enforcement (`06`), ranking (the discovery document). Where a screen expresses a
rule, the rule lives elsewhere and this document points at it.

**v1 is 31 screens.** Every one of them is dark-only, built from tokens, with
its strings in slang, and with designed empty, error and offline states — those
are a shared system (§30) rather than an afterthought bolted onto each screen.

---

## Auth & onboarding (7)

Screens 2–7 share one shell and one honest counter: **6 steps, 1/6 → 6/6.**
Phone and code count separately so the bar never appears frozen, and the count
ends where onboarding actually ends. There is no seventh step hiding behind
"done".

1. **Landing** — the loud brand moment. The headline promise is the **quiz**;
   messaging is the second line and never the hook. "Anonymous chat" as a lead
   carries a dead category with it.
2. **Age gate** (1/6) — the first data step, before anything is collected. Under
   18 leads to a plain goodbye screen and nothing is stored (`06` §Layer 1).
3. **Phone number** (2/6) — country selector shows name and dial code, **no
   flags**: nothing in this product assumes a market. The assurance line is
   mid-emphasis, never low — it is the most trust-critical sentence on the
   screen and burying it is the opposite of reassurance.
4. **SMS code** (3/6) — six digits, **system keyboard**, because autofill, paste
   and accessibility are not ours to reimplement. Resend with backoff, and
   **"Numarayı değiştir" is mandatory** — a person who mistyped their number has
   no other way out.
5. **Nickname** (4/6) — six designed states: empty · typing · checking ·
   available · taken · invalid. **A success affordance never appears on a field
   that has not been checked.** The classifier runs on save (`06` §Layer 2).
6. **Representation** (5/6) — **blank, avatar or photo.** Blank is a real
   choice, not a skip: a person without a picture must never look like a broken
   profile anywhere in the product.
7. **Quiz handoff** (6/6) — shows the reward before asking for the effort: a
   sample quiz card and a sample result, so the first quiz is a known payoff
   rather than a blind step. Leads into the first quiz. The secondary path
   **"Önce keşfet"** enters browse-only mode (§Cross-cutting).

Interests are not an onboarding step (§Cross-cutting).

## Quizzes (3)

8. **Quiz home** — a featured quiz, category rows, and a strip of anything left
   unfinished.
9. **Quiz player** — one question per view, progress in the shared stepper,
   honest time estimate. Re-solving an already-solved quiz is normal and adds a
   result rather than replacing one (`01` §Quiz).
10. **Result and share card** — the celebration beat, and the one loud moment
    inside the app. The card exports at 9:16 and 1:1 for sharing, and the link
    it carries deep-links back into **that same quiz**. This screen is the only
    free growth surface the product has; everything about it is built for the
    screenshot.

## Discover (3)

11. **Discover feed** — single column, batched, with a full-width shuffle action
    and an honest pool-exhausted state. **Zero swipe gestures.** Ranking,
    fatigue and batching belong to the discovery document.
12. **Profile detail** — representation, collection, bio, prompts, interests, and
    the entry to writing. Tapping a result or a prompt carries that context into
    the composer as the message's anchor.
13. **Boost sheet** — price, duration, and a plain explanation that a boost
    changes how often you are shown and nothing else (`01` §Commerce).

## Messaging (5)

14. **Chat home** — conversations and requests, with the filtered folder
    collapsed. Anonymous and open conversations sit in the same list and must
    read consistently: an anonymous one shows its assigned handle where an open
    one shows a nickname and picture. **A person can rename any conversation for
    themselves** (`01` §Conversation).
15. **Request preview** — the message, the anchor it was written from, and
    **legitimacy rather than identity**: the shared results and interests
    themselves, named and never counted (`01` §Request). Accept
    by replying; decline silently; report. Declining tells the sender nothing.
    **First time only:** a one-time note explaining that declining is silent and
    that the door is adjustable, linking to §24. This is where receiver
    supremacy is taught — at the moment it is actionable, not in a pledge screen
    nobody reads.
16. **Composer** — **identity state is stated before the first keystroke**:
    *"Bu mesaj anonim gidiyor"* or *"Bu mesaj profilinle gidiyor"*, and the send
    button repeats it. No confirmation dialogue: a dialogue trains people to tap
    through it, and it would frame writing openly as dangerous when the receiver
    deliberately asked for it. Three icebreakers, pre-seeded when arriving from a
    result or prompt. Quota errors appear only when a quota is actually hit.
    **First time only:** a one-time note explaining what the receiver will and
    will not see.
17. **Chat thread** — bubbles, typing indicator, a small fixed reaction set,
    identity state visible in the header for the life of the conversation.
    Shared points unfurl in the header after the first reply. A shield icon
    opens §18. **Messages cannot be edited or unsent** (`01` §Message). Read
    receipts off by default. No presence.
18. **Safety sheet** — block, report, and a shortcut to the door.

## Profile & settings (8)

19. **My profile** — with an "as others see it" toggle.
20. **Edit profile** — up to three prompt answers from curated questions, bio,
    interests, representation.
21. **Collection** — every result, equal, accumulating. **No featured slot, no
    ordering by rarity, no completion meter.** A person may remove any result
    (`01` §Quiz); that is the only editorial control they have and the only one
    they need.
22. **Saved** — private bookmarks. **The saved person is never notified.**
23. **Settings** — account, notification categories written honestly, privacy,
    data export and deletion. Deletion states plainly that enforcement records
    survive it (`01` §Account deletion).
24. **Door — "Kimler yazabilir?"** — anonymous first messages on or off, effort
    floor, keyword mute (`06` §The door). Written so that turning anonymity off
    reads as a preference rather than a safety warning; framing it as protection
    implies the default is dangerous.
25. **Blocked list** — durable, account-level.
26. **Safety centre** — report status with outcomes, locale-aware resources,
    policy in plain language per locale.

## Commerce & system (5)

27. **Paywall** — utility framing, honest renewal copy, restore. It may not
    advertise anything safety-adjacent, and it may not imply that paying reveals
    anything (`01` §Commerce).
28. **Manage subscription** — a one-tap path toward cancelling, handed to the
    store.
29. **Report flow** — category, optional context, confirmation, and a 24-hour
    commitment for critical categories with the outcome delivered later.
30. **Ban and appeal** — reason category, appeal path, no shaming copy. A person
    being removed is still a person.
31. **Empty, error and offline** — one system, not thirty variations. Literal,
    warm copy carried by composition and sentence, since no illustrated
    character exists to carry it. Every one has a retry affordance and says what
    happened rather than apologising for it.

---

## Cross-cutting behaviours

**Full-screen flows.** Quiz play, onboarding and the composer hide the
navigation bar. They are tasks, not destinations.

**Deep links.** A share card carries its target quiz id, and **that id survives
the entire onboarding flow** — someone arriving from a shared result lands on
*that* quiz the moment onboarding completes, never on a generic quiz home.
Onboarding sits between the click and the payoff, so without this the only free
growth loop leaks at its last step.

**Browse-only mode ("Önce keşfet").** Discover and profiles are viewable with
zero quizzes; writing is not. The composer entry states the reason plainly and
links straight to a quiz. This mirrors the effort floor most receivers have on
anyway (`06`) — the gate makes visible what the door would otherwise enforce
silently, which is friendlier than a message that vanishes.

**Interests.** Not an onboarding step. Reachable from Edit profile and offered
once as a dismissible prompt on first Discover open. Not optional in spirit: an
empty interest set thins shared points toward zero, and shared points are what
give a first message something to be about.

**Receiver supremacy is taught contextually, never as a tutorial.** Carousels get
skipped and pledge screens get tapped through. The two notes in §15 and §16
appear once each, inside the task, at the moment they are actionable.

<!-- agent-law:id=experience.identity-state-visible -->
**Identity state is never inferred.** Every surface where a person could be
uncertain whether they are anonymous states it outright — before writing, while
writing, and in the conversation forever after.
<!-- /agent-law -->

**Skeletons, not spinners.** Every list loads as a shape of itself.

**Nothing counts down at a person.** No visible quota counters, no "3 messages
left", no streaks, no completion percentages (`06` §Quotas).
