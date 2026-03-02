#!/usr/bin/env bash
set -euo pipefail

log() { printf "%s %s\n" "$1" "$2" >&2; }
die() { log "❌" "$1"; exit "${2:-1}"; }
require_cmd() { command -v "$1" >/dev/null 2>&1 || die "Missing dependency: $1" 3; }

usage() {
  cat <<'EOF'
Usage:
  restore-database.sh --file <dump> [--yes]

Safety:
  This is destructive. It will DROP objects (pg_restore --clean --if-exists).
  You must pass --yes to proceed.

Env:
  DATABASE_URL=postgres://...
  OR: PGHOST PGPORT PGUSER PGPASSWORD PGDATABASE
EOF
}

require_cmd pg_restore

FILE=""
CONFIRM=false

while [ $# -gt 0 ]; do
  case "$1" in
    --file) FILE="${2:-}"; shift 2 ;;
    --yes) CONFIRM=true; shift ;;
    -h|--help) usage; exit 0 ;;
    *) die "Unknown option: $1 (use --help)" 2 ;;
  esac
done

[ -n "${FILE}" ] || die "Missing --file" 2
[ -f "${FILE}" ] || die "Dump file not found: ${FILE}" 2
[ "${CONFIRM}" = "true" ] || die "Blocked: pass --yes to confirm destructive restore" 5

# Verify checksum if exists
if [ -f "${FILE}.sha256" ]; then
  log "ℹ️" "Verifying checksum..."
  if command -v sha256sum >/dev/null 2>&1; then
    (cd "$(dirname "${FILE}")" && sha256sum -c "$(basename "${FILE}").sha256") >/dev/null
  elif command -v shasum >/dev/null 2>&1; then
    # shasum -c expects "hash  file"
    (cd "$(dirname "${FILE}")" && shasum -a 256 -c "$(basename "${FILE}").sha256") >/dev/null
  else
    log "⚠️" "No checksum tool found; skipping checksum verification."
  fi
  log "✅" "Checksum OK"
fi

if [ -n "${DATABASE_URL:-}" ]; then
  CONN="${DATABASE_URL}"
else
  : "${PGHOST:?PGHOST required}"
  : "${PGUSER:?PGUSER required}"
  : "${PGDATABASE:?PGDATABASE required}"
  CONN="postgresql://${PGUSER}@${PGHOST}:${PGPORT:-5432}/${PGDATABASE}"
fi

log "⚠️" "Restoring ${FILE} into target DB (DESTRUCTIVE)"
pg_restore --clean --if-exists -d "${CONN}" "${FILE}"

log "✅" "Restore completed"