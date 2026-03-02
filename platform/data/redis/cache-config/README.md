# Redis Cache Configuration

Put cache policy docs here:
- key naming conventions
- TTL rules
- invalidation strategy
- per-tenant prefixing (if multi-tenant)

Baseline rules:
- Every cache entry must have TTL
- Keys must be namespaced: {env}:{service}:{tenant}:{key}