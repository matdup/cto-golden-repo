# Go Service (Optional)

A minimal, production-grade Go HTTP service intended for:
- high-throughput endpoints
- isolation of specific workloads
- performance-sensitive paths

## Endpoints
- `GET /health` — liveness
- `GET /ready` — readiness
- `GET /api/users` — sample endpoint (replace)

## Local run
```bash
cp -n .env.example .env || true
export PORT=8080
go run ./cmd/api
```

## Docker
```bash
docker build -t go-service:local .
docker run --rm -p 8080:8080 go-service:local
curl -fsS http://localhost:8080/health
curl -fsS http://localhost:8080/ready
```

## Operational notes
- Graceful shutdown enabled (SIGINT/SIGTERM)
- Timeouts are configured to mitigate slowloris and hung connections
- Request IDs are generated when missing and returned in response headers
