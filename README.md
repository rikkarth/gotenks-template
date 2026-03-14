# Gotenks Template

A Bun-first baseline for AI apps with:

- `apps/web`: React + TypeScript + Rsbuild frontend
- `apps/api`: ElysiaJS backend with CORS and a health route

## Why this shape

This repo is meant to be cloned and adapted into a new application. The layout follows a common full-stack TypeScript convention: separate deployable apps in a single workspace, keep Bun as the runtime and package manager, and let the frontend consume backend types directly inside the monorepo.

## Setup after cloning

1. Clone the repository and enter the workspace:

   ```bash
   git clone <your-repo-url>
   cd gotenks-template
   ```

2. Install Bun if it is not already available:

   ```bash
   curl -fsSL https://bun.sh/install | bash
   ```

   Confirm the install:

   ```bash
   bun --version
   ```

3. Install workspace dependencies:

   ```bash
   make install
   ```

4. Create local env files from the examples:

   ```bash
   make env
   ```

5. Review and adjust environment values if needed:

   - `apps/api/.env` controls the API port and allowed frontend origin
   - `apps/web/.env` controls the API base URL used by the frontend

   Default local values:

   - API: `http://localhost:3001`
   - Web: `http://localhost:3000`

6. Optionally install the local LLM docs skill bundle used by this template:

   ```bash
   make setup-llm-docs
   ```

7. Validate the workspace before starting development:

   ```bash
   make check
   ```

8. Start both apps:

   ```bash
   make dev
   ```

9. Open the local app and health endpoint:

   - frontend: `http://localhost:3000`
   - API health: `http://localhost:3001/api/health`

## Quick start

If Bun is already installed, the shortest path is:

```bash
make install
make env
make check
make dev
```

## Make targets

- `make help`: show the available commands
- `make install`: install workspace dependencies
- `make env`: create local `.env` files from the examples
- `make setup-llm-docs`: install the local Rsbuild skill into `~/.agents/skills` and add the Elysia skill
- `make dev`: start frontend and backend together
- `make dev-web`: start only the Rsbuild app
- `make dev-api`: start only the Elysia app
- `make build`: build both apps
- `make typecheck`: run TypeScript checks in both apps
- `make clean`: remove generated build output

## Bun scripts

The `Makefile` is a thin wrapper around the Bun workspace scripts. That keeps one implementation path while giving you a more conventional project command surface.

## Notes

- The frontend uses Rsbuild's `PUBLIC_` env convention, which is the current recommended public-variable pattern in the official docs.
- The frontend is intentionally minimal. Replace it with your actual UI early in each project.
- The backend starts with a single health endpoint so you can add your own routes without removing demo logic first.
- `make setup-llm-docs` installs a local `rsbuild-docs` skill into `~/.agents/skills` and then runs `bunx skills add elysiajs/skills`.
