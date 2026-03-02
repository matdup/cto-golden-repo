# Required Variables
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

# Azure Configuration
variable "region" {
  description = "Azure region"
  type        = string
  default     = "West Europe"
}

variable "instance_flavor" {
  description = "Virtual Machine size"
  type        = string
  default     = "Standard_B2s"
}

# Network
variable "private_subnet_cidr" {
  description = "CIDR for private subnet"
  type        = string
  default     = "10.0.1.0/24"
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
  default     = "10.0.0.0/16"
}

# Database
variable "database_flavor" {
  description = "Database SKU"
  type        = string
  default     = "B_Standard_B1ms"
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