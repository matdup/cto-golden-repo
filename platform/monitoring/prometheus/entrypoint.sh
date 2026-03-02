#!/bin/sh
set -eu

ARGS="--config.file=/etc/prometheus/prometheus.yml \
--storage.tsdb.path=/prometheus \
--web.console.libraries=/etc/prometheus/console_libraries \
--web.console.templates=/etc/prometheus/consoles \
--storage.tsdb.retention.time=${PROMETHEUS_RETENTION:-30d}"

if [ "${PROMETHEUS_ENABLE_LIFECYCLE:-false}" = "true" ]; then
  ARGS="$ARGS --web.enable-lifecycle"
fi

if [ "${PROMETHEUS_ENABLE_ADMIN_API:-false}" = "true" ]; then
  ARGS="$ARGS --web.enable-admin-api"
fi

exec /bin/prometheus $ARGS