---
title: Claude Code Hooks
type: pattern
status: stub
confidence: 10
tags: [claude-code, ai-agent, hooks, automation]
last-updated: 2026-04-12
sources: []
---

# Claude Code Hooks

> **Status: stub** — needs Ingest from Anthropic Claude Code docs and community examples.

## What to research / fill in

- [ ] Hook event types: `PreToolUse`, `PostToolUse`, `Notification`, `Stop`, `SubagentStop`
- [ ] Hook configuration location (`.claude/settings.json` or `settings.local.json`)
- [ ] Hook input/output format (stdin JSON → stdout JSON)
- [ ] How to block a tool call from a hook (exit codes)
- [ ] How to inject feedback into Claude's context from a hook
- [ ] Environment variables available to hooks
- [ ] Common hook patterns:
  - Auto-lint on file edit
  - Auto-format on file save
  - Block commits without tests
  - Log all tool calls
  - Notify on task completion
  - Auto-run tests after code changes
- [ ] Hook security considerations (what hooks can/cannot do)
- [ ] Difference between hooks in `settings.json` vs `settings.local.json`

## Sources to Ingest

- Anthropic Claude Code docs: hooks section
- Community examples: GitHub search `claude code hooks settings.json`
- Rohitg00 extension gist: https://gist.github.com/rohitg00/2067ab416f7bbe447c1977edaaa681e2
