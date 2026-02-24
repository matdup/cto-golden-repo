# 🛡️ GitHub Workflows — CI/CD Suite

> **Centralized CI/CD & Security Pipelines** for all CTO Factory repositories  
> Each workflow uses **explicit, deterministic detection rules** to adapt safely to the repository type.
No implicit guessing, no hidden behavior — everything is auditable and predictable across backend, frontend, infrastructure, docs, or monitoring projects.

This **single `.github` folder** contains universal pipelines that automatically detect and adapt to your project type.

---

## 🎯 Deterministic Project Detection

The workflows automatically detect your project type:

| Project Type | Detection File | Actions Triggered |
|--------------|----------------|------------------|
| **Backend** | `go.mod` | Go validation, test matrix, build, scan, deploy|
| **Frontend** | `package.json` | Node.js validation, test matrix, build, scan, deploy |
| **Infrastructure** | `terraform/` + `.tf` files | Terraform validation, plan, security scan, gated apply |
| **Documentation** | `mkdocs.yml` | Docs build & deployment |
| **Monitoring** | Project structure | Health checks & metrics |

---

## 📄 Full Documentation

You can access the detailed pipeline documentation and audit overview here:

👉 **[CTO Factory Pipelines Overview (Google Doc)](https://docs.google.com/document/d/1Oa3UDlAzR4AjBUYPFZcczIed0R_gptSYDwXhxkSp7hs/edit?usp=sharing)**

This document includes:
- Full phase-by-phase breakdown (CI/CD + Security)
- Secrets and compliance requirements
- Audit and SOC2 alignment
- Future roadmap for reusable workflows

---

## 🔧 Workflows

| File | Purpose |
|------|----------|
| **ci.yml** | Full CI/CD pipeline — validation, testing, build, security scan, deployment, monitoring : validation → test matrix → build → security gate → deployment → post-deploy checks |
| **security.yml** | Independent Deep Security Suite — secrets, SAST, dependency scan, container scan, IaC security, SBOM, reporting |

---

## 🚀 Features
- **Deterministic CI/CD** (no hidden logic, no implicit behavior)
- **Language-aware pipelines** (Go, Node.js, Terraform, Docs)
- **Test matrices** (Go & Node LTS)
- **Docker build & scan gating**
- **Terraform plan/apply separation (audit-friendly)**
- **SBOM + coverage artifacts**
- **SARIF integration with GitHub Security**
- **Slack notifications on failures**
- **Production-safe deployment guards**

---

## 🔒 Security Model

Security is enforced as a **first-class, independent concern**.

The Security Suite runs:
- On every PR
- On every push to main / develop
- On a scheduled weekly scan (Monday 06:00 UTC)

Enforced controls include:
- Secret detection (Gitleaks, Trivy FS)
- Dependency and container vulnerability blocking
- IaC static analysis (TFLint, tfsec)
- SBOM generation and archival
- SARIF reporting into GitHub Security

All secrets are managed exclusively via **GitHub Secrets**.
No credentials are stored in code or artifacts.

---

## ✅ Usage
1. Copy the `.github` folder at the root of your repository
2. Add the required secrets (depending on project type)
3. Push to `main` or open a PR

The workflows automatically enforce:
- Validation before tests
- Tests before build
- Build + security before deployment
- Deployment only on `main`

---

## 🧩 Advanced: Centralized Reusable Workflows
For large organizations, you can centralize these workflows in a single repo (e.g. `org/github-actions`)
and call them from others using:

```yaml
jobs:
  use-central-ci:
    uses: org/github-actions/.github/workflows/ci.yml@main
```

---
🧾 **License Notice**  
This repository is proprietary and shared for demonstration purposes only.  
Reuse, redistribution, or inclusion in other portfolios is strictly prohibited.  
See [LICENSE](../LICENSE.md) for details.
---

---

📦 **Part of the Tech Factory Framework**  
Version: `v1.1` — Updated: 2025-02-07