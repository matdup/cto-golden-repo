# Architecture overview

## Goal
Provide a secure, observable foundation that can evolve from MVP to Growth/Scale without rewriting core contracts.

## High-level components
- **Frontend** (`apps/frontend`): UI + client logic
- **Backend** (`apps/backend`): API + domain logic (modular monolith by default)
- **Contracts** (`contracts/`): API source of truth (OpenAPI + schemas)
- **Infrastructure** (`apps/infrastructure`): runtime manifests + IaC
- **Platform** (`platform/monitoring`, `platform/security`): observability & security tooling
- **Governance** (`governance/`): policies referenced by the stack

## Data flow (simplified)
1. Client authenticates via chosen auth provider
2. Client calls backend with bearer token + request id
3. Backend enforces RBAC/ABAC and tenant context
4. Backend persists domain state and emits:
   - operational logs
   - metrics
   - audit events (for sensitive actions)
5. Monitoring stack aggregates signals and triggers alerts/runbooks

## Non-negotiables
- Contracts are versioned and reviewed
- CI security checks run on PRs
- Audit logging exists for sensitive actions
- Rollback path exists for any deployment

## Links
- Decisions: `decisions.md`
- Edge: `edge.md`
- SLO: `slo.md`