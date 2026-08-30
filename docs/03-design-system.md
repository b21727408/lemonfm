# 03 — Design System

What this document owns: every visual and interaction value in the product, and
the contract each component must satisfy. If a colour, size, radius, duration or
state appears anywhere in the app, its definition is here.

What it does not own: which screens exist (`02`), what the words say (`00` §Voice, `07`), or how the rules are enforced in code (`08`).

**Tokens only.** No raw colour, text style, radius, spacing or duration exists
outside this system. Token *values* live in `design/tokens/*.json` and the code
layer is generated from them: this document explains what the system means, the
JSON is what the values are.

<!-- agent-law:id=design.behaviour-not-appearance -->
**Use the framework's behaviour; never let its appearance escape.**
<!-- /agent-law --> A component
here may build on Flutter's behavioural primitives — text editing, focus,
semantics, scrolling, gesture handling — because focus management, input method
support, selection and accessibility took years to get right and rewriting them
produces a worse product, not a purer one. What may never leave this package is
framework *styling*: no Material component with theme-derived visuals reaches a
feature, and every colour, radius, and text style is set explicitly. A feature
writes `LfInput`, never `TextField`.

---

## Three tiers, not two

- **Loud** — landing, quiz result, share card, paywall. The accent used
  generously, celebration motion, photography at full strength.
- **Structured** — onboarding. Display typography and grouped fields are
  encouraged; colour discipline follows calm. One accent per screen, no glow.
  **Onboarding is not a loud surface.** It is the calm system wearing the
  brand's typography, and the loud beats land only because the steps before them
  were quiet.
- **Calm** — everything else.

Everywhere: at most one accent per screen. No shadows — depth comes from surface
steps and hairlines. Dark-only in v1.

## One accent, two grammars

The palette has a single accent, so the accent alone cannot distinguish an
action from a signal. The distinction is carried by **treatment**:

<!-- agent-law:id=design.one-accent-two-grammars -->
- **Filled yellow means action.** The primary button, and nothing else.
- **Outlined yellow, or yellow text, means signal.** A shared-point chip, a
  proximity badge, the active navigation destination, a focus ring.
<!-- /agent-law -->

A filled yellow chip reads as a button the person failed to press. Hold the
grammar and one accent stays legible; break it once and the accent stops meaning
anything.

## Colour

```
brandYellow      #FEC602    the only accent

bg0              #050613    ground
surface1         #10111D
surface2         #191A26
surface3         #23242F
stroke           #14FFFFFF  white at 8%

primary          #FEC602    interactive: fill AND foreground
primaryPressed   #E0AE02
primaryContainer #2A2411    tonal fill
onPrimary        #050613    ink on yellow

textHigh         #EBFFFFFF  white at 92%   16.9:1 on bg0
textMid          #A3FFFFFF  white at 64%    8.3:1 on bg0
textLow          #66FFFFFF  white at 40%

success          #34D399    10.5:1 on bg0
danger           #FF5C7A     6.8:1 on bg0

disabledFill        #22232E
onDisabledFill      #8E9099   4.9:1 on disabledFill
disabledForeground  #8A8C95   6.0:1 on bg0
disabledStroke      #6E7079   4.1:1 on bg0

scrim            #99000000  black at 60%
navBarSurface    #F510111D  surface1 at 96%
```

**One interactive token, not two.** Yellow is unusual: it clears contrast both as
a foreground on a dark ground (12.8:1) and as a fill under dark ink (12.8:1).
Most accents cannot do both, and a palette that needed a light tint for icons and
a dark one for fills would need two tokens. This one does not.

**`onPrimary` is ink, never white.** White on this yellow is 1.6:1 — unreadable,
not merely weak. Every yellow surface carries dark text.

**There is no `warn` colour.** Amber is the accent, so an amber warning would be
indistinguishable from a call to action. Warnings use `danger` plus an icon.

