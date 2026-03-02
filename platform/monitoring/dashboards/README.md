# Dashboards

Place Grafana dashboards here.

Rules:
- File naming: `service-name.overview.json`
- Title must include environment context where relevant
- Dashboards must avoid hardcoded datasource UIDs (use provisioning names)

After adding a dashboard:
- Ensure it loads via provisioning
- Ensure panels use valid PromQL/logQL