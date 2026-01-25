# 🚀 DevWander - Portfólio Pessoal <!-- FIX: Em producao...-->

Bem-vindo ao repositório do meu portfólio pessoal e profissional. Este projeto é um **monorepo** moderno projetado para alta performance, escalabilidade e facilidade de manutenção, utilizando as melhores práticas de desenvolvimento Full Stack e DevOps.

## 🛠️ Tech Stack

O projeto está dividido em duas aplicações principais e uma camada de infraestrutura:

### 🎨 Frontend (`apps/frontend`)

- **Framework:** [Astro](https://astro.build/) (v5) - Para performance estática e hidratação parcial.
- **Runtime & Package Manager:** [Bun](https://bun.sh/) - Para instalação e builds ultra-rápidos.
- **Estilização:** [Tailwind CSS](https://tailwindcss.com/) (v4) - Estilização utilitária moderna via plugin Vite.
- **Linguagem:** TypeScript - Tipagem estática rigorosa.

### ⚙️ Backend (`apps/backend`)

- **Linguagem:** [Go](https://go.dev/) (v1.25+) - Alta performance e concorrência.
- **Router:** [Chi](https://github.com/go-chi/chi) - Roteador leve e idiomático.
- **Arquitetura:** Clean Architecture / Standard Go Layout (`cmd/`, `internal/`).

### 🏗️ Infraestrutura & DevOps

- **Containerização:** Docker & Docker Compose.
- **Reverse Proxy:** Nginx (TLS, HSTS, rate limiting).
- **Web Server:** Nginx (Frontend container).
- **Imagens enxutas:** Backend em `scratch` com binário Go estático.
- **CI/CD:** GitHub Actions.
- **Automação:** Makefile robusto para padronização de comandos.

---

## 📋 Pré-requisitos

Para rodar o projeto localmente, você precisará de:

- **Docker** e **Docker Compose** (Essencial para rodar a stack completa).
- **Git**.
- _(Opcional)_ **Bun** e **Go** instalados localmente se quiser desenvolver fora do Docker.

## 🚀 Como Rodar

Utilizamos um `Makefile` para simplificar todas as operações.

### 1. Setup Inicial

Clone o repositório e configure as dependências (caso vá rodar localmente) ou prepare o ambiente:

```bash
git clone https://codeberg.org/Toriama/portifolio.git
cd portifolio
make setup
```

### 2. Subir a Aplicação (Docker)

Este comando constrói as imagens e sobe os containers em background:

```bash
make docker-build
make up
```

Após subir, acesse:

- **Site (Reverse Proxy):** http://localhost
- **API (Reverse Proxy):** http://localhost/api

### 2.1. Subir com HTTPS local (self‑signed)

```bash
make cert-local
make up-local
```

Depois acesse: https://localhost (aceite o certificado no navegador).

### 2.2. Emissão de certificado Let's Encrypt

```bash
make cert-issue DOMAIN=wrtoriama.dev.br EMAIL=seu@email.com
```

### 2.3. Ambiente dev (build local + logs)

```bash
make up-dev
make logs-dev
```

### 3. Verificar Status

Para confirmar se tudo está rodando corretamente e verificar o healthcheck do backend:

```bash
make status
```

## 📜 Comandos Úteis (Makefile)

| Comando             | Descrição                                   |
| ------------------- | ------------------------------------------- |
| `make setup`        | Instala dependências locais (Bun/Go mod).   |
| `make build`        | Compila os binários/dist localmente.        |
| `make docker-build` | Cria as imagens Docker de produção.         |
| `make up`           | Sobe a stack completa via Docker Compose.   |
| `make up-local`     | Sobe a stack com build local e HTTPS local. |
| `make up-dev`       | Sobe a stack (build local).                 |
| `make logs-dev`     | Logs da stack local.                        |
| `make down`         | Para e remove os containers.                |
| `make logs`         | Exibe os logs dos containers em tempo real. |
| `make lint`         | Roda verificação de código (linting).       |
| `make test`         | Executa os testes unitários do backend.     |
| `make cert-issue`   | Emite certificado Let's Encrypt.            |
| `make cert-renew`   | Renova certificados Let's Encrypt.          |
| `make cert-local`   | Gera certificado local (self‑signed).       |
| `make clean`        | Limpa artefatos de build e caches.          |

## 📂 Estrutura do Projeto

```plaintext
.
├── apps/
│   ├── backend/      # Código fonte da API Go
│   └── frontend/     # Código fonte do site Astro/Tailwind
├── infra/
│   ├── docker/       # Dockerfiles otimizados
│   └── compose.yml   # Orquestração local
├── scripts/          # Scripts auxiliares (release, etc)
├── Makefile          # Automação de tarefas
└── README.md         # Documentação
```

## 📬 Contato

Desenvolvido por **DevWander (Toriama)**.

- **Codeberg:** [Toriama](https://codeberg.org/Toriama)
- **E-mail:** contato@wrtoriama.dev.br

---

&copy; 2026 Wrtoriama. Todos os direitos reservados.
