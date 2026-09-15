# Design

## Visual direction

Lemon.fm uses a dark ground, a yellow accent, distinctive display typography and calm reading surfaces. The starting onboarding direction uses a wordmark, large left-aligned headings, generous spacing and one prominent primary action. Refine visual choices in working screens with real content and interaction states. Concept images suggest composition; they do not establish behavior, accessibility or exact geometry. Landing and quiz results can carry stronger visual expression. Onboarding, profiles and conversation prioritize legibility and clear actions. The result reveal is the main celebratory moment.

There is no mascot, personality-driven profile color or ranking badge. Depth comes primarily from surface contrast and borders. Low-contrast curved lines and restrained tonal gradients may give onboarding a recognizable background; keep them static and subordinate to text and controls. Editorial quiz covers can have their own illustration and palette. Use restraint with decoration so the quiz writing and the people remain the content.

The initial palette direction is yellow #FEC602, a near-black blue ground #050613, stepped dark surfaces and neutral light text. Use dark text on the yellow primary action. Exact runtime values are owned by the typed Dart theme in lemon_ui. Its first version defines the roles used by real screens; no JSON-to-Dart token generator is required.

## Semantic styling

lemon_ui owns colors, typography, spacing, radii and motion values. Features use semantic theme values and shared components. A meaningful new value belongs in that system; a one-off layout relationship does not automatically require a globally named token.

Use Flutter's ThemeData, ColorScheme and component themes for their existing roles, adding typed brand values only where needed. Keep network timeouts, retry delays and business deadlines outside visual motion tokens. [Flutter themes](https://docs.flutter.dev/cookbook/design/themes)

| Styling role | Meaning |
|---|---|
| Page, raised surface and input surface | Reading hierarchy and grouping |
| Primary, secondary and helper text | Content emphasis without hiding essential explanations |
| Primary and secondary action | Action priority, including loading and disabled states |
| Focus and selection | Current interaction, distinct from validation success |
| Error and confirmation | Known operation outcome, with text or an icon as well as color |

For interactive controls, filled yellow identifies the primary action. Yellow outlines or text can identify shared points, selection and focus, with shape or labels carrying the distinction too. Quiz choices show selection with a marker and tonal or outlined treatment, so selection does not look like the next-step action. Static result artwork can use the accent expressively without adopting button styling.

Anonymous and profile-linked contact use equally neutral identity labels. Do not present anonymity as a green safety guarantee or profile-linked contact as a red danger state. The wording and timing of that explanation belong to [Experience](experience.md).

Use a four-point spacing basis. Controls have at least a 48 by 48 logical-pixel interaction target, even when a chip or icon is visually smaller. Start cards, fields and primary buttons with rounded rectangles and consistent corner treatment. Refine corner shapes with the first real screens; neither a pill nor a rounded rectangle is a quality requirement. Semantic error, disabled and focus states remain readable against the actual containing surface.

## Typography and localization

Use Space Grotesk for display and Inter for body text, bundled with their required licenses and Turkish glyph coverage. Body text starts around 16 logical pixels with comfortable line height. Display size can vary with available space, but text enlargement must not be defeated by shrinking important text to fit a fixed box.

Allow titles to wrap and layouts to grow or scroll. Do not implement a custom binary-search text fitter as a prerequisite for onboarding. Truncation is acceptable for a preview that has an accessible full-detail view; it is inappropriate for identity mode, an error, a consent statement or a destructive-action explanation.

Test Turkish and English with long realistic strings. Locale keys describe meaning, not the English sentence. Do not build sentences by concatenating fragments whose order may change between languages. Relative dates and numbers use the selected locale; server timestamps remain unambiguous.

## Framework and components

Use Flutter's text editing, focus, scrolling, semantics and platform behavior. Material components may be themed and wrapped inside lemon_ui. Retaining their tested behavior is preferable to rebuilding a text field or dialog from low-level pieces for visual purity.

Create shared components when they appear in a real flow. The first quiz slice needs buttons, inputs, progress, cards and empty/error states. Conversation and moderation components arrive with those features. A component name alone is not a reason to add a file or a Widgetbook entry.

