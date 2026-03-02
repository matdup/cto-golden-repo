# Repository Constraints (Non-Negotiable)

These rules cannot be bypassed.

---

## Structural

- Required directories must exist
- CI must pass before merge
- No direct commits to main

---

## Security

- No secrets in repo
- No disabling security scans
- SBOM generation mandatory
- Container scanning mandatory

---

## Testing

- Tests required for new features
- Breaking changes must update contracts
- Coverage must not decrease significantly

---

## Deployment

- Deploy only from main
- Production protected by environment approvals
- Rollback script must exist

---

## Compliance

- Data classification respected
- Retention policy enforced
- Audit logs accessible

---

Violations require CTO approval via RFC.