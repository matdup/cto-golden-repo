# 🚀 docs-template - Tech Factory

> **Beautiful documentation** with MkDocs Material and automated deployment
> Part of the [Tech Factory Framework](TechFactory/templates/docs-template/README.md)

---

## ⚡ Quick Start

```bash
# Serve documentation locally
pip install mkdocs-material
mkdocs serve

# Build static site  
mkdocs build

# Deploy to GitHub Pages
mkdocs gh-deploy
```
---

## 🛡️ CI/CD Integration

This template includes:
- **GitHub Actions** workflows (`ci.yml`, `security.yml`)
- Automated build, test, and deploy
- Security scanning (Trivy, Gitleaks, Snyk)
- Weekly compliance checks

---

## 🔒 Security Practices

- Zero secrets in code — use `.env` or GitHub Secrets
- Automated scanning on every push
- SOC2-aligned compliance via CI/CD
- Default firewall and container hardening

---

## 🧩 Related Templates
| Purpose | Template |
|----------|-----------|
| Infrastructure | [☁️ infra-template](../infra-template) |
| Monitoring | [📊 monitoring-template](../monitoring-template) |

---

🧾 **License Notice**  
This repository is proprietary and shared for demonstration purposes only.  
Reuse, redistribution, or inclusion in other portfolios is strictly prohibited.  
See [LICENSE](../../LICENSE.md) for details.

---

📦 **Part of the Tech Factory Framework**  
Version: `v1.0` — Updated: 2025-11-03