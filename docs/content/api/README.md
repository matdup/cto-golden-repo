# API documentation (Contracts-driven)

This section documents the product APIs. The **source of truth** is the repository’s `contracts/` directory:
- `contracts/openapi/v1/*.yaml`
- `contracts/schemas/*`

## Rules
- If docs contradict `contracts/`, **contracts win**.
- Changes to endpoints must update OpenAPI first, then code, then docs if needed.
- Versioning: use explicit `v1`, `v2`, etc. No implicit breaking changes.

## How to validate contracts
Recommended checks (CI-friendly):
- Lint OpenAPI (`spectral`, `openapi-cli`)
- Generate client stubs in a scratch build to detect schema mistakes
- Run contract tests (`contracts/contract-tests/…`) when enabled

## Pages
- `frontend-api.md`: how the frontend consumes and authenticates
- `backend-node-api.md`: backend conventions, errors, headers, tracing/audit hooks