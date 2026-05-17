---
title: .gitignore Best Practices
type: pattern
status: draft
confidence: 80
tags: [nodejs, typescript, security, claude-code]
last-updated: 2026-04-12
sources:
  - "GitHub gitignore templates: https://github.com/github/gitignore"
---

# .gitignore Best Practices

## Read This When

- Creating a `.gitignore` for a new project
- Auditing what should and should not be tracked
- Deciding which agent or tool config files belong in source control

## Default Recommendation

- Start from the GitHub Node.gitignore template and trim what you do not need.
- Commit shared tool config (`.claude/settings.json`, hooks, rules). Ignore personal config (`.claude/settings.local.json`).
- Never track secrets, credentials, or environment files.
- Review `.gitignore` as part of the bootstrap checklist, not as an afterthought.

## Use This Pattern

### Always ignore

```gitignore
# Dependencies
node_modules/

# Build output
dist/
.next/
out/
.vercel/

# Environment and secrets
.env
.env.*
!.env.example
*.pem
*.key
*credentials.json

# OS and editor
.DS_Store
Thumbs.db
*.swp
*~

# Test and coverage
coverage/

# Package manager logs
*.log
```

### Agent and tool config

Track shared config that the team should use consistently. Ignore personal config that varies per developer.

| File | Track? | Reason |
|---|---|---|
| `.claude/settings.json` | Yes | Shared hooks, permissions, tool policy |
| `.claude/settings.local.json` | No | Personal overrides, API keys |
| `.claude/rules/` | Yes | Path-scoped agent instructions |
| `.claude/hooks/` | Yes | Team-standard automation |
| `.coderabbit.yaml` | Yes | Shared review config |
| `.gitleaks.toml` | Yes | Shared secret scanning config |
| `.obsidian/` | Depends | Track if the team uses Obsidian for the repo; ignore otherwise |

```gitignore
# Personal Claude Code config
.claude/settings.local.json
```

### Secrets and credentials

These should never be tracked, even temporarily:

- `.env` and variants (`.env.local`, `.env.production`)
- Service account JSON files
- Private keys (`.pem`, `.key`)
- `credentials.json` or similar auth files

Provide a `.env.example` with placeholder values so developers know what variables are needed without exposing real values.

### Vercel and deployment

```gitignore
.vercel/
```

The `.vercel/` directory contains project linking metadata that may include org-specific details. Track it only if the team explicitly decides to.

## Commands / Config

```bash
# Check what is currently ignored
git status --ignored

# Check if a specific file is ignored
git check-ignore -v path/to/file

# Stop tracking a file that was committed before being ignored
git rm --cached path/to/file
```

## Pitfalls

- Do not ignore hook scripts or shared agent config — they are team infrastructure.
- Do not commit `.env` even once — it stays in git history. Use `git rm --cached` and rotate any exposed secrets.
- Do not use overly broad patterns like `*.json` — be specific about which JSON files to ignore.
- Do not forget `.env.example` — without it, new developers have no reference for required variables.
- Do not ignore lock files (`package-lock.json`, `pnpm-lock.yaml`) — they ensure reproducible installs.

## Related Pages

- [security-scanning](security-scanning.md)
- [new-project-checklist](new-project-checklist.md)
- [claude-md-conventions](claude-md-conventions.md)
- [project-templates](project-templates.md)
