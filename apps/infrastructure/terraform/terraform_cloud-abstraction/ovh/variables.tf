# Required Variables
variable "ovh_project_id" {
  description = "OVH Cloud Project ID"
  type        = string
  sensitive   = true
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "techfactory"
}

variable "environment" {
  description = "Environment (development, staging, production)"
  type        = string
  default     = "staging"
}

# OVH Configuration
variable "region" {
  description = "OVH region"
  type        = string
  default     = "GRA"
}

variable "instance_flavor" {
  description = "Instance flavor type"
  type        = string
  default     = "d2-2"
}

# Network
variable "vlan_id" {
  description = "VLAN ID for private network"
  type        = number
  default     = 42
}

variable "private_subnet_cidr" {
  description = "CIDR for private subnet"
  type        = string
  default     = "10.42.0.0/24"
}

# Security
variable "ssh_allowed_cidr" {
  description = "CIDR blocks allowed for SSH access"
  type        = string
  default     = "0.0.0.0/0"
}

variable "monitoring_allowed_cidr" {
  description = "CIDR blocks allowed for monitoring"
  type        = string
  default     = "10.42.0.0/24"
}

# Database
variable "database_plan" {
  description = "Database service plan"
  type        = string
  default     = "essential"
}

variable "database_flavor" {
  description = "Database flavor"
  type        = string
  default     = "db1-4"
}

# Application
variable "infrastructure_version" {
  description = "Infrastructure version"
  type        = string
  default     = "1.0.0"
}

variable "admin_email" {
  description = "Admin email for alerts"
  type        = string
  default     = "admin@example.com"
}

variable "domain_name" {
  description = "Domain name for application"
  type        = string
  default     = "example.com"
}

variable "docker_registry" {
  description = "Docker registry URL"
  type        = string
  default     = "ghcr.io"
}

variable "enable_monitoring" {
  description = "Enable monitoring stack"
  type        = bool
  default     = true
}