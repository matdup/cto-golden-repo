# Restore test

## Goal
Validate that backups can actually be restored.

## Schedule
- MVP: monthly
- Growth: weekly
- Scale/compliance: automated and frequent

## Steps (example)
1. Create a fresh isolated environment (local or ephemeral)
2. Restore latest backup
3. Run smoke tests + health checks
4. Record results (timestamp, backup id, success/failure)

## Verification
- restore completes without errors
- app can start and respond to basic requests
- critical data is present

## Output
Store a restore report in:
- `docs/content/tech-runbooks/` or
- incident/postmortem system (if applicable)