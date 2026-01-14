# **Project Name:** n8n Automated Deployment with ngrok

## **Project Description**

This project provides a **ready-to-deploy automation workflow platform using n8n**, fully configured to run in Docker with **ngrok integration** for public URLs. It includes scripts and configuration for **easy installation, deployment, and updates**, ensuring a **production-ready setup** with logging, automatic webhook updates, and secure data handling.

---

## **Key Features**

* **Dockerized n8n**: Runs n8n in Docker for easy portability and consistent environment.
* **ngrok Integration**: Automatically exposes n8n to a public URL using ngrok.
* **Automatic Webhook Update**: A script updates webhook URLs every time ngrok starts or restarts.
* **Systemd Service for ngrok**: Ensures ngrok runs in the background and restarts automatically on server reboot.
* **Log Management**: All logs are written to files with logrotate configured to manage log rotation and prevent disk overflow.
* **Idempotent Installation**: `install_ngrok.sh` sets up ngrok, systemd service, logrotate, and folders for n8n data.
* **One-command Deployment**: `deploy.sh` starts ngrok, updates webhooks, and runs `docker-compose up -d`.
* **n8n Data Management**: Ensures the `n8n-data` folder exists with proper permissions, preventing container startup errors.
* **Git-based Updates**: Project can be easily updated on any server via `git pull` + `deploy.sh`.

---

## **Directory Structure**

```
my-n8n-project/
├─ docker-compose.yml
├─ .env                  # Environment variables
├─ install_ngrok.sh      # First-time installation script
├─ deploy.sh             # Deployment script
├─ update-ngrok-webhook.sh  # Updates n8n webhook with current ngrok URL
├─ ngrok.yml             # ngrok configuration
├─ n8n-data/             # Persistent n8n data folder (ignored in Git)
├─ Makefile (optional)   # Optional convenience commands
└─ README.md
```

---

## **Installation & Deployment**

```bash
# Clone project
git clone git@github.com:youruser/my-n8n-project.git

# First-time setup
sudo ./install_ngrok.sh

# Create n8n-data folder with proper permissions
mkdir -p ./n8n-data
chown -R 1000:1000 ./n8n-data

# Initial deployment
./deploy.sh
```
---

## **Requirements**

* Linux server (Ubuntu/Debian recommended)
* Docker & Docker Compose installed
* ngrok account (for authtoken)
* Git installed

---

## **Benefits**

* Easy, **repeatable deployment** on any server
* Logs automatically rotated and managed
* ngrok tunnels are persistent and webhooks auto-updated
* Safe updates through Git integration

---

If you want, I can also write a **shorter, “GitHub-ready README” version** that’s **catchy and professional**, including badges, prerequisites, and quick start instructions.

Do you want me to do that?
