#!/bin/bash
# deploy-infrastructure.sh - 10 minutes Deployment

set -euo pipefail

# ===============================================================
# 🏗️ TECHFACTORY - Multi-Cloud Infrastructure Deployment
# ---------------------------------------------------------------
# Works with the unified orchestration model:
# infra-template/terraform_cloud-abstraction/ → orchestrates aws, azure, or ovh
# ===============================================================

echo "🛡️ Starting Infrastructure Deployment..."

# 🔐 Prerequisites Validation
check_prerequisites() {
    echo "🔍 Checking prerequisites..."
    
    if ! command -v terraform &> /dev/null; then
        echo "❌ Terraform is not installed"
        exit 1
    fi
    
    # Check minimal cloud credentials
    if [ -z "${OVH_APPLICATION_KEY:-}" ] && [ -z "${AWS_ACCESS_KEY_ID:-}" ] && [ -z "${ARM_CLIENT_ID:-}" ]; then
        echo "❌ No cloud provider credentials detected."
        echo "Please export credentials for OVH, AWS, or Azure before running this script."
        exit 1
    fi
    
    echo "✅ All prerequisites met"
}

# 🏗️ infrastructure Deployment
deploy_infrastructure() {
    local project_id="$1"
    local provider="${2:-ovh}" # Default to OVH if not specified
    
    echo "🏗️ Deploying infrastructure for project: $project_id using provider: $provider"
    
    cd apps/infrastructure/terraform/terraform_cloud-abstraction/
    
    # Initialization
    echo "📦 Initializing Terraform..."
    terraform init -upgrade
    
    # Validation
    echo "🔍 Validating configuration..."
    terraform validate
    
    # Planification
    echo "📋 Creating execution plan..."
    terraform plan \
        -var="cloud_provider=$provider" \
        -var="ovh_project_id=$project_id" \
        -var="environment=staging" \
        -out=terraform.plan
        
    # Application
    echo "🚀 Applying infrastructure..."
    terraform apply -auto-approve terraform.plan
    
    # Outputs
    echo "📊 Deployment outputs:"
    terraform output
}

# 📊 Deployment Validation
validate_deployment() {
    echo "🔍 Validating deployment..."
    
    local app_url=$(terraform output -raw application_url 2>/dev/null || echo "")
    local provider=$(terraform output -raw cloud_provider 2>/dev/null || echo "unknown")

    if [ -z "$app_url" ]; then
        echo "❌ Could not retrieve application URL"
        exit 1
    fi

    echo "🌐 Testing application endpoint on $provider..."
    if curl -f -s -o /dev/null --connect-timeout 30 --retry 3 --retry-delay 10 "$app_url"; then
        echo "✅ Application is responding"
    else
        echo "⚠️ Application is deployed but not responding (check firewall, DNS or LB config)"
    fi
}

# 🎯 Main entry point
main() {
    local start_time=$(date +%s)
    
    echo "🛡️ Infrastructure Deployment Started"
    
    # Validation
    check_prerequisites
    
    if [ $# -lt 1 ]; then
        echo "Usage: $0 <project_id> [cloud_provider]"
        echo "Example: $0 1234567890abcdef ovh"
        exit 1
    fi

    local project_id="$1"
    local provider="${2:-ovh}"
    
    # Deployement
    deploy_infrastructure "$project_id" "$provider"
    
    # Validation
    validate_deployment
    
    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    
    echo "🎉 Deployment completed successfully in ${duration} seconds!"
    echo "🌐 Application URL: http://$(terraform output -raw application_url)"
}

main "$@"