# Disaster Recovery Targets

Defines Recovery Point Objective (RPO) and Recovery Time Objective (RTO).

---

## Environments

| Environment | RPO | RTO | Owner |
|-------------|-----|-----|-------|
| Dev | 24h | 24h | Engineering |
| Staging | 12h | 12h | Engineering |
| Production | 1h | 4h | CTO |

---

## Requirements

Production must have:
- Automated daily backups
- Cross-region backup copy (if applicable)
- Restore test at least quarterly
- Documented DR runbook

---

## Incident Escalation

Severity 1:
- Data loss
- Full outage
Escalate to CTO immediately.

---

DR testing results must be documented in:
`docs/tech-runbooks/restore-test.md`