# OpenAPI Contracts

Defines HTTP API surfaces.

---

## Conventions

- OpenAPI 3.1
- JSON responses
- camelCase fields
- snake_case query params only if required
- ISO8601 timestamps (UTC)

---

## Status Codes

200 — Success  
201 — Created  
204 — No Content  
400 — Validation error  
401 — Unauthorized  
403 — Forbidden  
404 — Not Found  
409 — Conflict  
422 — Business rule violation  
500 — Internal error  

---

## Authentication

Public API:
- Bearer JWT

Admin API:
- Bearer JWT + role enforcement

---

## Error Model

All errors must follow:
{
  "error": {
    "code": "string",
    "message": "string",
    "requestId": "string"
  }
}

---

## Validation

All specs must:
- Pass spectral lint
- Pass openapi validation
- Be tested against backend implementation