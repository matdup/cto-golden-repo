# Capability Mapping

## Purpose

Map business capabilities to system modules and technical ownership.

Prevents:
- Duplicate features
- Architecture drift
- Ownership ambiguity

---

# 1. Core Business Capabilities

| Capability | Description |
|------------|-------------|
| Identity Management | Authentication & access control |
| Asset Management | Core product logic |
| Audit & Compliance | Traceability & reporting |
| Observability | System monitoring |
| Deployment | CI/CD & infra control |

---

# 2. Capability → System Mapping

| Capability | System Location | Owner |
|-------------|----------------|-------|
| Identity | apps/backend/context/identity | Backend Lead |
| UI Experience | apps/frontend | Frontend Lead |
| Infrastructure | apps/infrastructure | DevOps |
| Monitoring | platform/monitoring | DevOps |
| Contracts | contracts/openapi | Backend Lead |
| Governance | governance/ | CTO |

---

# 3. Capability Maturity Levels

| Capability | MVP | Growth | Scale |
|-------------|------|--------|--------|
| Identity | Basic JWT | RBAC | OIDC + SSO |
| Monitoring | Logs | Metrics | Tracing |
| Infra | Compose | Terraform | Kubernetes |
| Security | Basic scans | Full suite | External audit |

---

# 4. Ownership Rules

Each capability must have:
- Named owner
- Backup owner
- Documentation
- Monitoring
- Roadmap alignment

---

# 5. Change Process

Any new capability requires:
- RFC
- Ownership assignment
- Metric definition
- Cost impact review

---

Capabilities define the system.  
Features are implementations of capabilities.