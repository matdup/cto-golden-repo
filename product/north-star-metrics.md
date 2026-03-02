# North Star Metrics

## Purpose

Define measurable indicators of product success and system health.

---

# 1. Primary North Star Metric

(Define based on your product)

Example:
- Monthly Active Institutional Assets Managed
- Transactions processed per month
- Active verified users

This metric must:
- Reflect real user value
- Be directly tied to revenue or engagement
- Be measurable via system data

---

# 2. Supporting Metrics

## Growth

- Weekly active users
- Conversion rate
- Feature adoption rate

## Reliability

- Uptime (target: 99.9%+)
- Error rate < 1%
- MTTR < 1 hour

## Performance

- P95 API latency < 300ms
- Page load time < 2s

## Security

- Critical vulnerabilities: 0
- Secret exposure: 0
- Security scan coverage: 100%

## Financial

- Infra cost per active user
- Cloud cost growth vs revenue growth

---

# 3. Guardrail Metrics

Metrics that must NOT degrade:

- Data loss incidents
- Security incidents
- SLA violations
- Compliance violations

---

# 4. Monitoring Implementation

Metrics must be:
- Collected via Prometheus
- Visible in Grafana dashboards
- Reviewed monthly
- Used in quarterly planning

---

What is not measured is not managed.