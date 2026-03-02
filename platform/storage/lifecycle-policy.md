# Lifecycle Policy

Lifecycle is a cost + risk control mechanism.

## Baseline retention
- Backups: 30–90 days (depends on RPO/RTO)
- Audit exports: 365 days minimum (or regulatory)
- Temporary exports: 7–30 days

## Rules
- Enable versioning on buckets containing critical artifacts
- Enforce encryption-at-rest
- Prefer WORM/immutability for audit archives (if required)
- Periodically test restore

This policy must match:
- governance/data-retention-policy.md
- governance/dr-targets.md