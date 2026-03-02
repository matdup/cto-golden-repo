# Clerk Setup (Managed Auth)

This folder documents how to integrate Clerk.

Minimum items to document:
- Required env vars (public + server)
- JWT verification strategy (edge vs app)
- Session model
- RBAC claims structure
- Webhooks (user created, org membership, etc.)

No secrets in repo.
Use `.env.example` at app level and GitHub Secrets in CI/CD.