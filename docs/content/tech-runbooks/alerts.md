# Alerts

## Goal
Respond to alerts with consistent severity handling.

## Required alert fields (policy)
- `severity`: critical/warning/info
- `owner`: team or component owner
- `runbook_url`: link to the exact runbook

## Steps when alert triggers
1. Identify severity + blast radius
2. Follow the linked runbook
3. If Sev-1:
   - declare incident (see `/ops-runbooks/incident-response.md`)
   - start timeline
4. Post-resolution:
   - capture root cause
   - add prevention item

## Verification
Alert resolves and system metrics return to baseline.