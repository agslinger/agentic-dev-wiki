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

> **Status: draft** — sourced from Vitest docs and Node.js Best Practices (April 2026).

---

## Framework decision: Vitest vs Jest vs node:test

| Criterion | Vitest | Jest | node:test |
|---|---|---|---|
| ESM support | Native (via Oxc) | Requires Babel/ts-jest transform | Native (Node 20+) |
| TypeScript | Native (via Oxc) | Requires ts-jest or babel | Requires tsx/ts-node |
| Speed | Fast (Vite pipeline) | Moderate | Fast (no deps) |
| API | Jest-compatible | — | Different API, smaller |
| Dependencies | Vite ≥6, Node ≥20 | Any Node | Built-in, zero deps |
| Mocking | Built-in vi.mock() | Built-in jest.mock() | t.mock.fn/method/module/timers |
| Coverage | @vitest/coverage-v8 | built-in --coverage | --experimental-test-coverage |
| Snapshots | Built-in | Built-in | Built-in (t.assert.snapshot) |
| Ecosystem / plugins | Growing | Mature (100M+/month downloads) | Minimal |
| Process isolation | Single process (default) | Parallel processes | Separate processes (default) |

**Recommendation for new projects:** Use **Vitest** — ESM-native, Jest-compatible API, zero transform config for TypeScript, fast watch mode. Requires Node ≥ 20.

**When to choose Jest:** Existing large Jest test suite, deep use of Jest-specific plugins (React Testing Library, etc.), or team familiarity that outweighs migration effort. Note: Jest requires Babel or ts-jest for ESM/TypeScript.

**When to choose node:test:** Zero-dependency requirement (tooling scripts, CLI utilities), projects that must not pull in external test deps, or when you want to use Node's built-in test infrastructure without any framework.

---

## Vitest setup

### Install

```bash
npm install --save-dev vitest
# For coverage:
npm install --save-dev @vitest/coverage-v8
```

**Requirements:** Vite ≥ 6.0.0, Node ≥ 20.0.0

### package.json scripts

```json
{
  "scripts": {
    "test": "vitest run",
    "test:watch": "vitest",
    "test:coverage": "vitest run --coverage"
  }
}
```

Note: `vitest` (no args) starts watch mode. `vitest run` is single-pass for CI.

### Configuration

Vitest auto-reads `vite.config.*`. For backend Node.js projects without Vite, create a dedicated config:

```js
// vitest.config.js
import { defineConfig } from 'vitest/config';

export default defineConfig({
  test: {
    environment: 'node',     // default; alternatives: 'jsdom', 'happy-dom'
    globals: false,           // set true to avoid importing describe/it/expect
    coverage: {
      provider: 'v8',
      reporter: ['text', 'json', 'html'],
      thresholds: {
        lines: 70,
        branches: 70,
        functions: 70,
        statements: 70,
      },
    },
  },
});
```

### Test file naming

Test files must contain `.test.` or `.spec.` in the filename:
- `src/utils.test.js` (co-located)
- `src/__tests__/utils.js` (grouped)

Both patterns work. Co-located (`.test.js` next to source) is common for unit tests; a top-level `__tests__/` or `test/` dir is common for integration tests.

---

## Writing tests

### Three-part test names (best practice)

Structure test descriptions as: **what** is being tested → **under what conditions** → **expected outcome**:

```js
import { describe, it, expect } from 'vitest';
import { parseAmount } from './utils.js';

describe('parseAmount', () => {
  it('returns a positive integer when given a valid numeric string', () => {
    expect(parseAmount('42')).toBe(42);
  });

  it('throws a RangeError when the amount is negative', () => {
    expect(() => parseAmount('-1')).toThrow(RangeError);
  });
});
```

### AAA pattern (Arrange / Act / Assert)

```js
it('calculates the total with tax applied', () => {
  // Arrange
  const items = [{ price: 10 }, { price: 20 }];
  const taxRate = 0.1;

  // Act
  const total = calculateTotal(items, taxRate);

  // Assert
  expect(total).toBe(33);
});
```

### Per-test data (avoid global state)

Do not share mutable state across tests. Create fresh data in each test or `beforeEach`:

