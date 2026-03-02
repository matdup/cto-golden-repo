# Compatibility Rules

Defines what is considered breaking vs non-breaking.

---

## Breaking Changes (Require new version)

- Removing endpoint
- Renaming field
- Changing field type
- Changing response structure
- Removing enum value
- Making optional field required
- Changing authentication requirement

---

## Non-Breaking Changes

- Adding new endpoint
- Adding optional field
- Adding new enum value (if tolerant readers)
- Adding new error code

---

## Versioning Rules

- Major version = breaking change
- Minor changes within same folder
- Deprecation must be documented
- Deprecated endpoints must remain for at least one full release cycle

---

## CI Enforcement

Contracts must:
- Pass OpenAPI validation
- Pass schema validation
- Pass contract tests (if applicable)

---

If compatibility is unclear → RFC required.