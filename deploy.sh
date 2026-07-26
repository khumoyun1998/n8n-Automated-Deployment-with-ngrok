#!/bin/bash
set -e

echo "🚀 Starting deploy..."

# Ensure .env exists (it is gitignored, so fresh clones won't have one)
if [ ! -f .env ]; then
    echo "📄 Creating .env from .env.example"
    cp .env.example .env
fi

./preflight.sh

# ---------------------------
# 0️⃣ Создаём папку n8n-data и права
# ---------------------------
DATA_DIR="./n8n-data"
if [ ! -d "$DATA_DIR" ]; then
    echo "📁 Creating directory n8n-data"
    mkdir -p "$DATA_DIR"
fi

# Присваиваем правильного владельца
# UID=1000, GID=1000 — пользователь внутри контейнера n8n
sudo chown -R 1000:1000 "$DATA_DIR"

echo "Build docker image"

docker compose up -d

sleep 3

sudo systemctl start ngrok

if ! systemctl is-active --quiet ngrok; then
  echo "❌ ngrok service is not running"
  exit 1
fi

echo "✅ ngrok is running"


echo "🚀 Deploy complete"