```js
// ✅ Good — each test is independent
beforeEach(() => {
  db = createInMemoryDb();
});

// ❌ Bad — tests share state, order-dependent failures
const db = createInMemoryDb();
```

---

## HTTP / component testing with supertest

For Node.js HTTP servers, test via HTTP rather than calling functions directly. This tests the real request-response contract:

```bash
npm install --save-dev supertest
```

```js
import { describe, it, expect, beforeAll, afterAll } from 'vitest';
import request from 'supertest';
import { createServer } from './app.js';

let server;

beforeAll(() => {
  server = createServer().listen(0); // port 0 = OS-assigned random port
});

afterAll(() => {
  server.close();
});

describe('GET /health', () => {
  it('responds 200 with ok status', async () => {
    const res = await request(server).get('/health');
    expect(res.status).toBe(200);
    expect(res.body.status).toBe('ok');
  });
});
```

**Key pattern:** export a `createServer()` function from `app.js` that returns the http.Server without calling `.listen()`. The entry-point `index.js` calls `createServer().listen(PORT)`. Tests call `createServer().listen(0)` to get a random port.

---

## Mocking GCP clients

For unit tests of functions that use BigQuery, Cloud Storage, etc., mock the client at the module boundary:

```js
import { vi, describe, it, expect } from 'vitest';

// Mock before import
vi.mock('@google-cloud/bigquery', () => ({
  BigQuery: vi.fn().mockImplementation(() => ({
    query: vi.fn().mockResolvedValue([[{ count: 42 }]]),
  })),
}));

import { getRecordCount } from './data-access.js';

describe('getRecordCount', () => {
  it('returns the count from BigQuery', async () => {
    expect(await getRecordCount()).toBe(42);
  });
});
```

**Principle:** Mock GCP clients for unit tests. For integration tests, prefer using real GCP services (or the GCP emulator where available) to catch auth/schema mismatches.

---

## Coverage thresholds

Recommended minimums for a production Node.js service:

| Metric | Minimum |
|---|---|
| Lines | 70% |
| Branches | 70% |
| Functions | 80% |
| Statements | 70% |

Configure in `vitest.config.js` under `test.coverage.thresholds`. CI fails if thresholds are not met when running `vitest run --coverage`.

---

## Priority order: what to test first

Per Node.js Best Practices:

1. **Component / API tests** (HTTP-level) — minimum baseline; highest ROI
2. **Unit tests** — for complex business logic with multiple branches
3. **E2E tests** — for critical user journeys in production-like environment

Avoid 100% unit test coverage on trivial getters/setters — test behaviour, not implementation.

---

---

## Supertest: HTTP integration testing

Supertest is the standard library for testing Node.js HTTP servers at the HTTP level — no browser needed.

### Install

```bash
npm install --save-dev supertest
```

### Basic usage (async/await)

```js
import { describe, it, expect, beforeAll, afterAll } from 'vitest';
import request from 'supertest';
import { createServer } from './app.js';

let server;
beforeAll(() => { server = createServer().listen(0); });  // port 0 = random
afterAll(()  => { server.close(); });

describe('GET /health', () => {
  it('returns 200 with ok status', async () => {
    const res = await request(server).get('/health');
    expect(res.status).toBe(200);
    expect(res.body.status).toBe('ok');
  });

  it('sets Content-Type: application/json', async () => {
    const res = await request(server).get('/health');
    expect(res.headers['content-type']).toMatch(/json/);
  });
});
```

Supertest **auto-binds the server to an ephemeral port** if it isn't already listening — no manual port management needed.

### Common assertions

```js
// Status code
.expect(200)

// Header (exact or regex)
.expect('Content-Type', /json/)
.expect('X-Frame-Options', 'DENY')

// Body
.expect(200, { status: 'ok' })

// Custom assertion
.expect(res => {
  expect(res.body.items).toHaveLength(3);
})
```

### Cookie persistence across requests

```js
const agent = request.agent(server);

await agent.post('/login').send({ user: 'alice', pass: 'secret' });
// agent retains the session cookie
const res = await agent.get('/profile');
expect(res.status).toBe(200);
```

### Sending request bodies and headers

```js
const res = await request(server)
  .post('/data')
  .set('Authorization', 'Bearer test-token')
  .set('Accept', 'application/json')
  .send({ key: 'value' });
```

