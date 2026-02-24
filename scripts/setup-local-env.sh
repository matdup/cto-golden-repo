#!/usr/bin/env bash
set -euo pipefail
cp -n .env.example .env || true
echo "✅ Local env ready"
