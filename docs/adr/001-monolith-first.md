# ADR 001 — Monolith first (modular monolith)

## Status
Accepted

## Context
We need to ship quickly with a small team while keeping boundaries clear enough to scale later.

## Decision
Adopt a **modular monolith** backend by default:
- bounded contexts (domain modules)
- clean separation between domain/application/infrastructure/interfaces
- contracts-first API

## Consequences
### Positive
- fast iteration
- simpler deployments and observability
- less distributed failure modes

### Negative
- requires discipline to keep boundaries clean
- scaling hotspots might require service extraction later

## Alternatives considered
- Microservices from day 1: rejected (operational overhead too high)
- Serverless-only: rejected (lock-in and complexity for stateful domains)

## Links
- Architecture overview: `../content/architecture/overview.md`