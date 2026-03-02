# Rollback Procedure

## Purpose

Safely revert a production deployment with minimal downtime.

---

# Preconditions

Rollback allowed only if:
- Incident Commander approves
- Deployment is identified as root cause
- No data migration breaking rollback compatibility

---

# 1. Identify Target Version

- Retrieve previous stable image tag
- Confirm no breaking schema change applied

If migration executed:
- Check if backward compatible
- If not → escalate to CTO

---

# 2. Execution

If Docker Compose:

docker compose pull <previous-tag>
docker compose up -d

If Kubernetes:

kubectl rollout undo deployment/<service>

---

# 3. Database Considerations

Never:
- Roll back DB schema without migration plan
- Restore DB without confirming RPO compliance

If schema change incompatible:
- Switch to degraded mode
- Apply hotfix instead

---

# 4. Verification

- Health endpoint
- Error rate < threshold
- No crash loops
- Logs clean

Monitor for 30 minutes.

---

# 5. Documentation

- Record rollback time
- Record version
- Update incident timeline