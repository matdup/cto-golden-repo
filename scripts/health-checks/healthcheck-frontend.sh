#!/usr/bin/env bash
set -euo pipefail

log() { printf "%s %s\n" "$1" "$2" >&2; }
die() { log "❌" "$1"; exit "${2:-1}"; }
require_cmd() { command -v "$1" >/dev/null 2>&1 || die "Missing dependency: $1" 3; }

usage() {
  cat <<'EOF'
Usage:
  healthcheck-frontend.sh [--url <url>] [--timeout <seconds>] [--retries <n>]

Defaults:
  FRONTEND_URL env or http://localhost:3000
Note:
  If you have a dedicated /health endpoint, set FRONTEND_URL to it.
EOF
}

require_cmd curl

URL="${FRONTEND_URL:-http://localhost:3000}"
TIMEOUT=5
RETRIES=3

while [ $# -gt 0 ]; do
  case "$1" in
    --url) URL="${2:-}"; shift 2 ;;
    --timeout) TIMEOUT="${2:-}"; shift 2 ;;
    --retries) RETRIES="${2:-}"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) die "Unknown option: $1 (use --help)" 2 ;;
  esac
done

log "ℹ️" "Frontend check: ${URL}"
code="$(curl -sS -o /dev/null -w "%{http_code}" --max-time "${TIMEOUT}" --retry "${RETRIES}" --retry-all-errors --retry-delay 1 "${URL}" || true)"

# Accept 200 for root, 301/302 if redirected to login, etc.
if [ "$code" = "200" ] || [ "$code" = "301" ] || [ "$code" = "302" ]; then
  log "✅" "Frontend OK (${code})"
  exit 0
fi

die "Frontend check failed: HTTP ${code} on ${URL}" 4