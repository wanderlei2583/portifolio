Como habilitar HTTPS com Let's Encrypt

1) Suba os serviços base
   docker compose -f infra/compose.yml up -d

2) Emita o certificado (bootstrap HTTP)
   scripts/issue-cert.sh example.com seu@email.com

3) Atualize o arquivo `infra/nginx/reverse-proxy.conf`
   - Troque `example.com` pelo seu domínio no bloco SSL.

4) Recarregue o Nginx
   docker compose -f infra/compose.yml restart reverse-proxy

Renovação automática
- Execute a renovação via cron/CI:
  scripts/renew-cert.sh

HTTPS local (certificado self-signed)
1) Gerar o certificado local
   infra/nginx/create-local-cert.sh

2) Subir com override local
   docker compose -f infra/compose.yml -f infra/compose.local.yml up -d

3) Aceite o certificado no navegador
