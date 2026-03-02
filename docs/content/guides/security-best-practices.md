# Security best practices

## Non-negotiables
- No secrets in code or docs
- Use GitHub Secrets / secret manager
- Enable secret scanning and vulnerability scanning in CI
- Principle of least privilege for IAM and service roles

## Development practices
- Validate input strictly (schema-based)
- Prefer safe defaults (deny-by-default)
- Log safely: do not log tokens/PII
- Use request IDs for traceability

## Dependency management
- Keep lockfiles committed
- Use Dependabot (or Renovate)
- Patch cadence:
  - Critical: ASAP (24–72h target)
  - High: within 7 days
  - Medium/Low: scheduled

## Incident readiness
- Ensure runbooks exist:
  - security incident
  - incident response
  - rollback
  - disaster recovery