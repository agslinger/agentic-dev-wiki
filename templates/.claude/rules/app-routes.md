---
paths:
  - "app/**/*.ts"
  - "app/**/*.tsx"
---

# App Router Rules

- Prefer server components by default; add `"use client"` only when interactivity requires it.
- Validate all request inputs and AI outputs with Zod before processing.
- API routes: return appropriate typed responses; never leak stack traces.
- Server actions: return typed result objects, not thrown exceptions.
- Keep route handlers and server actions thin; delegate to `lib/` functions.
- For new workflows, get one simplified route or action working end to end before generalizing.
- If there are multiple reasonable approaches, ask the user one concise question before committing to one.
