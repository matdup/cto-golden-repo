# Tenancy

This folder defines the tenant propagation contract.

## MVP
- Shared DB, `tenant_id` column
- Application-level enforcement (every query scoped by tenant)
- Tenant context derived from a trusted identity claim

## Growth options
- Postgres RLS (Row Level Security)
- schema-per-tenant
- quotas/rate limits per tenant

## Rules
- Never trust `X-Tenant-Id` without verifying it is allowed for the authenticated subject.
- Tenant context must be included in logs and audit events (when applicable).