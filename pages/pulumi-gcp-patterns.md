---
title: Pulumi + GCP Patterns
type: pattern
status: stub
confidence: 30
tags: [pulumi, iac, gcp, nodejs, serverless]
last-updated: 2026-04-12
sources: []
---

# Pulumi + GCP Patterns

> **Status: stub** — partially populated from IaC-test-app audit. Needs deeper Pulumi docs ingest.

## Stack Structure

```
infra/
├── Pulumi.yaml             ← Resource definitions (YAML-based)
├── Pulumi.dev.yaml         ← Dev stack config (config values, not secrets)
├── Pulumi.<stack>.yaml     ← Per-environment config
├── index.js                ← Entry point (can be empty for pure YAML)
├── package.json            ← Pulumi deps (separate from app)
└── scripts/
    ├── runPulumi.js        ← CLI wrapper, env setup
    └── packageFunction.js  ← Zip Cloud Function source for upload
```

## Key Conventions (from IaC-test-app)

- Resource names prefixed with stack name: `${stack}-artifacts`, `number-doubler-${stack}`
- Secrets: `pulumi config set --secret` — never hardcoded
- Local backend: `.pulumi/` — fine for solo dev, needs remote backend for teams
- YAML-based Pulumi config preferred over TypeScript for simple stacks
- Keep `infra/` as its own `npm` project — run `npm install` separately from app

## GCP Services Used

| Service | Purpose | Notes |
|---------|---------|-------|
| Cloud Functions v2 | Serverless compute | Node.js 20, 256MB, max 1 instance |
| Cloud Storage | Function source artifact bucket | Zip uploaded before deploy |
| Cloud Run | Managed container runtime | Enabled as dependency of CF v2 |
| BigQuery | Billing analytics | Queries GCP billing export dataset |
| Cloud Build | Build automation | Enabled as dependency |
| Artifact Registry | Container image storage | Enabled as dependency |
| IAM | Access control | Service accounts for BigQuery |

## What to research / fill in

- [ ] Pulumi YAML vs TypeScript vs Python — decision criteria
- [ ] Remote backend options: Pulumi Cloud, GCS bucket, S3
- [ ] Stack reference pattern (sharing outputs between stacks)
- [ ] Pulumi ESC for secrets management
- [ ] GCP workload identity federation (replacing service account keys)
- [ ] Cloud Functions v2 vs Cloud Run — when to use each
- [ ] Pulumi Automation API for programmatic deployments
- [ ] CI/CD: how to run `pulumi up` in GitHub Actions (OIDC auth to GCP)
- [ ] Resource protection: `protect: true` for stateful resources (databases, buckets with data)
- [ ] Import existing resources: `pulumi import`

## Enabling Required GCP APIs

Always enable APIs before creating resources that depend on them:

```yaml
# In Pulumi.yaml resources section
enable-cloudfunctions-api:
  type: gcp:projects/service:Service
  properties:
    service: cloudfunctions.googleapis.com
```

Required APIs for Cloud Functions v2:
- `cloudfunctions.googleapis.com`
- `cloudbuild.googleapis.com`
- `artifactregistry.googleapis.com`
- `run.googleapis.com`

## Deployment Commands

```bash
# From infra/
npm run preview    # pulumi preview
npm run up         # pulumi up --yes
npm run destroy    # pulumi destroy
```

## Sources to Ingest

- Pulumi YAML docs: https://www.pulumi.com/docs/languages-sdks/yaml/
- Pulumi GCP provider: https://www.pulumi.com/registry/packages/gcp/
- GCP Cloud Functions v2 docs
