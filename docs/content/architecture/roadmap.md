# Architecture roadmap (MVP → Growth → Scale)

This roadmap describes when to activate additional components.

## MVP (day 1)
- Contracts-first API
- Modular monolith backend
- Basic monitoring (metrics + logs)
- Health checks + rollback procedure
- Basic audit logging policy

## Growth
- Alert routing + on-call rotation
- Contract tests and compatibility checks
- IaC hardening, environment separation
- Performance testing (k6 smoke)

## Scale / Compliance-driven
- Stronger secrets management (Vault server mode or managed KMS)
- Immutable audit archives (object storage + retention controls)
- Advanced tenancy isolation
- Dedicated SRE/Platform ownership boundaries