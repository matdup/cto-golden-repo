# Rollback

## Goal
Return to last known good state after a bad deploy.

## Preconditions
- You know the last good version (commit SHA / image tag)
- You have a rollback mechanism for your deployment type

## Steps
1. Stop the line (no further deploys)
2. Roll back to last good version (method-specific)
3. Run health checks:
```bash
bash scripts/health-checks/healthcheck-deps.sh
bash scripts/health-checks/healthcheck-backend.sh
bash scripts/health-checks/healthcheck-frontend.sh
```
4.	Verify key user flows
5.	Capture incident notes (even if small)

## Verification
- system stable
- metrics back to baseline
- alert resolved

## Follow-up
- open a bug ticket
- add a prevention task (tests, feature flag, canary, etc.)