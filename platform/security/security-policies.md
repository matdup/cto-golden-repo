# Security Policies (Platform)

This policy defines baseline security requirements for repositories using this platform stack.

## Severity handling
- Critical: patch/mitigate within 24–72h
- High: within 7 days
- Medium: within 30 days
- Low: best effort / scheduled

## Dependencies
- Dependabot/Renovate must be enabled
- Lockfiles required
- No unpinned "latest" images in production manifests

## Secrets
- Secret scanning must run on PR + push + scheduled
- No secrets in git history (rewrite required if incident)

## Vulnerability scanning
- Container scan blocks on CRITICAL/HIGH (configurable)
- IaC scan blocks on CRITICAL/HIGH for prod

## SBOM
- SBOM generated for every shipped container
- SBOM stored as artifact for audit window

## Ownership
Security-impacting changes require review by codeowners:
- platform/security/**
- platform/monitoring/**
- apps/infrastructure/**