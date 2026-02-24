#!/usr/bin/env bash
set -euo pipefail
url="${1:-http://localhost:8080/health}"
curl -fsS "$url" >/dev/null
echo "✅ OK $url"
