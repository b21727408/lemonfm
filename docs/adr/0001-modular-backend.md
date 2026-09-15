# ADR 1: A modular Spring backend

Status: Accepted

## Context

Lemon.fm has distinct account, quiz, discovery, contact and safety responsibilities. Several behaviors require one authoritative transaction: accepting a request against a changed door, preventing a duplicate exchange and enforcing a sender's accepted-request allowance. The initial team and traffic do not justify operating a network of independent services.

AI-assisted implementation benefits from explicit boundaries that are easy to inspect and automatically verify. It also needs a small enough runtime and build model that adding one feature does not require editing a second architecture framework.

## Decision

Use one Spring Boot application with business modules verified by standard Spring Modulith checks. Expose narrow APIs, declare permitted dependencies and keep the combined dependency graph acyclic, including subscribed event types. Use a single application build project initially, with internal package boundaries and a few focused architecture tests.

Declare the complete first-release module layout during bootstrap using standard package metadata. Implement behavior in vertical slices. Upfront declarations make ownership visible across the repository while keeping speculative services, persistence and interfaces out of the scaffold.

Use Spring Modulith's built-in explicitly-annotated detection with a test of the complete business-module set. Technical HTTP adapters and configuration remain outside that graph under the separate boundary in [ADR 5](0005-http-adapter-boundary.md). Focused architecture checks prevent those packages from becoming a route around module encapsulation; no custom module detector is required.

Place behavior and data in an owner that allows a clear dependency direction. For contact, Messaging owns pair state and accepted-send usage while Safety supplies protective policy independently of commercial entitlements. Authoritative multi-module writes use the short transaction and mutation-guard protocol in [Backend](../backend.md). After-commit work can use durable local events when retries are required.

## Alternatives

Independent services would offer separate deployment and scaling, but introduce distributed consistency, authorization propagation, delivery failure and operational work before those benefits are needed. They are not selected for the initial product.

An unrestricted monolith would minimize initial boundary configuration, but permit profile, moderation and conversation persistence to become entangled. Untangling identity-sensitive behavior later would be expensive. Package modules with automated verification provide a useful middle ground.

A custom dependency engine could distinguish several kinds of allowed cycles. Its ongoing implementation and upgrade cost is not justified while the ownership model can be designed to pass standard checks.

## Consequences

Modules deploy together and share a process and database. Boundaries are enforced by tests and review, not independent network or database credentials. This is deliberate. A simple module need not have every possible architectural layer.

The initial repository includes a small amount of module metadata ahead of its behavior. Verify discovery of all declared modules, but treat successful verification of an unimplemented module as structural evidence only.

Per-account mutation guards simplify correctness at the cost of serializing relevant writes by that account. Concurrency tests must establish the promised order. Event listeners still need idempotency, retry operation and observability; event publication does not automatically solve external delivery.

Reconsider service extraction when measured scaling, an independent team or a required isolation boundary justifies its operational cost. Reconsider guard granularity when actual contention is material. Current module names and dependencies belong in Backend rather than being copied into this decision.
