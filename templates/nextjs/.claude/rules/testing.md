---
paths:
  - "**/*.test.ts"
  - "**/*.test.tsx"
  - "**/*.spec.ts"
  - "**/*.spec.tsx"
  - "tests/**"
  - "e2e/**"
---

# Testing Rules

- Each test follows AAA: Arrange, Act, Assert.
- Test names describe: what → under what conditions → expected outcome.
- No shared mutable state between tests — each test sets up its own data.
- HTTP tests use supertest or Next.js test helpers, not manual fetch calls.
- Mock external services (AI clients, database) at the module boundary with `vi.mock()`.
- Do not mock the HTTP layer — test it with real requests.
- Add or update the closest relevant test before broadening a change.
- Prefer the smallest targeted test command before the full suite.
- Prove one simplified happy-path workflow before adding edge cases.
- For browser flows, start with one Playwright smoke path before adding variants.
- Commit after the smallest passing slice, not after a large unfinished batch.
