# Variáveis do Projeto
APP_NAME=portfolio-backend
DOCKER_IMAGE_NAME=wrtoriama/backend
MAIN_PATH=./cmd/api/main.go

# Deteta o sistema operativo para comandos específicos
OS := $(shell uname -s)

# Descobre onde o Go instala os binarios.
GOBIN := $(shell go env GOPATH)/bin

.PHONY: all build run watch test clean docker-build docker-run lint help

# Comando padrão ao digitar apenas 'make'
all: help

## help: Mostra esta ajuda
help:
	@echo "Uso: make [comando]"
	@echo ""
	@echo "Comandos disponíveis:"
	@sed -n 's/^##//p' ${MAKEFILE_LIST} | column -t -s ':' |  sed -e 's/^/ /'

## deps: Baixa as dependências e limpa pacotes não usados
deps:
	@echo " -> A atualizar dependências..."
	go mod tidy
	go mod verify

## build: Compila o binário para produção
build:
	@echo " -> A compilar a aplicação..."
	CGO_ENABLED=0 go build -ldflags="-w -s" -o bin/server $(MAIN_PATH)

## run: Executa a aplicação normalmente (sem hot-reload)
run:
	@echo " -> A iniciar servidor..."
	go run $(MAIN_PATH)

## watch: Executa a aplicação com Hot-Reload (desenvolvimento)
watch:
	@echo " -> A iniciar modo desenvolvimento com Air..."
	$(GOBIN)/air

## test: Executa testes unitários com deteção de race conditions
test:
	@echo " -> A executar testes..."
	go test -v -race ./...

## lint: Verifica a qualidade do código (Governança)
lint:
	@echo " -> A verificar qualidade do código..."
	$(GOBIN)/golangci-lint run

## clean: Remove binários e artefactos temporários
clean:
	@echo " -> A limpar ficheiros temporários..."
	rm -rf bin/ tmp/

## docker-build: Constrói a imagem Docker localmente
docker-build:
	@echo " -> A construir imagem Docker..."
	docker build -t $(DOCKER_IMAGE_NAME) .

## docker-run: Executa o contentor Docker na porta 8080
docker-run:
	@echo " -> A executar contentor Docker..."
	docker run -p 8080:8080 --rm --name $(APP_NAME) $(DOCKER_IMAGE_NAME)
