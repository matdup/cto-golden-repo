# Troubleshooting

## Goal
Provide quick diagnostics patterns.

## Common checks
### 1) Service down
- container logs
- health endpoint
- upstream dependencies (db/redis)
- network/DNS issues

### 2) High error rate
- look for error spikes in logs
- check recent deploy
- validate external dependencies
- check rate limits

### 3) Latency increase
- CPU/memory saturation
- DB slow queries
- upstream API degradation
- excessive retries

## Golden rules
- Always correlate by `X-Request-Id`
- Prefer narrowing scope to a single change
- If Sev-1: switch to incident process