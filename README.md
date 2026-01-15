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
* **Idempotent Installation**: `install_ngrok.sh` sets up ngrok, systemd service, logrotate.
* **One-command Deployment**: `deploy.sh` starts ngrok, updates webhooks, and runs `docker-compose up -d`.
* **n8n Data Management**: Ensures the `n8n-data` folder exists with proper permissions, preventing container startup errors.
---

## **Directory Structure**

```
n8n-Automated-Deployment-with-ngrok/
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
git clone https://github.com/khumoyun1998/n8n-Automated-Deployment-with-ngrok.git

# First-time setup
sudo ./install_ngrok.sh

# Initial deployment
./deploy.sh
```

#### or

```bash
# Clone project
git clone https://github.com/khumoyun1998/n8n-Automated-Deployment-with-ngrok.git

make up
```
---
##### PS : Do not add your auth token from ngrok account to ngrok.yml file

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
---
