# Backend Node API

This page defines conventions for a backend implemented in Node/Nest (or similar), aligned with the OpenAPI contracts.

## Source of truth
- OpenAPI: `contracts/openapi/v1/public.yaml` and `admin.yaml`
- Schemas: `contracts/schemas/*`

## API standards
### Status codes
- `200/201/204` success
- `400` validation error (client input)
- `401` unauthenticated
- `403` unauthorized
- `404` resource missing (do not leak whether something exists when sensitive)
- `409` conflict (idempotency/key reuse)
- `429` rate limit
- `5xx` server error

### Error format (recommended)
All errors should map to a stable structure (match your schema in `contracts/schemas/errors/`):
```json
{
  "error": {
    "code": "string",
    "message": "string",
    "request_id": "string",
    "details": {}
  }
}
```

### Idempotency

For endpoints that create resources:
- support Idempotency-Key header
- on replay, return the same result (or 409 with stable semantics)

## Request tracing
- Accept X-Request-Id (propagate through logs)
- If missing, generate one and return it in response headers

## Security
- Enforce authentication and authorization at the boundary (guards/middleware)
- Validate input using schema validation (class-validator/zod) aligned with contracts
- Reject unknown fields if possible (tight schemas reduce attack surface)

## Audit logging (contract to ops)

For high-sensitivity actions:
emit audit events with:
- who (subject/user/service)
- what (action)
- target (resource id)
- when (timestamp)
- where (ip/ua if available)
- outcome (success/failure)
Link: Architecture → Audit logging

## Versioning
/v1/... paths are immutable.
Breaking change → new version folder in contracts/openapi/.

## Operational endpoints
Expose:
/health (basic liveness)
/ready (readiness incl. deps if appropriate)