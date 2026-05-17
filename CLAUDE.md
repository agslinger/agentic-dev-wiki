@AGENTS.md

# CLAUDE.md — Agentic Dev Wiki

## Claude-specific notes

- Use Claude hooks and `.claude/settings.json` as useful enforcement/automation, especially for wiki maintenance reminders and allowed tooling.
- Use `.claude/rules/` for scoped guidance instead of expanding this file.
- For ingest work, `WebFetch` and `WebSearch` are useful and allowed in `.claude/settings.json`.
- Keep this file thin; shared repo policy belongs in `AGENTS.md`.
