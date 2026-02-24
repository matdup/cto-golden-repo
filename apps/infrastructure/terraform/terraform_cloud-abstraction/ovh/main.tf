# terraform/main.tf
terraform {
  required_version = ">= 1.6.0"
  
  required_providers {
    ovh = {
      source  = "ovh/ovh"
      version = "~> 0.32.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4.0"
    }
  }

  backend "s3" {
    # Secured Backend for the state - To be configured
    bucket = "techfactory-tfstate"
    key    = "infrastructure/terraform.tfstate"
    region = "gra" # Region OVH
    # endpoint = "https://s3.gra.io.cloud.ovh.net"
    # skip_credentials_validation = true
    # skip_region_validation = true
  }
}

# 🔐 OVH Provider with secured authentification
provider "ovh" {
  endpoint = "ovh-eu"
  
  # Use environnement variables:
  # OVH_APPLICATION_KEY, OVH_APPLICATION_SECRET, OVH_CONSUMER_KEY
  # OU via GitHub Secrets in CI/CD
}

# 📦 OVH project Data
data "ovh_cloud_project" "main" {
  service_name = var.ovh_project_id
}

# 🏷️ Tags Standardisation
locals {
  name_prefix = "${var.project_name}-${var.environment}"
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
    Repository  = "project-template/infra-template"
    Version     = var.infrastructure_version
  }
}

# 🌐 Network - Secured VPC
resource "ovh_cloud_project_network_private" "vpc" {
  service_name = data.ovh_cloud_project.main.service_name
  name         = "${local.name_prefix}-vpc"
  vlan_id      = var.vlan_id
  regions      = [var.region]

  tags = local.common_tags
}

resource "ovh_cloud_project_network_private_subnet" "subnet" {
  service_name = data.ovh_cloud_project.main.service_name
  network_id   = ovh_cloud_project_network_private.vpc.id
  region       = var.region
  start        = cidrhost(var.private_subnet_cidr, 10)
  end          = cidrhost(var.private_subnet_cidr, 200)
  network      = var.private_subnet_cidr
  dhcp         = true
  no_gateway   = false

  depends_on = [ovh_cloud_project_network_private.vpc]
}

# 🔥 SECURITY GROUPE  - Zero Trust
resource "ovh_cloud_project_network_security_group" "main" {
  service_name = data.ovh_cloud_project.main.service_name
  name         = "${local.name_prefix}-sg"
  
  rules {
    protocol  = "TCP"
    port      = 22
    source    = var.ssh_allowed_cidr
    direction = "in"
  }
  
  rules {
    protocol  = "TCP"
    port      = 80
    source    = "0.0.0.0/0"
    direction = "in"
  }
  
  rules {
    protocol  = "TCP"
    port      = 443
    source    = "0.0.0.0/0"
    direction = "in"
  }
  
  rules {
    protocol  = "TCP"
    port      = 9100  # Node Exporter
    source    = var.monitoring_allowed_cidr
    direction = "in"
  }
  
  # Egress rules
  rules {
    protocol  = "ANY"
    source    = "0.0.0.0/0"
    direction = "out"
  }

  tags = local.common_tags
}

# 🖥️ APPLICATIVE INSTANCE  - Hardened
resource "ovh_cloud_project_instance" "app_server" {
  service_name = data.ovh_cloud_project.main.service_name
  name         = "${local.name_prefix}-app"
  image_id     = data.ovh_cloud_project_capabilities_container_registry_filter.ubuntu22.image_id
  flavor_name  = var.instance_flavor
  region       = var.region
  
  # Secured Network Configuration
  network {
    network_id = ovh_cloud_project_network_private.vpc.id
    ip         = cidrhost(var.private_subnet_cidr, 50)
    dhcp       = false
  }
  
  # Secured initialization Script
  user_data = templatefile("${path.module}/userdata.sh", {
    domain_name        = var.domain_name
    admin_email        = var.admin_email
    docker_registry    = var.docker_registry
    monitoring_enabled = var.enable_monitoring
  })
  
  # Secured Metadata
  metadata = {
    deployment-version = var.infrastructure_version
    hardened-os       = "true"
    backup-enabled    = "true"
  }

  tags = local.common_tags

  depends_on = [
    ovh_cloud_project_network_private_subnet.subnet,
  ]
}

# 🗄️ MANAGED DATABASE - Production Ready
resource "ovh_cloud_project_database" "postgresql" {
  service_name = data.ovh_cloud_project.main.service_name
  engine       = "postgresql"
  version      = "16"
  plan         = var.database_plan
  nodes {
    region = var.region
  }
  flavor = var.database_flavor
  
  # Secured Configuration
  ip_restrictions = [var.private_subnet_cidr]
  backup_time     = "04:00"
  
  tags = local.common_tags
}

