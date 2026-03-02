# Contracts — Source of Truth

This directory defines the **canonical interface** of the system.

It is:
- Language-agnostic
- Backend-agnostic
- Frontend-agnostic
- Infrastructure-agnostic

All services MUST conform to these contracts.

---

## Structure

| Folder | Purpose |
|--------|----------|
| openapi/ | HTTP API contracts |
| schemas/ | Events & error schemas |
| compat/ | Compatibility rules |
| contract-tests/ | Consumer-driven tests |

---

## Governance Rules

- No API without OpenAPI definition
- No event without JSON schema
- Breaking change requires version bump
- All contracts validated in CI
- Contracts reviewed by owner (see governance/ownership.md)

---

## Versioning Model

- Major version in folder (`v1/`)
- Non-breaking changes allowed within version
- Breaking changes require new version folder

Example:
openapi/v1/
openapi/v2/

---

Contracts define system behavior.
Code implements it.