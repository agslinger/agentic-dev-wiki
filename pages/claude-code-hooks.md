---
title: Claude Code Hooks
type: pattern
status: draft
confidence: 85
tags: [claude-code, ai-agent, hooks, automation]
last-updated: 2026-04-12
sources:
  - "Anthropic Claude Code hooks docs: https://code.claude.com/docs/en/hooks"
---

# Claude Code Hooks

## Read This When

- Adding Claude-side automation
- Blocking risky actions
- Running local checks after edits
- Deciding what belongs in `.claude/settings.json` vs `.claude/settings.local.json`

## Default Recommendation

- Put shared hooks in `.claude/settings.json`.
- Put personal or machine-specific hooks in `.claude/settings.local.json`.
- Put non-trivial logic in scripts under `.claude/hooks/`.
- Start with `PostToolUse` and `SessionEnd`.
- Use `PreToolUse` only for real guardrails.

## Use This Pattern

Most useful events:

| Event | Use |
|---|---|
| `PostToolUse` | Run lint/report steps after edits |
| `SessionEnd` | Write summaries, observations, or logs |
| `PreToolUse` | Block destructive actions |
| `ConfigChange` | Warn when config affects repo automation |

Minimal shape:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/graph-sync.ps1"
          }
        ]
      }
    ]
  }
}
```

Recommended script layout:

```text
/.claude/
  settings.json
  settings.local.json
  hooks/
    graph-sync.ps1
    session-summary.ps1
    config-guard.ps1
```

## Commands / Config

Key rules:

- exit code `2` blocks
- exit code `0` allows optional JSON output
- large inline shell commands are harder to debug than checked-in scripts
- `async: true` is good for reporting tasks

Prefer:

- `PostToolUse` for informational automation
- `SessionEnd` for summaries
- `PreToolUse` for deny/ask decisions

## Pitfalls

- Exit code `1` does not block.
- Large inline commands inside JSON become unreadable quickly.
- Hooks run with Claude's OS permissions.
- Shared hooks should be code-reviewed like application code.

## Related Pages

- [claude-md-conventions](claude-md-conventions.md)
- [linting-setup](linting-setup.md)
- [security-scanning](security-scanning.md)
