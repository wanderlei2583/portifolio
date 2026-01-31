# =========================================================
# Projeto : wrtoriama.dev.br
# Perfil  : Production-grade monorepo
# Stack   : Astro + Bun | Go | Docker | Cloudflare | CI/CD
# =========================================================

# -------------------------
# Identidade
# -------------------------
PROJECT_NAME := wrtoriama
VERSION      := $(shell git describe --tags --abbrev=0 2>/dev/null || echo "0.1.0")
COMMIT       := $(shell git rev-parse --short HEAD)
DATE         := $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")

# -------------------------
# Registry / Imagens
# -------------------------
REGISTRY     := ghcr.io
REPO_URL     := $(shell git config --get remote.origin.url 2>/dev/null)
REPO         := $(shell echo "$(REPO_URL)" | sed -E 's#.*/([^/]+/[^/.]+)(\.git)?#\1#' | tr '[:upper:]' '[:lower:]')
ifeq ($(REPO),)
	REPO := appuser/wrtoriama
endif

FRONTEND_IMG := $(REGISTRY)/$(REPO)-frontend
BACKEND_IMG  := $(REGISTRY)/$(REPO)-backend

# -------------------------
# Paths
# -------------------------
FRONT_DIR    := apps/frontend
BACK_DIR     := apps/backend
COMPOSE_FILE := infra/compose.yml
ENV_FILE     := .env

# -------------------------
# Defaults
# -------------------------
.DEFAULT_GOAL := help
.PHONY: help

help:
	@echo ""
	@echo "== COMANDOS DISPONÍVEIS =="
	@echo ""
	@echo "Bootstrap:"
	@echo "  make setup              Setup inicial"
	@echo ""
	@echo "Qualidade:"
	@echo "  make lint               Lint geral"
	@echo "  make test               Testes backend"
	@echo "  make check              Lint + Test"
	@echo ""
	@echo "Build:"
	@echo "  make build              Build local"
	@echo "  make docker-build       Build imagens Docker"
	@echo ""
	@echo "Release:"
	@echo "  make release PATCH=1    Release semântico (PATCH|MINOR|MAJOR)"
	@echo ""
	@echo "Runtime:"
	@echo "  make up                 Subir stack"
	@echo "  make up-dev             Subir stack (build local)"
	@echo "  make logs-dev           Logs do stack local"
	@echo "  make down               Derrubar stack"
	@echo "  make logs               Logs"
	@echo "  make status             Status + healthcheck"
	@echo ""
	@echo "Cloudflare:"
	@echo "  make tunnel             Subir Cloudflare Tunnel"
	@echo ""
	@echo "TLS/Certificados:"
	@echo "  make cert-issue DOMAIN=...   Emitir certificado (Let's Encrypt)"
	@echo "  make cert-renew              Renovar certificado"
	@echo "  make cert-local              Gerar certificado local (self-signed)"
	@echo "  make up-bootstrap            Subir proxy em HTTP (bootstrap)"
	@echo "  make up-local                Subir stack com HTTPS local"
	@echo ""
	@echo "Deploy:"
	@echo "  make deploy             Deploy produção"
	@echo ""
	@echo "Higiene:"
	@echo "  make clean              Limpeza geral"
	@echo ""
	@echo "Deploy (FTP):"
	@echo "  make deploy-ftp         Build e envia via FTP"
	@echo ""

# =========================================================
# Bootstrap
# =========================================================
setup:
	@echo ">> Setup inicial"
	cd $(FRONT_DIR) && bun install
	cd $(BACK_DIR) && go mod tidy

# =========================================================
# Qualidade
# =========================================================
lint:
	@echo ">> Lint frontend"
	cd $(FRONT_DIR) && bun run lint || true
	@echo ">> Lint backend"
	cd $(BACK_DIR) && go vet ./...

test:
	@echo ">> Testes Go"
	cd $(BACK_DIR) && go test ./...

check: lint test

