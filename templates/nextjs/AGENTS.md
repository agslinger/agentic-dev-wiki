# AGENTS.md

> Shared agent instructions. Read by both Claude Code (`@AGENTS.md` import) and OpenAI Codex (native).
> Keep this under 80 lines. Put topic-specific rules in `.claude/rules/`.

## Project

Next.js App Router with TypeScript strict mode. Full-stack: React 19 frontend, API routes, Drizzle ORM + PostgreSQL + pgvector.

```
app/           ← Next.js App Router (pages, layouts, API routes)
components/    ← React components (shadcn/ui + custom)
lib/           ← Shared utilities, AI clients, config
db/            ← Drizzle schema, migrations, client
public/        ← Static assets
```

## Stack

- Framework: Next.js (App Router), React 19, TypeScript strict
- UI: Tailwind CSS 4 + shadcn/ui + Lucide React icons
- Data: Drizzle ORM + PostgreSQL + pgvector
- AI: Vercel AI SDK + Claude (Bedrock) + OpenAI (gpt-4o-mini, embeddings)
- Validation: Zod 4
- Lint/format: Biome (or ESLint flat config + Prettier)
- Test: Vitest (unit/component) + Playwright (E2E smoke)
- Deploy: Vercel
- Review: CodeRabbit

## Commands

```bash
npm run dev               # Next.js dev server
npm run build             # Production build
npm run lint              # Biome check (or next lint)
npm run lint:fix          # Biome check --write
npm run format            # Biome format --write
npm run format:check      # Biome format (check only)
npm test                  # Vitest — single run
npm run test:watch        # Vitest — watch mode
npm run test:coverage     # Vitest — with coverage thresholds
npm run test:e2e          # Playwright — browser smoke tests
npx drizzle-kit generate  # Generate migration from schema
npx drizzle-kit migrate   # Apply migrations
```

## Workflow

1. Read relevant source files before changing them.
2. Make the simplest useful change that can prove the workflow works.
3. Get one simplified happy-path workflow working before broadening the implementation.
4. Run the narrowest relevant test immediately after that small change.
5. Fix failures before expanding the scope.
6. Run `npm run lint` and `npm run build` at slice boundaries and before committing.
7. Use plan mode for changes touching more than 3 files.
8. Commit each coherent passing slice with a descriptive message explaining *why*, not just *what*.

## Quality Gates

- `npm run build` succeeds (zero type errors)
- `npm test` passes with ≥70% coverage
- `npm run lint` exits clean
- `npm run format:check` exits clean
- No secrets in source

## Rules

- TypeScript strict mode is mandatory — never set `strict: false`.
- Use `import`, never `require`. Use `node:` protocol for built-ins.
- Validate all external inputs and AI outputs with Zod before use.
- Never expose stack traces or internal paths in responses.
- Never hardcode secrets — use env vars or Vercel env config.
- Never modify files under `db/migrations/` without explicit approval.
- Keep route handlers and server actions thin — delegate to lib/ functions.
- Prefer server components; use `"use client"` only when interactivity requires it.
- Use shadcn/ui components before building custom ones.
- Use Lucide React for icons — do not mix icon libraries.
- Prefer one proving vertical slice over one large unfinished feature branch.
- If a task touches many files before any test passes, stop and simplify the slice until it proves the workflow.
- Prove one dummy end-to-end route or user flow before applying the pattern across more routes and components.

## Naming

- Files and directories: `kebab-case`
- Components: `PascalCase.tsx` (exception to kebab rule for React convention)
- Variables and functions: `camelCase`
- Types and interfaces: `PascalCase`
- Constants: `UPPER_SNAKE_CASE`
- Test files: `*.test.ts` or `*.test.tsx` co-located with source

## Error Handling

- Use Next.js `error.tsx` boundaries for page-level errors.
- API routes: return `NextResponse.json()` with appropriate status; never leak internals.
- Server actions: return typed error results, not thrown exceptions.
- Log full errors server-side; show generic messages client-side.
