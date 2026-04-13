---
title: Project Templates
type: reference
status: draft
confidence: 75
tags: [claude-code, ai-agent, agents-md, hooks, nodejs]
last-updated: 2026-04-12
sources:
  - "Wiki-internal: synthesised from all wiki pages"
---

# Project Templates

## Read This When

- Bootstrapping a new project with the full guardrail stack
- Wanting ready-to-use CLAUDE.md, AGENTS.md, hooks, and rules
- Reviewing the recommended agent architecture as a concrete example

## Two Template Variants

| Variant | Path | Stack |
|---|---|---|
| **Node.js / GCP** | `templates/` | Node.js 22, native http, Pulumi YAML, GCP Cloud Functions, ESLint + Prettier |
| **Next.js / Vercel** | `templates/nextjs/` | Next.js App Router, TypeScript strict, React 19, Tailwind + shadcn/ui, Drizzle + Postgres + pgvector, Biome, Vercel AI SDK |

Both share the same architecture: AGENTS.md core + thin CLAUDE.md + deterministic hooks + path-scoped rules. They differ in stack context, commands, rules, and which linter the hooks invoke.

## What Is In Each Variant

```
templates/             (Node.js / GCP)      templates/nextjs/       (Next.js / Vercel)
├── AGENTS.md                               ├── AGENTS.md
├── CLAUDE.md                               ├── CLAUDE.md
└── .claude/                                └── .claude/
    ├── settings.json                           ├── settings.json
    ├── hooks/                                  ├── hooks/
    │   ├── lint-changed.sh  (ESLint)           │   ├── lint-changed.sh  (Biome → next lint fallback)
    │   ├── test-on-change.sh                   │   ├── test-on-change.sh (.ts/.tsx aware)
    │   ├── block-destructive.sh                │   ├── block-destructive.sh
    │   └── quality-gate-reminder.sh            │   └── quality-gate-reminder.sh
    └── rules/                                  └── rules/
        ├── api-handlers.md  (src/**/*.js)          ├── app-routes.md    (app/**/*.ts{x})
        ├── testing.md       (**/*.test.js)         ├── components.md    (components/**/*.tsx)
        └── infrastructure.md (infra/**)            ├── database.md      (db/**)
                                                    └── testing.md       (**/*.test.ts{x})
```

## How The Pieces Fit Together

```
AGENTS.md (~80 lines, shared by Claude + Codex)
  ├─ project context, stack, commands
  ├─ workflow: smallest-slice-first, test immediately, commit each passing slice
  ├─ quality gates
  └─ hard rules, naming, error handling
        │
CLAUDE.md (~25 lines, Claude-specific)
  ├─ @AGENTS.md import
  ├─ Claude habits: subagents, /clear, plan mode, dummy-happy-path-first
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

The intended development loop is:

1. make the simplest slice that proves the workflow
2. run the narrowest relevant test immediately
3. fix failures before expanding scope
4. run broader checks at slice boundaries
5. commit each coherent passing slice

The intended expansion pattern is:

1. get one dummy happy-path workflow working
2. prove it with the smallest meaningful test
3. only then apply the pattern to adjacent files, edge cases, and broader code paths

## Using The Templates

Choose the variant matching your stack, then copy:

```bash
# Node.js / GCP variant
cp templates/AGENTS.md /path/to/new-project/
cp templates/CLAUDE.md /path/to/new-project/
cp -r templates/.claude /path/to/new-project/

# Next.js / Vercel variant
cp templates/nextjs/AGENTS.md /path/to/new-project/
cp templates/nextjs/CLAUDE.md /path/to/new-project/
cp -r templates/nextjs/.claude /path/to/new-project/

# Both: make hooks executable
chmod +x /path/to/new-project/.claude/hooks/*.sh
```

Then customise:

1. Update `AGENTS.md` project section with the actual project description
2. Update commands to match real `package.json` scripts
3. Adjust path-scoped rules for the actual directory layout
4. Add project-specific rules to `CLAUDE.md` prohibitions
5. Test each hook by triggering its event manually

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
| Proving-slice workflow | Instructions explicitly prefer the simplest passing slice that proves the workflow |
| Dummy-workflow-first | Templates tell agents to prove one toy happy path before generalizing |
| Quality reminder | Stop hook checks for a recent passing slice, not just generic activity |

## Pitfalls

- Do not add hook scripts to `.gitignore` — they are shared team configuration.
- Do not make hooks slow — timeouts cause silent failures (30s for lint, 60s for test).
- Do not use Stop hook with exit 2 to force more output — it prevents Claude from finishing.
- Do not duplicate linter rules in CLAUDE.md — the hook runs the linter, the linter has the rules.
- Do not forget `chmod +x` on hook scripts after copying.

## Related Pages

- [agent-instruction-design](agent-instruction-design.md)
- [claude-md-conventions](claude-md-conventions.md)
- [claude-code-hooks](claude-code-hooks.md)
- [new-project-checklist](new-project-checklist.md)
