# ADR 3: Authored OpenAPI at the client/server boundary

Status: Accepted

## Context

The Java backend and installed Flutter clients can change on different schedules. An assistant implementing one side must not infer the other side's payload or error behavior from scattered examples. Identity-sensitive responses also need explicit audience-specific shapes.

## Decision

Author the HTTP specification in OpenAPI and generate the Dart client and Java server interfaces from it. Add operations with their real features. Keep a separate staff specification and client when moderation is implemented. The consumer application includes only consumer bindings.

Validate actual backend responses in tests and exercise generated client serialization. Pin the generator and configuration, check deterministic output and compare contract changes for compatibility. Review disclosure and authorization independently of structural schema checks. [Contracts](../contracts.md) owns the conventions and [Quality](../quality.md) owns the verification workflow.

Generated Dart bindings are checked in to keep ordinary Flutter setup straightforward. Generated Java interfaces remain build outputs. Configuration and any small required templates are reviewed generator inputs; manual patches to output are not supported.

## Alternatives

Generating OpenAPI from controllers would keep the backend signature close to implementation, but make the interface easier to change incidentally while coding a feature. It remains viable for other projects; here an authored boundary supports deliberate review before both implementations change.

Hand-written clients would reduce generator setup and allow idiomatic endpoint-specific code. They would also duplicate serialization and make drift easier as operations grow. The initial real-quiz proof must establish that generation saves work without a large custom framework.

Generating every analytics, configuration and internal module type from one universal contract catalog would extend automation, but create unrelated machinery. Those boundaries use simple typed definitions or schemas when needed; this decision does not mandate universal code generation.

## Consequences

There are generated files and tool-version constraints. Some transport types will need mapping into presentation or domain shapes. The generator must be tested with the schema features the product uses; a valid OpenAPI document does not ensure every generator option works as expected.

A matching Java interface does not guarantee correct response content, transaction behavior or authorization. An absent staff SDK does not stop direct HTTP calls. Tests and server access controls provide those protections.

Reconsider generator strategy if a required schema feature consistently needs invasive templates or manual corrections. Preserve an explicit versioned contract even if the binding tool changes. Public API support and installed-client migration decisions remain separate from database schema rollout.
