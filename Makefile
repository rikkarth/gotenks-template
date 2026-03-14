.DEFAULT_GOAL := help

.PHONY: help install env setup-llm-docs dev dev-api dev-web build typecheck check clean

help: ## Show the available workspace commands.
	@printf "\nAvailable targets:\n\n"
	@awk 'BEGIN {FS = ": ## "}; /^[a-zA-Z0-9_-]+: ## / {printf "  %-12s %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@printf "\n"

install: ## Install workspace dependencies with Bun.
	bun install

env: ## Create local env files from the examples when they do not exist.
	@test -f apps/api/.env || cp apps/api/.env.example apps/api/.env
	@test -f apps/web/.env || cp apps/web/.env.example apps/web/.env

setup-llm-docs: ## Install the local Rsbuild skill and add the Elysia skill.
	./scripts/setup-llm-docs.sh

dev: ## Start the frontend and backend together.
	@bun run dev; status=$$?; if [ $$status -ne 0 ] && [ $$status -ne 130 ]; then exit $$status; fi

dev-api: ## Start only the Elysia backend.
	@bun run dev:api; status=$$?; if [ $$status -ne 0 ] && [ $$status -ne 130 ]; then exit $$status; fi

dev-web: ## Start only the Rsbuild frontend.
	@bun run dev:web; status=$$?; if [ $$status -ne 0 ] && [ $$status -ne 130 ]; then exit $$status; fi

build: ## Build the API and web app.
	bun run build

typecheck: ## Run TypeScript checks for the whole workspace.
	bun run typecheck

check: ## Run the default workspace validation command.
	bun run check

clean: ## Remove generated build output.
	rm -rf apps/api/dist apps/web/dist
