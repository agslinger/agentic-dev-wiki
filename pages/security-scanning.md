---
title: Secret Scanning and Security
type: pattern
status: draft
confidence: 75
tags: [security, secrets, gitleaks, nodejs, cicd]
last-updated: 2026-04-12
sources:
  - "Gitleaks README: https://github.com/gitleaks/gitleaks"
  - "IaC-test-app audit (agslinger/IaC-test-app): active Gitleaks + Husky setup observed"
---

# Secret Scanning and Security

## Read This When

- Adding secret scanning
- Deciding how to handle repo and CI secrets
- Setting default dependency and runtime security checks

## Default Recommendation

- Add Gitleaks on day one.
- Keep a repo `.gitleaks.toml`.
- Run Gitleaks in both pre-commit and CI.
- Add `npm audit --audit-level=high` to CI.
- Store deploy secrets with Pulumi encrypted config or environment variables, not source files.

## Use This Pattern

Typical setup:

1. install Gitleaks locally
2. add `.gitleaks.toml`
3. run `gitleaks protect --staged` in pre-commit
4. run `gitleaks-action` in GitHub Actions

Allowlist only known false positives such as:

- docs examples
- fixtures
- generated files with high-entropy values

Also ignore secret-like files in git:

- `.env*`
- `*credentials.json`
- `*.pem`
- `*.key`

## Commands / Config

Useful commands:

```bash
gitleaks detect --source .
gitleaks protect --staged --config .gitleaks.toml
npm audit --audit-level=high
pulumi config set --secret <key> <value>
```

## Pitfalls

- Do not rely on CI alone; block secrets before commit too.
- Do not use broad allowlists when file-specific ones work.
- Do not commit plaintext cloud credentials.
- Do not treat dependency scanning as a replacement for secret scanning.

## Related Pages

- [cicd-github-actions](cicd-github-actions.md)
- [nodejs-patterns](nodejs-patterns.md)
- [new-project-checklist](new-project-checklist.md)
