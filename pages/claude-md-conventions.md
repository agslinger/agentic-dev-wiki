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

## Read This When

- Writing a repo `CLAUDE.md`
- Splitting instructions between `CLAUDE.md`, `CLAUDE.local.md`, and `.claude/rules/`
- Deciding what belongs in instructions vs settings JSON

## Default Recommendation

- Keep the main repo `CLAUDE.md` short and specific.
- Target under `200` lines.
- Put shared project rules in `CLAUDE.md`.
- Put local-only instructions in `CLAUDE.local.md`.
- Use `.claude/rules/` for topic-specific or path-scoped rules.
- If the repo already uses `AGENTS.md`, create a small `CLAUDE.md` that imports it.

## Use This Pattern

Recommended structure:

1. Project overview
2. Common commands
3. Conventions
4. Rules
5. Architecture decisions

Useful facts:

- Claude loads `CLAUDE.md` as context, not enforced config.
- More specific files take precedence.
- Files are concatenated, not replaced.
- Nested subdirectory `CLAUDE.md` files load when Claude works in that subtree.

Import pattern:

```md
@AGENTS.md

## Claude Code
- Use `npm test` before merge.
```

Path-scoped rules belong in `.claude/rules/*.md`:

```md
---
paths:
  - "src/api/**/*.ts"
---
```

## Commands / Config

Useful locations:

- shared project file: `./CLAUDE.md`
- personal project file: `./CLAUDE.local.md`
- reusable scoped rules: `./.claude/rules/*.md`
- user-wide file: `~/.claude/CLAUDE.md`

## Pitfalls

- Do not put large procedures in the main `CLAUDE.md`.
- Do not put automation logic in `CLAUDE.md`; use settings/hooks for that.
- Do not duplicate the same rules across `AGENTS.md`, `CLAUDE.md`, and `.claude/rules/`.
- Conflicting rules reduce adherence.

## Related Pages

- [claude-code-hooks](claude-code-hooks.md)
- [new-project-checklist](new-project-checklist.md)
