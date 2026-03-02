# SLO (Service Level Objectives)

SLOs define reliability targets and the measurement method.

## MVP defaults (suggested)
- Availability: **99.9%** (monthly)
- p95 latency (API): **< 300ms** for core endpoints
- Error rate: **< 1%** (5xx + functional errors as defined)
- MTTR: **< 60 minutes** (for Sev-1)

## Indicators & sources
- Availability: Prometheus `up` + synthetic probes (blackbox)
- Latency: HTTP request duration histogram
- Error rate: `5xx` and domain error codes
- Saturation: CPU/memory/disk/network

## Alerting philosophy
- Alerts should be **actionable**
- Every alert must have:
  - severity
  - owner
  - runbook link

## Operational loop
1. Alert triggers
2. Engineer follows runbook
3. If Sev-1 or recurring: incident + postmortem
4. Improvement action lands in roadmap/backlog