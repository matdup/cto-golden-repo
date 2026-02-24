# terraform/main.tf - AZURE VERSION
terraform {
  required_version = ">= 1.6.0"
  
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~> 3.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "techfactory-tfstate"
    storage_account_name = "techfactorytfstate"
    container_name       = "tfstate"
    key                  = "infrastructure.terraform.tfstate"
  }
}

# 🔐 Azure Provider
provider "azurerm" {
  features {}
  
  # Use environment variables:
  # ARM_CLIENT_ID, ARM_CLIENT_SECRET, ARM_SUBSCRIPTION_ID, ARM_TENANT_ID
  # Or Managed Service Identity
}

# 📦 Resource Group
resource "azurerm_resource_group" "main" {
  name     = "rg-${var.project_name}-${var.environment}"
  location = var.region

  tags = local.common_tags
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

# 🌐 Network - Secured VNet
resource "azurerm_virtual_network" "main" {
  name                = "vnet-${local.name_prefix}"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  tags = local.common_tags
}

resource "azurerm_subnet" "private" {
  name                 = "snet-${local.name_prefix}-private"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.private_subnet_cidr]
}

resource "azurerm_public_ip" "lb" {
  name                = "pip-${local.name_prefix}-lb"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = local.common_tags
}

resource "azurerm_network_security_group" "main" {
  name                = "nsg-${local.name_prefix}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.ssh_allowed_cidr
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "0.0.0.0/0"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTPS"
    priority                   = 1003
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "0.0.0.0/0"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "NodeExporter"
    priority                   = 1004
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "9100"
    source_address_prefix      = var.monitoring_allowed_cidr
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowAllOutbound"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = local.common_tags
}

resource "azurerm_subnet_network_security_group_association" "main" {
  subnet_id                 = azurerm_subnet.private.id
  network_security_group_id = azurerm_network_security_group.main.id
}

# 🖥️ APPLICATIVE INSTANCE - Hardened
resource "azurerm_linux_virtual_machine" "app_server" {
  name                = "vm-${local.name_prefix}-app"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  size                = var.instance_flavor
  admin_username      = "azureuser"
  network_interface_ids = [
    azurerm_network_interface.app_server.id,
  ]

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("~/.ssh/id_rsa.pub") # Update with your public key path
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    disk_size_gb         = 30
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  custom_data = base64encode(templatefile("${path.module}/userdata.sh", {
    domain_name        = var.domain_name
    admin_email        = var.admin_email
    docker_registry    = var.docker_registry
    monitoring_enabled = var.enable_monitoring
    infrastructure_version = var.infrastructure_version
  }))

  tags = local.common_tags
}

resource "azurerm_network_interface" "app_server" {
  name                = "nic-${local.name_prefix}-app"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.private.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = local.common_tags
}

# 🗄️ MANAGED DATABASE - Production Ready
resource "azurerm_postgresql_flexible_server" "main" {
  name                   = "psql-${local.name_prefix}"
  location               = azurerm_resource_group.main.location
  resource_group_name    = azurerm_resource_group.main.name
  version                = "16"
  administrator_login    = "app_user"
  administrator_password = random_password.db_password.result
  storage_mb             = 32768
  sku_name               = var.database_flavor

  backup_retention_days        = 7
  geo_redundant_backup_enabled = false

  tags = local.common_tags
}

resource "azurerm_postgresql_flexible_server_database" "app_db" {
  name      = "app_production"
  server_id = azurerm_postgresql_flexible_server.main.id
  charset   = "UTF8"
  collation = "en_US.utf8"
}

resource "random_password" "db_password" {
  length  = 16
  special = false
}

# ⚖️ LOAD BALANCER - HA Configuration
resource "azurerm_lb" "app_lb" {
  name                = "lb-${local.name_prefix}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.lb.id
  }

  tags = local.common_tags
}

resource "azurerm_lb_backend_address_pool" "app_pool" {
  loadbalancer_id = azurerm_lb.app_lb.id
  name            = "BackEndAddressPool"
}

resource "azurerm_lb_probe" "http" {
  loadbalancer_id     = azurerm_lb.app_lb.id
  name                = "http-running-probe"
  port                = 80
  protocol            = "Http"
  request_path        = "/health"
  interval_in_seconds = 30
}

resource "azurerm_lb_rule" "http" {
  loadbalancer_id                = azurerm_lb.app_lb.id
  name                           = "HTTP"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "PublicIPAddress"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.app_pool.id]
  probe_id                       = azurerm_lb_probe.http.id
}

resource "azurerm_network_interface_backend_address_pool_association" "app_server" {
  network_interface_id    = azurerm_network_interface.app_server.id
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.app_pool.id
}

# 🔍 MONITORING & OBSERVABILITY
resource "azurerm_monitor_action_group" "main" {
  name                = "ag-${local.name_prefix}"
  resource_group_name = azurerm_resource_group.main.name
  short_name          = "techfactory"

  email_receiver {
    name          = "sendToAdmin"
    email_address = var.admin_email
  }

  tags = local.common_tags
}

resource "azurerm_monitor_metric_alert" "cpu_high" {
  name                = "alert-${local.name_prefix}-cpu-high"
  resource_group_name = azurerm_resource_group.main.name
  scopes              = [azurerm_linux_virtual_machine.app_server.id]
  description         = "Action will be triggered when CPU utilization is high"

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachines"
    metric_name      = "Percentage CPU"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }

  window_size        = "PT5M"
  frequency          = "PT1M"

  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }

  tags = local.common_tags
}

resource "azurerm_monitor_metric_alert" "memory_high" {
  name                = "alert-${local.name_prefix}-memory-high"
  resource_group_name = azurerm_resource_group.main.name
  scopes              = [azurerm_linux_virtual_machine.app_server.id]
  description         = "Action will be triggered when memory utilization is high"

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachines"
    metric_name      = "Available Memory Bytes"
    aggregation      = "Average"
    operator         = "LessThan"
    threshold        = 1073741824 # 1GB
  }

  window_size        = "PT5M"
  frequency          = "PT1M"

  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }

  tags = local.common_tags
}

# 🗂️ Secured outputs
output "load_balancer_ip" {
  value       = azurerm_public_ip.lb.ip_address
  description = "Load Balancer Public IP"
  sensitive   = false
}

output "application_url" {
  value       = "http://${azurerm_public_ip.lb.ip_address}"
  description = "Application access URL"
}

output "database_host" {
  value       = azurerm_postgresql_flexible_server.main.fqdn
  description = "Database Hostname"
  sensitive   = false
}

output "database_port" {
  value       = 5432
  description = "Database Port"
}

output "database_name" {
  value       = azurerm_postgresql_flexible_server_database.app_db.name
  description = "Database name"
}

output "database_username" {
  value       = azurerm_postgresql_flexible_server.main.administrator_login
  description = "Database username"
}

output "database_password" {
  value       = random_password.db_password.result
  description = "Database Password"
  sensitive   = true
}

output "instance_private_ip" {
  value       = azurerm_network_interface.app_server.private_ip_address
  description = "Application instance private IP"
  sensitive   = false
}

output "resource_group_name" {
  value       = azurerm_resource_group.main.name
  description = "Resource Group Name"
  sensitive   = false
}

output "infrastructure_version" {
  value       = var.infrastructure_version
  description = "Deployed infrastructure version"
}