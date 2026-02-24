# terraform/main.tf - AWS VERSION
terraform {
  required_version = ">= 1.6.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
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

  backend "s3" {
    bucket = "techfactory-tfstate"
    key    = "infrastructure/terraform.tfstate"
    region = "eu-west-3"
  }
}

# 🔐 AWS Provider
provider "aws" {
  region = var.region
  
  # Use environment variables:
  # AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY
  # Or IAM Role for EC2/ECS
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
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-vpc"
  })
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = "${var.region}a"

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-private-subnet"
  })
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-igw"
  })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-public-rt"
  })
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.public.id
}

# 🔥 SECURITY GROUP - Zero Trust
resource "aws_security_group" "main" {
  name        = "${local.name_prefix}-sg"
  description = "Security group for application"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_allowed_cidr]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Node Exporter"
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = [var.monitoring_allowed_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.common_tags
}

# 🖥️ APPLICATIVE INSTANCE - Hardened
resource "aws_instance" "app_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_flavor
  subnet_id     = aws_subnet.private.id
  key_name      = aws_key_pair.deployer.key_name

  vpc_security_group_ids = [aws_security_group.main.id]
  associate_public_ip_address = true

  user_data = templatefile("${path.module}/userdata.sh", {
    domain_name        = var.domain_name
    admin_email        = var.admin_email
    docker_registry    = var.docker_registry
    monitoring_enabled = var.enable_monitoring
    infrastructure_version = var.infrastructure_version
  })

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
    encrypted   = true
  }

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-app"
  })

  depends_on = [aws_internet_gateway.main]
}

# SSH Key Pair
resource "aws_key_pair" "deployer" {
  key_name   = "${local.name_prefix}-key"
  public_key = file("~/.ssh/id_rsa.pub") # Update with your public key path

  tags = local.common_tags
}

# 🗄️ MANAGED DATABASE - Production Ready
resource "aws_db_instance" "postgresql" {
  identifier     = "${local.name_prefix}-postgres"
  engine         = "postgresql"
  engine_version = "16"
  instance_class = var.database_flavor
  allocated_storage = 20

  db_name  = "app_production"
  username = "app_user"
  password = random_password.db_password.result

  vpc_security_group_ids = [aws_security_group.main.id]
  db_subnet_group_name   = aws_db_subnet_group.main.name

  backup_retention_period = 7
  backup_window           = "04:00-05:00"
  maintenance_window      = "mon:05:00-mon:06:00"

  skip_final_snapshot = true
  deletion_protection = false

  tags = local.common_tags
}

resource "aws_db_subnet_group" "main" {
  name       = "${local.name_prefix}-db-subnet-group"
  subnet_ids = [aws_subnet.private.id]

  tags = local.common_tags
}

resource "random_password" "db_password" {
  length  = 16
  special = false
}

# ⚖️ LOAD BALANCER - HA Configuration
resource "aws_lb" "app_lb" {
  name               = "${local.name_prefix}-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.main.id]
  subnets            = [aws_subnet.private.id]

  enable_deletion_protection = false

  tags = local.common_tags
}

resource "aws_lb_target_group" "app_tg" {
  name     = "${local.name_prefix}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    enabled             = true
    interval            = 30
    path                = "/health"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = local.common_tags
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}

resource "aws_lb_target_group_attachment" "app_server" {
  target_group_arn = aws_lb_target_group.app_tg.arn
  target_id        = aws_instance.app_server.id
  port             = 80
}

# 🔍 MONITORING & OBSERVABILITY
resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "${local.name_prefix}-cpu-utilization-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"

  dimensions = {
    InstanceId = aws_instance.app_server.id
  }

  alarm_description = "This metric monitors EC2 CPU utilization"
  alarm_actions     = [] # Add SNS topic for notifications

  tags = local.common_tags
}

resource "aws_cloudwatch_metric_alarm" "memory_high" {
  alarm_name          = "${local.name_prefix}-memory-utilization-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "mem_used_percent"
  namespace           = "CWAgent"
  period              = "300"
  statistic           = "Average"
  threshold           = "85"

  dimensions = {
    InstanceId = aws_instance.app_server.id
  }

  alarm_description = "This metric monitors EC2 memory utilization"
  alarm_actions     = []

  tags = local.common_tags
}

# 📊 AMI Data
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# 🗂️ Secured outputs
output "load_balancer_dns" {
  value       = aws_lb.app_lb.dns_name
  description = "Load Balancer DNS Name"
  sensitive   = false
}

output "application_url" {
  value       = "http://${aws_lb.app_lb.dns_name}"
  description = "Application access URL"
}

output "database_host" {
  value       = aws_db_instance.postgresql.address
  description = "Database Hostname"
  sensitive   = false
}

output "database_port" {
  value       = aws_db_instance.postgresql.port
  description = "Database Port"
}

output "database_name" {
  value       = aws_db_instance.postgresql.db_name
  description = "Database name"
}

output "database_username" {
  value       = aws_db_instance.postgresql.username
  description = "Database username"
}

output "database_password" {
  value       = random_password.db_password.result
  description = "Database Password"
  sensitive   = true
}

output "instance_private_ip" {
  value       = aws_instance.app_server.private_ip
  description = "Application instance private IP"
  sensitive   = false
}

output "instance_public_ip" {
  value       = aws_instance.app_server.public_ip
  description = "Application instance public IP"
  sensitive   = false
}

output "infrastructure_version" {
  value       = var.infrastructure_version
  description = "Deployed infrastructure version"
}