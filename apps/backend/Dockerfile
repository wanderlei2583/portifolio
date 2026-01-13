# --- Estágio 1: Builder (Compilação) ---
FROM golang:1.23-alpine AS builder

# Instala certificados SSL (necessário para o binário falar com HTTPS) e git
RUN apk update && apk add --no-cache git ca-certificates tzdata && update-ca-certificates

# Cria um usuário "appuser" para não rodar como root (Segurança)
ENV USER=appuser
ENV UID=10001
RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "/nonexistent" \
    --shell "/sbin/nologin" \
    --no-create-home \
    --uid "${UID}" \
    "${USER}"

WORKDIR /app

# 1. Copia apenas os arquivos de dependência primeiro (Cache Layering)
# Se você não mudar as dependências, o Docker não baixa tudo de novo
COPY go.mod go.sum ./
RUN go mod download
RUN go mod verify

# 2. Copia o código fonte
COPY . .

# 3. Compilação Otimizada
# CGO_ENABLED=0: Desabilita dependências de C (gera binário estático puro)
# -ldflags="-w -s": Remove informações de debug (diminui o tamanho do binário)
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build \
    -ldflags="-w -s" \
    -o /go-binary .

# --- Estágio 2: Runner (Produção) ---
# Usamos 'scratch', uma imagem 100% vazia
FROM scratch

# Copia os dados do usuário criado no estágio anterior
COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /etc/group /etc/group

# Copia certificados SSL (crítico para chamar APIs externas)
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

# Copia configurações de Zona de Tempo (opcional, mas bom para logs BR)
COPY --from=builder /usr/share/zoneinfo /usr/share/zoneinfo

# Copia o binário compilado
COPY --from=builder /go-binary /go-binary

# Define o usuário para execução (não-root)
USER appuser:appuser

# Expõe a porta (apenas documentação, quem define a porta real é o Railway/Render)
EXPOSE 8080

# Comando de entrada
ENTRYPOINT ["/go-binary"]
