#!/usr/bin/env bash
set -euo pipefail

log() { printf "%s %s\n" "$1" "$2" >&2; }
die() { log "❌" "$1"; exit "${2:-1}"; }

usage() {
  cat <<'EOF'
Usage:
  deploy-staging.sh [--yes] [--skip-migrations] [--skip-healthchecks]

Behavior:
  - Runs infra plan (and apply only if --yes)
  - Optionally runs db migrations
  - Runs healthchecks

EOF
}

CONFIRM=false
SKIP_MIGRATIONS=false
SKIP_HEALTH=false

while [ $# -gt 0 ]; do
  case "$1" in
    --yes) CONFIRM=true; shift ;;
    --skip-migrations) SKIP_MIGRATIONS=true; shift ;;
    --skip-healthchecks) SKIP_HEALTH=true; shift ;;
    -h|--help) usage; exit 0 ;;
    *) die "Unknown option: $1 (use --help)" 2 ;;
  esac
done

log "ℹ️" "Staging deployment starting (confirmed=${CONFIRM})"

# Infra
if [ "${CONFIRM}" = "true" ]; then
  bash scripts/deploy-infrastructure.sh --project-id "${OVH_PROJECT_ID:-missing}" --env staging --apply --yes
else
  bash scripts/deploy-infrastructure.sh --project-id "${OVH_PROJECT_ID:-missing}" --env staging --plan-only
  log "⚠️" "Infra NOT applied (run with --yes to apply)."
fi

# Migrations
if [ "${SKIP_MIGRATIONS}" = "false" ]; then
  bash scripts/db-migrate.sh --node || die "Migrations failed" 1
fi

# Healthchecks
if [ "${SKIP_HEALTH}" = "false" ]; then
  bash scripts/health-checks/healthcheck-deps.sh || die "Deps healthcheck failed" 4
  bash scripts/health-checks/healthcheck-backend.sh || die "Backend healthcheck failed" 4
  bash scripts/health-checks/healthcheck-frontend.sh || die "Frontend healthcheck failed" 4
fi

log "✅" "Staging deployment finished"