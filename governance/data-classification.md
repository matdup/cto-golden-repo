# Data Classification Policy

Defines data sensitivity tiers and handling requirements.

---

## Tier 0 — Public

Examples:
- Marketing content
- Public docs

Controls:
- No special restrictions

---

## Tier 1 — Internal

Examples:
- Internal logs
- Non-sensitive operational data

Controls:
- Authenticated access
- Encrypted at rest

---

## Tier 2 — Sensitive

Examples:
- User emails
- Business metrics
- Contractual documents

Controls:
- Encrypted at rest
- Encrypted in transit
- Access logged
- Role-based access control

---

## Tier 3 — Highly Sensitive / PII

Examples:
- Government IDs
- Financial data
- Biometric data

Controls:
- Strict RBAC
- Audit logging mandatory
- Limited retention
- Encryption mandatory
- Access review quarterly

---

## Logging Rules

- No Tier 2+ data in logs
- PII must be masked
- Audit logs immutable

---

Data tier must be documented in:
- API contracts
- Database schema
- ADR if new category introduced