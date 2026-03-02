# scripts/

Automation & operational helper scripts for the Golden Repo.

## Principles
- **Safe by default**: no destructive action without explicit confirmation.
- **Idempotent**: rerunning should not break or corrupt state.
- **Deterministic**: explicit inputs, explicit outputs, predictable exit codes.
- **Portable**: Linux/macOS compatible where possible (Bash 4+).
- **No secrets**: secrets via env / secret managers only.

## Conventions
- All scripts must use `set -euo pipefail`
- All scripts must support `--help`
- Prefer environment variables over positional arguments for secrets
- Always validate dependencies (`curl`, `jq`, `docker`, `terraform`, `psql`, …)
- Log format:
  - ℹ️ info
  - ✅ success
  - ⚠️ warning
  - ❌ error

## Directory
- `health-checks/`: readiness checks used by CI/CD and deploy scripts
- `setup-local-env.sh`: creates local `.env` safely
- `db-migrate.sh`: runs database migrations
- `backup-database.sh`: creates a Postgres backup
- `restore-database.sh`: restores a Postgres backup
- `deploy-infrastructure.sh`: Terraform deploy wrapper
- `deploy-observability.sh`: monitoring stack wrapper
- `deploy-staging.sh`: staging deployment orchestration
- `rollback.sh`: rollback orchestration
- `ci_cd_application_script.sh`: propagate CI/CD workflows to multiple repos

## Exit codes (shared)
- `0` success
- `1` generic failure
- `2` invalid usage / missing arguments
- `3` missing dependency
- `4` healthcheck failed
- `5` unsafe operation blocked (needs confirmation)