Onboarding screens share a layout for branding, progress, title, content and actions. Spacing adapts when the keyboard or enlarged text needs room; the logo and decorative space must not push a focused field out of reach. Keep this layout independent of the feature's step order and validation. Progress uses one consistent visual treatment whose fill agrees with its current/total label.

| Component | Required behavior |
|---|---|
| Button | Enabled, disabled and loading; loading suppresses repeat activation and retains a meaningful accessible label |
| Input | Label, helper/error, keyboard type, focus and validation as separate state dimensions |
| Field validation display | Checking, valid and invalid presentations; the feature supplies a state tied to the current input |
| Progress | Honest current/total for a defined task; readable semantic value |
| Profile representation | Intentional blank, avatar, loading photo, approved photo and unavailable photo |
| Result card | Equal collection treatment; readable long copy; share-safe export |
| Message bubble | Sending, awaiting confirmation, sent and failed; no implied read status |
| Sheet or dialog | Focus enters the surface, returns to its trigger on dismissal, and unsaved work follows the feature's discard policy |
| Feedback | Immediate and contextual; persistent errors where an action is needed |

A component accepts semantic state rather than arbitrary combinations of success colors and unchecked data. Feature controllers own operation state and server calls; lemon_ui renders supplied values and emits user actions. It does not import feature controllers or generated API models. Suppressing a second tap is UI behavior; duplicate-write protection belongs to the server contract. Theme defaults and standard widgets remain usable inside the design package so small platform changes do not require a custom renderer.

Use the Flutter SDK's Material icon set initially, with one consistent style for each role and labels for icon-only actions. A different icon library needs a concrete visual need. Do not build a catalog of unused icons or generic wrappers for every SDK widget.

Profile and collection cards have one accessible primary navigation action. A nested contact or overflow action must not also trigger the card's navigation. Share cards use dedicated 1:1 and 9:16 export layouts; inspect their longest authored text without clipping. The in-app result remains fully readable with system text sizing.

## Motion and feedback

Use brief transitions for feedback and navigation. Motion must not delay an available action or make a sent message wait for an animation to become visible. Avoid animating entire long lists on each data refresh.

Honor reduced motion by removing nonessential movement and suppressing confetti. Preserve necessary feedback through text or a static state. Avoid flashing a celebration in a zero-duration animation. Haptics are optional feedback, never the only confirmation and never a punishment for an error.

Transient messages appear near the action or above bottom navigation. Replace obsolete transient feedback instead of queueing messages from contexts the user has already left. Errors requiring correction stay available in the relevant screen.

## Accessibility and visual verification

Use WCAG contrast targets as design checks: at least 4.5:1 for ordinary text and 3:1 for qualifying large text. Essential control/state indicators need 3:1 against adjacent colors where the non-text criterion applies; decorative borders do not automatically require it. Measure actual foreground/background combinations, including opacity and images. A palette definition does not establish that every screen passes. [W3C non-text contrast guidance](https://www.w3.org/WAI/WCAG22/Understanding/non-text-contrast.html)

Test representative flows at normal and 200% text size without losing information or functionality. Follow the platform text-scaling setting; 200% is a test point, not an application-wide cap. Screen-reader order follows reading and action order. Icon labels name the action. Inputs expose errors semantically; a repeated message should not cause the entire conversation to be announced again. [W3C text resize guidance](https://www.w3.org/WAI/WCAG22/Understanding/resize-text.html)

Use focused widget tests for interaction, selected goldens for stable shared components and visual inspection for complete flows. Widgetbook is a convenient catalog when shared components exist; a golden for every possible screen-state permutation is not required. New visual states should be inspected in their actual context, including small screens, the keyboard, long translations and reduced motion.

The first visual references are the entry form, one quiz question and its result. Inspect them with real Turkish and English content on a narrow supported phone, enlarged text and relevant error/loading states before expanding the component catalog. Focused fields, identity explanations and the primary action remain reachable above the keyboard through scrolling or an adaptive layout. A bottom-pinned action must not cover the final content. Verify screen-reader behavior with TalkBack and VoiceOver when the respective platform builds are available; screenshots alone cannot establish it.
