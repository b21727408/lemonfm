# 01 — Domain

What this document owns: the things the product is made of, the rules that must
hold about them, and how they change state. It is deliberately free of
technology — no tables, no services, no endpoints. If a rule here can be broken
by a future implementation choice, the rule is written wrong.

What it does not own: storage and module structure (`04`), interfaces (`05`),
screens (`02`), safety enforcement mechanics (`06`), content authoring (`07`).

---

## Person

One human, one account, established by a verified phone number. The phone is
held only as a **deterministic keyed hash**, which is what lets a ban outlive a
reinstall — the account can be deleted, the ability to re-enter cannot be
restored by clearing an app.

Holds: a nickname, a representation (blank, avatar or photo), up to three prompt
answers, up to five interests, a bio, a collection, a trait signal, a door, and
a trust state.

**A person is anonymous to other people only in the direction the door allows.
Nobody is ever anonymous to the platform.** These are separate facts and
conflating them is how this category dies.

## Collection

The set of results a person has earned, and the only thing on a profile that
accumulates over time.

<!-- agent-law:id=collection.results-equal -->
**Every result in it is equal.** Nothing is featured, promoted, pinned or
selected as a headline, and no result drives a colour, gradient or profile
theme. A profile is neutral and typographic. This is not a visual preference: a
chosen headline identity is a ranking of your own selves, and the product does
not rank.
<!-- /agent-law -->

## Quiz

A versioned definition: questions, options, and the results a person can land
on. Quizzes are content, not code — they are authored, versioned and served
without an app release (`07`).

A person may re-solve a quiz whenever they like, and **re-solving adds a result
rather than replacing one.** The product does not decide which answer is really
them, and does not treat an older result as a mistake to be corrected. People
change, and a collection is allowed to show that.

**A person may remove any result from their collection at any time.** That is
the autonomy mechanism — the way to drop something you no longer recognise is to
drop it, not to have the system overwrite it on your behalf.

Two limits keep this from becoming a loophole. **Landing on a result already
held adds nothing** — the collection holds each distinct result once, so
re-solving twenty times cannot produce twenty copies of the same thing.
<!-- agent-law:id=signal.resolve-cannot-inflate -->
And **re-solving updates a quiz's contribution to the trait signal without
increasing its weight**: each quiz contributes once, normalised, however many
times it is taken. Otherwise a person could dominate an axis by repetition, and
the signal would measure persistence rather than personality.
<!-- /agent-law -->

## Result (Sonuç)

<!-- agent-law:id=vocabulary.result-reserved -->
**The word "Result" is reserved for this, in code as well as in copy.** A generic
success-or-failure wrapper is named `Outcome`, never `Result`
<!-- /agent-law --> — otherwise a
codebase built on ubiquitous language ends up writing `Result<Result>`, and the
one word that carries product meaning stops carrying it.

What a quiz gives a person. It belongs to them, it is public on their profile,
and it is the unit that gets shared outside the app.

A result is **expression**. It is what a person shows.

## Trait signal

An accumulation derived silently from the answers a person gives, not from the
results they land on. It exists to rank Discover: proximity between two signals
is the estimate of whether two people are worth showing to each other.

A signal is **inference**. It is never shown — not to its owner, not to anyone
else, not as a number, a label, a percentage or a badge. Expression and
inference are separate layers by design: what you display and what the system
infers are allowed to differ, and neither is derivable from the other.

<!-- agent-law:id=signal.never-surfaced -->
**Invariant: no surface anywhere may render a trait signal, a distance between
two signals, or anything computed from them.** Ranking may use it. Nothing may
display it.
<!-- /agent-law -->

## Interests and prompt answers

Interests come from a fixed authored list — never free text — and a person picks
at most five. Prompt answers are free text against curated questions, at most
three.

Both exist for the same reason as results: they produce **shared points**, and a
shared point is something to write from. A profile with none of these is
reachable but hard to start a conversation with, which is a product problem to
solve in `02`, not a person to penalise.

## Door

A person's setting for how first messages may arrive:

- **anonymous allowed** (the default), or
- **profile required**.

