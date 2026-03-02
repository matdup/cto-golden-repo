# Security Incident Response

## Purpose

Handle confirmed or suspected security breach.

---

# 1. Incident Types

- Credential leak
- Data breach
- Unauthorized access
- Supply-chain compromise
- Infrastructure compromise

---

# 2. Immediate Actions (T+0)

- Contain exposure
- Revoke credentials
- Rotate secrets
- Disable compromised accounts
- Isolate affected systems

---

# 3. Preserve Evidence

- Do NOT delete logs
- Snapshot affected systems
- Preserve access logs
- Archive relevant CI artifacts

Evidence retention minimum: 1 year

---

# 4. Assess Impact

- Data tier affected (see data-classification.md)
- Number of users impacted
- Regulatory reporting requirement?

If Tier 3 data exposed:
- Immediate CTO escalation
- Legal review required

---

# 5. Remediation

- Patch vulnerability
- Redeploy services
- Validate fix
- Monitor closely

---

# 6. Communication

Internal:
- Immediate notification

External:
- Only after verified facts
- Legal review mandatory

---

# 7. Post-Incident Review

Must include:
- Root cause
- Control failure
- Control improvement
- Timeline

---

# 8. Prevention

After incident:
- Update CI rules
- Update scanning policies
- Add monitoring if missing
- Update risk-matrix.md