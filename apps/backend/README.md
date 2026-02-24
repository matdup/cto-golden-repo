# 🚀 Backend Template - Tech Factory

> **Production-Ready Go Backend** with built-in security, CI/CD, and cloud-native foundations
> Part of the [Tech Factory Framework](../backend-template/README.md)

---

## 🎯 Overview

A secure, scalable Go backend template with enterprise-grade DevOps automation. Part of the Tech Factory ecosystem.

---

## ⚡ Quick Start

```bash
# 1. Clone and setup
git clone <your-repo>
cd backend-template

# 2. Build and run
docker build -t backend .
docker run -p 8080:8080 backend

# 3. Test endpoints
curl http://localhost:8080/health
# {"status":"ok"}

curl http://localhost:8080/api/users  
# ["user1","user2","user3"]
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
| Documentation | [📚 docs-template](../docs-template) |

---
🧾 **License Notice**  
This repository is proprietary and shared for demonstration purposes only.  
Reuse, redistribution, or inclusion in other portfolios is strictly prohibited.  
See [LICENSE](../../LICENSE.md) for details.

---

📦 **Part of the Tech Factory Framework**  
Version: `v1.0` — Updated: 2025-11-03  

This repository supports a pragmatic backend layout:

- `nestjs-app/` (default): modular monolith (DDD-ish bounded contexts)
- `go-service/` (optional): high-performance service
- `rust-service/` (optional): security/critical workloads

Start MVP with minimal secure & observable foundation, then scale components only when justified.