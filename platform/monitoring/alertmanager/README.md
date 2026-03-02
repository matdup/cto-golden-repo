# Alertmanager (Growth)

Alertmanager is optional until you need routing/notifications.

## Goals
- Route alerts by severity/team/service
- Reduce noise (grouping + inhibition)
- Deliver notifications (Slack/email/pager)

## Required labels on alerts
- severity: critical|warning|info
- owner: team name or on-call group
- runbook_url: link to runbook in `platform/monitoring/runbooks/`

## Environment
- SLACK_WEBHOOK_URL (secret)
- ALERTS_SLACK_CHANNEL (default #alerts)

## Change policy
This file is production-impacting.
Any change requires PR review by platform owner.