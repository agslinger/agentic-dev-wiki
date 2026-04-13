---
title: Testing Setup for Node.js
type: pattern
status: draft
confidence: 80
tags: [nodejs, testing, jest, vitest, unit-test, integration-test]
last-updated: 2026-04-12
sources:
  - "Vitest docs: https://vitest.dev/"
  - "Vitest getting started guide: https://vitest.dev/guide/"
  - "Node.js Best Practices — goldbergyoni: https://github.com/goldbergyoni/nodebestpractices"
  - "Node.js test runner docs: https://nodejs.org/api/test.html"
  - "Jest homepage: https://jestjs.io/"
  - "supertest README: https://github.com/ladjs/supertest"
---

# Testing Setup for Node.js

## Read This When

- Choosing a test runner for a Node.js service
- Setting up HTTP tests
- Deciding what to test first

## Default Recommendation

- Use `Vitest` for new Node.js projects.
- Use `supertest` for HTTP-level tests.
- Keep `node:test` for zero-dependency tooling or scripts.
- Start with API/component tests, then unit tests, then E2E.
- Enforce coverage in CI.

## Use This Pattern

Install:

```bash
npm install --save-dev vitest @vitest/coverage-v8 supertest
```

Suggested scripts:

```json
{
  "scripts": {
    "test": "vitest run",
    "test:watch": "vitest",
    "test:coverage": "vitest run --coverage"
  }
}
```

Minimal config:

```js
export default defineConfig({
  test: {
    environment: 'node',
    coverage: {
      provider: 'v8',
      thresholds: {
        lines: 70,
        branches: 70,
        functions: 80,
        statements: 70
      }
    }
  }
});
```

HTTP test pattern:

- export `createServer()` from `app.js`
- call `.listen()` only in `index.js`
- test the server over HTTP with `supertest`

## Commands / Config

Use `Vitest` when:

- project is ESM
- team wants Jest-like API
- speed matters

Use `node:test` when:

- zero extra deps matter more than ecosystem

## Pitfalls

- Do not start with only unit tests if the service is mostly HTTP behavior.
- Do not share mutable state between tests.
- Do not skip coverage thresholds in CI once the suite exists.

## Related Pages

- [nodejs-patterns](nodejs-patterns.md)
- [cicd-github-actions](cicd-github-actions.md)
- [new-project-checklist](new-project-checklist.md)
