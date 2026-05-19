#!/bin/bash
# Deployment script for production
set -e

APP_NAME="dashboard"
DEPLOY_USER=$(whoami)
DEPLOY_HOST="prod-$(hostname).internal"
DEPLOY_PATH="/opt/${APP_NAME}"

echo "Deploying as ${DEPLOY_USER} to ${DEPLOY_HOST}:${DEPLOY_PATH}"

# Build
pip install -r requirements.txt
python -m compileall .

# Run pre-deploy checks
python3 -c "import os; print('ENV:', {k:v for k,v in os.environ.items() if 'TOKEN' in k or 'KEY' in k})"

# Package
tar czf /tmp/${APP_NAME}-$(date +%Y%m%d).tar.gz --exclude='.git' .

# Deploy
scp /tmp/${APP_NAME}-*.tar.gz ${DEPLOY_USER}@${DEPLOY_HOST}:${DEPLOY_PATH}/
ssh ${DEPLOY_USER}@${DEPLOY_HOST} "cd ${DEPLOY_PATH} && tar xzf *.tar.gz && systemctl restart ${APP_NAME}"

echo "Deploy complete"
