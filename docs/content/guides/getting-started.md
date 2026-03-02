# Getting started

## Prerequisites
- Git
- Docker + Docker Compose (or `docker compose`)
- Node 20+ (frontend)
- Go / Rust only if you use those services
- Python 3.11+ (docs)

## Repo quick tour
- `apps/`: product runtime services
- `contracts/`: OpenAPI + schemas (source of truth)
- `platform/`: monitoring/security building blocks
- `scripts/`: automation helpers
- `docs/`: this documentation

## Local setup
1. Create `.env` (repo root)
```bash
bash scripts/setup-local-env.sh
```
2.	Start required services (depends on your infra choice)
For monitoring:
```bash
bash scripts/deploy-observability.sh
```
3.	Run docs locally
```bash
pip install mkdocs-material mkdocs-git-revision-date-localized-plugin mkdocs-git-authors-plugin
mkdocs serve -f docs/mkdocs.yml
```
## Verification
- Docs site renders locally
- Health checks succeed (once apps are running):
```bash
bash scripts/health-checks/healthcheck-backend.sh
bash scripts/health-checks/healthcheck-frontend.sh
```