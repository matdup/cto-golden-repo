# ADR 002 — Multi-cloud strategy (pragmatic)

## Status
Accepted

## Context
We want portability, cost control, and resilience without paying the complexity tax on day 1.

## Decision
Use Terraform with:
- provider-specific modules behind an abstraction layer
- environment separation
- remote state with locking
- tagging for cost allocation

Multi-cloud is a **capability** (Growth), not a permanent mandate for every component (MVP).

## Consequences
- reduces lock-in risk
- increases IaC discipline requirement
- requires strong secrets management practices

## Alternatives
- Single provider only: acceptable for MVP but increases migration risk
- Kubernetes everywhere: postponed to Scale unless justified

## Links
- Guide: `../content/guides/multi-cloud-setup.md`
- Governance: `../../governance/finops-policy.md`