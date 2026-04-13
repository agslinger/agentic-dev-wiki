---
paths:
  - "app/**/*.ts"
  - "app/**/*.tsx"
---

# App Router Rules

- Prefer server components by default; add `"use client"` only when interactivity requires it.
- Validate all request inputs and AI outputs with Zod before processing.
- API routes: return `NextResponse.json()` with appropriate status; never leak stack traces.
- Server actions: return typed result objects, not thrown exceptions.
- Use `error.tsx` boundaries for page-level error handling.
- Keep route handlers and server actions thin — delegate to `lib/` functions.
- For route changes, verify the smallest affected flow first before editing adjacent routes.
- Prefer one passing route slice over broad multi-route edits without checkpoints.
- Optimize for the simplest route or action path that proves the workflow works.
- For new workflows, get one simplified route or action working end to end before generalizing to more routes or states.
