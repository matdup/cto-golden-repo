# Audit logging

Audit logs are for **security/compliance-relevant events** (not general debugging).

## What to log (minimum)
- Authentication events (login/logout, token issues)
- Privileged actions (admin changes, role grants)
- Data access to sensitive classes (see `governance/data-classification.md`)
- Tenant boundary changes (tenant creation, tenant config changes)
- Security settings changes
- Export/download actions

## Audit event shape (recommended)
- timestamp
- actor (user/service)
- tenant_id (if applicable)
- action (string enum)
- target (resource id/type)
- outcome (success/failure)
- request_id
- metadata (ip, user_agent, reason)

## Where audit events go
MVP options:
- Loki (fast search + retention)
- Dedicated DB table (stronger integrity)
- Object storage (immutable archive) for higher compliance

## Access control
- Restrict who can query audit logs
- Separate operational logs from audit logs where possible

## Retention mapping
Audit retention must align with governance policy:
- `governance/data-retention-policy.md`
- `platform/monitoring/audit/retention.md` (implementation mapping)