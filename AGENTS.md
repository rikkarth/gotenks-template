# AGENTS.md

## Coding Standards

### General
- **Comment your code as you go.** Write clear, concise comments that explain *why*, not *what*. Document non-obvious logic, business rules, and design decisions inline. Do not leave complex code unexplained.
- **Focus on validation and code correctness.** Validate inputs at system boundaries (API routes, form submissions, external data). Use type hints, and tools like Pydantic models or TypeScript types to catch errors at compile time. Test edge cases explicitly.

### Agent-Authored Files
When creating files intended for agent consumption (plans, rules, specs, prompts), use **Markdown with YAML frontmatter**. This combination is the most token-efficient structured format and is backed by empirical benchmarks. Avoid JSON, XML, or TOML for these documents — they cost significantly more tokens and can degrade reasoning.

## Commit Convention
- Use conventional commits with scope: `feat(scope):`, `fix(scope):`, `refactor(scope):`, `chore:`, `docs:`
- Common scopes: `observability`, `infra`, `users`, `config`, `smtp`, `bulk-import`
- Keep subject line concise; use body for detail when needed
- NEVER add a Co-Authored-By or any sign-off line to commit messages.

## Communication Style
- When the developer proposes a design decision, provide genuine feedback — don't just agree for the sake of it. Flag trade-offs, potential issues, and alternatives with clear reasoning.
- If you disagree, say so directly and explain why. If you agree, explain what makes it a good choice.
- When presenting options, explain the concrete pros/cons of each rather than deferring the choice entirely.
- Always research and present industry standards first — whether for data models, APIs, protocols, naming conventions, or any software design decision. The developer wants to evaluate well-established conventions before deciding on an approach, even if a custom solution ends up being the better fit.
