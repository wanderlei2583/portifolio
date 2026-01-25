#!/usr/bin/env sh
set -eu

compose_file="infra/compose.yml"

docker compose -f "$compose_file" run --rm certbot renew --webroot -w /var/www/certbot
docker compose -f "$compose_file" restart reverse-proxy
