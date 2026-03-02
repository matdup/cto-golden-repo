# Security Policy

## Reporting a Vulnerability

If you discover a vulnerability:

- DO NOT open a public issue
- Email: security@yourcompany.com
- Include:
  - Affected component
  - Steps to reproduce
  - Impact assessment

We commit to:
- Acknowledge within 48h
- Patch critical within 7 days
- Publish advisory after remediation

---

## Security Controls

- Secret scanning (gitleaks)
- Dependency scanning (Dependabot / Snyk)
- SBOM generation (Syft)
- Container scanning (Trivy)
- MFA required on GitHub
- Protected main branch