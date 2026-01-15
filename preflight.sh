#!/bin/bash
set -e

command -v docker >/dev/null || { echo "❌ Docker missing"; exit 1; }
docker compose version >/dev/null || { echo "❌ Compose missing"; exit 1; }

systemctl is-active --quiet docker || {
  echo "❌ Docker not running"
  exit 1
}


echo "✅ Preflight checks passed"
