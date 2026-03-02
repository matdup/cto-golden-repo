# Incident Response Runbook

## Purpose

Provide a structured response to production incidents to minimize impact and restore service within defined RTO.

---

# 1. Incident Severity Classification

| Severity | Definition | Example |
|----------|------------|----------|
| SEV-1 | Full outage / Data loss | API down |
| SEV-2 | Major degradation | >50% errors |
| SEV-3 | Minor degradation | Feature partially unavailable |
| SEV-4 | Cosmetic / low impact | UI bug |

---

# 2. Immediate Actions (T+0 to T+5 minutes)

- Acknowledge alert
- Identify impacted service
- Confirm reproducibility
- Open incident channel (Slack / Teams)
- Assign Incident Commander (IC)

---

# 3. Roles

## Incident Commander
- Coordinates response
- Maintains timeline
- Makes final decision

## Technical Lead
- Executes mitigation

## Communications Lead
- Internal + external updates (if needed)

---

# 4. Stabilization Phase

Goal: Stop impact escalation

Possible actions:
- Rollback recent deployment
- Disable feature flag
- Scale infrastructure
- Restart unhealthy services
- Enable degraded mode

---

# 5. Investigation Phase

- Check logs (Loki)
- Check metrics (Prometheus/Grafana)
- Identify recent changes
- Validate database health
- Check dependency status

Never:
- Deploy untested patch directly to prod
- Modify database schema under stress

---

# 6. Communication

SEV-1:
- Immediate leadership notification
- Status update every 30 min

SEV-2:
- Internal update every 60 min

---

# 7. Resolution

- Confirm service stability
- Monitor error rate for 30 minutes
- Close incident

---

# 8. Postmortem (Required for SEV-1 & SEV-2)

Must include:
- Timeline
- Root cause
- What worked
- What failed
- Preventive actions

Stored in:
docs/tech-runbooks/postmortems/YYYY-MM-DD-incident.md