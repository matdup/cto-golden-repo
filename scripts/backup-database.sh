#!/usr/bin/env bash
set -euo pipefail

log() { printf "%s %s\n" "$1" "$2" >&2; }
die() { log "❌" "$1"; exit "${2:-1}"; }
require_cmd() { command -v "$1" >/dev/null 2>&1 || die "Missing dependency: $1" 3; }

usage() {
  cat <<'EOF'
Usage:
  backup-database.sh [--out <dir>] [--name <prefix>]

Env:
  DATABASE_URL=postgres://user:pass@host:5432/db
  OR: PGHOST PGPORT PGUSER PGPASSWORD PGDATABASE

Defaults:
  out   = ./backups
  name  = db

Output:
  <out>/<name>_<timestamp>.dump (custom format)
  <out>/<name>_<timestamp>.sha256
EOF
}

require_cmd pg_dump
require_cmd sha256sum || true
require_cmd shasum || true

OUT="./backups"
NAME="db"

while [ $# -gt 0 ]; do
  case "$1" in
    --out) OUT="${2:-}"; shift 2 ;;
    --name) NAME="${2:-}"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) die "Unknown option: $1 (use --help)" 2 ;;
  esac
done

mkdir -p "${OUT}"
TS="$(date -u +%Y%m%dT%H%M%SZ)"
FILE="${OUT}/${NAME}_${TS}.dump"

if [ -n "${DATABASE_URL:-}" ]; then
  CONN="${DATABASE_URL}"
else
  : "${PGHOST:?PGHOST required}"
  : "${PGUSER:?PGUSER required}"
  : "${PGDATABASE:?PGDATABASE required}"
  CONN="postgresql://${PGUSER}@${PGHOST}:${PGPORT:-5432}/${PGDATABASE}"
fi

log "ℹ️" "Creating backup: ${FILE}"
pg_dump -Fc -f "${FILE}" "${CONN}"

# checksum
if command -v sha256sum >/dev/null 2>&1; then
  sha256sum "${FILE}" > "${FILE}.sha256"
elif command -v shasum >/dev/null 2>&1; then
  shasum -a 256 "${FILE}" > "${FILE}.sha256"
else
  log "⚠️" "No sha256 tool found; skipping checksum."
fi

log "✅" "Backup created: ${FILE}"