---
title: Node.js Application Patterns
type: pattern
status: draft
confidence: 76
tags: [nodejs, javascript]
last-updated: 2026-04-12
sources:
  - "Node.js Best Practices — goldbergyoni: https://github.com/goldbergyoni/nodebestpractices"
  - "OWASP Node.js Security Cheat Sheet: https://cheatsheetseries.owasp.org/cheatsheets/Nodejs_Security_Cheat_Sheet.html"
  - "Community patterns for minimal Node.js HTTP services"
---

# Node.js Application Patterns

> **Status: draft** — sourced from goldbergyoni/nodebestpractices and OWASP Node.js cheat sheet (April 2026).

---

## Project structure

### Component-based (recommended)

Organise by **business domain**, not by technical layer. Each domain is a self-contained module:

```
src/
├── billing/
│   ├── billing.routes.js
│   ├── billing.service.js
│   └── billing.dal.js         ← data access layer
├── health/
│   ├── health.routes.js
│   └── health.service.js
├── app.js                     ← wires routes together, returns http.Server
└── index.js                   ← entry point: calls createServer().listen(PORT)
```

### 3-tier separation within each component

| Tier | Responsibility | Example |
|---|---|---|
| Entry-point / routes | HTTP parsing, request validation, response serialisation | `billing.routes.js` |
| Domain / service | Business logic, orchestration | `billing.service.js` |
| Data access | DB queries, external API calls | `billing.dal.js` |

Never let the web layer reach into the database directly. Never let the data layer call out to other domains.

### IaC isolation

Keep infrastructure code in a **separate Node.js project** with its own `package.json`:

```
project/
├── src/                    ← application (Node.js)
│   └── package.json
├── infra/                  ← IaC (Pulumi/Terraform — separate package.json)
│   └── package.json
└── CLAUDE.md
```

Never mix application dependencies with IaC dependencies.

---

## Entry point pattern (testable server)

Export `createServer()` without calling `.listen()`. The entry point calls listen; tests call it on port 0:

```js
// src/app.js — creates and configures the server, does NOT listen
import http from 'node:http';
import { handleRequest } from './router.js';

export function createServer() {
  return http.createServer(handleRequest);
}
```

```js
// src/index.js — entry point only
import { createServer } from './app.js';

const PORT = process.env.PORT || 8080;
const server = createServer();

server.listen(PORT, () => {
  console.log(`Listening on port ${PORT}`);
});
```

---

## Module system: ESM vs CommonJS

| | ESM (`import`/`export`) | CommonJS (`require`) |
|---|---|---|
| Node.js support | Native since Node 12, stable in Node 16+ | Original Node.js system |
| File extension | `.mjs` or `"type": "module"` in package.json | `.cjs` or default |
| Dynamic imports | `import()` (async) | `require()` (sync) |
| Ecosystem trend | Ecosystem migrating to ESM | Legacy; still widely used |
| Tooling | Vitest, ESLint, Prettier all support natively | All tools support |

**Recommendation for new projects:** Use ESM. Set `"type": "module"` in `package.json`. Use `import('node:fs')` syntax for built-in modules (node protocol imports — future-proof).

**When to stay on CJS:** When consuming packages that don't ship ESM, or when using tooling that doesn't support ESM well.

---

## Node.js version pinning

Always specify the required Node.js version in two places:

```json
// package.json
{
  "engines": {
    "node": ">=20.0.0"
  }
}
```

```
# .nvmrc
20
```

`.nvmrc` is used by `nvm use` locally and by `actions/setup-node` in CI (`node-version-file: .nvmrc`).

---

## Configuration and environment variables

- **Never hardcode config** — read from environment variables
- **Validate at startup** — fail fast if required keys are missing
- **Use a validation library** — zod, env-var, or convict

```js
// src/config.js
import { z } from 'zod';

const schema = z.object({
  PORT: z.coerce.number().default(8080),
  GCP_PROJECT_ID: z.string().min(1),
  NODE_ENV: z.enum(['development', 'production', 'test']).default('development'),
});

export const config = schema.parse(process.env);
// Throws ZodError on startup if required vars are missing — fail fast
```

---

## Error handling

### Operational vs. catastrophic errors

| Type | Definition | Response |
|---|---|---|
| **Operational** | Expected failures: invalid input, network timeout, resource not found | Handle gracefully, return error response |
| **Catastrophic** | Programmer errors: uncaught exception, undefined is not a function | Log, then `process.exit(1)` (let orchestrator restart) |

### Pattern: async/await with custom error classes

