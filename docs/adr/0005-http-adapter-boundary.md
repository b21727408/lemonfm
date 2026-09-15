# ADR 5: Thin HTTP adapters outside business modules

Status: Accepted

## Context

Authored HTTP interfaces group transport operations and audience-specific models. Their grouping need not match business ownership: an exchange report is orchestrated by Messaging while Safety owns the report record. Making business modules implement a shared generated interface can introduce unrelated dependencies or leak transport types into their public APIs.

## Decision

Use a thin technical HTTP adapter that implements generated interfaces, maps transport values and delegates each operation to its owning module API. Business services retain authorization predicates, transactions and orchestration. Technical configuration composes infrastructure. Neither package owns product state or persistence.

Use standard explicitly-annotated Modulith discovery for the eight business modules. ArchUnit covers the technical adapter's access to module APIs and the prohibition on dependencies back from business modules. [Backend](../backend.md) owns package placement; [Quality](../quality.md) owns enforcement.

## Alternatives

Controllers inside each module are viable when generated interfaces align with that module. Requiring that alignment here would couple HTTP grouping and generator options to business ownership before their compatibility is proven.

A central application layer owning cross-module workflows would make controllers thin, but duplicate ownership already assigned to Messaging, Profile and other modules. That extra business layer is not selected.

## Consequences

HTTP models need deliberate mapping at this external boundary; internal models are not automatically duplicated at every layer. Generated interface changes remain isolated from business APIs where possible.

Modulith alone cannot verify unassigned technical packages. The small additional rules are mandatory, including a check that business code cannot move into an unannotated package to escape verification. Reconsider placement if real adapter code accumulates business orchestration or repeated coordination that belongs in a module. Do not use a framework limitation to change the product's ownership model silently.
