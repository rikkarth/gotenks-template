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
