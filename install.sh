#!/bin/bash
set -e

echo "🔧 Initial server setup"

### ROOT CHECK
if [ "$EUID" -ne 0 ]; then
  echo "Run as root"
  exit 1
fi

### DOCKER
if ! command -v docker &>/dev/null; then
  echo "🐳 Installing Docker"
  apt update
  apt install -y ca-certificates curl gnupg lsb-release

  curl -fsSL https://get.docker.com | sh
  systemctl enable docker
  systemctl start docker
else
  echo "✅ Docker already installed"
fi

### DOCKER COMPOSE
if ! docker compose version &>/dev/null; then
  echo "📦 Installing docker-compose plugin"
  mkdir -p /usr/local/lib/docker/cli-plugins
  curl -SL https://github.com/docker/compose/releases/download/v2.25.0/docker-compose-linux-x86_64 \
    -o /usr/local/lib/docker/cli-plugins/docker-compose
  chmod +x /usr/local/lib/docker/cli-plugins/docker-compose
else
  echo "✅ Docker Compose already installed"
fi

echo "✅ Docker ready"

### NGROK
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
PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"

if [ ! -f "$CONFIG_PATH" ]; then
  echo "⚙️ Installing ngrok config"
  sudo mkdir -p /etc/ngrok
  sudo cp ngrok.yml $CONFIG_PATH
fi

if [ ! -f "$SERVICE_PATH" ]; then
  echo "🛠 Installing systemd service"
  sed "s|{{PROJECT_DIR}}|$PROJECT_DIR|g" ngrok.service.template
  sudo cp ngrok.service $SERVICE_PATH
  sudo systemctl daemon-reload
  sudo systemctl enable ngrok
fi

echo "✅ ngrok ready"

### LOGROTATE
if ! command -v logrotate &>/dev/null; then
  echo "🌐 Installing logrotate"
  apt install -y logrotate
else
  echo "✅ logrotate already installed"
fi

LOG_DIR="/var/log/ngrok"
sudo mkdir -p "$LOG_DIR"
sudo chown root:adm "$LOG_DIR"

LOGROTATE_PATH="/etc/logrotate.d/ngrok"
if [ ! -f "$LOGROTATE_PATH" ]; then
    echo "🌀 Configurating logrotate..."
    cp ngrok.logrotate.config "$LOGROTATE_PATH"
fi

echo "✅ logrotate ready"