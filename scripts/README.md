# 🧱 TechFactory — Deployment & Automation Scripts

> **Purpose:**  
> These scripts provide a unified automation layer for provisioning, deploying, and securing all TechFactory environments — from infrastructure to observability to CI/CD propagation.

Each script is designed for **10-minute reproducible deployments** and can be safely executed on any machine with the proper tools installed.

---

## 📂 Script Overview

| Script | Purpose | Scope | Risk Level |
|---------|----------|--------|-------------|
| [`ci_cd_application_script.sh`](#️-ci_cd_application_scriptsh) | Propagate universal CI/CD pipelines (`ci.yml`, `security.yml`, and README) to all repositories | GitHub Organization | 🟢 Safe (no destructive actions) |
| [`deploy-infrastructure.sh`](#️-deploy-infrastructuresh) | Deploy complete multi-cloud infrastructure via Terraform orchestration (OVH, AWS, Azure) | Cloud Infrastructure | 🟡 Medium (modifies remote resources only) |
| [`deploy-observability.sh`](#️-deploy-observabilitysh) | Deploy the full observability stack (Grafana, Prometheus, Loki, Vault) | Local or remote Docker host | 🟢 Safe (read-only on repo, writes to Docker volumes) |

---

## ⚙️ General Requirements

Before using any script, make sure you have the following:

- **Operating system:** Linux or macOS (WSL2 compatible)
- **Tools installed:**
  - `git` and `gh` (GitHub CLI)
  - `bash >= 5.0`
  - `curl`
  - `jq`
  - For infrastructure: `terraform >= 1.5.0`
  - For observability: `docker` and `docker-compose`
- **Permissions:**
  - Access to the TechFactory GitHub organization
  - Required secrets (`OVH_APPLICATION_KEY`, `OVH_APPLICATION_SECRET`, `OVH_CONSUMER_KEY`, etc.)
  - Optional: `GH_TOKEN` if running automation from CI/CD

---

## 🛡️ `ci_cd_application_script.sh`

### 🎯 Purpose
Propagates the **universal CI/CD system** to all project templates:
- Copies `.github/workflows/ci.yml`, `.github/workflows/security.yml`, and `.github/README.md`
- Creates the `.github` structure if missing
- Commits and pushes to `main` in each repository

### 🧩 Workflow
1. Clones each repository into `/tmp/<repo>`
2. Creates `.github/workflows/`
3. Copies CI/CD pipelines and documentation
4. Commits and pushes changes
5. Cleans up temporary files

### ⚠️ Safety
- **Infra-template excluded by default** (to avoid overwriting critical Terraform configuration)
- Does **not** modify project source files — only `.github/` folder
- If branch protections block pushes, it fails gracefully

### ▶️ Usage
```bash
bash scripts/ci_cd_application_script.sh

Optional: Add --dry-run to preview actions without applying changes.
```
---

## 🏗️ deploy-infrastructure.sh

### 🎯 Purpose

Deploys the multi-cloud infrastructure environment using Terraform orchestration.  
Supports **OVH**, **AWS**, and **Azure** from a single entry point.  
Part of the `infrastructure` module.

### 🧩 Workflow

1. Validates prerequisites (Terraform and cloud credentials)  
2. Initializes Terraform in `apps/infrastructure/terraform/terraform_cloud-abstraction/`  
3. Validates and plans the configuration  
4. Applies the selected cloud configuration automatically  
5. Displays deployment outputs and performs endpoint validation  

---

### ☁️ Providers & Credentials

| Provider | Credentials Required | Default |
|-----------|----------------------|----------|
| **OVH** | `OVH_APPLICATION_KEY`, `OVH_APPLICATION_SECRET`, `OVH_CONSUMER_KEY`, and `ovh_project_id` | ✅ |
| **AWS** | `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY` | |
| **Azure** | `ARM_CLIENT_ID`, `ARM_CLIENT_SECRET`, `ARM_SUBSCRIPTION_ID`, `ARM_TENANT_ID` | |

---

### ⚠️ Safety

- Creates or modifies **remote infrastructure**, not local files  
- Locally, it only generates:
  - `.terraform/` folder  
  - `.terraform.lock.hcl`  
  - `terraform.plan`  
- Never overwrites `.tf` or `.tfvars` files  
- Stops on any error (`set -euo pipefail`)  

---

### ▶️ Usage

```bash
bash scripts/deploy-infrastructure.sh <project_id> [cloud_provider]
```

### 💡 Example

#### OVH:
```
OVH_APPLICATION_KEY="..." \
OVH_APPLICATION_SECRET="..." \
OVH_CONSUMER_KEY="..." \
bash scripts/deploy-infrastructure.sh 1234567890abcdef ovh
```

#### AWS
```
export AWS_ACCESS_KEY_ID="..."
export AWS_SECRET_ACCESS_KEY="..."
bash scripts/deploy-infrastructure.sh my-project aws
```

#### Azure
```
export ARM_CLIENT_ID="..."
export ARM_CLIENT_SECRET="..."
export ARM_SUBSCRIPTION_ID="..."
export ARM_TENANT_ID="..."
bash scripts/deploy-infrastructure.sh demo-azure azure
```

### 📦 Outputs
After a successful deployment, Terraform provides:

| Output | Description |
|---------|-------------|
| **application_url** | Public URL of the deployed service |
| **database_host** | Database endpoint |
| **instance_private_ip** | Private IP of main compute instance |
| **cloud_provider** | Selected cloud provider |
| **infrastructure_version** | Version tag for traceability |

### 🧠 Tips

- **Simulate only (dry run):**
  ```bash
  bash scripts/deploy-infrastructure.sh <project_id> <cloud_provider> --dry-run
  ```
- **Require confirmation before apply:**
  ```bash
  terraform plan -out=terraform.plan
  read -p "Apply this plan? (y/N): " confirm
  ```
---

## 📊 deploy-observability.sh

### 🎯 Purpose

Deploys the **TechFactory Observability Stack** in under 10 minutes, providing full visibility over system health, metrics, logs, alerts, and secrets.

Includes:

- 📊 Prometheus — metrics collection and alerting  
- 📈 Grafana — dashboards and visualization  
- 📝 Loki + Promtail — centralized logs  
- 🚨 Alertmanager — rule-based alert routing  
- 🔐 Vault + Vault UI — secrets management  
- 🩺 Uptime Kuma — uptime and external checks  

Part of the monitoring-template￼ module.

---

#### 🧩 Workflow
1. Validate prerequisites: Docker, Docker Compose, and daemon activity  
2. Ensure `.env` file exists (creates one from `.env.example` if missing)  
3. Deploy stack with `docker-compose.monitoring.yml`  
4. Initialize Vault and run `vault/init-vault.sh`  
5. Wait for Grafana readiness and auto-provision dashboards  
6. Perform health checks for Prometheus, Grafana, and Loki  
7. Display access details (URLs and credentials)

---

### ⚙️ Stack Composition

| Service | Port | Purpose |
|----------|------|----------|
| **Grafana** | 3000 | Dashboards & visualization |
| **Prometheus** | 9090 | Metrics collection |
| **Alertmanager** | 9093 | Alert management |
| **Loki** | 3100 | Log aggregation backend |
| **Promtail** | — | Log shipper agent |
| **Vault** | 8200 | Secret management API |
| **Vault UI** | 8300 | Web interface for Vault |
| **Uptime Kuma** | 3001 | Uptime monitoring dashboard |

---

### ⚠️ Safety
- No modification of repository files — all operations are container-based.
- Writes only to Docker volumes (grafana_data, prometheus_data, loki_data, etc.).
- Automatically halts if .env is missing or credentials are invalid.
- Idempotent — safe to re-run; will restart existing containers gracefully.
- Designed for local or remote hosts (works with SSH Docker contexts).

---

### ▶️ Usage

```bash
bash scripts/deploy-observability.sh
```

### 💡 Example Output

```text
🛡️ Starting Observability Deployment
✅ All prerequisites met
🏗️ Deploying monitoring stack...
⏳ Waiting for services to be ready...
🔐 Initializing Vault...
✅ Vault initialized successfully
✅ Prometheus is healthy
✅ Grafana is healthy
✅ Loki is healthy
🎉 All services are operational!
```
---

### 📊 Access URLs

| Service | URL |
|----------|-----|
| **Grafana** | http://localhost:3000 |
| **Prometheus** | http://localhost:9090 |
| **Alertmanager** | http://localhost:9093 |
| **Vault UI** | http://localhost:8300 |
| **Uptime Kuma** | http://localhost:3001 |
| **Loki** | http://localhost:3100 |

---

### 🧩 Configuration Files Overview

| File | Role |
|------|------|
| `docker-compose.monitoring.yml` | Main observability stack |
| `docker-compose.vault.yml` | Vault + UI containers |
| `grafana/dashboards/dashboard.json` | Default dashboard |
| `prometheus/prometheus.yml` | Metrics scraping configuration |
| `prometheus/alerting.yml` | Alert rules |
| `alertmanager/alertmanager.yml` | Alert routing configuration |
| `loki/loki-config.yml` | Log backend configuration |
| `promtail/promtail-config.yml` | Log shipping configuration |
| `vault/init-vault.sh` | Vault initialization script |

---

### 🩺 Health Validation Checks

| Component | Command | Expected Result |
|------------|----------|----------------|
| **Prometheus** | `curl http://localhost:9090/-/healthy` | `200 OK` |
| **Grafana** | `curl http://localhost:3000/api/health` | `200 OK` |
| **Loki** | `curl http://localhost:3100/ready` | `ready` response |

---

### 🛡️ Security Recommendations

- Change default passwords (Grafana, Vault)  
- Restrict exposed ports via firewall  
- Enable HTTPS/TLS for production  
- Integrate Grafana with OAuth/SSO  
- Backup Docker volumes (`grafana_data`, `vault_data`, etc.)  
- Store Vault unseal keys and root token securely 

---

### 🧠 Default Access

| Service | URL | Default Credentials |
|----------|-----|---------------------|
| **Grafana** | http://localhost:3000 | `admin / <GRAFANA_ADMIN_PASSWORD>` |
| **Prometheus** | http://localhost:9090 | — |
| **Alertmanager** | http://localhost:9093 | — |
| **Vault** | http://localhost:8300 | `root / root-token` |
| **Loki** | http://localhost:3100 | — |

---

### ✅ Validation Summary

| Check | Status |
|-------|--------|
| Folder structure matches script | ✅ |
| .env workflow functional | ✅ |
| All docker-compose files found | ✅ |
| Vault script available | ✅ |
| Prometheus/Grafana/Loki configured | ✅ |
| No destructive actions | ✅ |
| Idempotent on re-run | ✅ |

---

### 📦 Backups & Recovery

| Component | Recommended Backup Method | Frequency |
|------------|---------------------------|------------|
| **Prometheus** | Persist volume `prometheus_data` | Daily |
| **Grafana** | Export dashboards + volume `grafana_data` | Daily |
| **Vault** | Snapshot `vault_data` + unseal keys | Daily + secure offsite |
| **Loki** | Persist `loki_data` | Weekly |
| **Terraform State** | Remote backend or versioned storage | Every apply |

---

## 🔒 Security & Governance Notes
- All scripts use `set -euo pipefail` for safety  
- Fail fast on missing dependencies or credentials  
- Secrets never stored in code — only via environment variables  
- CI/CD integrates security scanners (`Trivy`, `Snyk`, `Gitleaks`, `Tfsec`)  
- Logs use standardized icons for clarity:  
  - 🛡️ Initialization  
  - 🏗️ Deployment  
  - 📊 Validation  
  - ✅ Success / ❌ Failure 

---

## 🧭 Repository Context

These scripts are part of the TechFactory Framework.

They enable:
- ⚙️ Fast, reproducible deployments  
- 🔍 Full observability from day one  
- 🧱 Standardized, secure CI/CD pipelines across all projects 

---
🧾 **License Notice**  
This repository is proprietary and shared for demonstration purposes only.  
Reuse, redistribution, or inclusion in other portfolios is strictly prohibited.  
See [LICENSE](../LICENSE.md) for details.
---