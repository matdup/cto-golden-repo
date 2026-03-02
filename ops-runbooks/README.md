# Operational Runbooks

This directory contains executable operational procedures for:

- Incident handling
- Rollback execution
- Disaster recovery
- Security incident response

These runbooks are:

- Aligned with governance policies
- Referenced by monitoring alerts
- Required for production readiness
- Reviewed quarterly

---

## Scope

| Runbook | Purpose |
|----------|----------|
| incident-response.md | General production incident handling |
| rollback-procedure.md | Safe deployment rollback |
| disaster-recovery.md | Infrastructure / data recovery |
| security-incident.md | Security breach handling |

---

## Usage Model

When an alert triggers:

1. Identify severity
2. Open incident channel
3. Follow corresponding runbook
4. Document timeline
5. Produce postmortem

---

## Ownership

- Primary Owner: CTO
- Backup Owner: DevOps / Engineering Lead

---

Runbooks are living documents.
They must be updated after any major incident.