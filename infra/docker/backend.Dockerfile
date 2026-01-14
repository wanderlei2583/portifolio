# ---------- Build ----------
FROM golang:alpine AS build
WORKDIR /app

COPY apps/backend/go.mod apps/backend/go.sum ./
RUN go mod download

COPY apps/backend/ .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
    go build -o api ./cmd/api

# ---------- Runtime ----------
FROM gcr.io/distroless/base-debian12
WORKDIR /app

COPY --from=build /app/api /app/api

EXPOSE 8080
USER nonroot:nonroot
ENTRYPOINT ["/app/api"]
