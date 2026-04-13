---
paths:
  - "**/*.test.ts"
  - "**/*.test.tsx"
  - "**/*.spec.ts"
  - "**/*.spec.tsx"
  - "test/**"
---

# Testing Rules

- Each test follows AAA: Arrange, Act, Assert.
- Test names describe: what → under what conditions → expected outcome.
- No shared mutable state between tests — each test sets up its own data.
- Prefer Vitest for unit and integration tests.
- Add or update the closest relevant test before broadening a change.
- Prefer the smallest targeted test command before the full suite.
- Prove one simplified happy-path workflow before adding edge cases or broad coverage.
- Optimize for the simplest slice that proves the path works, not the smallest slice in isolation.
- For browser flows, start with one Playwright smoke path before adding variants.
- Commit after the simplest proving slice, not after a large unfinished batch.
