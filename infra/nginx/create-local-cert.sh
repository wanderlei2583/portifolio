#!/usr/bin/env sh
set -eu

out_dir="infra/nginx/local-certs"
mkdir -p "$out_dir"

openssl req -x509 -nodes -newkey rsa:2048 -days 365 \
  -keyout "$out_dir/local.key" \
  -out "$out_dir/local.crt" \
  -subj "/CN=localhost"
