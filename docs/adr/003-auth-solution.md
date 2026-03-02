# ADR 003 — Authentication solution

## Status
Accepted

## Context
We need reliable authentication with strong security posture and minimal ops burden at MVP.

## Decision
Default to a **managed auth provider** (e.g. Clerk-like pattern) for MVP, with a documented path to self-hosted IAM (e.g. Keycloak) for compliance/scale.

## Consequences
- MVP delivery is faster and safer
- reduced operational overhead
- dependency on external provider

## Alternatives
- Self-hosted IAM from day 1: rejected (ops complexity)
- Custom auth: rejected (security risk)

## Links
- Platform auth: `../../platform/auth/`
- Security best practices: `../content/guides/security-best-practices.md`