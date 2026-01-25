#!/usr/bin/env sh
set -eu

domain="${1:-}"
email="${2:-}"
if [ -z "$domain" ] || [ -z "$email" ]; then
  echo "Uso: scripts/issue-cert.sh dominio email"
  exit 1
fi

compose_base="infra/compose.yml"
compose_bootstrap="infra/compose.bootstrap.yml"

docker compose -f "$compose_base" -f "$compose_bootstrap" up -d reverse-proxy

docker compose -f "$compose_base" run --rm certbot \
  certonly --webroot -w /var/www/certbot \
  -d "$domain" -d "www.$domain" \
  --email "$email" --agree-tos --no-eff-email

docker compose -f "$compose_base" up -d reverse-proxy
