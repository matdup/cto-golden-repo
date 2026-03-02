# Frontend API

This document describes **how the frontend calls the backend** and what conventions are required to keep the system reliable.

## Base URLs
- Local: `http://localhost:8080` (backend)
- Staging/Prod: defined via environment variables in `apps/frontend/.env*`

## Authentication
**Rule:** Never store secrets in the frontend.
- Frontend obtains a session/token from the auth provider (managed by the chosen auth solution).
- Frontend sends tokens using:
  - `Authorization: Bearer <token>` (default)
  - Optional: `X-Tenant-Id` for tenant routing (if required by the backend model)

## Required headers (recommended)
- `Authorization: Bearer ...`
- `X-Request-Id`: generated client-side when not provided (UUID)
- `X-Client-Version`: frontend build version (optional, helps debugging)

## Error handling
Frontend must handle:
- `401/403`: auth required / forbidden
- `429`: rate-limited — show retry UI (respect `Retry-After` when present)
- `5xx`: backend failure — show fallback + capture error event

## Retries
- Only retry **idempotent requests** (GET, and safe POST only when explicitly designed).
- Use exponential backoff with jitter.
- Respect `Retry-After` if present.

## Observability hooks
- Attach `X-Request-Id` to logs and error reports.
- Capture “API error rate” and “latency p95” (frontend metrics if enabled).

## Security notes
- No tokens in localStorage if avoidable (prefer HTTP-only cookies for web apps when compatible).
- Sanitize all user-provided inputs before sending.
- Do not leak internal errors in UI; show generic message and log details client-side.