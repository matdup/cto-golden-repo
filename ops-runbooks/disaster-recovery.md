# Disaster Recovery Runbook

## Purpose

Restore system after catastrophic failure (infra loss, region outage, data corruption).

Aligned with governance/dr-targets.md.

---

# 1. Trigger Conditions

- Data corruption
- Complete infra outage
- Ransomware
- Cloud provider outage

---

# 2. Assess Impact

- Which environment?
- Data loss window?
- Backup age?
- Region affected?

---

# 3. Restore Infrastructure

If Terraform-managed:

terraform init
terraform apply (validated plan)

Ensure:
- Networking restored
- DB instances provisioned
- Secrets re-injected

---

# 4. Restore Data

- Identify latest valid backup
- Restore into new instance
- Validate integrity
- Run smoke tests

---

# 5. Validate RPO/RTO

Compare:
- Backup timestamp
- Incident time

If RPO violated → escalate to CTO

---

# 6. Switch Traffic

- Update DNS / Load balancer
- Verify health endpoints
- Confirm error rate

---

# 7. DR Testing (Quarterly)

Must:
- Perform test restore
- Validate recovery time
- Document results

Stored in:
docs/tech-runbooks/restore-test.md