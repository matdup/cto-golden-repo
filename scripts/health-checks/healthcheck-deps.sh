#!/usr/bin/env bash
set -euo pipefail

log() { printf "%s %s\n" "$1" "$2" >&2; }
die() { log "❌" "$1"; exit "${2:-1}"; }
require_cmd() { command -v "$1" >/dev/null 2>&1 || die "Missing dependency: $1" 3; }

usage() {
  cat <<'EOF'
Usage:
  healthcheck-deps.sh [--db] [--redis]

Defaults:
  Checks both DB and Redis (if config provided)

DB configuration (choose one):
  - DATABASE_URL=postgres://user:pass@host:5432/db
  - Or PGHOST, PGPORT, PGUSER, PGPASSWORD, PGDATABASE

Redis configuration (choose one):
  - REDIS_URL=redis://host:6379
  - Or REDIS_HOST, REDIS_PORT

Notes:
  - This is a reachability check (ping/query), not a full integration test.
EOF
}

# Tools (we keep it flexible; psql is best but not always installed)
require_cmd curl

CHECK_DB=true
CHECK_REDIS=true

while [ $# -gt 0 ]; do
  case "$1" in
    --db) CHECK_REDIS=false; CHECK_DB=true; shift ;;
    --redis) CHECK_DB=false; CHECK_REDIS=true; shift ;;
    -h|--help) usage; exit 0 ;;
    *) die "Unknown option: $1 (use --help)" 2 ;;
  esac
done

ok=true

check_postgres() {
  if command -v psql >/dev/null 2>&1; then
    log "ℹ️" "Checking Postgres via psql..."
    # Prefer DATABASE_URL if provided
    if [ -n "${DATABASE_URL:-}" ]; then
      PGPASSWORD='' psql "${DATABASE_URL}" -v ON_ERROR_STOP=1 -c "SELECT 1;" >/dev/null 2>&1 || return 1
      return 0
    fi

    : "${PGHOST:?PGHOST required for Postgres check}"
    : "${PGUSER:?PGUSER required for Postgres check}"
    : "${PGDATABASE:?PGDATABASE required for Postgres check}"
    # PGPORT optional

    psql -v ON_ERROR_STOP=1 -c "SELECT 1;" >/dev/null 2>&1 || return 1
    return 0
  fi

  # Fallback: TCP reachability only
  log "⚠️" "psql not found; using TCP reachability fallback for Postgres."
  host="${PGHOST:-}"
  port="${PGPORT:-5432}"
  [ -n "$host" ] || { log "⚠️" "Skipping Postgres: no DATABASE_URL and no PGHOST set."; return 0; }
  timeout 2 bash -c "cat < /dev/null > /dev/tcp/${host}/${port}" >/dev/null 2>&1 || return 1
  return 0
}

check_redis() {
  # Use redis-cli if available, otherwise TCP reachability
  if command -v redis-cli >/dev/null 2>&1; then
    log "ℹ️" "Checking Redis via redis-cli..."
    if [ -n "${REDIS_URL:-}" ]; then
      redis-cli -u "${REDIS_URL}" ping | grep -q "PONG" || return 1
      return 0
    fi
    host="${REDIS_HOST:-localhost}"
    port="${REDIS_PORT:-6379}"
    redis-cli -h "${host}" -p "${port}" ping | grep -q "PONG" || return 1
    return 0
  fi

  log "⚠️" "redis-cli not found; using TCP reachability fallback."
  host=""
  port="6379"
  if [ -n "${REDIS_URL:-}" ]; then
    # Very light parsing: redis://host:port
    host="$(printf "%s" "$REDIS_URL" | sed -E 's#^redis://##' | cut -d':' -f1)"
    port="$(printf "%s" "$REDIS_URL" | sed -E 's#^redis://##' | cut -d':' -f2 | cut -d'/' -f1)"
  else
    host="${REDIS_HOST:-}"
    port="${REDIS_PORT:-6379}"
  fi

  [ -n "$host" ] || { log "⚠️" "Skipping Redis: no REDIS_URL and no REDIS_HOST set."; return 0; }
  timeout 2 bash -c "cat < /dev/null > /dev/tcp/${host}/${port}" >/dev/null 2>&1 || return 1
  return 0
}

if [ "${CHECK_DB}" = "true" ]; then
  if check_postgres; then
    log "✅" "Dependencies: Postgres OK"
  else
    log "❌" "Dependencies: Postgres FAILED"
    ok=false
  fi
fi

if [ "${CHECK_REDIS}" = "true" ]; then
  if check_redis; then
    log "✅" "Dependencies: Redis OK"
  else
    log "❌" "Dependencies: Redis FAILED"
    ok=false
  fi
fi

if [ "${ok}" = "true" ]; then
  exit 0
fi

exit 4