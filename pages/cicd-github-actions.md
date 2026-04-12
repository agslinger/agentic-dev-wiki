---
title: CI/CD with GitHub Actions
type: pattern
status: stub
confidence: 10
tags: [cicd, github-actions, automation, pulumi, gcp, nodejs]
last-updated: 2026-04-12
sources: []
---

# CI/CD with GitHub Actions

> **Status: stub** — needs Ingest from GitHub Actions docs and Pulumi CI/CD docs.

## What to research / fill in

- [ ] Recommended workflow file structure: `.github/workflows/`
- [ ] Standard CI workflow: lint → test → build (on every PR)
- [ ] Deploy workflow: triggered on merge to `main`
- [ ] Pulumi in CI: `pulumi/actions` GitHub Action
- [ ] GCP authentication in CI: Workload Identity Federation (OIDC) vs service account key
- [ ] Caching: `actions/cache` for `node_modules`
- [ ] Node.js setup: `actions/setup-node` with version from `.nvmrc` or `package.json#engines`
- [ ] Branch protection rules: require CI to pass before merge
- [ ] PR preview deployments: `pulumi preview` on PR, `pulumi up` on merge
- [ ] Secrets management in GitHub Actions: `secrets.PULUMI_ACCESS_TOKEN`, GCP credentials
- [ ] Concurrency: cancel in-progress runs on new push to same branch
- [ ] Matrix builds: test across Node.js versions

## Known Gap (IaC-test-app)

IaC-test-app has **no CI/CD pipeline** — deployment is fully manual via local Pulumi commands.

## Suggested Workflow Skeleton

```yaml
# .github/workflows/ci.yml
name: CI

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  lint-and-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version-file: .nvmrc
          cache: npm
      - run: npm ci
      - run: npm run lint
      - run: npm test
```

## GCP Authentication (OIDC — preferred over service account keys)

```yaml
- uses: google-github-actions/auth@v2
  with:
    workload_identity_provider: projects/PROJECT_NUMBER/locations/global/workloadIdentityPools/POOL/providers/PROVIDER
    service_account: SA_EMAIL
```

## Sources to Ingest

- GitHub Actions docs: https://docs.github.com/en/actions
- Pulumi GitHub Actions: https://github.com/pulumi/actions
- GCP Workload Identity Federation for GitHub: https://cloud.google.com/blog/products/identity-security/enabling-keyless-authentication-from-github-actions
