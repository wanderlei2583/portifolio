# ---------- Build ----------
FROM oven/bun:1 AS build
WORKDIR /app

COPY apps/frontend/package.json apps/frontend/bun.lock ./
RUN bun install

COPY apps/frontend/ .
RUN bun run build

# ---------- Runtime ----------
FROM nginx:alpine
WORKDIR /usr/share/nginx/html

RUN rm -rf ./*
COPY --from=build /app/dist .

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
