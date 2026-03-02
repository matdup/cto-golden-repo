#!/usr/bin/env bash
# userdata.sh - Secured Initialisation Script for AWS

set -euo pipefail
exec > >(tee /var/log/user-data.log) 2>&1

echo "🛡️ Starting Server Initialization on AWS..."

# 🔐 Secured basic Configuration
export DEBIAN_FRONTEND=noninteractive
readonly SCRIPT_DIR="/opt/techfactory"
readonly DOCKER_COMPOSE_VERSION="2.24.0"

# 🏷️ Metadata
readonly DOMAIN_NAME="${domain_name:-example.com}"
readonly ADMIN_EMAIL="${admin_email:-admin@example.com}"
readonly MONITORING_ENABLED="${monitoring_enabled:-true}"

# 📦 System Update
echo "📦 Updating system packages..."
apt-get update -y
apt-get upgrade -y --auto-remove
apt-get install -y \
    curl \
    wget \
    gnupg \
    lsb-release \
    ca-certificates \
    apt-transport-https \
    software-properties-common \
    htop \
    ntp \
    fail2ban \
    ufw

# 🔧 Timezone Configuration
timedatectl set-timezone Europe/Paris

# 🔐 Firewall Configuration (UFW)
echo "🔐 Configuring firewall..."
ufw --force reset
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw allow 80/tcp
ufw allow 443/tcp
ufw allow 9100/tcp  # Node Exporter
ufw --force enable

# 🐳 Secured Docker Installation
echo "🐳 Installing Docker..."
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin

# 🔧 Secured Configuration Docker
mkdir -p /etc/docker
cat > /etc/docker/daemon.json << 'EOF'
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  },
  "userns-remap": "default",
  "live-restore": true,
  "icc": false,
  "userland-proxy": false
}
EOF

systemctl enable docker
systemctl start docker

# 🚀 Docker Compose Installation 
echo "🚀 Installing Docker Compose..."
curl -SL "https://github.com/docker/compose/releases/download/v${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# 📁 Application structure creation
echo "📁 Creating application structure..."
mkdir -p ${SCRIPT_DIR}/{app,config,logs,backups,scripts}

# 🐳 Application deployment with Docker Compose
cat > ${SCRIPT_DIR}/docker-compose.yml << EOF
version: '3.8'

services:
  app:
    image: nginx:alpine
    container_name: hello-nginx
    ports:
      - "80:80"
    restart: unless-stopped
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.app.rule=Host(\`${DOMAIN_NAME}\`)"
    healthcheck:
      test: ["CMD", "wget", "--no-verbose", "--tries=1", "--spider", "http://localhost:80/"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s

  node-exporter:
    image: prom/node-exporter:latest
    container_name: node-exporter
    command:
      - '--path.procfs=/host/proc'
      - '--path.rootfs=/rootfs'
      - '--path.sysfs=/host/sys'
      - '--collector.filesystem.mount-points-exclude=^/(sys|proc|dev|host|etc)(\\$|/)'
    ports:
      - "9100:9100"
    restart: unless-stopped
    volumes:
      - /proc:/host/proc:ro
      - /sys:/host/sys:ro
      - /:/rootfs:ro

EOF

# 🚀 Starting services
echo "🚀 Starting application stack..."
cd ${SCRIPT_DIR}
docker-compose up -d

# 📊 Monitoring Installation if activated
if [ "${MONITORING_ENABLED}" = "true" ]; then
    echo "📊 Setting up monitoring..."
    
    # Install CloudWatch Agent for AWS monitoring
    wget https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
    dpkg -i -E ./amazon-cloudwatch-agent.deb
    
    # Health Check Script personalized
    cat > /usr/local/bin/health-check.sh << 'EOF'
#!/bin/bash
set -e

# Docker Verification 
if ! systemctl is-active --quiet docker; then
    echo "CRITICAL: Docker service not running"
    exit 2
fi

# Containers Verification
cd /opt/techfactory
if ! docker-compose ps | grep -q "Up"; then
    echo "CRITICAL: Some containers are not running"
    exit 2
fi

# Application Verification
if ! curl -f http://localhost:80/ > /dev/null 2>&1; then
    echo "CRITICAL: Application not responding"
    exit 2
fi

echo "OK: All systems operational"
exit 0
EOF

    chmod +x /usr/local/bin/health-check.sh
fi

# 🔧 Logs rotation Configuration
cat > /etc/logrotate.d/docker-app << 'EOF'
/opt/techfactory/logs/*.log {
    daily
    rotate 7
    compress
    delaycompress
    copytruncate
    missingok
}
EOF

# 🕐 Save & Maintenance cron Configuration
(crontab -l 2>/dev/null; echo "0 2 * * * /usr/local/bin/health-check.sh") | crontab -
(crontab -l 2>/dev/null; echo "0 3 * * * docker system prune -f") | crontab -

# 🎉 Finalization
echo "🎉 initialization completed successfully!"
echo "📊 Application URL: http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)"
echo "🔍 Monitoring: http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4):9100/metrics"

# 📈 Deployment Metrics
DEPLOYMENT_TIME=$(date -Iseconds)
cat > ${SCRIPT_DIR}/deployment-info.json << EOF
{
  "deployment_time": "${DEPLOYMENT_TIME}",
  "infrastructure_version": "${infrastructure_version}",
  "domain_name": "${DOMAIN_NAME}",
  "monitoring_enabled": "${MONITORING_ENABLED}"
}
EOF

echo "✅ AWS Server is ready for production workload!"