#!/usr/bin/env bash
set -euo pipefail

log() { printf "%s %s\n" "$1" "$2" >&2; }
die() { log "❌" "$1"; exit "${2:-1}"; }
require_cmd() { command -v "$1" >/dev/null 2>&1 || die "Missing dependency: $1" 3; }

usage() {
  cat <<'EOF'
Usage:
  deploy-infrastructure.sh --project-id <id> [--provider ovh|aws|azure] [--env staging|prod|dev]
                         [--plan-only | --apply --yes] [--dir <tf_dir>]

Defaults:
  provider  = ovh
  env       = staging
  dir       = apps/infrastructure/terraform/terraform_cloud-abstraction
  mode      = plan-only

Safety:
  - apply requires --apply --yes
  - blocks any destroy actions detected in plan

Required env (provider-dependent):
  OVH: OVH_APPLICATION_KEY OVH_APPLICATION_SECRET OVH_CONSUMER_KEY
  AWS: AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY
  AZ:  ARM_CLIENT_ID ARM_CLIENT_SECRET ARM_SUBSCRIPTION_ID ARM_TENANT_ID
EOF
}

require_cmd terraform
require_cmd python

PROJECT_ID=""
PROVIDER="ovh"
ENVIRONMENT="staging"
TF_DIR="apps/infrastructure/terraform/terraform_cloud-abstraction"
MODE="plan"
CONFIRM=false

while [ $# -gt 0 ]; do
  case "$1" in
    --project-id) PROJECT_ID="${2:-}"; shift 2 ;;
    --provider) PROVIDER="${2:-}"; shift 2 ;;
    --env) ENVIRONMENT="${2:-}"; shift 2 ;;
    --dir) TF_DIR="${2:-}"; shift 2 ;;
    --plan-only) MODE="plan"; shift ;;
    --apply) MODE="apply"; shift ;;
    --yes) CONFIRM=true; shift ;;
    -h|--help) usage; exit 0 ;;
    *) die "Unknown option: $1 (use --help)" 2 ;;
  esac
done

[ -n "${PROJECT_ID}" ] || die "Missing --project-id" 2
[ -d "${TF_DIR}" ] || die "Terraform dir not found: ${TF_DIR}" 2

if [ "${MODE}" = "apply" ] && [ "${CONFIRM}" != "true" ]; then
  die "Blocked: apply requires --yes" 5
fi

log "ℹ️" "Terraform dir: ${TF_DIR}"
log "ℹ️" "Deploy: provider=${PROVIDER} env=${ENVIRONMENT} project_id=${PROJECT_ID} mode=${MODE}"

cd "${TF_DIR}"

log "ℹ️" "terraform init"
terraform init -upgrade

log "ℹ️" "terraform validate"
terraform validate

log "ℹ️" "terraform plan"
terraform plan \
  -var="cloud_provider=${PROVIDER}" \
  -var="ovh_project_id=${PROJECT_ID}" \
  -var="environment=${ENVIRONMENT}" \
  -out=tfplan

terraform show -json tfplan > tfplan.json

# Block destroy actions
python - << 'PY'
import json, sys
j=json.load(open("tfplan.json"))
destroy=0
for rc in j.get("resource_changes",[]):
    actions=rc.get("change",