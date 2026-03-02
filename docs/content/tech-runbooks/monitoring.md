# Monitoring

## Goal
Ensure metrics/logs/alerts are working and actionable.

## Checks
- Prometheus ready: `http://localhost:9090/-/ready`
- Grafana health: `http://localhost:3000/api/health`
- Loki ready: `http://localhost:3100/ready`

## What to do if missing signals
- check target configuration
- check container logs
- validate scrape targets in Prometheus UI

## Ownership
Platform/Infra owner (see governance ownership + CODEOWNERS)