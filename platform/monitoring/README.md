# Monitoring (Observability Stack)

This folder provides a **production-minded** observability baseline:
- Metrics: Prometheus (+ Node Exporter, Blackbox)
- Logs: Loki + Promtail
- Dashboards: Grafana provisioning + dashboards
- Alerts: Prometheus rules + (optional) Alertmanager routing
- Uptime: Uptime Kuma (optional)
- Vault: optional dev-mode profile (NOT production by default)

## Quick start (local / single host)

```bash
cd platform/monitoring
cp .env.example .env
docker compose -f docker-compose.monitoring.yml up -d
```

## With Vault profile (optional)
docker compose -f docker-compose.monitoring.yml -f docker-compose.vault.yml up -d

## Access
	•	Grafana: http://localhost:3000
	•	Prometheus: http://localhost:9090
	•	Alertmanager: http://localhost:9093
	•	Loki: http://localhost:3100
	•	Uptime Kuma: http://localhost:3001

## Production notes (non-negotiable)
	•	Do not expose Prometheus/Grafana/Alertmanager publicly without auth + TLS.
	•	Configure retention according to governance/data-retention-policy.md.
	•	Alerts must include severity, owner, and runbook_url.
	•	Slack Webhook MUST live in secrets/env (never committed).

## Directory map
	•	prometheus/: scrape configs + rules + targets
	•	grafana/: dashboards + provisioning
	•	loki/: Loki config
	•	promtail/: Promtail config
	•	alertmanager/: routing/receivers (growth)
	•	audit/: audit logging policy (where, what, retention)
	•	runbooks/: runbook entry points referenced by alerts