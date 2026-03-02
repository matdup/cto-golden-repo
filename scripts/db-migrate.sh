#!/usr/bin/env bash
set -euo pipefail

log() { printf "%s %s\n" "$1" "$2" >&2; }
die() { log "❌" "$1"; exit "${2:-1}"; }
require_cmd() { command -v "$1" >/dev/null 2>&1 || die "Missing dependency: $1" 3; }

usage() {
  cat <<'EOF'
Usage:
  db-migrate.sh [--node|--sql] [--dir <path>]

Modes:
  --node  Runs backend migration command (npm)
  --sql   Applies *.sql migrations to Postgres using psql

Env (sql mode):
  DATABASE_URL=postgres://...
  OR: PGHOST PGPORT PGUSER PGPASSWORD PGDATABASE

Defaults:
  --node if apps/backend/package.json exists
  --sql  if migrations directory exists

Examples:
  db-migrate.sh --node
  DATABASE_URL=postgres://... db-migrate.sh --sql --dir apps/backend/migrations
EOF
}

MODE=""
DIR="migrations"

while [ $# -gt 0 ]; do
  case "$1" in
    --node) MODE="node"; shift ;;
    --sql) MODE="sql"; shift ;;
    --dir) DIR="${2:-}"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) die "Unknown option: $1 (use --help)" 2 ;;
  esac
done

if [ -z "${MODE}" ]; then
  if [ -f "apps/backend/package.json" ]; then MODE="node"; fi
  if [ -d "${DIR}" ] && [ -z "${MODE}" ]; then MODE="sql"; fi
fi

[ -n "${MODE}" ] || die "Cannot auto-detect migration mode. Use --node or --sql." 2

if [ "${MODE}" = "node" ]; then
  require_cmd node
  require_cmd npm

  [ -d "apps/backend" ] || die "apps/backend not found" 2
  log "ℹ️" "Running node migrations in apps/backend ..."

  (cd apps/backend && npm run migrate)
  log "✅" "Migrations completed (node)"
  exit 0
fi

if [ "${MODE}" = "sql" ]; then
  require_cmd psql
  [ -d "${DIR}" ] || die "Migrations dir not found: ${DIR}" 2

  log "ℹ️" "Applying SQL migrations from: ${DIR}"

  if [ -n "${DATABASE_URL:-}" ]; then
    CONN="${DATABASE_URL}"
  else
    : "${PGHOST:?PGHOST required}"
    : "${PGUSER:?PGUSER required}"
    : "${PGDATABASE:?PGDATABASE required}"
    CONN="postgresql://${PGUSER}@${PGHOST}:${PGPORT:-5432}/${PGDATABASE}"
  fi

  # Apply in lexicographic order
  shopt -s nullglob
  files=("${DIR}"/*.sql)
  if [ "${#files[@]}" -eq 0 ]; then
    die "No .sql migrations found in ${DIR}" 2
  fi

  for f in "${files[@]}"; do
    log "ℹ️" "Applying: ${f}"
    psql "${CONN}" -v ON_ERROR_STOP=1 -f "${f}" >/dev/null
  done

  log "✅" "Migrations completed (sql)"
  exit 0
fi

die "Unknown MODE: ${MODE}" 2