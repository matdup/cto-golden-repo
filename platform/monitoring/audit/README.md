# Audit Logging

Audit logs are **security-relevant** events:
- authentication & authorization decisions
- permission changes
- configuration changes
- data exports
- admin actions
- key lifecycle operations (create/rotate/revoke)

Audit logs must be:
- structured (JSON)
- immutable (append-only)
- queryable
- retained per governance policy

## Where audit logs go
MVP default:
- Logs shipped to Loki with label `log_type=audit`

Growth/Compliance:
- Mirror to Postgres (append-only table) or object storage (WORM)
- Apply retention per `platform/monitoring/audit/retention.md`

## Correlation
Every audit event must include:
- request_id / trace_id
- actor_id
- tenant_id (if multi-tenant)
- resource + action
- outcome (allow/deny)