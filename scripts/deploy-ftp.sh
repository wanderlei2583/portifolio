#!/usr/bin/env sh
set -eu

load_env() {
  if [ ! -f ".env.deploy" ]; then
    return
  fi

  while IFS= read -r line || [ -n "$line" ]; do
    case "$line" in
      ''|\#*) continue ;;
    esac

    key=${line%%=*}
    val=${line#*=}

    case "$key" in
      FTP_HOST) FTP_HOST=$val ;;
      FTP_USER) FTP_USER=$val ;;
      FTP_PASS) FTP_PASS=$val ;;
      FTP_DIR) FTP_DIR=$val ;;
      FTP_PORT) FTP_PORT=$val ;;
    esac
  done < ./.env.deploy
}

load_env

if [ -z "${FTP_HOST:-}" ] || [ -z "${FTP_USER:-}" ] || [ -z "${FTP_PASS:-}" ] || [ -z "${FTP_DIR:-}" ]; then
  echo "Variaveis obrigatorias: FTP_HOST, FTP_USER, FTP_PASS, FTP_DIR (defina em .env.deploy)"
  exit 1
fi

cd apps/frontend
bun install
bun run build
cd ../..

if ! command -v lftp >/dev/null 2>&1; then
  echo "lftp nao encontrado. Instale com: sudo apt install lftp"
  exit 1
fi

host_url="ftp://$FTP_HOST"
if [ -n "${FTP_PORT:-}" ]; then
  host_url="ftp://$FTP_HOST:$FTP_PORT"
fi

echo ">> Testando conexao FTP..."
lftp -e "set net:max-retries 1; set net:timeout 10; set ssl:verify-certificate no; set ftp:ssl-allow yes; ls $FTP_DIR; bye" \
  -u "$FTP_USER","$FTP_PASS" "$host_url"

echo ">> Enviando arquivos..."
lftp -e "set ssl:verify-certificate no; set ftp:ssl-allow yes; mirror -R --delete --verbose apps/frontend/dist/ $FTP_DIR; bye" \
  -u "$FTP_USER","$FTP_PASS" "$host_url"
