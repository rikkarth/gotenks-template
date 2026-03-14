#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILL_NAME="rsbuild-docs"
SOURCE_URL="${RSBUILD_LLMS_URL:-https://rsbuild.rs/llms-full.txt}"
TEMPLATE_SKILL_DIR="${ROOT_DIR}/skills/${SKILL_NAME}"
AGENTS_HOME_DIR="${AGENTS_HOME:-${HOME}/.agents}"
UNIVERSAL_SKILLS_DIR="${AGENTS_HOME_DIR}/skills"
INSTALLED_SKILL_DIR="${UNIVERSAL_SKILLS_DIR}/${SKILL_NAME}"
REFERENCE_FILE="${INSTALLED_SKILL_DIR}/references/llms-full.txt"

mkdir -p "${UNIVERSAL_SKILLS_DIR}"

rm -rf "${INSTALLED_SKILL_DIR}"
mkdir -p "${INSTALLED_SKILL_DIR}"

# Keep the repo copy as a template only; the installed skill under ~/.agents/skills is the canonical local copy.
if [ -d "${TEMPLATE_SKILL_DIR}" ]; then
  cp -R "${TEMPLATE_SKILL_DIR}/." "${INSTALLED_SKILL_DIR}"
fi

# Bootstrap the skill metadata when the local template files are missing from the worktree.
if [ ! -f "${INSTALLED_SKILL_DIR}/SKILL.md" ]; then
  cat <<'EOF' > "${INSTALLED_SKILL_DIR}/SKILL.md"
---
name: rsbuild-docs
description: Use when working on Rsbuild applications or configuration. Applies to Rsbuild config, plugins, React setup, env vars, dev server behavior, HTML templates, output tuning, and troubleshooting. Before making non-trivial Rsbuild changes, read references/llms-full.txt and follow the documented Rsbuild option names and patterns.
---

# Rsbuild Docs

Use this skill whenever the task touches Rsbuild.

## Workflow

1. Open `references/llms-full.txt`.
2. Search for the exact Rsbuild feature or option name you need before editing code.
3. Follow the documented Rsbuild pattern instead of inventing custom behavior or guessing from Vite or webpack.
4. Validate with the project's normal build and typecheck commands.

## Reference Search

- Start with exact option names such as `server`, `html`, `source.entry`, `PUBLIC_`, `output`, `performance`, `resolve.alias`, or the plugin name you need.
- Prefer `rg -n "term" references/llms-full.txt` to jump directly to the relevant section.
- If multiple approaches exist, choose the one that matches the current repo shape instead of introducing extra framework glue.

## Notes

- `references/llms-full.txt` is refreshed by `make setup-llm-docs`.
- Keep this skill concise and treat the downloaded Rsbuild file as the primary reference.
EOF
fi

mkdir -p "${INSTALLED_SKILL_DIR}/agents"

if [ ! -f "${INSTALLED_SKILL_DIR}/agents/openai.yaml" ]; then
  cat <<'EOF' > "${INSTALLED_SKILL_DIR}/agents/openai.yaml"
interface:
  display_name: "Rsbuild Docs"
  short_description: "Official Rsbuild reference skill"
  default_prompt: "Use $rsbuild-docs to solve this Rsbuild task using the bundled llms-full reference."
EOF
fi

mkdir -p "$(dirname "${REFERENCE_FILE}")"

printf "Fetching Rsbuild docs from %s\n" "${SOURCE_URL}"
curl --fail --location --silent --show-error "${SOURCE_URL}" -o "${REFERENCE_FILE}"

printf "Installing Elysia skill via bunx\n"
bunx skills add --yes --global elysiajs/skills

printf "\nInstalled skills:\n"
printf "  - %s\n" "${INSTALLED_SKILL_DIR}"
printf "  - elysiajs/skills via bunx --global\n"
printf "\nRestart Codex and any other skill-aware tools to pick up new skills.\n"
