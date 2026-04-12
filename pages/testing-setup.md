---
title: Testing Setup for Node.js
type: pattern
status: stub
confidence: 10
tags: [nodejs, testing, jest, vitest, unit-test, integration-test]
last-updated: 2026-04-12
sources: []
---

# Testing Setup for Node.js

> **Status: stub** — needs Ingest from testing best practices and community examples.

## What to research / fill in

- [ ] Jest vs Vitest — decision criteria (ESM support, speed, API compatibility)
- [ ] Recommended folder structure: `__tests__/` vs `*.test.js` co-located
- [ ] Unit test patterns for route handlers (mock http.IncomingMessage)
- [ ] Integration test patterns for Cloud Functions (supertest or similar)
- [ ] Test coverage thresholds — what's a reasonable minimum
- [ ] Mocking GCP clients (BigQuery, etc.) — when to mock vs. use real services
- [ ] Test scripts in `package.json`: `test`, `test:watch`, `test:coverage`
- [ ] Pre-commit hook: run tests before commit (or just lint?)
- [ ] CI: fail PR if coverage drops below threshold
- [ ] Node.js built-in test runner (`node:test`) — viable alternative?

## Known Gap (IaC-test-app)

IaC-test-app has **no tests** — this is the highest priority gap to address when adding best practices to an existing project.

## Suggested Starting Point

For a simple Node.js app with native `http`:

```bash
npm install --save-dev vitest
```

```json
// package.json
"scripts": {
  "test": "vitest run",
  "test:watch": "vitest",
  "test:coverage": "vitest run --coverage"
}
```

## Sources to Ingest

- Vitest docs: https://vitest.dev/
- Jest docs: https://jestjs.io/
- Node.js test runner: https://nodejs.org/api/test.html
- Testing Node.js HTTP servers with supertest
