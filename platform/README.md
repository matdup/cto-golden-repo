# Platform

`platform/` contains **technical platform capabilities** shared across applications:
- Monitoring & observability (metrics, logs, alerts)
- Security tooling & policies (secret scanning, SBOM, vuln scanning)
- Auth integration blueprints (managed-first, self-hosted later)
- Data plane baselines (Postgres, Redis)
- Storage patterns (S3/MinIO/OVH Object Storage)
- Performance tooling (k6)

This directory is **not process** (that lives in `governance/` and `ops-runbooks/`).
It is implementation-oriented and can be mounted/used by apps and infra.

## Activation model
- 🟢 MVP: monitoring/, security/, data/postgres/
- 🟡 Growth: alertmanager/, perf/k6/, redis/
- 🔴 Scale: advanced auth, distributed tracing, hardened secrets management