**There is no brand gradient.** Loud surfaces carry weight through photography,
scale and the accent. A gradient button also fails contrast at its lighter end,
and a treatment that needs a WCAG large-text exemption to be legal is the wrong
treatment.

**No result-driven colour.** Nothing on a profile is tinted by which quizzes a
person has solved (`01` §Collection).

## Typography

Two families, bundled locally with pinned checksums and a Turkish glyph
assertion. **Never fetched at runtime** — it makes goldens non-deterministic and
gives the first launch a wrong-font flash.

```
Space Grotesk 700   display
Inter               body

display XL   40/44        H1  28/34        H2  22/28
body         16/24        secondary  14/20
caption      12/16        chip 12/14 semibold
button       16/20 semibold
navLabel     11/14 semibold
```

**Display is a range, not a value.** Implemented as font/line-height bands with a
two-line clamp: **XL** 40→32 / 44→36 · **H1** 28→24 / 34→30 · **H2** 22→18 /
28→24. Minimums are set so adjacent levels never collapse into each other and H2
stays above body.

A title finds the largest size that fits by binary search, interpolates line
height with size, and ellipsises only after reaching the minimum. It **anchors
from its top edge** inside a slot reserved at `maxLineHeight × maxLines`, so the
body below never moves between a one-line and a two-line title.

The reason is the locale law: Turkish runs materially longer than English, and a
fixed display size means hand-tuning every screen in every language — which
turns adding a locale into code work. At 342 logical pixels (390 minus the
standard inset) titles shrink somewhere around 30 characters; that is a
reference point for writing titles, not a limit.

## Geometry

Spacing on a 4-point scale, 4 through 48.

Radius: chip 8 · input 12 · card 16 · sheet 20 · **pill 999 for every button, in
every tier** — the shape learned on the landing must not change one screen later.

Icons: Phosphor, regular weight, filled for active states.

Controls: button minimum height 48 with 24 horizontal padding, 8 content gap, 20
icon. Chip 32 visual height inside a **48 interaction target** — a small chip is
never a small tap — with 12 horizontal padding, 4 gap, 16 icon. Stroke 1. Focus
ring 2 with a 2 gap, always `primary`. Pressed scale 0.98.

The 48 is a *minimum*: a real button renders around 56 once padding and the
label's line box are included.

## Motion

```
micro        120ms  easeOutCubic
standard     200ms  easeOutCubic      presses, sheets, tabs
emphasized   320ms  easeOutBack
page         240ms  easeInOutCubic    fade-through with hero
celebration  600ms  spring(mass 1, stiffness 180, damping 14) + confetti
```

Celebration is **the quiz result only** — the single loud beat in the product.

Haptics: selection light, confirm medium, quiz result heavy, **errors none**. An
error is already bad news; buzzing about it is punishment.

**Reduced motion** zeroes every duration, linearises every curve, and **suppresses
celebration entirely rather than shortening it** — confetti at 0ms is a flash,
not a celebration. Components resolve motion through the theme rather than
reading raw tokens, so honouring the preference is the default path instead of
something each component remembers.

Three signature moments and no more: the **result reveal**, the **request-accept
transition** where a request unfolds into a conversation, and the **duo-quiz
reveal** where two results appear side by side.

## Component contracts

Every component ships every state, every state has a golden, and Widgetbook
shows all of them. A state that exists in code but not in Widgetbook is a state
nobody has looked at.

**LfButton** — four variants, all pill, no glow, no shadow.

| Variant | Enabled | Pressed | Disabled |
|---|---|---|---|
| primary-solid *(default)* | `primary` / `onPrimary` | `primaryPressed` | `disabledFill` / `onDisabledFill` |
| tonal | `primaryContainer` / `textHigh` | scale only | `disabledFill` / `onDisabledFill` |
| ghost | no fill / `primary` | scale only | `disabledForeground` |
| destructive | no fill / `danger` | scale only | `disabledForeground` |

A **loading** state is required wherever a press starts network work — the OTP
send button takes double taps without one.

