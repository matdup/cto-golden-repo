#!/usr/bin/env bash
set -euo pipefail

log() { printf "%s %s\n" "$1" "$2" >&2; }
die() { log "❌" "$1"; exit "${2:-1}"; }
require_cmd() { command -v "$1" >/dev/null 2>&1 || die "Missing dependency: $1" 3; }

usage() {
  cat <<'EOF'
Usage:
  deploy-observability.sh [--with-vault] [--dir <path>]

Defaults:
  dir = platform/monitoring

Behavior:
  - Ensures .env exists (copies .env.example if missing and stops)
  - Starts docker compose stack
  - Optionally starts Vault profile
  - Waits for Prometheus/Grafana/Loki readiness

EOF
}

require_cmd docker
# Prefer modern docker compose; fallback on docker-compose if needed
if docker compose version >/dev/null 2>&1; then
  COMPOSE="docker compose"
elif command -v docker-compose >/dev/null 2>&1; then
  COMPOSE="docker-compose"
else
  die "Missing dependency: docker compose" 3
fi
require_cmd curl

WITH_VAULT=false
DIR="platform/monitoring"

while [ $# -gt 0 ]; do
  case "$1" in
    --with-vault) WITH_VAULT=true; shift ;;
    --dir) DIR="${2:-}"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) die "Unknown option: $1 (use --help)" 2 ;;
  esac
done

[ -d "${DIR}" ] || die "Monitoring dir not found: ${DIR}" 2

if ! docker info >/dev/null 2>&1; then
  die "Docker daemon is not running" 1
fi

cd "${DIR}"

if [ ! -f ".env" ]; then
  cp ".env.example" ".env"
  die "Created .env from .env.example. Edit it (set secure passwords) and rerun." 2
fi

# Basic guard: reject unchanged default password
if grep -q "^GRAFANA_ADMIN_PASSWORD=change_this_password" ".env"; then
  die "Refusing to deploy with default Grafana password. Update .env first." 5
fi

log "ℹ️" "Starting monitoring stack (${COMPOSE})..."
${COMPOSE} -f docker-compose.monitoring.yml up -d

if [ "${WITH_VAULT}" = "true" ]; then
  log "ℹ️" "Starting Vault profile..."
  ${COMPOSE} -f docker-compose.vault.yml up -d
fi

wait_http() {
  local url="$1"
  local name="$2"
  local attempts="${3:-30}"
  local sleep_s="${4:-2}"
  for i in $(seq 1 "${attempts}"); do
    if curl -fsS --max-time 3 "${url}" >/dev/null 2>&1; then
      log "✅" "${name} ready"
      return 0
    fi
    sleep "${sleep_s}"
  done
  die "${name} not ready: ${url}" 4
}

wait_http "http://localhost:9090/-/ready" "Prometheus"
wait_http "http://localhost:3000/api/health" "Grafana"
wait_http "http://localhost:3100/ready" "Loki"

log "✅" "Observability stack is operational."
cat <<EOF
📊 URLs:
- Grafana:      http://localhost:3000
- Prometheus:   http://localhost:9090
- Alertmanager: http://localhost:9093
- Loki:         http://localhost:3100
- Uptime Kuma:  http://localhost:3001
EOF

if [ "${WITH_VAULT}" = "true" ]; then
  log "ℹ️" "Vault: http://localhost:8200 (DEV profile)"
fi