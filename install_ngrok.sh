#!/bin/bash
set -e

if command -v ngrok >/dev/null 2>&1; then
  echo "✅ ngrok already installed"
else
  echo "📦 Installing ngrok..."

  curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc \
    | sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null

  echo "deb https://ngrok-agent.s3.amazonaws.com buster main" \
    | sudo tee /etc/apt/sources.list.d/ngrok.list

  sudo apt update
  sudo apt install ngrok -y
fi

CONFIG_PATH="/etc/ngrok/ngrok.yml"
SERVICE_PATH="/etc/systemd/system/ngrok.service"

if [ ! -f "$CONFIG_PATH" ]; then
  echo "⚙️ Installing ngrok config"
  sudo mkdir -p /etc/ngrok
  sudo cp ngrok.yml $CONFIG_PATH
fi

if [ ! -f "$SERVICE_PATH" ]; then
  echo "🛠 Installing systemd service"
  sudo cp ngrok.service $SERVICE_PATH
  sudo systemctl daemon-reload
  sudo systemctl enable ngrok
fi

LOG_DIR="/var/log/ngrok"
sudo mkdir -p "$LOG_DIR"
sudo chown root:adm "$LOG_DIR"

LOGROTATE_PATH="/etc/logrotate.d/ngrok"
if [ ! -f "$LOGROTATE_PATH" ]; then
    echo "🌀 Configurating logrotate..."
    cp ngrok.logrotate.config "$LOGROTATE_PATH"
fi
echo "✅ ngrok ready"

