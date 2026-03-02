# Data Retention Policy

Defines retention and deletion requirements.

---

## Application Logs

- Default retention: 30 days
- Security logs: 90 days
- Audit logs: 1 year (minimum)

---

## Backups

- Daily backups retained: 30 days
- Weekly backups retained: 12 weeks
- Monthly backups retained: 12 months

Backups must be:
- Encrypted
- Tested via restore procedure quarterly

---

## User Data

Retention based on:
- Contractual obligation
- Legal requirements
- Product necessity

Deletion:
- User-request deletion within 30 days
- Soft-delete pattern allowed
- Hard-delete required for Tier 3 data after TTL

---

## Audit Evidence

- CI logs: 90 days
- Security scans: 1 year
- SBOM artifacts: 1 year

---

Retention policies must be enforced via:
- Database TTL
- Object storage lifecycle rules
- Backup rotation scripts