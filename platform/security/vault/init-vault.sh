#!/usr/bin/env bash
# platform/security/vault/init-vault.sh
# WARNING: This script is for LOCAL/DEV bootstrap only.
# Do NOT use in production. In production, follow hardened Vault procedures.

set -euo pipefail

VAULT_ADDR="${VAULT_ADDR:-http://vault:8200}"
VAULT_TOKEN="${VAULT_TOKEN:-${VAULT_DEV_ROOT_TOKEN_ID:-root-token}}"

echo "🔐 Vault bootstrap (DEV ONLY)"
echo "VAULT_ADDR=${VAULT_ADDR}"

# Wait for Vault
until curl -fsS "${VAULT_ADDR}/v1/sys/health" >/dev/null; do
  echo "⏳ Waiting for Vault..."
  sleep 2
done

export VAULT_ADDR
export VAULT_TOKEN

# Enable kv-v2 at secret/ if not enabled
if ! vault secrets list -format=json | jq -e 'has("secret/")' >/dev/null 2>&1; then
  vault secrets enable -path=secret kv-v2
fi

# Create example paths WITHOUT real creds (placeholders only)
vault kv put secret/platform/example \
  note="placeholder only" \
  created_at="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"

# Minimal read policy example (placeholder)
vault policy write platform-readonly - <<'EOF'
path "secret/data/platform/*" {
  capabilities = ["read"]
}
EOF

echo "✅ Vault bootstrap complete (DEV ONLY)."