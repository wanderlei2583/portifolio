# ---------- Build ----------
FROM golang:1.22-alpine AS build
WORKDIR /app

COPY apps/backend/go.mod apps/backend/go.sum ./
RUN go mod download

COPY apps/backend/ .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
    go build -o api

# ---------- Runtime ----------
FROM gcr.io/distroless/base-debian12
WORKDIR /app

COPY --from=build /app/api /app/api

EXPOSE 8080
USER appuser:appuser
ENTRYPOINT ["/app/api"]
