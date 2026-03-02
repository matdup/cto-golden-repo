# Health endpoint

This route is used by:
- CI/CD smoke checks
- load balancers / edge probes
- uptime monitoring

## Contract
- `GET /api/health` returns:
  - `200` with `{ "status": "ok" }`
  - `Cache-Control: no-store`

This endpoint must remain lightweight and dependency-free.