<!-- agent-law:id=identity.sender-never-chooses -->
The door belongs to the receiver. **A sender never chooses, never sees the
setting, and never negotiates it** — they are told which one applies to the
person they are writing to, and that is all.
<!-- /agent-law --> This is the single most
load-bearing rule in the domain: a sender-side choice turns "did not reveal
themselves" into a signal, anonymous becomes the suspicious lane, and the
mechanic is dead within months.

The door also carries an effort floor (at least one quiz solved) and a keyword
mute. Details and enforcement live in `06`.

## Request (İstek)

A first message from one person to another, before any reply exists.

<!-- agent-law:id=identity.state-frozen -->
Its identity state — anonymous or open — is **decided by the receiver's door at
the moment the request is created, and frozen forever after**.
<!-- /agent-law --> A receiver who
later closes their door does not retroactively unmask anyone; a receiver who
opens it does not retroactively hide anyone. Changing a setting must never
change the past, or the setting becomes a trap.

A request carries: the message, the **anchor** it was written from (the shared
result or profile line the sender tapped), and — when anonymous — **legitimacy
rather than identity**: the results and interests the two of them share, named
rather than counted. There is no sender card, no alias, no self-description, and
nothing the sender can shape to present themselves.

**Counts are forbidden here.** A number of shared points is a compatibility
score, and a number of quizzes solved is a reputation score. Both are the
measurement this product exists without, and both would reappear as ranking the
moment they were visible.

**A request may not be edited or unsent, and its identity state may not be
changed after it leaves.**

## Conversation

What a request becomes when the receiver replies.

<!-- agent-law:id=identity.anonymity-permanent -->
**A conversation inherits the request's identity state and keeps it forever.**
An anonymous conversation stays anonymous through its thousandth message. There
is no reveal action, no mutual unmask, no milestone that suggests one, and no
way for a receiver to request one.
<!-- /agent-law --> Replying means "this was worth answering",
not "show me who you are".

An anonymous sender appears under a **handle the system assigns**, stable for
the life of that conversation. The sender does not choose it, cannot see it as
something to shape, and cannot change it — a sender who names themselves has
rebuilt the identity the anonymity was protecting, and self-presentation is back
to being a performance.

The handle is **scoped to the conversation, not to the person.** The same sender
writing to two people gets two unrelated handles, so two receivers comparing
notes cannot establish that they are talking to the same person.

**The receiver may rename any conversation for themselves.** It is a private
label, visible only to them, and it leaks nothing in either direction — the same
thing people do when they save an unknown number under a description instead of
a name.

Either side may end a conversation. Ending is not blocking; blocking is
absolute and account-level (`06`).

## Duo quiz

A quiz two people in an existing conversation take together. Either side may
invite.

Both solve **independently** — nobody waits on anyone, nobody is nudged, and an
invitation that is never accepted simply sits there and expires quietly. Results
appear side by side once both have finished; before that, a finished side is
held and not revealed, so nobody can see the other's answer and then choose
their own.

<!-- agent-law:id=duo.no-score -->
**A duo quiz produces two results, never a score.**
<!-- /agent-law --> No percentage, no
"compatibility", no shared verdict. Two results next to each other, and whatever
the two people make of that.

## Message

A single utterance inside a conversation. It may carry a reaction from a small
fixed set.

<!-- agent-law:id=message.no-edit-no-unsent -->
**A message cannot be edited or unsent.**
<!-- /agent-law --> In a channel where the sender carries
no identity cost, an unsend is an evidence-erasure tool: write something ugly,
watch it land, remove it, and leave the receiver with nothing to report. A
person may hide a conversation from their own view; nothing they do removes what
they wrote from the other side or from moderation records.

## Commerce

Two paid surfaces exist: a subscription and a boost. The domain only cares about
what money is not allowed to do.

**A boost increases how often a profile is shown. It never changes the quality
of ranking** — you cannot buy being a better fit, only being seen more often.
Everyone still sees a truthfully ranked feed.

**Money never relaxes a safety restriction** — not a quota that protects a
receiver, not a door, not a block, not a cooldown, not a trust state.

<!-- agent-law:id=commerce.no-identity-purchase -->
**Money never buys identity.** No tier, at any price, reveals who an anonymous
sender is, or exposes a trait signal, or unmasks anything the free product
hides.
<!-- /agent-law --> This is the first monetisation idea anyone will have and it is closed
permanently: the moment identity is purchasable, anonymity is a paywall rather
than a promise.

