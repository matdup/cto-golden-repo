# 🛡️ GitHub — CI/CD & Security (Golden Repo)

This `.github` folder is the **single source of truth** for:
- CI validation
- security scanning (secrets, vulns, SARIF)
- supply-chain artifacts (SBOM + attestations)
- repository structure enforcement (policy gate)
- production deployment controls (environment-protected)

## ✅ Design Principles
- Deterministic behavior (no implicit guessing)
- Least privilege permissions
- Audit-friendly outputs (SARIF, SBOM artifacts)
- Production-safe (environment protection, concurrency)

## 🔧 Workflows

| Workflow | Purpose |
|---------|---------|
| `policy.yml` | Enforces required repo structure (fails fast) |
| `security-suite.yml` | Secrets + Trivy FS + Dependency review (PR) |
| `supply-chain.yml` | SBOM + attestation (OIDC) |
| `contract-tests.yml` | OpenAPI + JSON Schema validation |
| `frontend-next.yml` | Next.js lint/test/build + container scan + SBOM |
| `backend-node.yml` | Node backend lint/test/build + container scan + SBOM |
| `backend-go.yml` | Go lint/test + container scan + SBOM |
| `infrastructure-terraform.yml` | terraform fmt/validate/tflint + tfsec + plan gate |
| `deploy.yml` | Production deployment (environment protected) |
| `docs.yml` | MkDocs strict build |

## 🔐 Security Model
- **Never** store secrets in Git.
- Secrets scanning enforced via **Gitleaks**.
- Vulnerability reporting via **SARIF** in GitHub Security tab.
- Supply-chain SBOM is archived per commit.

## 🚀 Deployment
`deploy.yml` targets **production** using GitHub Environments.
Make sure `production` environment is configured with:
- required reviewers (manual approval)
- secrets scoped to environment

## 🧩 Required Files
The structure gate requires key paths and governance files.
See: `.github/policies/required-paths.yml`.

---

🧾 **License Notice**  
This repository is proprietary and shared for demonstration purposes only.  
Reuse, redistribution, or inclusion in other portfolios is strictly prohibited.  
See [LICENSE](../LICENSE.md) for details.

---
