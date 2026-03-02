# Disaster recovery (technical)

## Goal
Recover service availability after catastrophic failure.

## Inputs
- RPO/RTO targets: `governance/dr-targets.md`
- Data retention: `governance/data-retention-policy.md`

## DR procedure (outline)
1. Declare incident and start coordination (`/ops-runbooks/incident-response.md`)
2. Identify scope:
   - region outage? DB corruption? credential compromise?
3. Restore platform:
   - infrastructure (IaC)
   - secrets access
4. Restore data:
   - restore DB
   - verify integrity
5. Restore services:
   - backend
   - frontend
6. Validate:
   - health endpoints
   - key flows
   - monitoring signals
7. Postmortem:
   - root cause
   - prevention items

## Verification
- service reachable
- error rate stable
- monitoring/alerts operational