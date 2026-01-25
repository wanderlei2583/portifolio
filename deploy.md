# Deploy com Cloudflare (wrtoriama.dev.br)

Guia completo para publicar em um VPS Linux com Docker e Cloudflare, priorizando segurança.

## 1) Pré‑requisitos
- VPS Linux (Ubuntu 22.04+ ou Debian 12)
- Docker + Docker Compose
- Chave SSH (sem login por senha)
- Firewall (UFW)
- Domínio no Cloudflare

## 2) Hardening básico do servidor
```bash
sudo apt update && sudo apt upgrade -y
sudo adduser deployer
sudo usermod -aG sudo deployer
sudo usermod -aG docker deployer

sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo systemctl restart ssh
```

### Firewall
```bash
sudo ufw allow OpenSSH
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw enable
sudo ufw status
```

## 3) DNS no Cloudflare
- A record:
  - Nome: `@`
  - IP: IP do VPS
  - Proxy: Proxied (laranja)
- CNAME:
  - Nome: `www`
  - Destino: `wrtoriama.dev.br`
  - Proxy: Proxied

## 4) Clonar e configurar
```bash
git clone https://github.com/wanderlei2583/SEU_REPO.git
cd portifolio
cp .env.example .env
```

No `.env`, configure:
```
ALLOWED_ORIGINS=https://wrtoriama.dev.br,https://www.wrtoriama.dev.br
```

## 5) TLS (Let’s Encrypt)
```bash
make cert-issue DOMAIN=wrtoriama.dev.br EMAIL=wanderlei@tutamail.com
```

## 6) Subir stack
```bash
make up
```

## 7) Cloudflare SSL/TLS
- Modo: **Full (strict)**
- HSTS: **Ativado**
- Always Use HTTPS: **Ativado**
- Minimum TLS: **1.2** ou **1.3**

## 8) Checklist de segurança
- SSH sem senha
- UFW ativo (22/80/443)
- CORS restrito no `.env`
- TLS Full (strict)
- HSTS ativo
- Rate limiting no Nginx
- Certificados renovando
- Sistema atualizado

## 9) Renovação
```bash
make cert-renew
```
