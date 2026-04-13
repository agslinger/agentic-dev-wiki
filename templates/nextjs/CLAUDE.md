# CLAUDE.md

@AGENTS.md

## Claude Code

- Use subagents for codebase exploration — keep main context clean.
- Use `/clear` between unrelated tasks.
- Start a fresh session when context exceeds ~60%.
- For features touching >3 files, enter plan mode first.
- Work in the simplest passing slice that proves something works.
- Prefer a dummy happy path first: one simplified route or user flow that proves the design end to end.
- After each small change, run the narrowest relevant test before continuing.
- After implementing, verify your own work — run tests, check build, read the diff.
- Commit after each coherent passing slice instead of batching unrelated work.
- Start the dev server and test UI changes in a browser before reporting done.

## Hooks Active

These run automatically — you do not need to duplicate their behavior:

- **PostToolUse (Write|Edit)**: auto-lint changed files with Biome
- **PostToolUse (Write|Edit)**: auto-test related files to encourage tight loops
- **PreToolUse (Bash)**: blocks destructive commands
- **Pre-commit (Husky)**: Gitleaks + lint-staged

## Do Not

- Do not suppress lint or type errors to make the build pass.
- Do not add `// @ts-ignore` or `// @ts-expect-error` without a comment explaining why.
- Do not commit `.env.local`, credentials, or key files.
- Do not run `npx drizzle-kit migrate` without explicit approval.
- Do not add new npm dependencies without stating why.
- Do not use `any` type — use `unknown` and narrow, or define a proper type.
