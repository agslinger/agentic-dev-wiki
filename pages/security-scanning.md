---
title: Secret Scanning and Security
type: pattern
status: stub
confidence: 40
tags: [security, secrets, gitleaks, nodejs, cicd]
last-updated: 2026-04-12
sources: []
---

# Secret Scanning and Security

> **Status: stub** — partially populated from IaC-test-app audit. Needs broader security research.

## Pre-commit Secret Scanning (Gitleaks)

### Current setup (IaC-test-app)

Gitleaks runs as a Husky pre-commit hook. Config lives in `.gitleaks.toml`.

**Custom rules for Pulumi and GCP:**

```toml
# .gitleaks.toml

[[rules]]
id = "pulumi-access-token"
description = "Pulumi access token"
regex = '''pul-[a-zA-Z0-9]{40}'''
tags = ["pulumi", "token"]

[[rules]]
id = "google-adc-refresh-token"
description = "Google ADC refresh token"
regex = '''\"refresh_token\":\s*\"[^\"]+\"'''
tags = ["google", "oauth"]

[[rules]]
id = "google-oauth-client-secret"
description = "Google OAuth client secret"
regex = '''\"client_secret\":\s*\"[^\"]+\"'''
tags = ["google", "oauth"]

[allowlist]
paths = [
  "package-lock.json",
  ".pulumi/"
]
```

**Husky pre-commit hook (`.husky/pre-commit`):**

```bash
#!/usr/bin/env sh
gitleaks protect --staged --config=.gitleaks.toml
```

### Installation

```bash
npm install --save-dev husky
npx husky init
# Then add gitleaks call to .husky/pre-commit
# Install gitleaks: https://github.com/gitleaks/gitleaks#installing
```

## What to research / fill in

- [ ] Gitleaks vs `git-secrets` vs `trufflehog` — comparison
- [ ] Gitleaks in CI (GitHub Actions step)
- [ ] `.gitignore` patterns for secret files (`.env`, `*.pem`, `*credentials.json`)
- [ ] GCP service account key handling — alternatives (Workload Identity)
- [ ] Pulumi secrets: `pulumi config set --secret` workflow
- [ ] Node.js security: `npm audit` and `npm audit fix` in CI
- [ ] Dependency vulnerability scanning: Dependabot or Snyk
- [ ] OWASP Top 10 for Node.js HTTP handlers
- [ ] Content Security Policy generation and testing

## Security Headers (from IaC-test-app)

Currently set manually per-response. Consider Helmet.js for Express:

```js
// Current manual approach (app.js)
res.setHeader("Content-Security-Policy", "default-src 'self'; ...");
res.setHeader("X-Frame-Options", "DENY");
res.setHeader("X-Content-Type-Options", "nosniff");
res.setHeader("Strict-Transport-Security", "max-age=31536000; includeSubDomains");
res.setHeader("Referrer-Policy", "strict-origin-when-cross-origin");
res.setHeader("Permissions-Policy", "geolocation=(), microphone=(), camera=()");
```

## Sources to Ingest

- Gitleaks: https://github.com/gitleaks/gitleaks
- OWASP Node.js security cheat sheet
- Husky docs: https://typicode.github.io/husky/
