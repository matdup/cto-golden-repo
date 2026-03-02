# Postgres (Data Plane)

This folder contains initialization scripts and backup helpers.

- init-scripts/: schema/bootstrap scripts
- backup-scripts/: backup/restore automation

All scripts must be:
- idempotent where possible
- safe defaults
- environment-driven (no secrets committed)