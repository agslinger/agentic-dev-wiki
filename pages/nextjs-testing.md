---
title: Next.js Testing
type: pattern
status: draft
confidence: 72
tags: [nodejs, testing, vitest, jest, integration-test]
last-updated: 2026-04-12
sources:
  - "Playwright docs: https://playwright.dev/docs/intro"
  - "Vitest docs: https://vitest.dev/"
  - "Next.js documentation: https://nextjs.org/docs/app/getting-started"
---

# Next.js Testing

## Read This When

- Adding tests to a Next.js app
- Deciding how to combine unit, integration, and browser E2E tests
- Bootstrapping a practical test stack for App Router projects

## Default Recommendation

- Use `Vitest` for fast unit and component-adjacent logic tests.
- Use `Playwright` for browser E2E tests.
- Start with a small Playwright smoke suite for critical flows.
- Keep E2E coverage focused on user-visible flows, not every component detail.
- Reuse the broader Node.js testing guidance unless Next.js behavior changes the decision.

## Use This Pattern

Recommended stack:

1. `Vitest` for utility code, pure logic, and fast feedback
2. framework-level integration tests where needed
3. `Playwright` for route, navigation, auth, and rendering smoke tests

Typical first Playwright flows:

- homepage loads
- main navigation works
- key route renders expected content
- auth or form submission flow works if relevant

When Next.js is using server rendering or route handlers, Playwright is especially useful because it verifies the real browser behavior across routing, rendering, and network boundaries.

## Commands / Config

Suggested scripts:

```json
{
  "scripts": {
    "test": "vitest run",
    "test:e2e": "playwright test",
    "test:e2e:ui": "playwright test --ui"
  }
}
```

Keep E2E separate from the fast unit-test loop:

- run Vitest often
- run Playwright smoke tests before merge
- expand browser coverage only when the app complexity justifies it

## Pitfalls

- Do not rely on Playwright as the only test layer.
- Do not create a large flaky browser suite before basic unit coverage exists.
- Do not test every UI detail in E2E when lower-level tests are faster and clearer.

## Related Pages

- [testing-setup](testing-setup.md)
- [nextjs-patterns](nextjs-patterns.md)
- [cicd-github-actions](cicd-github-actions.md)
