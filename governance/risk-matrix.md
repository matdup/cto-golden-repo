# Risk Matrix

Defines risk identification and mitigation approach.

---

## Risk Categories

| Category | Example | Mitigation |
|-----------|----------|-------------|
| Security | Credential leak | Gitleaks + rotation |
| Availability | DB outage | Backups + DR plan |
| Compliance | PII misclassification | Data tier review |
| Financial | Cost spike | Budget alerts |
| Operational | Single maintainer | Backup owner |

---

## Risk Severity

- Low: minimal impact
- Medium: partial degradation
- High: production disruption
- Critical: data loss / security breach

---

## Review Cadence

Risk matrix reviewed:
- Quarterly
- After major incident
- Before major architecture change