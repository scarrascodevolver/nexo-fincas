#!/usr/bin/env bash
# Sube la web pública (carpeta site/) al VPS, donde la sirve el Caddy del ERP (ver nexo-erp/docker/caddy/Caddyfile.prod).
# Uso: deploy/deploy-web.sh
set -euo pipefail
HOST=${DEPLOY_HOST:-deploy@178.104.147.16}
DIR=${DEPLOY_WEB_DIR:-/opt/nexo-web}

cd "$(dirname "$0")/.."
ssh "$HOST" "sudo mkdir -p $DIR && sudo chown \$(id -u):\$(id -g) $DIR"
rsync -az --delete --exclude '.DS_Store' site/ "$HOST:$DIR/"
echo "==> Web subida a $HOST:$DIR ($(git rev-parse --short HEAD))"
