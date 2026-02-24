# ============================================================
# 🏢 TECHFACTORY MULTI-CLOUD ORCHESTRATION
# ============================================================

terraform {
  required_version = ">= 1.6.0"
  
  required_providers {
    # Providers seront configurés dynamiquement selon le cloud choisi
  }

  # Backend sera configuré dynamiquement selon le cloud
}

# 🌍 CLOUD SELECTION
variable "cloud_provider" {
  description = "Cloud provider to deploy infrastructure (ovh, aws, azure)"
  type        = string
  default     = "ovh"
  
  validation {
    condition     = contains(["ovh", "aws", "azure"], var.cloud_provider)
    error_message = "Cloud provider must be 'ovh', 'aws', or 'azure'."
  }
}

# 🔧 DYNAMIC PROVIDER CONFIGURATION
provider "ovh" {
  count = var.cloud_provider == "ovh" ? 1 : 0
  endpoint = "ovh-eu"
  # OVH_APPLICATION_KEY, OVH_APPLICATION_SECRET, OVH_CONSUMER_KEY via env vars
}

provider "aws" {
  count = var.cloud_provider == "aws" ? 1 : 0
  region = var.region
  # AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY via env vars
}

provider "azurerm" {
  count = var.cloud_provider == "azure" ? 1 : 0
  features {}
  # ARM_CLIENT_ID, ARM_CLIENT_SECRET, ARM_SUBSCRIPTION_ID, ARM_TENANT_ID via env vars
}

# 🏷️ GLOBAL CONFIGURATION
locals {
  name_prefix = "${var.project_name}-${var.environment}"
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
    Repository  = "project-template/infra-template"
    Version     = var.infrastructure_version
    Cloud       = var.cloud_provider
  }
}

# 🎯 DYNAMIC INFRASTRUCTURE MODULE
module "infrastructure" {
  source = "./terraform_cloud-abstraction/${var.cloud_provider}"
  
  # ========== CORE VARIABLES ==========
  project_name          = var.project_name
  environment           = var.environment
  infrastructure_version = var.infrastructure_version
  
  # ========== NETWORK VARIABLES ==========
  region               = var.region
  private_subnet_cidr  = var.private_subnet_cidr
  
  # ========== SECURITY VARIABLES ==========
  ssh_allowed_cidr     = var.ssh_allowed_cidr
  monitoring_allowed_cidr = var.monitoring_allowed_cidr
  
  # ========== COMPUTE VARIABLES ==========
  instance_flavor      = var.instance_flavor
  
  # ========== DATABASE VARIABLES ==========
  database_flavor      = var.database_flavor
  
  # ========== APPLICATION VARIABLES ==========
  admin_email          = var.admin_email
  domain_name          = var.domain_name
  docker_registry      = var.docker_registry
  enable_monitoring    = var.enable_monitoring
  
  # ========== CLOUD-SPECIFIC VARIABLES ==========
  ovh_project_id       = var.ovh_project_id
  vlan_id              = var.vlan_id
}

# 🗂️ UNIVERSAL OUTPUTS
output "application_url" {
  description = "Application access URL"
  value       = module.infrastructure.application_url
}

output "database_host" {
  description = "Database hostname"
  value       = module.infrastructure.database_host
  sensitive   = false
}

output "database_name" {
  description = "Database name"
  value       = module.infrastructure.database_name
}

output "instance_private_ip" {
  description = "Application instance private IP"
  value       = module.infrastructure.instance_private_ip
}

output "infrastructure_version" {
  description = "Deployed infrastructure version"
  value       = module.infrastructure.infrastructure_version
}

output "cloud_provider" {
  description = "Selected cloud provider"
  value       = var.cloud_provider
}

output "deployment_summary" {
  description = "Infrastructure deployment summary"
  value = {
    cloud_provider    = var.cloud_provider
    environment       = var.environment
    project_name      = var.project_name
    application_url   = module.infrastructure.application_url
    database_host     = module.infrastructure.database_host
    deployed_at       = timestamp()
  }
}