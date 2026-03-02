# Provider Vault pour AWS
provider "vault" {
  # Configuration via environment variables:
  # VAULT_ADDR, VAULT_TOKEN
  # Ou via AWS IAM authentication
}

# Données Vault
data "vault_generic_secret" "database" {
  path = "secret/techfactory/database"
}

data "vault_generic_secret" "api" {
  path = "secret/techfactory/api"
}

# Utilisation des secrets Vault
resource "aws_db_instance" "postgresql" {
  # ... autres configurations ...
  
  username = data.vault_generic_secret.database.data["username"]
  password = data.vault_generic_secret.database.data["password"]
}

# Outputs sécurisés
output "vault_secrets_available" {
  value       = true
  description = "Indicates if Vault secrets are accessible"
  sensitive   = false
}

output "vault_database_username" {
  value       = data.vault_generic_secret.database.data["username"]
  description = "Database username from Vault"
  sensitive   = true
}