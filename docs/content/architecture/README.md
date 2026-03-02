# Architecture index

This section describes the system architecture and engineering decisions.

## Documents
- `overview.md`: boundaries, components, data flow
- `decisions.md`: “what we decided and why” (high-level)
- `edge.md`: gateway / reverse proxy / rate limiting / auth patterns
- `slo.md`: reliability targets and how we measure them
- `audit-logging.md`: audit event model + storage expectations + query guidance
- `multi-tenancy.md`: tenant context propagation and isolation strategies
- `roadmap.md`: MVP → Growth → Scale activation plan

## Rule
If a decision is **material** (security, correctness, cost, compliance),
record it as an ADR in `docs/adr/`.