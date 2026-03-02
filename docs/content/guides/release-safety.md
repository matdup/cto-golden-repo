# Release safety

This guide defines safe release behavior.

## Minimum rules
- CI must be green
- No secrets introduced (gitleaks clean)
- Vulnerability gates respected (no critical/high)
- Health checks must pass post-deploy
- Rollback path defined before shipping

## Recommended practices
- Feature flags for risky changes
- Small incremental releases
- Change logs / release notes when behavior changes
- “Stop-the-line” authority: anyone can block release on safety grounds

## Rollback
Always define:
- What is rolled back (app, infra, config)
- How long it takes
- How to validate rollback success

See runbook:
- `../tech-runbooks/rollback.md`