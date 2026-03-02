# Audit Retention

This file maps audit retention to `governance/data-retention-policy.md`.

## Default baseline (MVP)
- audit logs: 365 days
- security incidents: 2 years (or per regulation)
- operational logs: 30 days
- metrics: 30–90 days

## Access control
- Only security + platform owners can access audit logs
- Read access must be logged (meta-audit)

## Deletion
- Retention expiry is the only allowed deletion path
- No manual deletion except incident response with approval