#!/bin/bash
set -e

echo "🚀 Starting deploy..."

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
chown -R 1000:1000 "$DATA_DIR"

docker compose up -d

sudo systemctl start ngrok

echo "🚀 Deploy complete"
