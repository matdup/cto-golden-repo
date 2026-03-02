# Backend

This folder contains the backend runtime options for the Golden Repo.

## Layout
- `nestjs-app/` (**default**) — modular monolith backend (DDD-ish bounded contexts)
- `go-service/` (optional) — high-performance service for specific endpoints
- `rust-service/` (optional) — security/critical workloads where Rust is justified

## Operating principles
- Contracts-first: API source of truth is `contracts/`
- Observability from day one: request IDs, logs, metrics hooks (where applicable)
- Safe-by-default: no secrets in code, strict config validation, health/readiness endpoints

## MVP recommendation
Start with `nestjs-app/`, and extract into Go/Rust only for:
- performance hotspots
- isolated compliance/security workloads
- high-throughput background processing

## Standard endpoints (expected)
All runtime services must expose:
- `GET /health` (liveness)
- `GET /ready` (readiness, includes dependency checks if applicable)

## Local run (examples)
- NestJS app:
  ```bash
  cd nestjs-app
  cp -n .env.example .env || true
  npm ci
  npm run start:dev
```
- Go service:
```bash
cd go-service
cp -n .env.example .env || true
go run ./cmd/api
```
## Security
- Never commit secrets. Use .env locally and GitHub Secrets in CI/CD.
- Run secret scanning (gitleaks) and vulnerability scanning in CI.

## See:
- docs/content/api/ for API conventions
- docs/content/architecture/audit-logging.md for audit expectations
- governance/ for policy alignment