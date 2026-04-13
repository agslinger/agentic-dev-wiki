---
title: Secret Scanning and Security
type: pattern
status: draft
confidence: 75
tags: [security, secrets, gitleaks, nodejs, cicd]
last-updated: 2026-04-12
sources:
  - "Gitleaks README: https://github.com/gitleaks/gitleaks"
  - "Community Gitleaks + Husky integration patterns"
---

# Secret Scanning and Security

> **Status: draft** — sourced from Gitleaks docs (April 2026).

---

## What Gitleaks is

Gitleaks is a SAST (Static Application Security Testing) tool that detects secrets — passwords, API keys, tokens — in git repositories, files, and stdin. Detection uses regex pattern matching combined with optional Shannon entropy analysis.

Three scanning modes:
- **`git` mode** — scans repository history via `git log -p`
- **`dir` mode** — scans directories and files directly  
- **`stdin` mode** — processes data piped from standard input

---

## Installation

```bash
# macOS
brew install gitleaks

# Docker
docker pull ghcr.io/gitleaks/gitleaks:latest
docker run -v $(pwd):/repo ghcr.io/gitleaks/gitleaks:latest detect --source /repo

# From source (requires Go)
git clone https://github.com/gitleaks/gitleaks && cd gitleaks && make build

# Binary release — download from: https://github.com/gitleaks/gitleaks/releases
```

---

## Running Gitleaks

```bash
# Scan repo history for secrets
gitleaks detect --source .

# Scan staged changes only (for pre-commit use)
gitleaks protect --staged

# Scan specific directory
gitleaks detect --source ./src

# Use a custom config file
gitleaks detect --source . --config .gitleaks.toml

# Generate a JSON report
gitleaks detect --source . --report-format json --report-path gitleaks-report.json

# Create a baseline (ignore historical findings, focus on new ones)
gitleaks detect --source . --baseline-path .gitleaks-baseline.json
gitleaks detect --source . --baseline-path .gitleaks-baseline.json  # only new findings
```

---

## Configuration (`.gitleaks.toml`)

Config load precedence:
1. `--config` / `-c` flag
2. `GITLEAKS_CONFIG` environment variable
3. `GITLEAKS_CONFIG_TOML` env var (inline TOML content)
4. `.gitleaks.toml` in the target path
5. Built-in default ruleset

### Minimal config with custom rules

```toml
# .gitleaks.toml
title = "Gitleaks custom config"

# Extend the built-in default rules
[extend]
useDefault = true

# Custom rule: Pulumi access tokens
[[rules]]
id = "pulumi-access-token"
description = "Pulumi access token"
regex = '''pul-[a-zA-Z0-9]{40}'''
tags = ["pulumi", "token"]

# Custom rule: GCP ADC refresh token
[[rules]]
id = "google-adc-refresh-token"
description = "Google Application Default Credentials refresh token"
regex = '''"refresh_token":\s*"[^"]+"'''
tags = ["google", "oauth"]

# Custom rule: GCP OAuth client secret
[[rules]]
id = "google-oauth-client-secret"
description = "Google OAuth client secret"
regex = '''"client_secret":\s*"[^"]+"'''
tags = ["google", "oauth"]
```

### Allowlisting false positives

**Global allowlist** (applies to all rules):

```toml
[allowlist]
description = "Global allowlist"
paths = [
  "package-lock.json",      # high entropy values, many false positives
  ".pulumi/",               # Pulumi state files
  "test/fixtures/",         # test data that looks like secrets
]
regexes = [
  # Known safe patterns
  '''EXAMPLE_KEY_[A-Z0-9]{20}''',
]
```

**Rule-level allowlist** (applies to one rule only):

```toml
[[rules]]
id = "pulumi-access-token"
regex = '''pul-[a-zA-Z0-9]{40}'''

  [rules.allowlist]
  paths = ["docs/examples.md"]   # documentation that shows example tokens
```

**Inline suppression** (specific line):

```js
const EXAMPLE = "pul-exampleTokenForDocs1234567890";  // gitleaks:allow
```

---

## Pre-commit hook (Husky integration)

Run Gitleaks on staged files before every commit:

```bash
#!/usr/bin/env sh
# .husky/pre-commit
gitleaks protect --staged --config=.gitleaks.toml
```

