# Lemon.fm

A social discovery app built on quizzes. Solve quizzes, earn results that
collect on your profile, browse open profiles, and write to people — anonymously
by default, unless the person you are writing to has asked for a profile.

18+, dark-only, Turkish and English, launched one city at a time.

## For AI sessions

Read [`AGENTS.md`](AGENTS.md) first. It is read at the start of every session and
it is law. It is **generated** from `agent-law` blocks in the documents below —
a rule is edited where it is written, then `./lemon generate` rebuilds the file
and CI fails on a diff. Editing `AGENTS.md` by hand is a build failure.

This file is for humans.

## Documentation

The documents in `docs/` are the source of truth for this project. Code is
downstream of them.

| | |
|---|---|
| [`00-product`](docs/00-product.md) | what this is, who for, vocabulary, KPIs |
| [`01-domain`](docs/01-domain.md) | entities, invariants, state machines |
| [`02-experience`](docs/02-experience.md) | screens, flows, states |
| [`03-design-system`](docs/03-design-system.md) | tokens, components, accessibility, motion |
| [`04-architecture`](docs/04-architecture.md) | topology, module boundaries, data |
| [`05-contracts`](docs/05-contracts.md) | API, errors, content schemas, versioning |
| [`06-safety`](docs/06-safety.md) | safety invariants, moderation, legal |
| [`07-content`](docs/07-content.md) | quizzes, results, editorial rules |
| [`08-quality`](docs/08-quality.md) | tests, lints, gates, release |
| [`09-discovery`](docs/09-discovery.md) | ranking, fatigue, distribution, capacity |
| [`10-roadmap`](docs/10-roadmap.md) | what gets built next, and why in that order |

## Layout

```
apps/           the shipped app, the component catalogue, the moderation console
packages/       the design system, generated clients, technical boundaries,
                and one package per bounded context
backend/        Spring Boot modular monolith
contracts/      every typed boundary, authored
architecture/   modules.yaml — the boundary definition
design/         token values as data
content/        quizzes and interests, validated in CI
docs/           the documents above
```

**The exact package list lives in
[`architecture/modules.yaml`](architecture/modules.yaml) and nowhere else.**
Repeating it here would mean maintaining it in two places, and it has already
drifted once.

## Getting started

Prerequisites and exact versions are pinned in the repository and listed in
[`docs/08-quality`](docs/08-quality.md).

```bash
docker compose up postgres                    # the only Phase 0 dependency
./lemon dev                                    # everything else natively
```

One command surface, and CI runs the same commands:

```bash
./lemon check      # everything CI runs
./lemon test
./lemon fix        # format and autofix
./lemon generate   # clients, tokens, AGENTS.md, boundary rules
```

## Working here

`main` is protected. Everything arrives through a pull request with a green
pipeline — policy checks, then the fast per-stack jobs, then contracts,
integration, build smoke and security. The stages are defined in
[`docs/08-quality`](docs/08-quality.md).

Before opening one, run `./lemon check` — it is most of the Definition of Done
in [`docs/08-quality`](docs/08-quality.md). What is left for a human is what a
machine cannot judge.

Boundaries are defined in [`architecture/modules.yaml`](architecture/modules.yaml)
and enforced from it. Changing what a module may depend on means editing that
file.

Build logic lives in `build-logic/` and is owned separately. **A feature
task never changes build logic, dependency policy or a quality gate** — a task
that needs to is a build-infrastructure task and says so in its title.

Commits follow the conventional format, with `safety:` and `content:` as
first-class types.

## A note on the gates

Every check in CI is deliberately broken once and watched failing before it is
trusted. A gate that has never failed on purpose is decoration, not protection —
so when you add one, break it first.
