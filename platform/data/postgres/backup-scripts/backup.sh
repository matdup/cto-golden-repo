#!/usr/bin/env bash
set -euo pipefail

# Usage:
# PGHOST=... PGPORT=5432 PGUSER=... PGPASSWORD=... PGDATABASE=... ./backup.sh /backups

OUT_DIR="${1:-./backups}"
TS="$(date -u +%Y%m%dT%H%M%SZ)"
FILE="${OUT_DIR}/${PGDATABASE:-db}_${TS}.dump"

mkdir -p "${OUT_DIR}"

: "${PGHOST:?PGHOST required}"
: "${PGUSER:?PGUSER required}"
: "${PGDATABASE:?PGDATABASE required}"

echo "📦 Backing up ${PGDATABASE} -> ${FILE}"
pg_dump -Fc -f "${FILE}" "${PGDATABASE}"
echo "✅ Done"