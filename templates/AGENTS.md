# AGENTS.md

> Shared agent instructions. Read by both Claude Code (`@AGENTS.md` import) and OpenAI Codex (native).
> Keep this under 80 lines. Put topic-specific rules in `.claude/rules/`.

## Project

Node.js 22 service on GCP Cloud Functions v2. Pulumi YAML for infrastructure.

```
src/           ← application code (ESM, own package.json)
  index.js     ← entry point — calls createServer().listen(PORT)
  app.js       ← exports createServer() — all routing and middleware
infra/         ← Pulumi IaC (own package.json, separate deps)
```

App and infra are independent Node.js projects. Never mix their dependencies.

## Stack

- Runtime: Node.js 22, ESM (`"type": "module"`)
- Test: Vitest + supertest (HTTP) + Playwright (E2E smoke)
- Lint: ESLint flat config + Prettier
- Pre-commit: Husky + lint-staged + Gitleaks
- IaC: Pulumi YAML, GCP provider
- CI: GitHub Actions (lint → test → deploy)
- Review: CodeRabbit

## Commands

```bash
npm test                # Vitest — single run
npm run test:watch      # Vitest — watch mode
npm run test:coverage   # Vitest — with coverage thresholds
npm run test:e2e        # Playwright — browser smoke tests
npm run lint            # ESLint
npm run lint:fix        # ESLint --fix
npm run format:check    # Prettier --check
npm run format          # Prettier --write
```

## Workflow

1. Read relevant source files before changing them.
2. Make the simplest useful change that can prove the workflow works.
3. Get one simplified happy-path workflow working before broadening the implementation.
4. Run the narrowest relevant test immediately after that small change.
5. Fix failures before expanding the scope.
6. Run `npm run lint` and broader checks at slice boundaries and before committing.
7. Use plan mode for changes touching more than 3 files.
8. Commit each coherent passing slice with a message explaining *why*, not just *what*.

## Quality Gates

All of these must pass before a PR is ready:

- `npm test` passes with ≥70% line and branch coverage
- `npm run lint` exits clean (zero errors)
- `npm run format:check` exits clean
- No secrets in source (Gitleaks pre-commit is active)

## Rules

- Use `import`, never `require`.
- Use `node:` protocol for built-in modules (`import fs from 'node:fs'`).
- Validate all external inputs with zod at the handler boundary.
- Never expose stack traces or internal paths in HTTP error responses.
- Never hardcode secrets — use env vars or `pulumi config set --secret`.
- Never modify files under `infra/migrations/` without explicit approval.
- Keep route handlers thin — delegate to service layer functions.
- Export `createServer()` from `app.js`; only call `.listen()` in `index.js`.
- Prefer 1 proving slice over 1 large unfinished feature.
- If work grows before anything is proven, stop and simplify the slice until it proves the workflow.
- Prove one dummy end-to-end path before applying the pattern across the wider codebase.

## Naming

- Files: `kebab-case.js`
- Variables and functions: `camelCase`
- Classes: `PascalCase`
- Constants: `UPPER_SNAKE_CASE`
- Test files: `*.test.js` co-located with source

## Error Handling

- Operational errors (invalid input, not found): return appropriate HTTP status, generic message.
- Catastrophic errors (uncaught exception): log full error, then `process.exit(1)`.
- Never resume after an uncaught exception.
