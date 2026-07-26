#!/bin/bash
set -e

echo "🚀 Starting deploy..."

# Ensure .env exists (it is gitignored, so fresh clones won't have one)
if [ ! -f .env ]; then
    echo "📄 Creating .env from .env.example"
    cp .env.example .env
fi

# ---------------------------
# Fill .env from the static domain in ngrok.yml (single source of truth).
# With a reserved ngrok domain the public URL never changes, so there is
# no need to query the ngrok API or restart n8n on every tunnel start.
# ---------------------------
STATIC_DOMAIN=$(grep -E '^[[:space:]]*domain:' ngrok.yml | awk '{print $2}')
if [ -z "$STATIC_DOMAIN" ] || echo "$STATIC_DOMAIN" | grep -q "YOUR_STATIC_DOMAIN"; then
    echo "❌ Set your reserved static domain in ngrok.yml (domain: ...) first"
    exit 1
fi
PUBLIC_URL="https://$STATIC_DOMAIN"
echo "🌐 Public URL: $PUBLIC_URL"
sed -i.bak \
    -e "s|^WEBHOOK_URL=.*|WEBHOOK_URL=$PUBLIC_URL|" \
    -e "s|^N8N_EDITOR_BASE_URL=.*|N8N_EDITOR_BASE_URL=$PUBLIC_URL|" \
    -e "s|^N8N_HOST=.*|N8N_HOST=$STATIC_DOMAIN|" \
    .env
rm -f .env.bak

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