#!/usr/bin/env bash
set -euo pipefail

# Usage:
# PGHOST=... PGPORT=5432 PGUSER=... PGPASSWORD=... PGDATABASE=... ./restore.sh path/to/file.dump

FILE="${1:?dump file required}"

: "${PGHOST:?PGHOST required}"
: "${PGUSER:?PGUSER required}"
: "${PGDATABASE:?PGDATABASE required}"

echo "♻️ Restoring ${FILE} -> ${PGDATABASE}"
pg_restore --clean --if-exists -d "${PGDATABASE}" "${FILE}"
echo "✅ Done"