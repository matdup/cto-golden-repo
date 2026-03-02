#!/usr/bin/env bash
set -euo pipefail

# -----------------------------
# Generic HTTP readiness check
# -----------------------------

log() { printf "%s %s\n" "$1" "$2" >&2; }
die() { log "❌" "$1"; exit "${2:-1}"; }

usage() {
  cat <<'EOF'
Usage:
  healthcheck-http.sh [URL] [--timeout <seconds>] [--retries <n>] [--expect <code>]

Defaults:
  URL        = http://localhost:8080/health
  timeout    = 5
  retries    = 3
  expect     = 200

Examples:
  healthcheck-http.sh http://localhost:8080/health
  healthcheck-http.sh https://example.com/health --timeout 3 --retries 5 --expect 204
EOF
}

require_cmd() { command -v "$1" >/dev/null 2>&1 || die "Missing dependency: $1" 3; }

require_cmd curl

URL="${1:-http://localhost:8080/health}"
shift || true

TIMEOUT=5
RETRIES=3
EXPECT=200

while [ $# -gt 0 ]; do
  case "$1" in
    --timeout) TIMEOUT="${2:-}"; shift 2 ;;
    --retries) RETRIES="${2:-}"; shift 2 ;;
    --expect)  EXPECT="${2:-}"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) die "Unknown option: $1 (use --help)" 2 ;;
  esac
done

[ -n "$TIMEOUT" ] || die "Invalid --timeout" 2
[ -n "$RETRIES" ] || die "Invalid --retries" 2
[ -n "$EXPECT" ] || die "Invalid --expect" 2

log "ℹ️" "Checking URL: ${URL} (expect=${EXPECT}, timeout=${TIMEOUT}s, retries=${RETRIES})"

# We request status code only, no output
code="$(curl -sS -o /dev/null -w "%{http_code}" --max-time "${TIMEOUT}" --retry "${RETRIES}" --retry-all-errors --retry-delay 1 "${URL}" || true)"

if [ "$code" = "$EXPECT" ]; then
  log "✅" "OK ${URL} (HTTP ${code})"
  exit 0
fi

die "Healthcheck failed for ${URL}: expected ${EXPECT}, got ${code}" 4