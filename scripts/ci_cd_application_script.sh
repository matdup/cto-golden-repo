#!/bin/bash
set -euo pipefail

# ===============================================================
# 🛡️ TECHFACTORY - CI/CD Installer
# ---------------------------------------------------------------
# This script installs the universal CI/CD and Security workflows
# across all template repositories.
# ===============================================================

# 🔐 Configuration
ORG_NAME="TECHFACTORY"
CI=".github/workflows/ci.yml"
SECURITY=".github/workflows/security.yml"
README=".github/README.md"

echo "🚀 Starting global CI/CD deployment for $ORG_NAME repositories..."
echo "==============================================================="

for repo in infra-template backend-template frontend-template docs-template monitoring-template; do
    echo "🔧 Processing $repo..."
    
    # 🧹 Cleanup previous tmp repo
    rm -rf /tmp/$repo

    # Repo Clone 
    gh repo clone $ORG_NAME/$repo /tmp/$repo
    
    # Create CI/CD structure
    mkdir -p /tmp/$repo/.github/workflows
    
    # Copy pipeline
    cp "$CI" /tmp/$repo/.github/workflows/ci.yml
    cp "$SECURITY" "/tmp/$repo/.github/workflows/security.yml"
    cp "$README" /tmp/$repo/.github/README.md

    # Commit and push
    cd /tmp/$repo
    git add .
    git commit -m "🛡️ Install CI/CD pipeline"
    git push origin main
    
    echo "✅ $repo secured with CI/CD"

    # Cleanup
    cd /
    rm -rf /tmp/$repo
done

echo "🎉 All repositories now protected by CI/CD!"