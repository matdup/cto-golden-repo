# Prometheus

Contains scrape config + alert rules + SLO rules.

Files:
- prometheus.yml: scrape config
- alerting.yml: alert rules (must include severity/owner/runbook_url)
- slo-rules.yml: SLO recording rules (optional but recommended)
- blackbox.yml: uptime probing config
- targets/: file-based targets for app metrics

## Validation
Run locally:
```bash
docker run --rm -v "$PWD:/etc/prometheus" prom/prometheus:v2.52.0 \
  promtool check config /etc/prometheus/prometheus.yml
``` 
and
```bash
docker run --rm -v "$PWD:/etc/prometheus" prom/prometheus:v2.52.0 \
  promtool check rules /etc/prometheus/alerting.yml
```