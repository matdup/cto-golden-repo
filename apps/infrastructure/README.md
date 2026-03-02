# 🚀 Infrastructure — TechFactory (IaC + Runtime)

This folder contains:
- **Runtime manifests** (Docker Compose for MVP)
- **Infra-as-Code** (Terraform multi-cloud abstraction)
- **Edge runtime config** (Traefik patterns, middlewares)

## ✅ MVP Runtime (local or single host)

```bash
docker compose -f infrastructure/docker-compose.yml up -d --build
curl -fsS http://localhost:8080/health
curl -fsS http://localhost:3000