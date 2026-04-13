---
title: Next.js Application Patterns
type: pattern
status: draft
confidence: 78
tags: [nodejs, javascript, typescript]
last-updated: 2026-04-12
sources:
  - "Next.js App Router getting started: https://nextjs.org/docs/app/getting-started"
  - "Next.js installation guide: https://nextjs.org/docs/app/getting-started/installation"
  - "create-next-app reference: https://nextjs.org/docs/app/api-reference/cli/create-next-app"
  - "Next.js App Router docs: https://nextjs.org/docs/app"
  - "Pages Router docs: https://nextjs.org/docs/pages"
  - "next/font docs: https://nextjs.org/docs/app/building-your-application/optimizing/fonts"
---

# Next.js Application Patterns

## Read This When

- Bootstrapping a new Next.js app
- Choosing between App Router and Pages Router
- Deciding which scaffold defaults are worth keeping
- Standardizing local dev commands for a new app

## Default Recommendation

- Start with `create-next-app`.
- Use the App Router for new work unless the project has a Pages Router constraint.
- Keep the default local workflow simple: install, dev server, edit `app/`.
- Treat the generated README as starter text and replace it with project-specific guidance.
- Keep useful framework defaults like TypeScript, linting, and App Router unless the project has a reason not to.
- Keep deployment guidance separate from app-structure guidance.

## Use This Pattern

Useful current bootstrap defaults from official Next.js docs:

- `create-next-app` for scaffolding
- App Router for new apps
- TypeScript by default
- built-in linting support
- import aliases if the team wants them

Use Next.js for bootstrapping when:

- the app is React-based
- frontend routes and server-side behavior should live in one framework
- the team wants a strong default stack instead of assembling React tooling manually

Use App Router by default because current official docs center it as the primary model for new apps. Use Pages Router mainly for existing codebases or compatibility reasons.

Keep only the scaffolded defaults the project is actually adopting:

- package manager
- router model
- TypeScript vs JavaScript
- font setup
- deploy target

If the team standard is `bun`, common local commands are:

```bash
bun install
bun dev
```

If the team standard is `npm`, `pnpm`, or `yarn`, use the matching generated commands instead. Bun is supported, but it is not automatically the best default for every team.

`next/font` is a good bootstrap default when the app needs custom or Google fonts with minimal setup. Official docs say it optimizes fonts, removes external network requests, and self-hosts font assets for better privacy and performance.

## Commands / Config

Typical early checks:

- scaffold with `create-next-app`
- local dev server starts successfully
- first route renders at `http://localhost:3000`
- `README.md` and `CLAUDE.md` reflect the real package manager and deploy target

Useful bootstrap decisions to confirm early:

- package manager
- TypeScript vs JavaScript
- App Router vs Pages Router
- whether Tailwind stays
- deployment target

## Pitfalls

- Do not keep the stock boilerplate README unchanged once real project decisions exist.
- Do not assume `bun` is the right default unless the team already standardizes on it.
- Do not choose Pages Router for a new app unless compatibility or migration constraints justify it.
- Do not keep every scaffold default automatically; remove what the project is not actually adopting.
- Do not mix deployment advice into the app-structure page when a separate deployment page is clearer.

## Related Pages

- [nextjs-testing](nextjs-testing.md) — Vitest + Playwright for Next.js
- [react-tailwind-shadcn-ui](react-tailwind-shadcn-ui.md) — UI layer for Next.js apps
- [testing-setup](testing-setup.md)
- [cicd-github-actions](cicd-github-actions.md)
- [vercel-deployment](vercel-deployment.md)
