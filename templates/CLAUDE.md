# CLAUDE.md

@AGENTS.md

## Claude Code

- Use subagents for codebase exploration — keep main context clean.
- Use `/clear` between unrelated tasks.
- Start a fresh session when context exceeds ~60%.
- For features touching >3 files, enter plan mode first.
- Work in the simplest passing slice that proves something works.
- Prefer a dummy happy path first: one simplified workflow that proves the design end to end.
- After each small change, run the narrowest relevant test before continuing.
- After implementing, verify your own work — run tests, check lint, read the diff.
- Commit after each coherent passing slice instead of batching unrelated work.

## Hooks Active

These run automatically — you do not need to duplicate their behavior:

- **PostToolUse (Write|Edit)**: auto-lint changed files
- **PostToolUse (Write|Edit)**: auto-test related files to encourage tight loops
- **PreToolUse (Bash)**: blocks `rm -rf`, `DROP TABLE`, `DELETE FROM`
- **Pre-commit (Husky)**: Gitleaks + lint-staged

## Do Not

- Do not suppress lint or test errors to make the build pass.
- Do not add `// eslint-disable` or `// @ts-ignore` without a comment explaining why.
- Do not commit `.env`, credentials, or key files.
- Do not run `pulumi up` without an explicit request.