```js
// errors.js
export class AppError extends Error {
  constructor(message, { statusCode = 500, code, isOperational = true } = {}) {
    super(message);
    this.name = this.constructor.name;
    this.statusCode = statusCode;
    this.code = code;
    this.isOperational = isOperational;
  }
}

export class NotFoundError extends AppError {
  constructor(resource) {
    super(`${resource} not found`, { statusCode: 404, code: 'NOT_FOUND' });
  }
}
```

### Centralised error handler

```js
// src/middleware/errorHandler.js
export function errorHandler(err, req, res) {
  if (err.isOperational) {
    res.writeHead(err.statusCode, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify({ error: err.message, code: err.code }));
  } else {
    // Catastrophic — log and crash
    console.error('Unexpected error:', err);
    process.exit(1);
  }
}
```

---

## Graceful shutdown (SIGTERM handler)

Required for containerised deployments — Kubernetes/Cloud Run sends SIGTERM before killing a pod:

```js
// src/index.js
const server = createServer();
server.listen(PORT);

function shutdown(signal) {
  console.log(`Received ${signal}, shutting down gracefully`);
  server.close(() => {
    console.log('HTTP server closed');
    process.exit(0);
  });

  // Force exit after 10s if requests are still in-flight
  setTimeout(() => {
    console.error('Forced shutdown after timeout');
    process.exit(1);
  }, 10_000);
}

process.on('SIGTERM', () => shutdown('SIGTERM'));
process.on('SIGINT',  () => shutdown('SIGINT'));
```

---

## Security headers

Use `helmet` middleware or set headers manually. Required headers for production:

```js
// Manual header setting (native http module, no framework)
res.setHeader('Content-Security-Policy', "default-src 'none'");
res.setHeader('X-Content-Type-Options', 'nosniff');
res.setHeader('X-Frame-Options', 'DENY');
res.setHeader('Strict-Transport-Security', 'max-age=31536000; includeSubDomains');
res.setHeader('Referrer-Policy', 'strict-origin-when-cross-origin');
res.setHeader('Permissions-Policy', 'geolocation=(), microphone=()');
```

With Express/Fastify, use `helmet`:

```bash
npm install helmet
```

```js
import helmet from 'helmet';
app.use(helmet());
```

---

## Logging

Write logs to **stdout** without hardcoding destinations. Let container orchestration aggregate logs.

- **Use structured logging** (JSON) in production — easier to query in Cloud Logging / Datadog
- **pino** is the recommended logger: lowest overhead, JSON output by default

```bash
npm install pino
```

```js
import pino from 'pino';

export const logger = pino({
  level: process.env.LOG_LEVEL || 'info',
  // In development, use pino-pretty for human-readable output
});
```

**Never use `console.log` in production code for operational logging** — it's not structured and can't be filtered by severity.

---

## Health check endpoint

Every service should expose a health check for load balancers and orchestrators:

```js
// Convention: /health or /_health
if (req.method === 'GET' && req.url === '/health') {
  res.writeHead(200, { 'Content-Type': 'application/json' });
  res.end(JSON.stringify({ status: 'ok', ts: Date.now() }));
  return;
}
```

---

## CORS pattern

Validate origin against an allowlist — never use `Access-Control-Allow-Origin: *` for authenticated endpoints:

```js
const ALLOWED_ORIGINS = new Set(
  (process.env.ALLOWED_ORIGINS || '').split(',').filter(Boolean)
);

const origin = req.headers.origin;
if (ALLOWED_ORIGINS.has(origin)) {
  res.setHeader('Access-Control-Allow-Origin', origin);
  res.setHeader('Vary', 'Origin');
}
```

---

## Security (OWASP Node.js recommendations)

### Input validation and sanitisation

```bash
npm install validator express-mongo-sanitize zod
```

```js
import { z } from 'zod';

// Validate and parse incoming JSON bodies
const CreateUserSchema = z.object({
  email: z.string().email(),
  name: z.string().min(1).max(100),
  age: z.number().int().min(0).max(150),
});

const data = CreateUserSchema.parse(req.body); // throws ZodError if invalid
```

- Never use `eval()` with user input
- Sanitise inputs to `child_process.exec()` — prefer `execFile()` with arguments array
- Set request size limits: `express.json({ limit: '1kb' })`

### Authentication and sessions

```js
// Cookie security flags — all three required
res.setHeader('Set-Cookie',
  `session=${token}; Secure; HttpOnly; SameSite=Strict; Path=/`
);
```

