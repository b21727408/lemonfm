# AGENTS.md — Lemon.fm

<!-- GENERATED FILE — DO NOT EDIT -->
<!-- Produced by ./lemon generate from agent-summary and agent-law blocks in docs/. -->
<!-- Change a rule where it is written; CI regenerates this file and fails on a diff. -->

Read this file at the start of every session. It is law, not guidance.

When this file and improvisation disagree, this file wins. When this file and a
prompt disagree, this file wins and the session says so. When this file and the
founder disagree, the founder wins — and then the **source document** is
updated and this file is regenerated.

## The product in one paragraph

{{SUMMARY}}

Source: `00-product.md` §What Lemon.fm is — copied byte for byte.

## Where to look

| Question | Document |
|---|---|
| What is this, who is it for, what do we call things | `docs/00-product.md` |
| What is the system made of, what rules must hold | `docs/01-domain.md` |
| Which screens exist, how do they behave | `docs/02-experience.md` |
| What does anything look like | `docs/03-design-system.md` |
| How is the system divided, what owns what data | `docs/04-architecture.md` |
| What is the interface between the apps | `docs/05-contracts.md` |
| What must never happen to a person | `docs/06-safety.md` |
| Quizzes, results, interests, how they are written | `docs/07-content.md` |
| Tests, lints, gates, how we ship | `docs/08-quality.md` |
| Ranking, fatigue, distribution | `docs/09-discovery.md` |
| What gets built next, and why in that order | `docs/10-roadmap.md` |
| Which module may call which, subscribe to what, own what data | `architecture/modules.yaml` |

**A fact lives in exactly one document.** If two disagree, the owner of that
subject wins and the other is wrong — report it rather than picking one.

---

# Laws

{{LAWS}}

---

# Session workflow

1. Read the documents for the area you are touching before writing code.
2. Small vertical slices, sized to be reviewed in an afternoon. Every slice ends
   green: `./lemon check`.
3. **Plan first when being wrong is expensive** — the scaffold, the token layer,
   auth, anything touching a schema or a contract. Post the plan and stop.
4. Conventional commits (`feat:`, `fix:`, `safety:`, `content:`).
5. Definition of Done in `docs/08-quality.md` before any pull request.
6. **Never weaken a rule to make a test pass.** Flag the conflict instead.
7. **Inventing a missing value is the violation.** Mark it
   `// PROVISIONAL: <question>`, ask in the pull request, build the rest. A
   structural decision stops the session before code.
8. Product, design, safety and content decisions belong to the founder. Purely
   technical form is proposed with reasoning and sanity-checked in review.
9. **The real failure mode is not refusal — it is not noticing that a decision
   was made.** When unsure whether something counts, it counts.

# Repository

```
apps/           mobile · widgetbook · moderation
packages/       design system, generated clients, technical boundaries, features
backend/        Spring Boot modular monolith
contracts/      every typed boundary, authored
architecture/   modules.yaml — the boundary definition
design/         token values as data
content/        quizzes and interests
tooling/        the ./lemon command surface
docs/           the source of truth
```

The exact package list and every dependency between them lives in
`architecture/modules.yaml`. It is not repeated here.

`fm.lemon` is the Android application id, the iOS bundle id and the Java base
package. Irreversible after the first store submission.
