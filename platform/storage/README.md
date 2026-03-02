# Storage

This folder documents object storage usage (S3/MinIO/OVH Object Storage).

Goals:
- backups storage
- audit log archival (growth/compliance)
- long-lived exports

Never store secrets in object storage.
Use server-side encryption and lifecycle rules.