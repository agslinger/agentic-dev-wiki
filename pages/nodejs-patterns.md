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

## Read This When

- Starting a new Node.js service
- Choosing the default project structure
- Deciding testability, config, logging, and shutdown behavior

## Default Recommendation

- Use Node `20+`.
- Use ESM for new projects.
- Keep app code in `src/` and infrastructure in a separate `infra/` package.
- Export `createServer()` from `src/app.js`; only call `.listen()` in `src/index.js`.
- Validate environment variables at startup.
- Log structured JSON to stdout.
- Add `/health`, graceful shutdown, and security headers by default.

## Use This Pattern

Suggested structure:

```text
src/
  app.js
  index.js
  health/
  billing/
infra/
  package.json
```

Suggested boundaries:

- routes/entry points: parse requests and responses
- service layer: business logic
- data layer: DB or external APIs

Config pattern:

- read from env vars
- validate at startup
- fail fast on missing required values

Operational defaults:

- structured logging with `pino`
- health endpoint at `/health`
- graceful `SIGTERM` shutdown
- CORS allowlist, not `*`
- `helmet` or equivalent security headers

## Commands / Config

Recommended defaults:

```json
{
  "engines": {
    "node": ">=20.0.0"
  }
}
```

```text
.nvmrc
20
```

Server pattern:

```js
export function createServer() {
  return http.createServer(handleRequest);
}
```

## Pitfalls

- Do not mix app and IaC dependencies.
- Do not hardcode config.
- Do not expose stack traces in responses.
- Do not let route handlers talk directly to the DB when the service layer should own that.
- Do not use `console.log` as the long-term production logging strategy.

## Related Pages

- [nextjs-patterns](nextjs-patterns.md) — Next.js-specific patterns for App Router projects
- [typescript-strict-mode](typescript-strict-mode.md) — strict typing for Node.js services
- [zod-4-validation](zod-4-validation.md) — runtime validation at service boundaries
- [testing-setup](testing-setup.md)
- [linting-setup](linting-setup.md)
- [security-scanning](security-scanning.md)
- [pulumi-gcp-patterns](pulumi-gcp-patterns.md)
