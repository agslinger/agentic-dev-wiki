---
title: CLAUDE.md / AGENTS.md Conventions
type: pattern
status: draft
confidence: 82
tags: [claude-code, ai-agent, agents-md]
last-updated: 2026-04-12
sources:
  - "Anthropic Claude Code docs — memory/CLAUDE.md guide: https://code.claude.com/docs/en/memory"
---

# CLAUDE.md / AGENTS.md Conventions

> **Status: draft** — sourced from official Anthropic Claude Code docs (April 2026).

---

## What CLAUDE.md is

CLAUDE.md files are plain-markdown files that give Claude Code persistent, cross-session instructions for a project, a user's personal workflow, or an organisation. They are loaded into the context window at the start of every session. Claude treats them as context, not enforced configuration — specific and concise instructions produce the most reliable adherence.

**AGENTS.md vs CLAUDE.md:** Claude Code reads `CLAUDE.md`, not `AGENTS.md`. If a repo already has `AGENTS.md` for other coding agents, create a `CLAUDE.md` that imports it so both tools share the same instructions without duplication:

```markdown
<!-- CLAUDE.md -->
@AGENTS.md

## Claude Code

Use plan mode for changes under `src/billing/`.
```

---

## File locations and scope

| Scope | Location | Shared via |
|---|---|---|
| **Managed policy** | macOS: `/Library/Application Support/ClaudeCode/CLAUDE.md` · Linux/WSL: `/etc/claude-code/CLAUDE.md` · Windows: `C:\Program Files\ClaudeCode\CLAUDE.md` | IT/MDM deployment |
| **Project** | `./CLAUDE.md` or `./.claude/CLAUDE.md` | Version control |
| **User** (personal, all projects) | `~/.claude/CLAUDE.md` | Local only |
| **Local** (personal, this project) | `./CLAUDE.local.md` — add to `.gitignore` | Local only |

More specific locations take precedence. All discovered files are **concatenated**, not overridden — later files override earlier ones for conflicting instructions at the same scope level (`CLAUDE.local.md` is appended after `CLAUDE.md` at each directory level).

---

## Discovery and load order

Claude Code walks up the directory tree from the current working directory, loading `CLAUDE.md` and `CLAUDE.local.md` from each ancestor directory at launch. For example, launching from `foo/bar/` loads:

1. `foo/bar/CLAUDE.md`
2. `foo/bar/CLAUDE.local.md`
3. `foo/CLAUDE.md`
4. `foo/CLAUDE.local.md`

Subdirectory `CLAUDE.md` files (below the cwd) are **not** loaded at launch — they load on demand when Claude reads a file in that subdirectory.

HTML block comments (`<!-- … -->`) are stripped before injection. Use them for maintainer notes that don't consume context tokens. Comments inside code blocks are preserved.

---

## Writing effective instructions

**Size:** Target under 200 lines per `CLAUDE.md`. Longer files consume more context and reduce adherence. Split using `@path` imports or `.claude/rules/` for larger projects.

**Structure:** Use markdown headers and bullets. Organised sections are easier for Claude to scan than dense paragraphs.

**Specificity:** Write instructions that are concrete enough to verify:
- ✅ `"Use 2-space indentation"`  vs  ❌ `"Format code properly"`
- ✅ `"Run npm test before committing"`  vs  ❌ `"Test your changes"`
- ✅ `"API handlers live in src/api/handlers/"`  vs  ❌ `"Keep files organised"`

**Consistency:** Conflicting instructions across CLAUDE.md files may be followed arbitrarily. Audit periodically and remove outdated entries.

---

## Recommended sections

A project CLAUDE.md typically contains:

1. **Project Overview** — purpose, directory map (directory → what it contains), key entry points
2. **Common Commands** — build, test, lint, deploy (exact shell commands in code blocks)
3. **Conventions** — naming rules, module system (ESM vs CJS), code style
4. **Rules** — numbered imperative rules (e.g. `1. Never commit .env files`)
5. **Architecture Decisions** — anything Claude wouldn't discover from reading the code

**Token budget guidance:** CLAUDE.md is loaded alongside the conversation context — it's visible in the context window visualiser. The 200-line target keeps it fast and effective. Move multi-step procedures to [skills](/en/skills). Move per-subdirectory rules to `.claude/rules/`.

---

## Importing additional files

Use `@path/to/file` syntax to pull in other files (relative or absolute). Imported files are expanded at launch. Recursive imports are supported up to 5 hops deep:

```text
See @README for project overview and @package.json for available npm commands.

# Additional Instructions
- git workflow: @docs/git-instructions.md
```

---

## Path-scoped rules with `.claude/rules/`

For larger projects, break instructions into topic-specific files under `.claude/rules/`. Each `.md` file covers one topic. Files without `paths` frontmatter load at launch. Files with `paths` frontmatter load only when Claude works with matching files — reducing context noise:

```
your-project/
├── CLAUDE.md               ← main project instructions
└── .claude/
    └── rules/
        ├── code-style.md   ← no paths: loads always
        ├── testing.md
        └── api.md          ← has paths: only loads for src/api/**
```

```markdown
---
paths:
  - "src/api/**/*.ts"
---

# API Rules
- All endpoints must include input validation
- Use the standard error response format
```

Glob patterns supported: `**/*.ts`, `src/**/*`, `*.{ts,tsx}`.

---

## Auto memory (complementary system)

Claude Code also maintains an **auto memory** directory at `~/.claude/projects/<project>/memory/`. Claude writes its own notes here (build commands, debugging insights, code-style preferences) — separate from the human-authored CLAUDE.md. The first 200 lines of `MEMORY.md` (or 25KB, whichever is first) are loaded at session start; topic files are loaded on demand.

| | CLAUDE.md | Auto memory |
|---|---|---|
| Who writes it | You | Claude |
| What it contains | Instructions & rules | Learnings & patterns |
| Scope | Project / user / org | Per working tree |

---

## Quick-start

Run `/init` inside Claude Code to auto-generate a starting `CLAUDE.md`. Claude analyses the codebase and fills in build commands, test instructions, and conventions it discovers. Use `CLAUDE_CODE_NEW_INIT=1` for an interactive multi-phase flow.

---

## Common pitfalls

- **File not listed in `/memory` output** → Claude can't see it; check file location
- **Instructions lost after `/compact`** → root-level CLAUDE.md survives; nested CLAUDE.md in subdirs do not auto-reload
- **File too large** → split with `@` imports or `.claude/rules/`
- **Conflicting rules** → audit across CLAUDE.md files; later-loaded files win at the same directory level