**LfChip** — common-point: no fill, **yellow outline and label**; interest:
`surface2`/`textMid`, selected `primaryContainer`/`textHigh`; filter: no fill
with `stroke`/`textMid`, selected as interest; input: `surface2`/`textHigh` with
a `textMid` remove icon.

**LfInput** — `surface2`, radius 12, 1px state stroke, 48 minimum height. Focus
is orthogonal to validation: the state stroke stays and a 2px `primary` ring
renders outside it.

| State | Stroke | Trailing |
|---|---|---|
| empty | `stroke` | none |
| typing | `stroke` | none |
| checking | `primary` | spinner, `primary` |
| valid | `success` | check circle, `success` |
| taken | `danger` | x circle, `danger` |
| invalid | `danger` | warning circle, `danger` |

**The success treatment is reachable only from `valid`.** Empty and typing never
render success. This is a component-level guarantee, not a caller's
responsibility — a caller must not be able to show a green field it never
checked.

**LfFieldGroup** — a layout, not a container. Label → input → helper → assurance
row, sitting directly on the ground with no card or fill of its own. The helper
colour is **derived from the input's state**, so a caller cannot show a
success-coloured helper on an unchecked field. The assurance row is always
`textMid`, never `textLow`: it is the trust-critical line.

**StepperPill** — a trailing `current/total` counter, then equal-width segments.
Serves both the fixed onboarding counter and a variable quiz question count; it
assumes no count internally.

**OnboardingScaffold** — progress header → title → reserved subtitle → body →
CTA → back. The XL title anchors from its top and reserves its full two-line
slot, so one- and two-line titles leave the body in the same place. There is **no
leading slot in the header**, so its alignment never shifts between steps. The
back affordance sits **below the CTA**, absent on step 1 — the bottom of the
screen is where the thumb already is.

**LfNavBar** — four destinations, 64 plus safe area, `navBarSurface` with a 1px
top hairline. Active: filled icon, `primary`, inside a `surface3` pill. Inactive:
regular icon, `textMid`. Labels always visible in `navLabel`. Badge dot uses
`primary`.

**LfSheet** — `surface1`, radius 20 on top corners, `scrim` behind. Scrim tap and
system back both dismiss. No drag-to-dismiss and no handle: neither is specified
and inventing a gesture threshold is inventing a decision.

**LfToast** — **bottom-anchored, above the nav bar**, `surface2` with a hairline.
Toasts are triggered by things at the bottom of the screen — a button press, a
sheet dismissal — and feedback appearing at the top is feedback people miss.
Status colour is confined to the icon. Neutral and success dwell 4s, error 6s;
reduced motion removes the entrance transition, not the dwell. **One toast at a
time**: a new one replaces the current one, and nothing queues, because a stale
toast surfacing after its context has passed is worse than a missed one.

**LfAvatar** — blank, avatar or photo. **The blank state is a designed state, not
a fallback.** It must look like a choice.

Also in the inventory: ProfileCard · QuizCard · ResultShareCard (9:16 and 1:1
export) · RequestTile · MessageBubble · EmptyState · PaywallBlock · SafetyBanner.

## Accessibility

Text meets 4.5:1 and large text 3:1 against whatever sits behind it; the token
values above are chosen so this holds without per-screen checking.

Every interactive element has a 48×48 target regardless of its visual size.

Every control carries a semantic label; icon-only controls carry one describing
the action, not the icon. Reduced motion is honoured everywhere. Dynamic type
scales body text; display type scales within its band and stops.

**Colour is never the only carrier.** A validation state is a colour *and* an
icon; a shared-point chip is an outline *and* a position; the active navigation
destination is a colour *and* a filled icon *and* a pill.

## Content density

A screen has one primary action. If a second competes, one of them is not
primary and the screen has not been decided yet.

Empty states say what is missing and what to do, never apologise, and never fill
space with decoration to seem less empty.
