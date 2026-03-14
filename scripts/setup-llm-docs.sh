#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILL_NAME="rsbuild-docs"
SOURCE_URL="${RSBUILD_LLMS_URL:-https://rsbuild.rs/llms-full.txt}"
LOCAL_SKILL_DIR="${ROOT_DIR}/skills/${SKILL_NAME}"
REFERENCE_FILE="${LOCAL_SKILL_DIR}/references/llms-full.txt"
AGENTS_HOME_DIR="${AGENTS_HOME:-${HOME}/.agents}"
UNIVERSAL_SKILLS_DIR="${AGENTS_HOME_DIR}/skills"
INSTALLED_SKILL_DIR="${UNIVERSAL_SKILLS_DIR}/${SKILL_NAME}"

mkdir -p "$(dirname "${REFERENCE_FILE}")" "${UNIVERSAL_SKILLS_DIR}"

printf "Fetching Rsbuild docs from %s\n" "${SOURCE_URL}"
curl --fail --location --silent --show-error "${SOURCE_URL}" -o "${REFERENCE_FILE}"

# Install into the universal skills directory so compatible tools can discover the same local skill.
rm -rf "${INSTALLED_SKILL_DIR}"
cp -R "${LOCAL_SKILL_DIR}" "${INSTALLED_SKILL_DIR}"

printf "Installing Elysia skill via bunx\n"
bunx skills add --yes --global elysiajs/skills

printf "\nInstalled skills:\n"
printf "  - %s\n" "${INSTALLED_SKILL_DIR}"
printf "  - elysiajs/skills via bunx --global\n"
printf "\nRestart Codex and any other skill-aware tools to pick up new skills.\n"
