---
title: Project Templates
type: reference
status: draft
confidence: 78
tags: [claude-code, ai-agent, agents-md, hooks, nodejs]
last-updated: 2026-05-17
sources:
  - "Wiki-internal: synthesised from all wiki pages"
  - "YouTube — A love letter to Pi | Lucas Meijer: https://www.youtube.com/watch?v=fdbXNWkpPMY"
---

# Project Templates

## Read This When

- Bootstrapping a new project with the full guardrail stack
- Wanting ready-to-use CLAUDE.md, AGENTS.md, hooks, and rules
- Reviewing the recommended agent architecture as a concrete example

## Default Recommendation

- Start from the unified default template in `templates/`.
- Keep `AGENTS.md` as the shared core and `CLAUDE.md` as the thin Claude-specific layer.
- Use hooks for deterministic enforcement and rules for path-scoped guidance.
- Follow [agent-development-lifecycle](agent-development-lifecycle.md) for proving-slice workflow.
- Require a final human review pack after automated checks and before commit.
- Implement the stack in stages so each layer is proven before the next is added.

## Use This Pattern

## Canonical Template Stack

The recommended default stack is:

- Next.js App Router
- TypeScript strict mode
- React 19
- Tailwind CSS 4 + shadcn/ui + Lucide + Geist
- Drizzle + PostgreSQL + pgvector
- Vercel AI SDK + model providers behind explicit policy
- Zod 4
- Biome
- Vitest + Playwright smoke
- Vercel by default unless user constraints say otherwise

## What Is In The Template

```
templates/
├── AGENTS.md
├── CLAUDE.md
└── .claude/
    ├── settings.json
    ├── hooks/
    │   ├── lint-changed.sh
    │   ├── test-on-change.sh
    │   ├── block-destructive.sh
    │   └── quality-gate-reminder.sh
    └── rules/
        ├── app-routes.md
        ├── components.md
        ├── database.md
        └── testing.md
```

## How The Pieces Fit Together

```
AGENTS.md (~80 lines, shared by Claude + Codex)
  ├─ project context, stack, commands
  ├─ workflow: proving slice, focused checks, review pack
  ├─ quality gates
  ├─ build order by stage
  └─ hard rules, naming, decision points
        │
CLAUDE.md (~25 lines, Claude-specific)
  ├─ @AGENTS.md import
  ├─ Claude habits: subagents, /clear, dummy-happy-path-first
  ├─ ask-the-user rule for meaningful tradeoffs
  ├─ documents which hooks are active
  └─ explicit prohibitions
        │
.claude/rules/ (loaded on demand when matching paths are read)
  ├─ domain-specific rules scoped to file patterns
  └─ keeps global instruction count low
        │
.claude/settings.json (hooks — deterministic enforcement)
  ├─ PostToolUse → lint the changed file
  ├─ PostToolUse → run the related test
  ├─ PreToolUse  → block destructive commands
  └─ Stop        → remind about quality gates
```

This follows the enforcement pyramid from [agent-instruction-design](agent-instruction-design.md):

1. **Hooks enforce** what must always happen (lint, targeted test, block danger)
2. **CLAUDE.md advises** on workflow and architecture
3. **Rules scope** domain knowledge to the files that need it

For task workflow selection, use [agent-development-lifecycle](agent-development-lifecycle.md).

## Using The Templates

Copy the unified template into a new project:

```bash
cp templates/AGENTS.md /path/to/new-project/
cp templates/CLAUDE.md /path/to/new-project/
cp -r templates/.claude /path/to/new-project/
chmod +x /path/to/new-project/.claude/hooks/*.sh
```

Then customise:

1. Update `AGENTS.md` project section with the actual project description
2. Update commands to match real `package.json` scripts
3. Remove stages the project does not need yet, but keep the order
4. Adjust path-scoped rules for the actual directory layout
5. Add project-specific rules to `CLAUDE.md` prohibitions
6. Test each hook by triggering its event manually

## Commands / Config

Typical setup steps:

- copy the unified template
- make hooks executable
- update commands to match the real project
- test hooks manually before relying on them

## Staged Build Order

The template is intentionally layered. Implement in this order:

1. strict TypeScript, Biome, and one route
2. Zod validation and one passing unit test
3. one UI path with Tailwind + shadcn/ui
4. one database schema and one proven read/write path
5. one AI flow on a dummy happy path
6. one Playwright smoke test
7. deploy and CI

Each stage should be proven before the next is added.

## User Questions

Where there are real options, the agent should ask the user one concise question before committing.

Ask about:

- deployment target if the org already has a cloud standard
- database hosting/provider choice
- whether pgvector is needed now or later
- which model vendor is allowed or preferred

Default toward:

- stricter typing
- more runtime validation
- stronger deterministic guardrails
- simpler safe workflows before broader automation

## Design Decisions

### Why AGENTS.md is the main file

AGENTS.md is read by both Claude Code (via `@AGENTS.md` import) and OpenAI Codex (natively). Putting shared instructions here means the same rules apply regardless of which agent runs.

CLAUDE.md adds only Claude-specific behavior: subagent usage, context management, hook documentation, and explicit prohibitions.

### Why hooks, not CLAUDE.md rules

Every CLAUDE.md instruction costs a slot in the ~100-150 instruction budget. Rules like "always lint after editing" are better enforced by a PostToolUse hook that runs automatically. This saves instruction budget for things only advisory text can express (architectural decisions, naming, workflow).

### Why path-scoped rules

Global rules compete for attention with every other instruction. Path-scoped rules in `.claude/rules/` load only when Claude reads files in matching directories — keeping context lean and relevant.

### Hook design principles

| Principle | Implementation |
|---|---|
| Fast feedback | Lint and test hooks run the smallest relevant checks first |
| No false blocks | PostToolUse hooks exit 0 always — they inform, they cannot block |
| Explicit danger list | PreToolUse block-destructive uses an allowlist of known-bad patterns |
| Prompt on ambiguity | `pulumi up` gets `"ask"` (user confirms), not `"deny"` (blocked) |
| Proving-slice workflow | Instructions point to the lifecycle page |
| Dummy-workflow-first | Templates tell agents to prove one toy happy path before generalizing |
| Review handoff | Instructions require a review pack after automated checks and before commit |
| Quality reminder | Stop hook checks for a recent passing slice, not just generic activity |

## Pitfalls

- Do not add hook scripts to `.gitignore` — they are shared team configuration.
- Do not make hooks slow — timeouts cause silent failures (30s for lint, 60s for test).
- Do not use Stop hook with exit 2 to force more output — it prevents Claude from finishing.
- Do not duplicate linter rules in CLAUDE.md — the hook runs the linter, the linter has the rules.
- Do not forget `chmod +x` on hook scripts after copying.

## Related Pages

- [agent-development-lifecycle](agent-development-lifecycle.md)
- [agent-instruction-design](agent-instruction-design.md)
- [claude-md-conventions](claude-md-conventions.md)
- [claude-code-hooks](claude-code-hooks.md)
- [new-project-checklist](new-project-checklist.md)
- [gitignore-best-practices](gitignore-best-practices.md)
