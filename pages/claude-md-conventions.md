---
title: CLAUDE.md / AGENTS.md Conventions
type: pattern
status: stub
confidence: 10
tags: [claude-code, ai-agent, agents-md]
last-updated: 2026-04-12
sources: []
---

# CLAUDE.md / AGENTS.md Conventions

> **Status: stub** — needs Ingest from Anthropic docs and community templates.

## What to research / fill in

- [ ] Difference between `CLAUDE.md` and `AGENTS.md` — when to use each
- [ ] File placement: repo root vs. subdirectory (e.g., `src/CLAUDE.md`)
- [ ] Required vs. optional sections
- [ ] How Claude Code discovers and loads these files (hierarchy, inheritance)
- [ ] Global `~/.claude/CLAUDE.md` vs. project-level
- [ ] Best practice section headings (Project Overview, Conventions, Rules, Commands, etc.)
- [ ] How to reference the wiki from a project-level CLAUDE.md
- [ ] Token budget considerations — what to keep short vs. detailed

## Known Patterns (from IaC-test-app)

The existing `AGENTS.md` in `agslinger/IaC-test-app` demonstrates:
- Project Overview table (directory → purpose mapping)
- Conventions section (entry points, naming rules)
- Rules section (numbered, imperative)
- Common Commands section (bash codeblocks)
- Adding New Infrastructure section (numbered steps)

## Sources to Ingest

- Anthropic Claude Code official docs (CLAUDE.md guide)
- Community templates: GitHub search `"CLAUDE.md" template`
- Karpathy: https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f
