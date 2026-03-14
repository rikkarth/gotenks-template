# Planning Guidelines

## Constraints

- ALWAYS write plans to the **project-local** `<project-root>/docs/plans/<plan-name>/` directory.
- NEVER write a plan as a single monolithic file. Break it into self-contained step files.
- ALWAYS write the full plan (all step files + index) and get user approval before executing any step.
- ALWAYS update step `status` in both the step file frontmatter and `_index.md` simultaneously.
- Structure steps to maximize parallelization. If two pieces of work don't share state, they MUST be separate steps with no dependency between them.

## Directory Layout

```
<project-root>/docs/plans/<plan-name>/
├── _index.md
├── 01-<step-name>.md
├── 02-<step-name>.md
└── ...
```

- `<plan-name>`: kebab-cased slug (e.g., `add-user-auth`, `migrate-to-timescale`).
- Numbered prefixes set reading order. Execution order is governed by `depends_on`.

## Step File Format

YAML frontmatter fields:

| Field        | Type       | Required | Values / Description                                              |
|--------------|------------|----------|-------------------------------------------------------------------|
| `id`         | `string`   | yes      | Unique step identifier (e.g., `step-01`, `setup-db`)             |
| `title`      | `string`   | yes      | Short human-readable description                                  |
| `depends_on` | `string[]` | yes      | Step `id`s that must complete before this step. `[]` if none      |
| `status`     | `enum`     | yes      | One of: `pending`, `in-progress`, `done`, `blocked`               |

Step body sections:

| Section                | Purpose                                                        |
|------------------------|----------------------------------------------------------------|
| **Objective**          | What this step accomplishes and why                            |
| **Tasks**              | Checkbox list of concrete work items                           |
| **Files Likely Involved** | File paths this step will read or modify                    |
| **Acceptance Criteria**| How to verify the step is complete                             |
| **Notes**              | Edge cases, open questions, or design decisions (optional)     |

### Example

```
---
id: step-01
title: Create audit events storage
depends_on: []
status: pending
---

# Create audit events storage

## Objective
Add durable storage for audit events so downstream features can query a complete activity history.

## Tasks
- [ ] Create the schema change for the new audit events table
- [ ] Define the application model with the required indexes

## Files Likely Involved
- db/migrations/
- src/domain/audit-events/

## Acceptance Criteria
- Schema change applies cleanly in a fresh environment
- The model matches the agreed schema from the design doc
```

## Index File Format (`_index.md`)

The index is the plan's entry point. It must contain these sections:

**Summary** — 1-3 sentences describing the overall goal.

**Steps table** — Single source of truth for step status and dependencies:

```
| #  | ID       | Title                     | Depends On       | Status  |
|----|----------|---------------------------|------------------|---------|
| 01 | step-01  | Create audit events storage | —                | pending |
| 02 | step-02  | Add write API for events    | step-01          | pending |
| 03 | step-03  | Add activity history UI     | —                | pending |
| 04 | step-04  | Connect UI to event data    | step-02, step-03 | pending |
```

**Parallel execution groups** — Derived from the dependency graph. Steps within a group have no mutual dependencies and can execute concurrently:

```
- Group 1 (no dependencies): step-01, step-03
- Group 2 (after step-01): step-02
- Group 3 (after step-02, step-03): step-04
```

## File Format Rationale

All plans, rules, and agent-consumed documents in this project use **Markdown with YAML frontmatter**. This is deliberate:

- **Markdown** keeps plans readable in diffs, easy to scan in editors, and lightweight for both humans and agents.
- **YAML frontmatter** provides structured metadata (`id`, `status`, `depends_on`) without splitting the narrative from the machine-readable fields.
- **Avoid JSON, XML, or TOML** for planning documents unless an external integration explicitly requires one of them. They add structure, but usually make these files harder to read and maintain.
- If section boundaries need stronger delimiting, use lightweight tags inside Markdown sparingly. Prefer plain headings unless there is a clear parsing need.
