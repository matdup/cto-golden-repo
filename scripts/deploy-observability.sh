#!/bin/bash
# deploy-observability.sh - 10 minutes Deployment

set -euo pipefail

echo "🛡️ Deploying Observability Stack..."

# 🔐 Prerequisites Validation
validate_prerequisites() {
    echo "🔍 Validating prerequisites..."
    
    if ! command -v docker &> /dev/null; then
        echo "❌ Docker is not installed"
        exit 1
    fi
    
    if ! command -v docker-compose &> /dev/null; then
        echo "❌ Docker Compose is not installed"
        exit 1
    fi
    
    if ! docker info &> /dev/null; then
        echo "❌ Docker daemon is not running"
        exit 1
    fi
    
    echo "✅ All prerequisites met"
}

# 🏗️ Monitoring Stack Deployment
deploy_monitoring_stack() {
    echo "🏗️ Deploying monitoring stack..."
    
    cd platform/monitoring
    
    # Environnement Configuration 
    if [ ! -f .env ]; then
        cp .env.example .env
        echo "⚠️  Please edit .env file with your configuration"
        echo "   Required: GRAFANA_ADMIN_PASSWORD, DOMAIN_NAME"
        exit 1
    fi
    
    # Start services
    docker-compose -f docker-compose.monitoring.yml up -d
    
    # Wait services readiness
    echo "⏳ Waiting for services to be ready..."
    sleep 30
    
    # Statut Verification
    docker-compose -f docker-compose.monitoring.yml ps
}

# 🔐 Vault Initialization
initialize_vault() {
    echo "🔐 Initializing Vault..."
    
    cd templates/monitoring-template
    
    # Starting Vault
    docker-compose -f docker-compose.vault.yml up -d
    
    # Wait Vault readiness
    local timeout=60
    local counter=0

    until curl -f -s http://localhost:8200/v1/sys/health > /dev/null; do
        echo "⏳ Waiting for Vault to be ready... ($counter/$timeout seconds)"
        sleep 5
        counter=$((counter + 5))
        if [ $counter -ge $timeout ]; then
            echo "❌ Vault failed to start within $timeout seconds"
            exit 1
        fi
    done
    
    # Initialisation
    docker-compose -f docker-compose.vault.yml exec vault /bin/sh /policies/init-vault.sh
    
    echo "✅ Vault initialized successfully"
}

# 📊 Configuration des dashboards
setup_dashboards() {
    echo "📊 Setting up dashboards..."
    
    # Attente que Grafana soit prêt
    until curl -s http://localhost:3000/api/health > /dev/null; do
        echo "⏳ Waiting for Grafana to be ready..."
        sleep 5
    done
    
    echo "✅ Dashboards are being provisioned automatically"
}

# 🧪 Deployment Validation 
validate_deployment() {
    echo "🔍 Validating deployment..."
    
    # Prometheus Test 
    if curl -f -s --retry 3 --retry-delay 5 --max-time 10 http://localhost:9090/-/healthy > /dev/null; then
        echo "✅ Prometheus is healthy"
    else
        echo "❌ Prometheus is not healthy after 3 attempts"
        exit 1
    fi
    
    # Grafana Test 
    if curl -f -s --retry 3 --retry-delay 5 --max-time 10 http://localhost:3000/api/health > /dev/null; then
        echo "✅ Grafana is healthy"
    else
        echo "❌ Grafana is not healthy after 3 attempts"
        exit 1
    fi
    
    # Loki Test 
    if curl -f -s --retry 2 --retry-delay 5 --max-time 10 http://localhost:3100/ready > /dev/null; then
        echo "✅ Loki is healthy"
    else
        echo "❌ Loki is not healthy after 2 attempts"
        exit 1
    fi
    
    echo "🎉 All services are operational!"
}

# 📋 Affichage des informations d'accès
display_access_info() {
    echo ""
    echo "🛡️ Observability Stack Deployment Complete!"
    echo ""
    echo "📊 Access URLs:"
    echo "   Grafana:      http://localhost:3000"
    echo "   Prometheus:   http://localhost:9090"
    echo "   Alertmanager: http://localhost:9093"
    echo "   Vault UI:     http://localhost:8300"
    echo "   Uptime Kuma:  http://localhost:3001"
    echo "   Loki:         http://localhost:3100"
    echo ""
    echo "🔐 Default Credentials:"
    echo "   Grafana: admin / ${grafana_password}"
    echo "   Vault:   root / root-token"
    echo ""
    echo "🚨 Next Steps:"
    echo "   1. Change default passwords in Grafana and Vault"
    echo "   2. Configure SSL/TLS for production"
    echo "   3. Set up alert notifications"
    echo "   4. Add your application targets to Prometheus"
    echo "   5. Review dashboards in Grafana"
    echo ""
}

# 🎯 Main entry Point
main() {
    local start_time=$(date +%s)
    
    echo "🛡️ Starting Observability Deployment"
    
    # Validation
    validate_prerequisites
    
    # Deployment
    deploy_monitoring_stack
    initialize_vault
    setup_dashboards
    
    # Validation
    validate_deployment
    
    # Informations
    display_access_info
    
    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    
    echo "✅ Deployment completed in ${duration} seconds"
}

main "$@"