# =========================================================
# Build
# =========================================================
build:
	@echo ">> Build frontend"
	cd $(FRONT_DIR) && bun run build
	@echo ">> Build backend"
	cd $(BACK_DIR) && CGO_ENABLED=0 go build \
		-ldflags "-X main.version=$(VERSION) -X main.commit=$(COMMIT)" \
		-o bin/api ./cmd/api

# =========================================================
# Docker
# =========================================================
docker-build:
	@echo ">> Build imagens Docker"
	docker build -f infra/docker/frontend.Dockerfile \
		-t $(FRONTEND_IMG):$(VERSION) \
		-t $(FRONTEND_IMG):latest .
	docker build -f infra/docker/backend.Dockerfile \
		-t $(BACKEND_IMG):$(VERSION) \
		-t $(BACKEND_IMG):latest .

docker-push:
	@echo ">> Push imagens Docker"
	docker push $(FRONTEND_IMG):$(VERSION)
	docker push $(FRONTEND_IMG):latest
	docker push $(BACKEND_IMG):$(VERSION)
	docker push $(BACKEND_IMG):latest

# =========================================================
# Release Semântico
# =========================================================
release:
ifndef PATCH
ifndef MINOR
ifndef MAJOR
	$(error Use PATCH=1 ou MINOR=1 ou MAJOR=1)
endif
endif
endif
	@echo ">> Release semântico"
	@git fetch --tags
	@bash scripts/release.sh

# =========================================================
# Runtime
# =========================================================
up:
	@echo ">> Subindo stack"
	docker compose -f $(COMPOSE_FILE) up -d

up-bootstrap:
	@echo ">> Subindo proxy em HTTP (bootstrap)"
	docker compose -f $(COMPOSE_FILE) -f infra/compose.bootstrap.yml up -d reverse-proxy

up-local:
	@echo ">> Subindo stack com HTTPS local"
	docker compose -f $(COMPOSE_FILE) -f infra/compose.local.yml up -d --build

up-dev:
	@echo ">> Subindo stack (build local)"
	docker compose -f $(COMPOSE_FILE) -f infra/compose.local.yml up -d --build

logs-dev:
	@echo ">> Logs do stack local"
	docker compose -f $(COMPOSE_FILE) -f infra/compose.local.yml logs -f

down:
	@echo ">> Derrubando stack"
	docker compose -f $(COMPOSE_FILE) down

logs:
	docker compose -f $(COMPOSE_FILE) logs -f

status:
	@echo ">> Status containers"
	docker compose -f $(COMPOSE_FILE) ps
	@echo ""
	@echo ">> Healthcheck backend"
	@curl -sf http://localhost:8081/health || echo "Backend indisponível"

# =========================================================
# Cloudflare Tunnel
# =========================================================
tunnel:
	@echo ">> Cloudflare Tunnel"
	cloudflared tunnel run wrtoriama

# =========================================================
# TLS / Certificados
# =========================================================
cert-issue:
ifndef DOMAIN
	$(error Use DOMAIN=seu-dominio.com.br)
endif
ifndef EMAIL
	$(error Use EMAIL=seu@email.com)
endif
	@echo ">> Emitindo certificado Let's Encrypt para $(DOMAIN)"
	@bash scripts/issue-cert.sh $(DOMAIN) $(EMAIL)

cert-renew:
	@echo ">> Renovando certificado Let's Encrypt"
	@bash scripts/renew-cert.sh

cert-local:
	@echo ">> Gerando certificado local (self-signed)"
	@bash infra/nginx/create-local-cert.sh

# =========================================================
# Deploy
# =========================================================
deploy:
	@echo ">> Deploy produção"
	git pull origin main
	make check
	make docker-build
	make docker-push
	make up

# =========================================================
# Higiene
# =========================================================
clean:
	@echo ">> Limpeza geral"
	rm -rf $(FRONT_DIR)/dist
	rm -rf $(BACK_DIR)/bin
	docker system prune -f

# =========================================================
# Deploy (FTP)
# =========================================================
deploy-ftp:
	@echo ">> Deploy via FTP"
	@bash scripts/deploy-ftp.sh
