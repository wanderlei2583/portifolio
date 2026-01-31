# Deploy na HostGator (cPanel) – domínio devwander.com.br

Este guia cobre o **deploy completo do frontend** (Astro) em hospedagem compartilhada HostGator e orienta como manter o backend em outro serviço (VPS/Render/Railway), já que cPanel **não suporta Docker/Go** diretamente.

## 1) O que será publicado na HostGator
- **Frontend estático** (Astro build → arquivos HTML/CSS/JS).
- **Backend** deve ficar **fora** da HostGator (VPS/Render/Railway/Cloud Run).

## 2) Ajustes no projeto antes do build
1) Atualize CORS do backend (se usar backend externo):
```
ALLOWED_ORIGINS=https://devwander.com.br,https://www.devwander.com.br
```

2) (Opcional) se houver URL da API no frontend, aponte para o backend real.

## 3) Build do frontend
No seu PC:
```bash
cd apps/frontend
bun install
bun run build
```

O build gera a pasta:
```
apps/frontend/dist
```

## 4) Enviar arquivos para a HostGator
### Opção A — cPanel File Manager
1) Acesse o cPanel.
2) File Manager → `public_html/`
3) Apague arquivos antigos (se houver).
4) Faça upload de **todo o conteúdo de `dist/`** para `public_html/`.

### Opção B — FTP
1) Crie um usuário FTP no cPanel.
2) Envie o conteúdo de `apps/frontend/dist/` para `public_html/`.

## 5) SSL no cPanel
1) cPanel → **SSL/TLS Status**
2) Ative o **AutoSSL** para `devwander.com.br` e `www.devwander.com.br`.
3) Aguarde a emissão e confirme o cadeado no navegador.

## 6) Forçar HTTPS e redirecionar WWW
Crie um arquivo `.htaccess` em `public_html/` com:
```
RewriteEngine On

# Força HTTPS
RewriteCond %{HTTPS} !=on
RewriteRule ^ https://%{HTTP_HOST}%{REQUEST_URI} [L,R=301]

# Redireciona www -> sem www (opcional)
RewriteCond %{HTTP_HOST} ^www\.devwander\.com\.br$ [NC]
RewriteRule ^(.*)$ https://devwander.com.br/$1 [L,R=301]
```

## 7) Headers de segurança (Apache)
Se o módulo `headers` estiver ativo, adicione no `.htaccess`:
```
Header always set X-Content-Type-Options "nosniff"
Header always set X-Frame-Options "DENY"
Header always set Referrer-Policy "no-referrer"
Header always set Permissions-Policy "geolocation=(), microphone=(), camera=(), payment=()"
Header always set Content-Security-Policy "default-src 'self'; img-src 'self' data:; style-src 'self' 'unsafe-inline'; script-src 'self' 'unsafe-inline'; connect-src 'self' https://api.seu-backend.com; object-src 'none'; base-uri 'self'; frame-ancestors 'none'"
```
Se algum header quebrar o site, remova e teste novamente.

## 8) Backend (API) usando subdomínio dedicado
Como a HostGator não suporta Go/Docker em shared hosting:
- Suba o backend em um VPS/Render/Railway.
- Use o subdomínio **`api.devwander.com.br`** exclusivamente para a API.
- No Cloudflare, crie um **A record** para o IP do backend (ou CNAME se usar plataforma gerenciada).
- Atualize o frontend para consumir `https://api.devwander.com.br`.

## 9) Cloudflare Tunnel (alternativa ao IP público)
Se você não quiser expor o IP do backend:
1) Instale `cloudflared` no servidor do backend.
2) Autentique:
```
cloudflared tunnel login
```
3) Crie o tunnel:
```
cloudflared tunnel create devwander-api
```
4) Crie o arquivo `~/.cloudflared/config.yml`:
```
tunnel: devwander-api
credentials-file: /home/seu-usuario/.cloudflared/devwander-api.json

ingress:
  - hostname: api.devwander.com.br
    service: http://localhost:8080
  - service: http_status:404
```
5) Suba o tunnel:
```
cloudflared tunnel run devwander-api
```
6) No Cloudflare → DNS, crie o registro CNAME automático:
```
cloudflared tunnel route dns devwander-api api.devwander.com.br
```

## 10) Ajuste do .htaccess (cPanel)
Se o seu cPanel permitir, use este `.htaccess` em `public_html/`:
```
RewriteEngine On

# Força HTTPS
RewriteCond %{HTTPS} !=on
RewriteRule ^ https://%{HTTP_HOST}%{REQUEST_URI} [L,R=301]

# Redireciona www -> sem www
RewriteCond %{HTTP_HOST} ^www\.devwander\.com\.br$ [NC]
RewriteRule ^(.*)$ https://devwander.com.br/$1 [L,R=301]

# Bloqueia arquivos sensíveis
<FilesMatch "\\.(env|log|ini|bak|sql|sh|yml|yaml)$">
    Require all denied
</FilesMatch>
```

## 11) Checklist de segurança
- HTTPS ativo (AutoSSL)
- Redireciono HTTP → HTTPS
- CORS restrito no backend
- Headers de segurança no `.htaccess`
- DNS com registros corretos
- Backups periódicos

## 12) Teste final
1) Acesse `https://devwander.com.br`
2) Verifique se o conteúdo carregou corretamente.
3) Teste rotas da API (se houver).
