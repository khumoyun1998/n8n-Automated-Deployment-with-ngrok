#!/bin/bash

ENV_FILE=".env"
SERVICE_NAME="n8n"
NGROK_API="http://127.0.0.1:4040/api/tunnels"

# Get current ngrok public URL
NEW_URL=$(curl -s $NGROK_API | jq -r '.tunnels[] | select(.proto=="https") | .public_url')

if [ -z "$NEW_URL" ] || [ "$NEW_URL" == "null" ]; then
  echo "❌ Could not fetch ngrok URL"
  exit 1
fi

echo "✅ New ngrok URL: $NEW_URL"

# Update .env file
sed -i.bak "s|^WEBHOOK_URL=.*|WEBHOOK_URL=$NEW_URL|" $ENV_FILE
sed -i.bak "s|^N8N_EDITOR_BASE_URL=.*|N8N_EDITOR_BASE_URL=$NEW_URL|" $ENV_FILE

# Restart n8n container
docker-compose restart

#echo "🚀 n8n restarted with new WEBHOOK_URL"
