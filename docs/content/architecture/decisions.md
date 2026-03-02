# Architecture decisions (high-level)

This page summarizes key decisions. Detailed decisions belong in ADRs.

## Decisions
### 1) Contracts-first
API specs in `contracts/` are the source of truth. Code and docs follow.

### 2) Monolith-first (modular)
Default is a modular monolith backend; split services only when justified.

### 3) Observability from day one
Prometheus + Grafana + Loki baseline is included; alerting grows with maturity.

### 4) Multi-tenancy readiness
Tenant context propagation is explicit (header/claim) and audited.

### 5) “Safety gates” in CI/CD
Secret scanning and vulnerability scans block merges when critical issues are found.

## Where to track changes
- Architectural decisions: `docs/adr/`
- Security policies: `platform/security/` and `governance/`
- Operational runbooks: `docs/content/tech-runbooks/`