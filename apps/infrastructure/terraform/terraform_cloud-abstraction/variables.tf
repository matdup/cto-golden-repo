# ============================================================
# 🎯 TECHFACTORY MULTI-CLOUD VARIABLES
# ============================================================

# 🌍 CLOUD SELECTION
variable "cloud_provider" {
  description = "Cloud provider to deploy infrastructure (ovh, aws, azure)"
  type        = string
  default     = "ovh"
}

# 🏢 CORE CONFIGURATION
variable "project_name" {
  description = "Project name for resource naming and tagging"
  type        = string
  default     = "techfactory"
}

variable "environment" {
  description = "Deployment environment (development, staging, production)"
  type        = string
  default     = "staging"
  
  validation {
    condition     = contains(["development", "staging", "production"], var.environment)
    error_message = "Environment must be 'development', 'staging', or 'production'."
  }
}

variable "infrastructure_version" {
  description = "Infrastructure version for tracking and rollback"
  type        = string
  default     = "1.0.0"
}

# 🌐 NETWORK CONFIGURATION
variable "region" {
  description = "Cloud region for deployment"
  type        = string
  default     = "default" # Will be overridden per cloud
}

variable "private_subnet_cidr" {
  description = "CIDR block for private subnet"
  type        = string
  default     = "10.42.0.0/24"
}

# 🔐 SECURITY CONFIGURATION
variable "ssh_allowed_cidr" {
  description = "CIDR blocks allowed for SSH access"
  type        = string
  default     = "0.0.0.0/0"
}

variable "monitoring_allowed_cidr" {
  description = "CIDR blocks allowed for monitoring access"
  type        = string
  default     = "10.42.0.0/24"
}

# 🖥️ COMPUTE CONFIGURATION
variable "instance_flavor" {
  description = "Virtual machine instance type/flavor"
  type        = string
  default     = "default" # Will be overridden per cloud
}

# 🗄️ DATABASE CONFIGURATION
variable "database_flavor" {
  description = "Database instance type/plan"
  type        = string
  default     = "default" # Will be overridden per cloud
}

# 📱 APPLICATION CONFIGURATION
variable "admin_email" {
  description = "Administrator email for alerts and notifications"
  type        = string
  default     = "admin@techfactory.com"
}

variable "domain_name" {
  description = "Domain name for the application"
  type        = string
  default     = "techfactory-app.com"
}

variable "docker_registry" {
  description = "Docker registry URL for container images"
  type        = string
  default     = "ghcr.io"
}

variable "enable_monitoring" {
  description = "Enable monitoring stack deployment"
  type        = bool
  default     = true
}

# ☁️ CLOUD-SPECIFIC VARIABLES
variable "ovh_project_id" {
  description = "OVH Cloud Project ID (required for OVH deployment)"
  type        = string
  default     = ""
  sensitive   = true
}

variable "vlan_id" {
  description = "VLAN ID for OVH private network"
  type        = number
  default     = 42
}