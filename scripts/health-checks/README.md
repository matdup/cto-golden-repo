# Health checks

These scripts validate readiness and basic availability.
They are intended for:
- CI/CD gates
- deploy scripts post-checks
- local smoke validation

## Rules
- Must be **fast** (typically < 5s)
- Must **fail fast** and return non-zero on failure
- Must be configurable via env and/or arguments
- Must not require secrets

## Scripts
- `healthcheck-http.sh`: generic HTTP GET check
- `healthcheck-backend.sh`: backend health endpoint
- `healthcheck-frontend.sh`: frontend root or /health
- `healthcheck-deps.sh`: database and redis reachability checks

## Usage
```bash
bash scripts/health-checks/healthcheck-http.sh http://localhost:8080/health
bash scripts/health-checks/healthcheck-backend.sh
bash scripts/health-checks/healthcheck-frontend.sh
bash scripts/health-checks/healthcheck-deps.sh
```