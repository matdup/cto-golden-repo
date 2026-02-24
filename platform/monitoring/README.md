# 📊 Monitoring Template - Tech Factory

> **Complete Observability Stack** with Prometheus, Grafana, Loki, and security monitoring


---


## ⚡ Quick Start

### 1. Configure environment
```bash
cp .env.example .env
# Edit .env with secure passwords
```

### 2. Deploy monitoring stack
```bash
docker compose -f docker-compose.monitoring.yml up -d
```

### 3. Access dashboards
```bash
echo "Grafana: http://localhost:3000"
echo "Prometheus: http://localhost:9090"
```


---


## 🎯 Features

- 📊 Real-time Metrics - Prometheus + Node Exporter
- 📝 Centralized Logging - Loki + Promtail
- 🚨 Smart Alerting - Alertmanager with Slack/email
- 📈 Beautiful Dashboards - Pre-built Grafana dashboards
- 🔍 Uptime Monitoring - Uptime Kuma
- 🔐 Secrets Management - HashiCorp Vault


---


## What this demonstrates (CTO portfolio)
- End-to-end observability design (metrics, logs, alerts, uptime) with sane defaults
- Security-aware documentation: explicit dev-mode vs production hardening boundaries
- CI/CD enforcement for quality + security (SAST/secret scanning/container scanning)
- Operational thinking: SLOs, maintenance cadence, troubleshooting runbooks


---


## 🔐 Vault: dev-mode by default, production hardening guidance

> **Default behavior:** Vault runs in **development mode** in this template (fast local setup, no unseal, no TLS).
> The sections below are **production hardening guidance** and do **not** change the default compose behavior.

### Production reference (server mode)
For production, run Vault in **server mode** with persistent storage and TLS. At minimum:

- Initialize once: `vault operator init`
- Unseal via KMS/HSM (preferred) or split keys
- Disable root-token workflows
- Enable audit devices
- Enforce TLS everywhere

```bash
# vault/init-vault.sh - Secured Version 
#!/bin/bash
set -euo pipefail

echo "🔐 Initializing HashiCorp Vault in SECURE mode..."
```

#### Generate secured tokens
export VAULT_TOKEN=$(openssl rand -base64 32)
export VAULT_ADDR='http://vault:8200'

#### Secured Initialisation
vault operator init -key-shares=5 -key-threshold=3

echo "✅ Vault initialized SECURELY"
echo "📋 Save the unseal keys and root token securely!"

> ⚠️ This secure Vault initialization is provided as a **production reference**.  
> The default monitoring stack runs Vault in development mode for simplicity.


---


## 🛡️ CI/CD Integration

This template includes:
- **GitHub Actions** workflows (`ci.yml`, `security.yml`)
- Automated build, test, and deploy
- Security scanning:
  - Gitleaks (secrets in repo + history)
  - Trivy (container vulnerabilities + SARIF)
  - Snyk (dependency scanning when token is configured)
- Weekly compliance checks


### Post-deployment validation

If a `health-check.sh` script is present at repository root,  
the CI/CD pipeline will automatically execute it after deployment.

This allows monitoring stacks to validate:
- Prometheus readiness
- Grafana availability
- Alertmanager responsiveness
- Vault status (optional)

The script must exit with `0` on success.


---


## 🔒 Security Practices

- Zero secrets in code — use `.env` or GitHub Secrets
- Automated scanning on every push
- SOC2-aligned compliance via CI/CD
- Default firewall and container hardening

### Service Reliability Targets (Default)

- Availability: 99.9%
- API p95 latency < 300ms
- Error rate < 1%
- MTTR target < 60 minutes

Breaching an SLO triggers:
- Incident declaration
- Postmortem
- Backlog action item
- Ownership assignment and prevention action

### 🧪 Error Tracking

- Structured application errors (per service)
- Correlated with logs and metrics
- Alerting on error rate spikes

Tooling is intentionally not fixed (Sentry-compatible).


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

nouveau readme :
## Vault (optional)
Vault is provided as an optional profile for secrets management and experimentation.

### Start monitoring stack (no Vault)
docker compose -f docker-compose.monitoring.yml up -d

### Start monitoring + Vault
docker compose -f docker-compose.monitoring.yml -f docker-compose.vault.yml up -d

### Notes
- Use Vault for secrets, not for application data.
- Prefer external secret managers in production when available.