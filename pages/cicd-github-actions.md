---
title: CI/CD with GitHub Actions
type: pattern
status: draft
confidence: 80
tags: [cicd, github-actions, automation, pulumi, gcp, nodejs]
last-updated: 2026-04-12
sources:
  - "Pulumi GitHub Actions: https://github.com/pulumi/actions"
  - "GCP Workload Identity Federation docs: https://docs.cloud.google.com/iam/docs/workload-identity-federation-with-deployment-pipelines"
  - "GitHub Actions workflow syntax: https://docs.github.com/en/actions/writing-workflows/workflow-syntax-for-github-actions"
---

# CI/CD with GitHub Actions

## Read This When

- Adding CI or deploy workflows
- Setting up PR validation
- Wiring Pulumi deploys on GCP

## Default Recommendation

- Split CI and deploy into separate workflows.
- Run lint and test on every PR.
- Use `npm ci`, not `npm install`, in CI.
- Use `actions/setup-node` with `.nvmrc`.
- Use OIDC / Workload Identity Federation for GCP auth.
- Use PR preview before deploy when infrastructure changes matter.

## Use This Pattern

Recommended workflow split:

```text
.github/workflows/
  ci.yml
  deploy.yml
```

CI workflow:

- checkout
- setup Node
- `npm ci`
- `npm run lint`
- `npm test`

Deploy workflow:

- checkout
- setup Node
- install dependencies
- authenticate to GCP with OIDC
- run `pulumi/actions`

Useful defaults:

- `concurrency.cancel-in-progress: true` for CI
- least-privilege `permissions`
- PR preview for Pulumi when useful

## Commands / Config

Prefer:

- `actions/checkout@v4`
- `actions/setup-node@v4`
- `google-github-actions/auth@v2`
- `pulumi/actions@v6`

Required permission for OIDC:

- `id-token: write`

## Pitfalls

- Do not combine deploy and PR validation in one mutating workflow.
- Do not use long-lived GCP key files if OIDC works.
- Do not skip `npm ci` reproducibility.
- Do not let stale CI runs pile up.

## Related Pages

- [testing-setup](testing-setup.md)
- [pulumi-gcp-patterns](pulumi-gcp-patterns.md)
- [security-scanning](security-scanning.md)
- [code-review-automation](code-review-automation.md)
