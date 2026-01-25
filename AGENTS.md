# Repository Guidelines

## Project Structure & Module Organization
- `apps/frontend/`: Astro + Tailwind frontend (`src/pages`, `src/components`, `src/layouts`, `src/styles`, `public/`).
- `apps/backend/`: Go API using standard layout (`cmd/api`, `internal/`).
- `infra/`: Dockerfiles and `compose.yml` for local orchestration.
- `scripts/`: helper scripts (release automation).
- Root `Makefile`: primary entry point for common tasks.

## Build, Test, and Development Commands
- `make setup`: install frontend deps with Bun and run `go mod tidy`.
- `make build`: build Astro site and compile Go API binary.
- `make up` / `make down`: start or stop the Docker Compose stack.
- `make logs`: stream container logs.
- `make status`: show container status and hit `/health` on the API.
- `make lint`: frontend lint (if configured) and `go vet` for backend.
- `make test`: run backend unit tests (`go test ./...`).
- Frontend local dev (inside `apps/frontend/`): `bun run dev`.

## Coding Style & Naming Conventions
- Frontend: follow Astro/TypeScript defaults; components use `PascalCase.astro` (e.g., `Header.astro`).
- Indentation: existing Astro files use tabs; keep consistent in touched files.
- Backend: standard Go formatting (`gofmt`) and idiomatic package naming (short, lowercase).
- Tailwind is the primary styling approach; keep utility classes close to the markup.

## Testing Guidelines
- Backend tests are run via `go test ./...` (see `make test`).
- No explicit coverage thresholds are enforced; add tests for new handlers or business logic.
- Test files should follow Go conventions (`*_test.go`).

## Commit & Pull Request Guidelines
- Commits follow a conventional style such as `feat: ...` (see `git log`).
- PRs should include: a concise summary, testing performed, and screenshots for UI changes.
- Link related issues when applicable and keep PRs focused.

## Configuration & Security Notes
- Copy `.env.example` to `.env` if environment variables are introduced.
- Docker is the preferred way to run the full stack locally.
