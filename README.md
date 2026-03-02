# 🏛️ CTO Golden Repo 
## The Enterprise-Grade Default Foundation for Shipping & Scaling Safely

> **Single source of truth** for: architecture, multi-cloud infrastructure, CI/CD, security, observability, governance, and runbooks.  
> Start simple (Compose), evolve safely (Terraform multi-env, then K8s scale profile).

---

## 🎯 What this repository is

This repository is the **CTO Golden Repo**: a **production-ready baseline** that standardizes how we build, deploy, secure, observe, and operate systems.

It is designed to be:
- **Operational out of the box**
- **Multi-cloud ready** (AWS / Azure / OVH)
- **Audit-friendly** (ADR, CI evidence, policies)
- **Secure by default** (secrets hygiene + scans + least privilege)
- **Observable by default** (metrics/logs dashboards + alerts → runbooks)
- **Evolvable** (MVP → Growth → Scale profile toggles)

This is **not a product repo**.  
It’s the **foundation** that product repos inherit or fork from.

---

## ✅ Non-negotiables (baseline contract)

- **No secrets in Git** (gitleaks enforced)
- **CI must be green** before merge
- **Environments are isolated** (dev/staging/prod)
- **Infra is code** (Terraform modules + environments)
- **Backups exist + restore is tested**
- **Observability exists before scale**
- **Major changes require ADRs**

If a layer is not **secure, observable, reversible** → it is **not allowed to scale**.

---

## 🧭 How to use this repo

### Option A — Use as “Golden Reference”
- Keep this repo as the **source of truth**
- Product repos reference it (docs/policies/scripts patterns)
- Platform team updates it and publishes changes

### Option B — Fork per product (recommended early-stage)
1. Fork / copy this repo
2. Remove what’s not needed for MVP
3. Keep the structure and non-negotiables

---

## 🚀 Quick start

### 1) Setup local environment
```bash
cp .env.example .env
# fill variables
make dev
```

### 2) Run MVP runtime (Docker Compose)
```bash
docker compose -f apps/infrastructure/docker-compose.yml up -d
docker compose -f apps/infrastructure/docker-compose.yml ps
```

### 3) Validate (lint/test/security)
```bash
make lint
make test
```
CI/CD will run the same checks automatically via GitHub Actions.

---

## 🏗️ Multi-cloud orchestration (Foundation upgrade)

This repo supports multi-cloud provisioning via Terraform:
- Providers: AWS / Azure / OVH
- Environments: dev / staging / prod
- Modules: edge / network / database / monitoring / security / kubernetes / finops
- Abstraction layer: apps/infrastructure/terraform/terraform_cloud-abstraction/*

High-level flow:
1.	Choose cloud provider(s)
2.	Configure environment (dev/staging/prod)
3.	Apply Terraform
4.	Deploy runtime (Compose → later K8s scale profile)

---

## 🗂️ Repository map (source of truth)

Top-level
- .github/ — CI/CD pipelines, policy checks, supply-chain scans
- apps/ 
    — frontend/
    - backend/
    - infrastructure/ — runtime (Compose), IaC (Terraform), scale profile (K8s)
- platform/ — monitoring, security tooling, auth patterns, data plane
- docs/ — MkDocs documentation, ADRs, architecture, runbooks (technical)
- governance/ — policies (data classification, retention, finops, principles)
- ops-runbooks/ — incident response, rollback, DR (process + coordination)
- product/ — Product ↔ Tech alignment artifacts

---

## 📦 Infrastructure folder (what exists today) inside apps/

infrastructure/
├── docker-compose.yml
├── compose/
│   └── traefik/
│       ├── traefik.yml
│       ├── dynamic.yml
│       ├── auth/
│       │   ├── README.md
│       │   └── jwt.md
│       └── middlewares/
│           ├── README.md
│           ├── rate-limit.yml
│           └── quotas.yml
└── terraform/
    ├── README.md
    ├── environments/
    │   ├── dev/README.md
    │   ├── staging/README.md
    │   └── prod/README.md
    ├── modules/
    │   ├── edge/README.md
    │   ├── network/README.md
    │   ├── database/README.md
    │   ├── kubernetes/README.md
    │   ├── monitoring/README.md
    │   ├── security/README.md
    │   └── finops/README.md
    └── terraform_cloud-abstraction/
        ├── aws/
        ├── azure/
        └── ovh/

Default runtime: Docker Compose
Scale profile: Kubernetes (Terraform module scaffold; manifests activated when needed)

---

## 🔐 Security model

Security gates enforced by policy:
- Secret scanning (gitleaks)
- Container scan (Trivy)
- Dependency hygiene (dependabot/renovate)
- SBOM generation (Syft) where enabled
- Least privilege IAM patterns (edge/iam module)

Vulnerability reporting: see SECURITY.md

---

## 📊 Observability model

Default stack:
- Prometheus (metrics)
- Loki (logs)
- Grafana (dashboards)
- Alertmanager (when enabled)

Rules:
- Every alert must define: severity, owner, runbook URL
- No orphan alerts

```bash
docker compose -f platform/monitoring/docker-compose.monitoring.yml up -d
```

See: platform/monitoring/README.md

---

## 🔄 Release safety

Baseline pipeline contract:
Lint → Tests → Security Scan → Build → Deploy → Health Checks → Rollback hook

Feature flags are configuration-first (env/config), not code forks.

---

## 🧾 Governance & auditability
- ADRs are mandatory for major architecture choices
    - Index: DECISIONS.md
    - Content: docs/adr/
- Data governance:
    - classification: governance/data-classification.md
    - retention: governance/data-retention-policy.md
- DR targets:
	- governance/dr-targets.md
	- operational procedures: ops-runbooks/disaster-recovery.md

---

## 🛠️ Standard commands

make help
make dev
make lint
make test
make docs

Scripts (when present) live under /scripts/ and must be:
- idempotent
- safe by default
- environment-aware (dev/staging/prod)

---

## 👥 Ownership

Ownership is mandatory for all critical paths.

See: CODEOWNERS

---

## 📎 Repo standards
- Formatting: .editorconfig
- Ignore rules: .gitignore
- Toolchain pinning: .tool-versions
- Contribution rules: CONTRIBUTING.md
- Security disclosure: SECURITY.md
- License: LICENSE.md

---

## 🧾 License notice

This repository is proprietary and shared for demonstration or internal use only.
See LICENSE.md.

---

Maintainer: CTO Office / Platform
Next review: Q1 2026

---
