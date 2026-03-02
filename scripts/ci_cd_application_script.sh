#!/usr/bin/env bash
set -euo pipefail

log() { printf "%s %s\n" "$1" "$2" >&2; }
die() { log "❌" "$1"; exit "${2:-1}"; }
require_cmd() { command -v "$1" >/dev/null 2>&1 || die "Missing dependency: $1" 3; }

usage() {
  cat <<'EOF'
Usage:
  ci_cd_application_script.sh --org <ORG> [--repos "a b c"] [--branch <name>] [--dry-run]

Behavior:
  - Clones each repo into a temp directory
  - Ensures .github/workflows exists
  - Copies CI/CD files from this golden repo:
      .github/workflows/ci.yml
      .github/workflows/security-suite.yml (or security.yml if you use it)
      .github/README.md
      .github/policies/required-paths.yml (optional if present)
  - Commits changes only if needed
  - Pushes to the target branch (default: main)

Notes:
  - This script assumes you run it from the golden repo root.
  - It does not bypass branch protections.

Examples:
  ci_cd_application_script.sh --org TECHFACTORY --repos "backend-template frontend-template"
  ci_cd_application_script.sh --org TECHFACTORY --dry-run
EOF
}

require_cmd gh
require_cmd git
require_cmd rsync

ORG=""
REPOS="infra-template backend-template frontend-template docs-template monitoring-template"
BRANCH="main"
DRY_RUN=false

while [ $# -gt 0 ]; do
  case "$1" in
    --org) ORG="${2:-}"; shift 2 ;;
    --repos) REPOS="${2:-}"; shift 2 ;;
    --branch) BRANCH="${2:-}"; shift 2 ;;
    --dry-run) DRY_RUN=true; shift ;;
    -h|--help) usage; exit 0 ;;
    *) die "Unknown option: $1 (use --help)" 2 ;;
  esac
done

[ -n "${ORG}" ] || die "Missing --org" 2
[ -f ".github/workflows/ci.yml" ] || die "Missing source: .github/workflows/ci.yml (run from repo root)" 2
[ -f ".github/README.md" ] || die "Missing source: .github/README.md (run from repo root)" 2

# Prefer your current naming
SECURITY_SRC=""
if [ -f ".github/workflows/security-suite.yml" ]; then
  SECURITY_SRC=".github/workflows/security-suite.yml"
elif [ -f ".github/workflows/security.yml" ]; then
  SECURITY_SRC=".github/workflows/security.yml"
else
  die "Missing security workflow: expected .github/workflows/security-suite.yml or security.yml" 2
fi

TMP_BASE="$(mktemp -d)"
cleanup() { rm -rf "${TMP_BASE}"; }
trap cleanup EXIT

log "ℹ️" "Starting CI/CD propagation to org=${ORG} branch=${BRANCH} dry_run=${DRY_RUN}"
log "ℹ️" "Repos: ${REPOS}"

for repo in ${REPOS}; do
  log "ℹ️" "Processing: ${ORG}/${repo}"

  DEST="${TMP_BASE}/${repo}"
  rm -rf "${DEST}"

  gh repo clone "${ORG}/${repo}" "${DEST}" >/dev/null

  mkdir -p "${DEST}/.github/workflows"
  mkdir -p "${DEST}/.github/policies" || true

  # Copy files (rsync keeps perms, makes it clean)
  rsync -a ".github/workflows/ci.yml" "${DEST}/.github/workflows/ci.yml"
  rsync -a "${SECURITY_SRC}" "${DEST}/.github/workflows/$(basename "${SECURITY_SRC}")"
  rsync -a ".github/README.md" "${DEST}/.github/README.md"

  if [ -f ".github/policies/required-paths.yml" ]; then
    rsync -a ".github/policies/required-paths.yml" "${DEST}/.github/policies/required-paths.yml"
  fi

  cd "${DEST}"

  # Ensure branch exists locally
  git fetch origin "${BRANCH}" >/dev/null 2>&1 || true
  git checkout -B "${BRANCH}" "origin/${BRANCH}" >/dev/null 2>&1 || git checkout -B "${BRANCH}" >/dev/null

  if git diff --quiet; then
    log "✅" "No changes for ${repo}"
    cd - >/dev/null
    continue
  fi

  git add .github
  git commit -m "chore(ci): sync golden repo CI/CD workflows" >/dev/null

  if [ "${DRY_RUN}" = "true" ]; then
    log "✅" "[dry-run] Would push changes to ${repo}:${BRANCH}"
  else
    git push origin "${BRANCH}"
    log "✅" "Pushed changes to ${repo}:${BRANCH}"
  fi

  cd - >/dev/null
done

log "✅" "CI/CD propagation completed"