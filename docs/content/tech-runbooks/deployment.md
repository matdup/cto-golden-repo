# Deployment

## Goal
Deploy safely with verification and rollback readiness.

## Prerequisites
- CI green on target commit
- Secrets configured (GitHub secrets / secret manager)
- Monitoring visible (Grafana/Prometheus/Loki reachable)

## Steps
1. Deploy using the approved mechanism (CI/CD job or manual script)
2. Run post-deploy health checks:
```bash
bash scripts/health-checks/healthcheck-deps.sh
bash scripts/health-checks/healthcheck-backend.sh
bash scripts/health-checks/healthcheck-frontend.sh
```

## Verification
- health checks pass
- error rate not spiking
- key dashboards show expected signals