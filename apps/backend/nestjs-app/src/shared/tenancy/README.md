# Tenancy

This folder defines the tenant propagation contract.

Evolution options:
- Shared DB (tenant_id column + RLS / app-level filtering)
- Schema-per-tenant

Pick the simplest safe approach for MVP and evolve when needed.
