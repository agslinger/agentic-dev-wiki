# AGENTS.md

> Shared agent instructions. Read by both Claude Code (`@AGENTS.md` import) and OpenAI Codex (natively).
> Keep this concise. Put path-specific rules in `.claude/rules/`.

## Project

Default stack: Next.js App Router with TypeScript strict mode. Full-stack web app with React 19 frontend, Drizzle ORM + PostgreSQL + pgvector, Vercel AI SDK, Zod validation, Biome, Vitest, and Playwright.

```
app/           ← routes, layouts, server actions, route handlers
components/    ← UI components (shadcn/ui + custom)
lib/           ← shared utilities, AI clients, config
db/            ← Drizzle schema, migrations, client
public/        ← static assets
```

## Stack

- Framework: Next.js App Router
- Language: TypeScript strict mode
- UI: React 19, Tailwind CSS 4, shadcn/ui, Lucide, Geist
- Data: Drizzle ORM + PostgreSQL + pgvector
- AI: Vercel AI SDK + Claude (Bedrock) + OpenAI
- Validation: Zod 4
- Lint/format: Biome
- Test: Vitest + Playwright smoke
- Deploy: Vercel by default

## Build Order

Implement in proving stages. Do not jump ahead before the current stage works.

1. Scaffold app, TypeScript strict mode, Biome, and one route
2. Add Zod validation and one passing unit test
3. Add one simple UI path with Tailwind + shadcn/ui
4. Add one database schema and one proven read/write path
5. Add one AI flow on a dummy happy path
6. Add one Playwright smoke test for the main workflow
7. Add deployment and CI only after the app path is already proven locally

## Commands

```bash
npm run dev
npm run build
npm run lint
npm run format
npm test
npm run test:coverage
npm run test:e2e
npx drizzle-kit generate
npx drizzle-kit migrate
```

## Workflow

1. Read the relevant files first.
2. Build the simplest slice that proves the workflow works.
3. Prove one dummy happy path end to end before generalizing.
4. Run the narrowest relevant test immediately after each small change.
5. Fix failures before broadening scope.
6. Run lint, build, and broader checks at proving boundaries and before commit.
7. Commit each coherent proving slice separately.

## Decision Points

- If an option has real tradeoffs, ask the user one concise question before committing.
- Prefer safer defaults when choosing between options.
- Prefer stronger guardrails over lower setup effort.
- Prefer runtime validation, strict typing, and deterministic checks by default.

Ask before deciding things like:

- deployment target if the repo must fit an existing cloud standard
- database hosting/provider choice
- whether pgvector is needed now or later
- which model vendor is allowed or preferred

## Rules

- TypeScript strict mode is mandatory.
- Validate all external inputs and AI outputs with Zod.
- Prefer server components; add `"use client"` only when required.
- Use shadcn/ui before inventing custom component primitives.
- Use Lucide for icons; do not mix icon libraries.
- Never expose stack traces or internal paths in responses.
- Never hardcode secrets.
- Never modify migration files retroactively without explicit approval.
- Prefer one proving slice over one large unfinished feature.