---

## node:test (built-in, Node 20+)

The built-in test runner — no install required, stable since Node 20.

### Import and basic usage

```js
import { describe, it, before, after, beforeEach, afterEach } from 'node:test';
import assert from 'node:assert/strict';

describe('parseAmount', () => {
  it('returns a number for a valid string', () => {
    assert.strictEqual(parseAmount('42'), 42);
  });

  it('throws for negative values', () => {
    assert.throws(() => parseAmount('-1'), RangeError);
  });
});
```

### Running tests

```bash
# Discover and run all test files (*.test.js, *.spec.js, test/**/*.js, etc.)
node --test

# Run specific file
node --test src/utils.test.js

# Watch mode (experimental)
node --test --watch

# Coverage (experimental)
node --test --experimental-test-coverage

# Filter by name
node --test --test-name-pattern="parseAmount"
```

Default discovery patterns: `**/*.test.{js,mjs,cjs}`, `**/*.spec.{js,mjs,cjs}`, `**/test/**/*.{js,mjs,cjs}`, `**/test.{js,mjs,cjs}`

### Mocking

```js
import { test } from 'node:test';
import assert from 'node:assert/strict';

test('mock a function', (t) => {
  const fn = t.mock.fn((a, b) => a + b);
  fn(3, 4);
  assert.strictEqual(fn.mock.callCount(), 1);
  assert.deepStrictEqual(fn.mock.calls[0].arguments, [3, 4]);
});

// Timer mocking
test('mock setTimeout', (t) => {
  const fn = t.mock.fn();
  t.mock.timers.enable({ apis: ['setTimeout'] });
  setTimeout(fn, 1000);
  t.mock.timers.tick(1000);
  assert.strictEqual(fn.mock.callCount(), 1);
});
```

### Skip, todo, only

```js
it.skip('not ready yet', () => { /* skipped */ });
it.todo('implement me');

// Run only flagged tests: node --test --test-only
it('focused test', { only: true }, () => { /* runs */ });
```

### Reporters

```bash
node --test --test-reporter=spec     # human-readable (default)
node --test --test-reporter=tap      # TAP format
node --test --test-reporter=dot      # compact dots
node --test --test-reporter=junit    # XML for CI systems
node --test --test-reporter=lcov --test-reporter-destination=lcov.info
```

### Key differences from Vitest/Jest

| | node:test | Vitest/Jest |
|---|---|---|
| Install | None | npm install |
| Process model | Each test file in its own process | Single process (Vitest default) |
| Config file | None needed | vitest.config.js / jest.config.js |
| Plugin ecosystem | None | Rich (Vitest plugins, Jest matchers) |
| TypeScript | Via tsx/ts-node flag | Native |

---

## Jest reference (for existing codebases)

Jest is the incumbent framework — mature, 100M+ downloads/month, used by Facebook, Twitter, Spotify.

### Key traits
- **Zero config** for most JS projects (CJS)
- **ESM requires** Babel (`@babel/preset-env`) or `--experimental-vm-modules` + transform config
- **Snapshots** — inline and file-based
- **Coverage** built-in: `jest --coverage` (no extra package)
- **Parallel** — each test file runs in an isolated worker process

### When to migrate from Jest to Vitest
- If your project uses ESM or TypeScript and you're fighting transform configs
- If you want faster watch mode
- The Jest API is fully compatible — `describe`, `it`, `expect`, `vi.*` vs `jest.*`

### Jest config (for CJS or Babel-transpiled projects)

```js
// jest.config.js
export default {
  testMatch: ['**/*.test.js', '**/*.spec.js'],
  testEnvironment: 'node',
  coverageThreshold: {
    global: { lines: 70, branches: 70, functions: 80 },
  },
};
```

---

## Adding tests to an existing Node.js service

If a project has no tests yet, work through this in order:
1. Refactor so `app.js` exports `createServer()` without calling `.listen()` — entry point calls it
2. `npm install --save-dev vitest supertest`
3. Write smoke tests for the health endpoint and at least one data endpoint
4. Add `test`, `test:watch`, `test:coverage` scripts to `package.json`
5. Set 70% line/branch coverage threshold in `vitest.config.js`
6. Add `npm test` step to the CI workflow
