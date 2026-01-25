# Deploy no Raspberry Pi (Ubuntu Server em casa)

Guia para rodar o projeto no seu servidor residencial (Raspberry Pi), com segurança e acesso via Cloudflare.

## 1) Pré‑requisitos
- Ubuntu Server no Raspberry Pi (arm64)
- Docker + Docker Compose
- Chave SSH (sem senha)
- Firewall (UFW)
- IP público com redirecionamento de portas (no roteador)

## 2) Hardening básico
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

## 3) Port‑forward no roteador
No roteador, redirecione:
- TCP 80 → IP interno do Raspberry
- TCP 443 → IP interno do Raspberry

Se você **não tiver IP fixo**, use **Cloudflare Tunnel** (recomendado).

## 4) DNS no Cloudflare
### Opção A — IP público + port‑forward
- A record:
  - Nome: `@`
  - IP: IP público
  - Proxy: Proxied (laranja)

### Opção B — Cloudflare Tunnel (mais seguro)
- Instale `cloudflared` no Raspberry.
- Crie o tunnel e aponte para o reverse‑proxy local.

## 5) Clonar e configurar
```bash
git clone https://github.com/wanderlei2583/SEU_REPO.git
cd portifolio
cp .env.example .env
```

No `.env`:
```
ALLOWED_ORIGINS=https://wrtoriama.dev.br,https://www.wrtoriama.dev.br
```

## 6) TLS
### Let’s Encrypt (exige portas 80/443 abertas)
```bash
make cert-issue DOMAIN=wrtoriama.dev.br EMAIL=wanderlei@tutamail.com
```

### Cloudflare Origin Certificate (recomendado em casa)
No painel Cloudflare:
- SSL/TLS → Origin Server → Create Certificate
- Salve cert/key no Raspberry
- Ajuste o Nginx para usar esses arquivos

## 7) Subir stack
```bash
make up
```

## 8) Checklist de segurança
- SSH sem senha
- UFW ativo
- Portas 80/443 apenas
- CORS restrito
- TLS Full (strict) no Cloudflare
- Backups e atualizações

## 9) Renovação
```bash
make cert-renew
```