- Rate-limit login endpoints (`express-rate-limit` or `rate-limiter-flexible`)
- Implement account lockout after N failed attempts
- Use `bcrypt` or `scrypt` for password hashing — never SHA/MD5/plain
- CSRF: use `SameSite=Strict` cookies + verify `Origin`/`Referer` headers for state-changing requests

### Error handling (never expose internals)

```js
// ❌ Bad — leaks stack trace and internal paths
res.status(500).json({ error: err.message, stack: err.stack });

// ✅ Good — generic message to client, full error in logs
logger.error({ err }, 'Unhandled error in request handler');
res.status(500).json({ error: 'Internal server error' });
```

- Bind error handlers on `EventEmitter` objects to prevent unhandled crashes
- Handle `uncaughtException` — clean up resources then `process.exit(1)`; do not resume

### Dependency security

```bash
# Run in CI — fail on high/critical CVEs
npm audit --audit-level=high

# Check for outdated packages
npm outdated

# Auto-fix (non-breaking)
npm audit fix
```

Recommended: connect repo to **Dependabot** (GitHub) or **Snyk** for continuous CVE monitoring with automated PRs.

Test regex patterns for ReDoS vulnerabilities with `vuln-regex-detector` before using in production.

### Node.js Permissions Model (v20+)

Restrict filesystem and network access at runtime:

```bash
# Allow only specific filesystem paths
node --permission --allow-fs-read=/app/src --allow-fs-write=/app/tmp src/index.js

# Allow only specific environment variables
node --permission --allow-env=NODE_ENV,PORT src/index.js
```

Useful for hardening serverless functions that have well-defined resource access patterns.

### HTTP Parameter Pollution

```bash
npm install hpp
```

```js
import hpp from 'hpp';
app.use(hpp()); // prevents duplicate query parameter abuse
```

### Security checklist

| Practice | Implementation |
|---|---|
| Input validation | zod or Joi — validate at every system boundary |
| SQL/NoSQL injection | ORM/ODM with parameterised queries; never string-concatenate |
| Password hashing | bcrypt or scrypt (never plain SHA/MD5) |
| Secret management | Environment variables only — never in source code |
| Rate limiting | `rate-limiter-flexible` or `express-rate-limit` |
| Cookie flags | `Secure; HttpOnly; SameSite=Strict` |
| Request size | `express.json({ limit: '1kb' })` |
| Error messages | Generic to client; full detail to logs only |
| Dependency scanning | `npm audit` in CI; Dependabot/Snyk for continuous |
| Non-root container | `USER node` in Dockerfile |
| Security headers | Helmet.js (14 headers) or manual (see above) |
| Event loop monitoring | `toobusy-js` to detect overload |
| Activity logging | pino / Winston / Bunyan — structured JSON to stdout |

---

## Production practices

| Practice | Detail |
|---|---|
| `NODE_ENV=production` | Enables framework optimisations and suppresses dev logging |
| `npm ci` in CI/CD | Reproducible installs from lock file |
| Log to stdout | Don't hardcode log file paths |
| Stateless design | No in-process session state; use Redis for sessions |
| Health endpoints | `/health` for liveness probes |
| Graceful SIGTERM | Close server, drain requests, then exit |
| Memory limits | `--max-old-space-size=512` in container to match resource limits |

---

## Docker best practices (summary)

```dockerfile
# Multi-stage build
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production

FROM node:20-alpine AS runtime
WORKDIR /app
COPY --from=builder /app/node_modules ./node_modules
COPY src/ ./src/
USER node                          # non-root user
EXPOSE 8080
CMD ["node", "src/index.js"]       # direct node, not npm start
```

Key rules:
- Use Alpine base images (smaller, fewer vulnerabilities)
- Use specific image tags, not `latest`
- Copy `package*.json` before source code (maximise layer caching)
- Use `USER node` (non-root)
- Start with `node src/index.js`, not `npm start`
- Use `.dockerignore` to exclude `node_modules`, `coverage`, `.git`

---

## Patterns for minimal Node.js HTTP services (no framework)

These patterns suit simple Cloud Functions or lightweight HTTP services that don't warrant a full framework:

- `"use strict"` at top of all CJS files (use `"type": "module"` in `package.json` for ESM)
- Native `http` module — suitable when the service has only a few routes and no middleware needs
- Manual security headers per-response (see Security section above)
- CORS: manual origin validation against an env-var allowlist — never `*` for authenticated endpoints
- In-memory cache with TTL for data that changes infrequently (e.g. billing exports, reference data)
- `src/` for application code, `infra/` for Pulumi IaC — separate `package.json` per directory
