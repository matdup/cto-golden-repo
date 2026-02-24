#!/bin/bash
# vault/init-vault.sh - Secured Vault Initialisation script

set -euo pipefail

echo "🔐 Initializing HashiCorp Vault..."

# Waiting Vault Readiness
until curl -s http://vault:8200/v1/sys/health > /dev/null; do
  echo "⏳ Waiting for Vault to be ready..."
  sleep 5
done

# Initialization (in development mode)
export VAULT_ADDR='http://vault:8200'
export VAULT_TOKEN='root-token'

# Secret Creation for the application
vault secrets enable -path=secret kv-v2

# Secrets for database
vault kv put secret/techfactory/database \
  username="app_user" \
  password="$(openssl rand -base64 32)" \
  host="localhost" \
  port="5432" \
  database="app_production"

# Secrets for the API
vault kv put secret/techfactory/api \
  jwt_secret="$(openssl rand -base64 64)" \
  encryption_key="$(openssl rand -base64 32)" \
  admin_api_key="$(openssl rand -base64 48)"

# Secrets for external services
vault kv put secret/techfactory/external \
  smtp_password="$(openssl rand -base64 24)" \
  payment_gateway_key="pk_test_$(openssl rand -base64 24)" \
  monitoring_api_key="$(openssl rand -base64 32)"

# Access Policy
vault policy write app-reader - <<EOF
path "secret/data/techfactory/*" {
  capabilities = ["read"]
}
EOF

echo "✅ Vault initialized successfully!"
echo "📊 Secrets created:"
echo "  - Database credentials"
echo "  - API secrets"
echo "  - External services"