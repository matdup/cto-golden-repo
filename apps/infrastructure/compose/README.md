# 🐳 Runtime Stack (Docker Compose)

This directory defines the default runtime stack for MVP environments.

## Philosophy

- Application logic stays in `frontend/` and `backend/`
- Edge security is handled by Traefik
- Internal services are never publicly exposed
- Production deployments should migrate to Kubernetes

## Services

| Service | Role | Exposure |
|----------|-------|----------|
| frontend | Public UI | via Traefik |
| backend | API | internal only |
| traefik | Edge proxy | public |

## Security Rules

- No secrets in compose files
- Use `.env` or external secret manager
- All external traffic goes through Traefik
- Healthcheck mandatory for all services