#!/usr/bin/env bash
set -euo pipefail

log() { printf "%s %s\n" "$1" "$2" >&2; }
die() { log "❌" "$1"; exit "${2:-1}"; }

usage() {
  cat <<'EOF'
Usage:
  rollback.sh --strategy <compose|k8s|manual> [--yes]

Safety:
  Requires --yes to execute.

Notes:
  Rollback is deployment-specific. This script provides a safe wrapper.
EOF
}

STRATEGY=""
CONFIRM=false

while [ $# -gt 0 ]; do
  case "$1" in
    --strategy) STRATEGY="${2:-}"; shift 2 ;;
    --yes) CONFIRM=true; shift ;;
    -h|--help) usage; exit 0 ;;
    *) die "Unknown option: $1 (use --help)" 2 ;;
  esac
done

[ -n "${STRATEGY}" ] || die "Missing --strategy" 2
[ "${CONFIRM}" = "true" ] || die "Blocked: rollback requires --yes" 5

case "${STRATEGY}" in
  compose)
    if docker compose version >/dev/null 2>&1; then
      COMPOSE="docker compose"
    elif command -v docker-compose >/dev/null 2>&1; then
      COMPOSE="docker-compose"
    else
      die "Missing docker compose" 3
    fi
    [ -f "apps/infrastructure/docker-compose.yml" ] || die "apps/infrastructure/docker-compose.yml not found" 2
    log "⚠️" "Compose rollback requires a defined strategy (previous image tag)."
    die "Not implemented: define PREVIOUS_TAG and update compose accordingly." 2
    ;;
  k8s)
    die "Not implemented: provide kubectl rollback integration (deployment name + revision)." 2
    ;;
  manual)
    log "ℹ️" "Manual rollback selected. See ops-runbooks/rollback-procedure.md"
    exit 0
    ;;
  *)
    die "Unknown strategy: ${STRATEGY}" 2
    ;;
esac