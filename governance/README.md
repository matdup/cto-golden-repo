# Governance — CTO Operating System Layer

This directory defines the **non-negotiable governance framework** of the Golden Repo.

It translates strategy into enforceable constraints across:
- Architecture
- Security
- Data handling
- Reliability
- Cost control
- Ownership
- Risk management

These policies are:
- Referenced by CI/CD
- Enforced by CODEOWNERS
- Reflected in infrastructure and monitoring
- Auditable (SOC2 / ISO 27001 ready)

---

## Governance Scope

| Domain | File | Purpose |
|--------|------|----------|
| Architecture | architecture-principles.md | Structural engineering doctrine |
| Risk | risk-matrix.md | Risk identification & mitigation |
| Data | data-classification.md | Data sensitivity tiers |
| Data | data-retention-policy.md | Retention + TTL rules |
| DR | dr-targets.md | RPO/RTO targets |
| FinOps | finops-policy.md | Cost discipline |
| Ownership | ownership.md | Accountability model |
| Repo | repo-constraints.md | Non-negotiable structural rules |
| Technology | tech-radar.md | Approved / Adopt / Trial / Hold stack |

---

## Enforcement Model

Governance is enforced via:

- `.github/workflows/` (security, supply-chain, policy gates)
- `CODEOWNERS`
- Monitoring alerts + SLOs
- Terraform constraints
- ADR process (`docs/adr/`)

---

## Maturity Model

This governance is **stage-aware**:

- Stage 0–1 (MVP): minimal viable enforcement
- Stage 2 (Growth): reliability + audit traceability
- Stage 3 (Scale): formal controls + evidence retention

---

Governance is not bureaucracy.
It is controlled risk management aligned with delivery speed.