If Gitleaks exits non-zero, the commit is blocked. Developers see the finding and must either remove the secret or add an allowlist entry.

### Alternative: pre-commit framework

```yaml
# .pre-commit-config.yaml
repos:
  - repo: https://github.com/gitleaks/gitleaks
    rev: v8.24.2
    hooks:
      - id: gitleaks
```

```bash
pip install pre-commit
pre-commit install
```

---

## GitHub Actions integration

```yaml
# .github/workflows/gitleaks.yml
name: Secret Scanning

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]
  workflow_dispatch:

jobs:
  gitleaks:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0         # full history for git-mode scanning

      - name: Run Gitleaks
        uses: gitleaks/gitleaks-action@v2
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          GITLEAKS_LICENSE: ${{ secrets.GITLEAKS_LICENSE }}  # required for org repos
```

For public repos, no license is needed. For private org repos, the `GITLEAKS_LICENSE` env var is required.

---

## `.gitignore` patterns for secret files

Ensure these are in `.gitignore`:

```gitignore
# Environment files
.env
.env.*
!.env.example     # allow the example template

# GCP credentials
*credentials.json
application_default_credentials.json
service-account-key.json
*.pem
*.key

# Pulumi state (if using local backend)
.pulumi/

# Secrets output files
gitleaks-report.json
*.secrets
```

---

## Dependency vulnerability scanning

Complement Gitleaks (secret detection) with dependency scanning (CVE detection):

```bash
# Built-in: audit dependencies against npm advisory database
npm audit

# Auto-fix non-breaking vulnerabilities
npm audit fix

# Fail CI if high-severity vulnerabilities exist
npm audit --audit-level=high
```

In CI:

```yaml
- name: Audit dependencies
  run: npm audit --audit-level=high
```

For continuous monitoring, connect the repo to **Dependabot** (GitHub) or **Snyk** — these send PRs when new CVEs are found.

---

## Security headers (manual approach for native http servers)

For projects using Node's native `http` module without a framework, set headers manually per-response:

```js
res.setHeader('Content-Security-Policy', "default-src 'none'");
res.setHeader('X-Frame-Options', 'DENY');
res.setHeader('X-Content-Type-Options', 'nosniff');
res.setHeader('Strict-Transport-Security', 'max-age=31536000; includeSubDomains');
res.setHeader('Referrer-Policy', 'strict-origin-when-cross-origin');
res.setHeader('Permissions-Policy', 'geolocation=(), microphone=(), camera=()');
```

For Express/Fastify projects, use `helmet` (covers 14 headers automatically — see [nodejs-patterns.md](nodejs-patterns.md)).

---

## Pulumi secrets (config encryption)

Never store secrets as plaintext config values. Use Pulumi's encrypted secrets:

```bash
# Store encrypted
pulumi config set --secret databasePassword supersecret123
pulumi config set --secret gcpServiceAccountKey "$(cat sa-key.json)"

# Read (decrypted at runtime)
pulumi config get databasePassword
```

Encrypted values are stored in `Pulumi.<stack>.yaml` as ciphertext — safe to commit. They are decrypted only by Pulumi at deploy time using the stack's encryption key.

---

## Gitleaks vs alternatives

| Tool | Approach | Strengths |
|---|---|---|
| **Gitleaks** | Regex + entropy, git history | Fast, easy config, pre-commit friendly |
| **Trufflehog** | Entropy + regex + ML, multi-source | Deeper detection, more false positives |
| **git-secrets** | Simple regex | Simple but limited ruleset |
| **Dependabot** | CVE database | Dependency vulnerabilities, not secrets |
| **Snyk** | CVE database + SAST | Commercial, broader coverage |

---

## Known gaps / to research

- [ ] Gitleaks composite rules (v8.28.0+) — require multiple patterns to match near each other
- [ ] GCP Secret Manager integration — access runtime secrets without env vars
- [ ] OWASP Top 10 for Node.js HTTP handlers — see [nodejs-patterns.md](nodejs-patterns.md) OWASP section
- [ ] Content Security Policy generation and testing — CSP evaluator tooling
- [ ] Trivy or Snyk for Docker image vulnerability scanning
