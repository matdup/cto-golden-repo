# Grafana

Grafana is provisioned automatically via `provisioning/`.

- `provisioning/datasources/`: Prometheus datasource
- `provisioning/dashboards/`: dashboard provider
- `dashboards/`: dashboard JSON files mounted read-only

Security defaults:
- anonymous disabled
- signup disabled
- admin password from env