## Account deletion

A person may delete their account. Their profile, collection, prompt answers,
interests and access are removed, and they disappear from Discover immediately.

**Messages already delivered to another person remain with that person.** They
are part of a conversation somebody else also had, and a product where deleting
an account erases what you said to someone is a product where "delete account"
is an evidence-removal tool. What is removed is the link back to an identity:
the sender becomes permanently unresolvable rather than retroactively silent.

Retention of moderation and enforcement material follows its own policy (`06`),
and the precise boundary is subject to per-market legal review.

<!-- agent-law:id=deletion.ban-anchors-survive -->
**Ban identifiers survive deletion.**
<!-- /agent-law --> A phone hash or installation carrying an
enforcement record keeps carrying it after the account is gone — otherwise
deletion is simply the fastest route back in, and every ban is one tap from
being undone. What is retained is the enforcement anchor and nothing else: no
profile, no content, no history.

## Trust state

A hidden reputation with a small set of states, moving in one direction under
pressure and decaying back with good behaviour. It is never shown to anyone,
including its owner — a visible reputation is a score, and there are no scores
here. What moves it, and what each state costs, is `06`.

## Block, report, enforcement

Blocking is absolute and account-level: it survives aliases, conversations and
new requests, in both directions. Reporting produces an outcome the reporter
hears about. Enforcement acts on the person, not on the message.

## Saved

Private bookmarks of profiles. <!-- agent-law:id=saved.never-notified -->
**The saved person is never notified and can
never learn they were saved.**
<!-- /agent-law --> A bookmark that leaks is a signal, and a signal
is a score.

---

# State machines

## Request
```
created ──reply──────────────▶ conversation
        ──decline (silent)───▶ closed
        ──report─────────────▶ closed + enforcement
```
Declining is **silent**: the sender is told nothing, sees no state change, and
cannot distinguish a decline from a message not yet read. **Requests never
expire and are never hidden for being numerous** — somebody wrote them, and
volume is not a reason to bury a message. Spreading inbound fairly is Discover's
job (`00` §What retention depends on), not the inbox's. The only requests that
leave the main list are ones filtered on **signal** — a low-trust sender or
flagged content — and that is `06`'s decision, not a volume threshold.

After a decline or a receiver-ended conversation, the pair enters a cooldown; a
second refusal from the same receiver is permanent. Enforced silently, so
refusal never becomes a conversation of its own.

## Conversation
```
active ──ended by either side──▶ ended
       ──block───────────────────▶ severed (both directions, permanent)
```
Identity state never transitions. It is set at request creation and is
immutable for the life of the conversation.

## Duo quiz
```
invited ──accept──▶ in progress ──both finish──▶ revealed
        ──ignored─▶ expired quietly (no notification, no nudge)
```
A single finished side is held, never shown, never announced.

## Person
```
new ──age gate──▶ age-verified ──phone──▶ active
active ⇄ restricted ⇄ warned ──▶ suspended ──▶ banned
```
Ban is anchored on the phone hash and the installation, so it survives a
reinstall. Movement between trust states is invisible to the person.

---

# Invariants that hold everywhere

These are the sentences a future session is most likely to break by accident.
Each names how it is held, or admits that it is not yet held — see `08` for the
audit of the second kind.

1. **No number ranks one person against another** — no compatibility percentage,
   no follower or like count, no online indicator, no visible reputation.
2. **A trait signal never reaches a surface.** Ranking consumes it; nothing
   renders it.
3. **Identity state is set by the receiver's door at request creation and is
   immutable thereafter.**
4. **A sender never chooses their own visibility**, in any surface, in any tier.
5. **Declines are silent.** No read state, no "seen", no inference available to
   the sender.
6. **Every result is equal**; no featured, pinned or headline identity exists.
7. **A duo quiz never produces a score.**
8. **A saved person is never notified.**
9. **Money never relaxes a safety restriction, and never buys identity.**
10. **Messages cannot be edited or unsent.**
11. **Deleting an account does not delete an enforcement record.**

Vocabulary rules — including the banned word "match" — live in `00` and are not
repeated here.
