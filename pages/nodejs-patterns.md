---
title: Node.js Application Patterns
type: pattern
status: stub
confidence: 15
tags: [nodejs, javascript]
last-updated: 2026-04-12
sources: []
---

# Node.js Application Patterns

> **Status: stub** — structure and known patterns from IaC-test-app. Needs broader research.

## Project Structure

```
project/
├── src/
│   ├── index.js        ← HTTP server entry point (keep thin)
│   ├── app.js          ← Request handler / router
│   └── function.js     ← Cloud Function wrapper (if serverless)
├── infra/              ← Keep IaC separate (own package.json)
├── package.json        ← App dependencies only
└── AGENTS.md / CLAUDE.md
```

**Key convention:** application code (`src/`) and infrastructure code (`infra/`) are independent Node.js projects with separate `package.json` files. Never mix them.

## What to research / fill in

- [ ] Recommended folder structure for Express/Fastify vs native http
- [ ] Module system: CommonJS vs ESM — when to choose each
- [ ] Environment variable handling (dotenv, @dotenvx/dotenvx)
- [ ] Error handling patterns (centralised vs per-route)
- [ ] Logging: pino vs winston vs console — structured logging
- [ ] Health check endpoint conventions (`/health`, `/_health`)
- [ ] Security headers — Helmet.js vs manual (currently manual in IaC-test-app)
- [ ] CORS handling patterns
- [ ] Graceful shutdown pattern (SIGTERM handler)
- [ ] Node.js version pinning strategy (`.nvmrc`, `engines` field in package.json)

## Known Patterns (from IaC-test-app)

- `"use strict"` at top of all JS files
- Native `http` module (no framework) — suitable for simple Cloud Functions
- Manual security headers: `Content-Security-Policy`, `X-Frame-Options`, `X-Content-Type-Options`, `Strict-Transport-Security`, `Referrer-Policy`, `Permissions-Policy`
- CORS: manual origin validation against allowlist
- In-memory cache with TTL (24h for billing data)
- BigQuery client for analytics queries

## Sources to Ingest

- Node.js best practices guide: https://github.com/goldbergyoni/nodebestpractices
- Google Cloud Functions Node.js docs
