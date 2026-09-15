# ADR 4: Flutter feature packages with selective layers

Status: Accepted

## Context

The app includes quiz play, discovery, profiles, anonymous contact and safety flows. These have separate state and behavior, but share design components and an HTTP boundary. AI-assisted development should have visible feature ownership without requiring every small operation to pass through several empty layers.

## Decision

Use a Dart Pub workspace with feature packages and a consumer application that composes their public entry points. Features do not depend on sibling features. Share lemon_ui and the generated api_client. Add other packages only for a real reusable boundary.

Use Riverpod for state and dependency injection and go_router for navigation. Separate presentation from data access. Introduce domain/use-case types for complex or repeated logic, not as mandatory forwarding layers. Ordinary immutable Dart types are sufficient unless generation provides a concrete benefit.

The host owns cross-feature navigation and application lifecycle, composes Auth's session state, and wires explicit change/refresh callbacks. Features own their repositories, controllers and localized interface text. Feature code remains independently testable through its actual external seams. Standard analyzer checks plus a small manifest dependency check enforce the chosen package rule. [Mobile](../mobile.md) owns the current layout and implementation conventions.

## Alternatives

Feature folders inside one application would reduce pubspec files and package entry points. They are suitable for many small apps. For Lemon.fm's known feature boundaries and AI review workflow, explicit packages offer useful ownership and make accidental implementation imports easier to detect.

Mandatory presentation/application/domain/data layers in every package would look uniform, but add pass-through classes and mappings where no independent rule exists. We accept some variation in a feature's internal depth while preserving its public boundary and the UI/data distinction.

Generating a full package graph and custom Dart lint plugin from a central architecture file could enforce more detailed import rules. That additional tooling is not justified by the initial no-sibling-dependency rule, which can be checked directly from standard manifests.

## Consequences

Packages introduce metadata, imports and public composition APIs. Shared navigation must be wired explicitly. That cost is accepted for established features; a package is not created merely because a screen appears in a roadmap.

Riverpod is a concrete framework dependency in presentation and composition code. It does not define the domain model or replace state-machine reasoning. A repository abstraction is useful at an external boundary, while a wrapper around every class would dilute that value.

Keep the first completed quiz feature as a working example of state, errors, API use and tests. Reconsider package granularity when repeated host plumbing or genuine shared feature behavior outweighs the isolation benefit. Reconsider a domain layer when controller complexity or duplication demonstrates its need.
