#!/usr/bin/env bash
set -euo pipefail

log() { printf "%s %s\n" "$1" "$2" >&2; }
die() { log "❌" "$1"; exit "${2:-1}"; }

usage() {
  cat <<'EOF'
Usage:
  setup-local-env.sh [--force]

Behavior:
  - Copies .env.example to .env if .env does not exist
  - Does not overwrite .env unless --force is provided

EOF
}

FORCE=false
while [ $# -gt 0 ]; do
  case "$1" in
    --force) FORCE=true; shift ;;
    -h|--help) usage; exit 0 ;;
    *) die "Unknown option: $1 (use --help)" 2 ;;
  esac
done

if [ ! -f ".env.example" ]; then
  die "Missing .env.example at repo root" 2
fi

if [ -f ".env" ] && [ "${FORCE}" = "false" ]; then
  log "✅" ".env already exists (use --force to overwrite)"
  exit 0
fi

cp ".env.example" ".env"
log "✅" "Local env ready: .env created from .env.example"