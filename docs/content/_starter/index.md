# Starter

This is the minimal entry point for readers who need to:
- run locally
- understand system boundaries
- know where the source of truth lives

## Where to start
1. **Architecture overview** → `Architecture → Overview`
2. **API contracts** → `API (Contracts) → API Index`
3. **Operational runbooks** → `Tech runbooks → Runbooks index`

## Minimum operational baseline (MVP)
- Health endpoints exist and are used in CI/CD health checks
- Monitoring stack can be started locally
- Rollback procedure exists (even if simple)
- Audit logging is defined (what, where, retention mapping)

## If you are contributing
- Read `Guides → Release safety`
- Read `Guides → Security best practices`
- Follow PR hygiene (tests, no secrets, docs updated if needed)