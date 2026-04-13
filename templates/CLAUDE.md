# CLAUDE.md

@AGENTS.md

## Claude Code

- Work in the simplest passing slice that proves something works.
- Prefer one dummy happy path first: one simplified route or user flow that proves the design end to end.
- After each small change, run the narrowest relevant test before continuing.
- If an architectural choice has non-obvious tradeoffs, ask the user a concise question before committing.
- Default to the safer, more strongly guarded option when the user has no stated preference.
- After implementing, verify your own work: run tests, lint, build, and read the diff.
- Commit after each coherent proving slice instead of batching unrelated work.

## Hooks Active

- **PostToolUse (Write|Edit)**: lint changed files
- **PostToolUse (Write|Edit)**: run the smallest relevant related test
- **PreToolUse (Bash)**: block destructive commands
- **Pre-commit**: Gitleaks + project-specific staged checks

## Do Not

- Do not suppress lint, test, or type errors to make progress look real.
- Do not broaden a pattern across the codebase before one simple version works end to end.
- Do not use `any` where a narrower type or `unknown` would preserve guardrails.
- Do not add dependencies or infra choices silently when a user decision is materially involved.
