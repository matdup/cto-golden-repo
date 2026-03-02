# Multi-tenancy

This document defines tenant context propagation and isolation expectations.

## Tenant context propagation (contract)
Tenant context must be carried via one of:
- JWT claim (preferred): `tenant_id`
- Header: `X-Tenant-Id` (only if trusted and validated)

Rules:
- Never trust a raw header without validating it against the authenticated identity.
- Tenant context must be present in logs and audit events.

## Isolation models
- Shared DB + tenant_id column (MVP default)
- Schema-per-tenant (growth)
- DB-per-tenant (scale/high compliance)

## Operational implications
- Backups and restores must consider tenant boundaries.
- Data deletion requests must be tenant-scoped and auditable.

## Security notes
- Ensure queries are tenant-scoped by default
- Add tests for tenant boundary violations
- Consider quotas/rate-limits per tenant at edge/app layer