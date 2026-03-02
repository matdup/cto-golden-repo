# 🛡️ Monitoring Setup Guide

## 🎯 Overview

Complete observability stack for Tech Factory infrastructure featuring:
- 📊 **Metrics**: Prometheus + Node Exporter
- 📝 **Logs**: Loki + Promtail  
- 🚨 **Alerts**: Alertmanager
- 📈 **Visualization**: Grafana
- 🔔 **Uptime**: Uptime Kuma
- 🔐 **Secrets**: HashiCorp Vault

## 🚀 Quick Start

### 1. Prerequisites

```bash
# Install Docker & Docker Compose
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER
```

Clone the monitoring template
```bash
git clone https://github.com/project-template/monitoring-template
cd monitoring-template
```

### 2. Environment Configuration
Copy and configure environment
```bash
cp .env.example .env
```

Edit .env with your settings
```bash
nano .env
```

Required environment variables:
```env
GRAFANA_ADMIN_PASSWORD=your_secure_password
DOMAIN_NAME=your-monitoring-domain.com
```
Used for reverse proxy and external URLs (Grafana, Alertmanager).

### 3. Deploy Monitoring Stack
Start all services
```bash
docker compose -f docker-compose.monitoring.yml up -d
```

Verify services are running
```bash
docker compose -f docker-compose.monitoring.yml ps
```

### 4. Access Dashboards

- Grafana: http://localhost:3000 (admin/your_password)
- Prometheus: http://localhost:9090
- Alertmanager: http://localhost:9093
- Uptime Kuma: http://localhost:3001
- Vault UI: http://localhost:8300

---

## 🔧 Configuration Details

### Prometheus Targets

Edit prometheus/prometheus.yml to add your application targets:
```yml
- job_name: 'your_app'
  static_configs:
    - targets: ['your-app-server:8080']
  metrics_path: /metrics
  scrape_interval: 30s
```

### Grafana Data Sources

Data sources are auto-configured via provisioning. Check grafana/provisioning/datasources/datasources.yml

### Alert Rules

Modify prometheus/alerting.yml to define custom alerts:
```yml
groups:
- name: instance
  rules:
  - alert: InstanceDown
    expr: up == 0
    for: 5m
    labels:
      severity: critical
    annotations:
      summary: "Instance {{ $labels.instance }} down"
      description: "{{ $labels.instance }} has been down for more than 5 minutes."
```


---


## 🛡️ Security Hardening

### 1. Network Security
Configure host-level firewall rules
```bash
ufw allow 3000/tcp comment 'Grafana'
ufw allow 9090/tcp comment 'Prometheus'
ufw allow 9093/tcp comment 'Alertmanager'
ufw --force enable
```

### 2. SSL/TLS Configuration

Add to docker-compose.monitoring.yml 
Example reverse proxy configuration (simplified). For production, use hardened TLS, restricted ciphers, and automated cert rotation (e.g., Let's Encrypt).
```yml
nginx:
  image: nginx:alpine
  ports:
    - "443:443"
  volumes:
    - ./nginx/nginx.conf:/etc/nginx/nginx.conf
    - ./ssl/:/etc/nginx/ssl/
```

### 3. Authentication

Grafana authentication defaults to enabled (no anonymous access).  
For advanced auth (SSO/OIDC, headers, etc.), mount a `grafana.ini` into the container or configure via environment variables.
```ini
[auth]
disable_login_form = false
[auth.anonymous]
enabled = false
```

---


## 📊 Monitoring Best Practices

### 1. Key Metrics to Monitor

| Metric | Alert Threshold | Description |
|---|---:|---|
| CPU Usage | > 80% for 5m | High CPU utilization |
| Memory Usage | > 90% for 5m | Memory pressure |
| Disk Usage | > 85% | Low disk space |
| Service Uptime | < 1 for 2m | Service down |
| HTTP Errors | > 5% for 5m | High error rate |


### 2. Alerting Strategy

- P1 Critical: Immediate notification (SMS/Slack)
- P2 High: Notification within 15 minutes
- P3 Medium: Daily digest
- P4 Low: Weekly review


### 3. Log Retention

- Application logs: 30 days
- Audit logs: 1 year
- Security logs: 2 years


---


## 🔄 Maintenance

### Daily Checks

- Review alert dashboard
- Check service health
- Verify backup status
- Review security scans


### Weekly Tasks

- Update container images
- Review log patterns
- Check storage usage
- Validate backup restoration


### Monthly Tasks

- Security audit
- Performance review
- Capacity planning
- Documentation update


---


## 🚨 Troubleshooting - Common Issues

### 1 Prometheus not scraping

Check target status
```bash
curl http://localhost:9090/api/v1/targets
```

### 2 Grafana login issues

Reset admin password
```bash
docker exec -it grafana grafana-cli admin reset-admin-password newpassword
```

### 3 High memory usage

Check Prometheus memory
```bash
docker stats prometheus
```


---


## Log Locations

- Prometheus: /var/lib/docker/volumes/prometheus_data
- Grafana: /var/lib/docker/volumes/grafana_data
- Loki: /var/lib/docker/volumes/loki_data


---


## 📞 Support

- 📚 Documentation
- 🐛 Issues
- 💬 Slack
- 🚨 Emergency


---


## 🔗 References

- Prometheus Documentation
- Grafana Documentation
- Loki Documentation
- Alertmanager Documentation


---


# 🔐 Vault – Development Mode vs Production Hardening

## Development Mode (current setup)

This monitoring template runs HashiCorp Vault in development mode by design.

This choice is intentional and provides:
- Fast local setup
- No unseal process
- Single root token
- No TLS
- In-memory or file-based storage
- Minimal operational overhead

⚠️ This mode is NOT suitable for production environments.
It is provided for:
- Local development
- Demos
- CI/CD pipelines
- Documentation and learning purposes


---


## Production Hardening Checklist (Vault)

The following checklist outlines minimum requirements to run Vault securely in production.

### 1. Vault Server Mode
- Disable -dev mode
- Run Vault in server mode
- Enable persistent storage (Raft recommended)

### 2. Storage Backend
- Use Raft integrated storage or an external backend
- Enable regular snapshot backups
- Restrict filesystem permissions

### 3. Initialization & Unseal
- Initialize Vault once (vault operator init)
- Store unseal keys securely (HSM, KMS, offline storage)
- Use auto-unseal when possible (AWS KMS, GCP KMS, Azure Key Vault)

### 4. Authentication Methods
- Disable root token usage
- Use one or more auth methods:
- AppRole
- Kubernetes Auth
- OIDC / SSO
- Enforce short-lived tokens

### 5. Policies & Access Control
- Define least-privilege policies
- Separate read/write/admin roles
- Enable audit logging

### 6. Transport Security
- Enable TLS (native or via reverse proxy)
- Enforce HTTPS-only access
- Rotate certificates regularly

### 7. Secrets Management
- Avoid static secrets when possible
- Use dynamic secrets (DB, cloud credentials)
- Enforce TTLs and rotation

### 8. Operational Controls
- Enable audit devices
- Monitor Vault health and seal status
- Restrict network access (private subnet, firewall)


---


## Recommendation

For production environments, Vault should be deployed outside of the monitoring stack,
as a dedicated, highly available security component, integrated with applications via:
- Vault Agent
- Sidecars
- CI/CD secret injection