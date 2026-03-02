# FinOps Policy

Cost control is part of system reliability.

---

## Principles

- Default to minimal viable infra
- Scale only when metrics justify
- No overprovisioning without SLO justification

---

## Tagging

All cloud resources must include:
- environment
- owner
- cost-center
- project

---

## Budget Controls

- Monthly budget defined per environment
- Alert at 70% consumption
- Review at 90%

---

## Optimization Cadence

Quarterly review:
- Unused resources
- Overprovisioned instances
- Idle storage
- Egress spikes

---

## Scaling Rules

Kubernetes adoption only when:
- Multi-team scaling
- Horizontal scaling required
- Infra complexity justified

Compose is default.