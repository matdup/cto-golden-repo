# Edge (gateway / reverse proxy)

This document defines the edge responsibilities and safe defaults.

## Edge responsibilities
- TLS termination (when applicable)
- Request routing
- Rate limiting / basic abuse protection
- Optional: JWT verification (careful—see below)
- Request ID injection (if missing)
- Basic security headers

## JWT verification at the edge
Only do this if:
- you have a stable signing key management strategy
- you can rotate keys safely
- your app still performs authorization checks (edge auth ≠ business auth)

If uncertain, do **authentication/authorization in the application**.

## Rate limiting
Baseline policy:
- per IP for public endpoints
- per tenant/user for authenticated endpoints (when identity available)
- return `429` with `Retry-After`

## Required headers
- Preserve or add `X-Request-Id`
- Forward `X-Forwarded-For`, `X-Forwarded-Proto` appropriately

## Operational guidance
- Changes to rate limiting must include a rollback plan.
- If edge config changes, run smoke health checks after deployment:
  - backend `/health`
  - frontend root
  - key API endpoints

Related:
- Runbook deployment: `../tech-runbooks/deployment.md`
- Runbook rollback: `../tech-runbooks/rollback.md`