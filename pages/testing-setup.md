---
title: Testing Setup for Node.js
type: pattern
status: draft
confidence: 82
tags: [nodejs, testing, jest, vitest, unit-test, integration-test]
last-updated: 2026-05-17
sources:
  - "Vitest docs: https://vitest.dev/"
  - "Vitest getting started guide: https://vitest.dev/guide/"
  - "Node.js Best Practices — goldbergyoni: https://github.com/goldbergyoni/nodebestpractices"
  - "Node.js test runner docs: https://nodejs.org/api/test.html"
  - "Jest homepage: https://jestjs.io/"
  - "supertest README: https://github.com/ladjs/supertest"
  - "Playwright docs: https://playwright.dev/docs/intro"
  - "YouTube — A love letter to Pi | Lucas Meijer: https://www.youtube.com/watch?v=fdbXNWkpPMY"
---

# Testing Setup for Node.js

## Read This When

- Choosing a test runner for a Node.js service
- Setting up HTTP tests
- Deciding what to test first

## Default Recommendation

- Use `Vitest` for new Node.js projects.
- Use `supertest` for HTTP-level tests.
- Use `Playwright` for true browser E2E tests.
- Keep `node:test` for zero-dependency tooling or scripts.
- Work in the simplest passing slice that proves something works.
- Prove one simplified happy-path workflow end to end before broadening the implementation.
- Run the narrowest relevant test immediately after each small change.
- Start with API/component tests, then unit tests, then E2E.
- Enforce coverage in CI.
- Keep Playwright as the top test layer, not the main fast-feedback layer.
- Start with a small Playwright smoke suite and expand only for high-value user flows.
- After the automated checks pass, prepare a short manual review pack before commit.
- Commit after each coherent passing slice, not after a large batch of work.

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

Recommended test stack:

1. `Vitest` for unit and service logic
2. `supertest` for HTTP and API integration
3. `Playwright` for browser-level E2E smoke tests

Recommended loop:

1. make the simplest change that can prove the workflow
2. run the smallest relevant test immediately
3. fix failures before expanding the change
4. run broader checks only at slice boundaries
5. prepare a manual review pack after tests, lint, and build are green
6. commit once the slice is green and easy to review

Human-like expansion rule:

1. get a dummy workflow working on one simplified case
2. verify that case end to end
3. only then generalize to more inputs, edge cases, and wider code areas

Review-pack defaults:

- backend or API change -> list files changed, exact command or request to replay, expected response
- browser or UI change -> include screenshots and a short click path; add a demo clip for richer behavior
- build or tooling change -> record the exact commands run and the warning or failure that should now be gone

## Commands / Config

Use `Vitest` when:

- project is ESM
- team wants Jest-like API
- speed matters

Use `node:test` when:

- zero extra deps matter more than ecosystem

Use `Playwright` when:

- a real browser matters
- you need user-flow confidence across the full stack
- you want a small smoke suite on top of unit and integration tests

Loop sizing rule:

- changed function or helper -> targeted Vitest test first
- changed HTTP behavior -> closest `supertest` or integration test first
- changed user-facing browser flow -> smallest relevant Playwright smoke test first
- full suite -> before commit, PR, or major slice boundary

## Pitfalls

- Do not start with only unit tests if the service is mostly HTTP behavior.
- Do not share mutable state between tests.
- Do not skip coverage thresholds in CI once the suite exists.
- Do not replace fast unit/integration feedback with a large E2E-only suite.
- Do not start with broad Playwright coverage; begin with a few smoke tests for critical flows.
- Do not keep coding across many files without a passing checkpoint.
- Do not wait until the end of a large feature to run the first meaningful test.
- Do not generalize a workflow across the codebase before one simple version works end to end.
- Do not optimize for tiny slices that prove nothing; optimize for the simplest slice that proves the path works.
- Do not stop at "tests passed" when the human still has to reconstruct how to review the slice.

## Related Pages

- [agent-development-lifecycle](agent-development-lifecycle.md)
- [nextjs-testing](nextjs-testing.md) — Next.js-specific test stack (Vitest + Playwright)
- [nodejs-patterns](nodejs-patterns.md)
- [cicd-github-actions](cicd-github-actions.md)
- [new-project-checklist](new-project-checklist.md)