resource "ovh_cloud_project_database_postgresql_user" "app_user" {
  service_name = ovh_cloud_project_database.postgresql.service_name
  cluster_id   = ovh_cloud_project_database.postgresql.id
  name         = "app_user"
  
  # Password is secured and generated automatically
}

resource "ovh_cloud_project_database_postgresql_database" "app_db" {
  service_name = ovh_cloud_project_database.postgresql.service_name
  cluster_id   = ovh_cloud_project_database.postgresql.id
  name         = "app_production"
}

# ⚖️ LOAD BALANCER - HA Configuration
resource "ovh_cloud_project_loadbalancer" "app_lb" {
  service_name = data.ovh_cloud_project.main.service_name
  name         = "${local.name_prefix}-lb"
  region       = var.region
  
  # High disponibility Configuration
  configuration {
    version = "v2"
  }

  tags = local.common_tags
}

resource "ovh_cloud_project_loadbalancer_frontend" "http" {
  service_name    = ovh_cloud_project_loadbalancer.app_lb.service_name
  loadbalancer_id = ovh_cloud_project_loadbalancer.app_lb.id
  name            = "http-frontend"
  protocol        = "HTTP"
  port            = "80"
  default_backend_id = ovh_cloud_project_loadbalancer_backend.app_backend.id
}

resource "ovh_cloud_project_loadbalancer_backend" "app_backend" {
  service_name    = ovh_cloud_project_loadbalancer.app_lb.service_name
  loadbalancer_id = ovh_cloud_project_loadbalancer.app_lb.id
  name            = "app-backend"
  protocol        = "HTTP"
  port            = 80
  balance         = "roundrobin"
  
  # Health checks
  probe {
    type     = "HTTP"
    port     = 80
    url      = "/health"
    method   = "GET"
    interval = 30
  }
}

resource "ovh_cloud_project_loadbalancer_server" "app_server" {
  service_name    = ovh_cloud_project_loadbalancer.app_lb.service_name
  loadbalancer_id = ovh_cloud_project_loadbalancer.app_lb.id
  backend_id      = ovh_cloud_project_loadbalancer_backend.app_backend.id
  name            = ovh_cloud_project_instance.app_server.name
  address         = ovh_cloud_project_instance.app_server.ip_addresses[0].ip
  port            = 80
  weight          = 100
}

# 🔍 MONITORING & OBSERVABILITY
resource "ovh_cloud_project_alerting" "infra_alerts" {
  service_name = data.ovh_cloud_project.main.service_name
  
  # CPU Alerts 
  delay    = 300
  email    = var.admin_email
  monthly_threshold = 80
  
  # Thresholds alert
  rules {
    metric_name = "cpu_used_percent"
    operator    = ">"
    threshold   = 80
  }
  
  rules {
    metric_name = "mem_used_percent" 
    operator    = ">"
    threshold   = 85
  }
}

# 📊 Image data et flavors
data "ovh_cloud_project_capabilities_container_registry_filter" "ubuntu22" {
  service_name = data.ovh_cloud_project.main.service_name
  plan_name    = "SMALL"
  region       = var.region
}

# 🗂️ Secured outputs
output "load_balancer_ip" {
  value       = ovh_cloud_project_loadbalancer.app_lb.ipv4
  description = "Load Balancer IP publique"
  sensitive   = false
}

output "application_url" {
  value       = "http://${ovh_cloud_project_loadbalancer.app_lb.ipv4}"
  description = "Application access URL"
}

output "database_host" {
  value       = ovh_cloud_project_database.postgresql.endpoints[0].domain
  description = "Database Hostname"
  sensitive   = false
}

output "database_port" {
  value       = ovh_cloud_project_database.postgresql.endpoints[0].port
  description = "Database Port"
}

output "database_name" {
  value       = ovh_cloud_project_database_postgresql_database.app_db.name
  description = "Database name"
}

output "database_username" {
  value       = ovh_cloud_project_database_postgresql_user.app_user.name
  description = "Database username"
}

output "database_password" {
  value       = ovh_cloud_project_database_postgresql_user.app_user.password
  description = "Database Password"
  sensitive   = true
}

output "instance_private_ip" {
  value       = ovh_cloud_project_instance.app_server.ip_addresses[0].ip
  description = "Applicativ instance private IP"
  sensitive   = false
}

output "infrastructure_version" {
  value       = var.infrastructure_version
  description = "Deployed infrastructure"
}