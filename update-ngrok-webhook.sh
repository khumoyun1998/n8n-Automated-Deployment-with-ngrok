#!/bin/bash
set -e

sleep 10

ENV_FILE=".env"
NGROK_API="http://127.0.0.1:4040/api/tunnels"

# Get current ngrok public URL
NEW_URL=$(curl -s $NGROK_API | jq -r '.tunnels[] | select(.proto=="https") | .public_url')

if [ -z "$NEW_URL" ] || [ "$NEW_URL" == "null" ]; then
  echo "❌ Could not fetch ngrok URL"
  exit 1
fi

# Host without protocol (e.g. abcd-1-2-3.ngrok-free.app)
NEW_HOST=${NEW_URL#https://}

# Update .env file
sed -i.bak \
  -e "s|^WEBHOOK_URL=.*|WEBHOOK_URL=$NEW_URL|" \
  -e "s|^N8N_EDITOR_BASE_URL=.*|N8N_EDITOR_BASE_URL=$NEW_URL|" \
  -e "s|^N8N_HOST=.*|N8N_HOST=$NEW_HOST|" \
  "$ENV_FILE"
rm -f "${ENV_FILE}.bak"

# Restart n8n container to pick up the new URL
docker compose restart

echo "🚀 n8n restarted with new WEBHOOK_URL"

SET_GREEN=$(tput setaf 2)
SET_BOLD=$(tput bold)
RESET=$(tput sgr0)

echo "${SET_GREEN}✅ New ngrok URL: ${SET_BOLD}$NEW_URL${RESET}"
