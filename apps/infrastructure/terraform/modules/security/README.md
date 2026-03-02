# 🔐 Security Baseline

This module defines:

- Network security groups
- Least-privilege IAM roles
- SSH restriction policies
- Audit logging configuration

Rules:

- No 0.0.0.0/0 SSH in production
- Encrypted volumes mandatory
- Database not publicly accessible
- Monitoring always enabled