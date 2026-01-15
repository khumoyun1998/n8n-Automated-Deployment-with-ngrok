#!/bin/bash
set -e

command -v docker >/dev/null || { echo "❌ Docker missing"; exit 1; }
docker-compose version >/dev/null || { echo "❌ Compose missing"; exit 1; }

systemctl is-active --quiet docker || {
  echo "❌ Docker not running"
  exit 1
}

if ! systemctl is-active --quiet ngrok; then
  echo "❌ ngrok service is not running"
  exit 1
fi

echo "✅ Preflight checks passed"
