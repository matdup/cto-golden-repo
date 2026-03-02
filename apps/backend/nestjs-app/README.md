# nestjs-app (Default Backend)

This is the default backend layout (modular monolith).

## Current state
This template is **Nest-ready** but intentionally ships with a minimal HTTP server placeholder
so the repo remains runnable even before NestJS dependencies are introduced.

## Endpoints
- `GET /health`
- `GET /ready`

## Local run
```bash
cp -n .env.example .env || true
PORT=8080 node src/main.ts
curl -fsS http://localhost:8080/health
curl -fsS http://localhost:8080/ready
```

## Next steps (when wiring NestJS)
- Add NestJS dependencies
- Replace src/main.ts with NestFactory bootstrap
- Implement controllers in interfaces/http/controllers
- Add validation, auth guards, structured logs, metrics hooks

## Domain layout
- contexts/<context>/domain: framework-agnostic domain
- contexts/<context>/application: use cases + ports
- contexts/<context>/infrastructure: adapters (DB, external APIs)
- contexts/<context>/interfaces/http: transport layer