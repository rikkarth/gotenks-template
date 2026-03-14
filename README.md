# AI App Template

A Bun-first baseline for AI apps with:

- `apps/web`: React + TypeScript + Rsbuild frontend
- `apps/api`: ElysiaJS backend with CORS and a health route

## Why this shape

This repo is meant to be cloned and adapted into a new application. The layout follows a common full-stack TypeScript convention: separate deployable apps in a single workspace, keep Bun as the runtime and package manager, and let the frontend consume backend types directly inside the monorepo.

## Quick start

1. Install dependencies:

   ```bash
   make install
   ```

2. Copy the example env files:

   ```bash
   make env
   ```

3. Start both apps:

   ```bash
   make dev
   ```

4. Open:

   - frontend: `http://localhost:3000`
   - API health: `http://localhost:3001/api/health`

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
