---
title: Pulumi + GCP Patterns
type: pattern
status: draft
confidence: 72
tags: [pulumi, iac, gcp, nodejs, serverless]
last-updated: 2026-04-12
sources:
  - "Pulumi YAML docs: https://www.pulumi.com/docs/languages-sdks/yaml/"
  - "Pulumi GCP provider: https://www.pulumi.com/registry/packages/gcp/"
  - "GCP Cloud Functions runtimes: https://docs.cloud.google.com/functions/docs/concepts/execution-environment"
  - "Community Pulumi YAML + GCP patterns"
---

# Pulumi + GCP Patterns

> **Status: draft** — sourced from Pulumi YAML docs and GCP Cloud Functions runtime docs (April 2026).

---

## Stack file structure

```
infra/
├── Pulumi.yaml             ← Resource definitions (YAML-based)
├── Pulumi.dev.yaml         ← Dev stack config values (non-secret)
├── Pulumi.<stack>.yaml     ← Per-environment config (non-secret)
├── index.js                ← Entry point (often empty for pure YAML stacks)
├── package.json            ← Pulumi deps — separate from app package.json
└── scripts/
    ├── runPulumi.js        ← CLI wrapper with env setup
    └── packageFunction.js  ← Zips Cloud Function source before upload
```

**Key rule:** `infra/` is its own npm project with its own `package.json`. Never mix application dependencies with IaC dependencies. Run `npm install` separately in each directory.

---

## Pulumi YAML format

Pulumi YAML is a **declarative**, config-file-style format — no programming logic. A self-contained project file.

### Top-level sections

```yaml
name: my-project
runtime: yaml
description: Deploys Cloud Functions and associated GCP resources

config:
  gcpProject:
    type: string
  region:
    default: us-central1
    type: string

resources:
  # ... resource definitions

outputs:
  functionUrl: ${my-function.url}
```

| Section | Purpose |
|---|---|
| `name` | Project identifier |
| `runtime` | Always `yaml` for YAML projects |
| `config` | Input variables with optional defaults and types |
| `resources` | Infrastructure components to provision |
| `outputs` | Values exposed after `pulumi up` completes |

### Resource definition format

```yaml
resources:
  resource-logical-name:
    type: provider:module:ResourceType
    properties:
      # resource-specific configuration
    options:
      # deployment directives (dependsOn, protect, ignoreChanges, etc.)
```

### Referencing other resources

Use interpolation syntax `${resource-name.attribute}`:

```yaml
resources:
  my-bucket:
    type: gcp:storage:Bucket
    properties:
      location: ${region}

  my-function:
    type: gcp:cloudfunctionsv2:Function
    properties:
      buildConfig:
        source:
          storageSource:
            bucket: ${my-bucket.name}   # ← references the bucket resource
```

Pulumi infers dependencies from references — no explicit `dependsOn` needed in most cases.

### Config variable access

```yaml
config:
  projectId:
    type: string
  environment:
    default: dev
    type: string

resources:
  my-bucket:
    type: gcp:storage:Bucket
    properties:
      name: ${projectId}-artifacts-${environment}
```

### Stack configuration files

Per-environment values live in `Pulumi.<stack>.yaml` (checked in, non-secret):

```yaml
# Pulumi.dev.yaml
config:
  projectId: my-gcp-project-dev
  region: us-central1
```

Secrets are set via CLI and stored encrypted:

```bash
pulumi config set --secret databasePassword supersecret123
```

---

## GCP provider

The Pulumi GCP provider (`pulumi-gcp`) manages most GCP services.

### Authentication

```bash
# Development (local): Application Default Credentials
gcloud auth application-default login

# CI/CD: Use Workload Identity Federation (see cicd-github-actions.md)
# or set GOOGLE_CREDENTIALS env var to service account key JSON (not preferred)
```

### Common resource types

| Service | Pulumi type | Notes |
|---|---|---|
| Cloud Functions v2 | `gcp:cloudfunctionsv2:Function` | Preferred over v1 for new projects |
| Cloud Storage bucket | `gcp:storage:Bucket` | Function source zips, data storage |
| Cloud Storage object | `gcp:storage:BucketObject` | Upload source zip artifact |
| IAM service account | `gcp:serviceaccount:Account` | Per-function least-privilege SA |
| IAM binding | `gcp:projects:IAMMember` | Assign roles to SAs |
| IAM invoker | `gcp:cloudfunctionsv2:FunctionIamMember` | Allow unauthenticated invocation |
| BigQuery dataset | `gcp:bigquery:Dataset` | Analytics data storage |
| BigQuery table | `gcp:bigquery:Table` | Schema-defined tables |
| Secret Manager secret | `gcp:secretmanager:Secret` | Encrypted secret storage |
| GCP API enablement | `gcp:projects:Service` | Enable required APIs |
| Cloud Run service | `gcp:cloudrun:Service` | Container-based serverless |
| Pub/Sub topic | `gcp:pubsub:Topic` | Async messaging |

### Enabling required APIs

Always enable APIs before creating resources that depend on them. Use `deleteBeforeReplace: false` to avoid destroying the enablement on re-deployment:

```yaml
enable-cloudfunctions-api:
  type: gcp:projects:Service
  properties:
    service: cloudfunctions.googleapis.com
  options:
    deleteBeforeReplace: false

enable-cloudbuild-api:
  type: gcp:projects:Service
  properties:
    service: cloudbuild.googleapis.com
  options:
    deleteBeforeReplace: false
```

Required APIs for Cloud Functions v2:
- `cloudfunctions.googleapis.com`
- `cloudbuild.googleapis.com`
- `artifactregistry.googleapis.com`
- `run.googleapis.com`

---

## Cloud Functions v2 pattern

### Supported Node.js runtimes

| Runtime | Runtime ID | Deprecation |
|---|---|---|
| Node.js 24 | `nodejs24` | 2028-04-30 |
| Node.js 22 | `nodejs22` | 2027-04-30 |
| Node.js 20 | `nodejs20` | 2026-04-30 |
| Node.js 18 | `nodejs18` | 2025-04-30 |

**Use `nodejs22` for new projects** — longest current support window.

### Full Cloud Function v2 resource pattern

```yaml
resources:
  # 1. Storage bucket for source artifacts
  artifacts-bucket:
    type: gcp:storage:Bucket
    properties:
      name: ${gcpProject}-cf-artifacts
      location: ${region}
      uniformBucketLevelAccess: true

  # 2. Zip and upload the function source
  function-source:
    type: gcp:storage:BucketObject
    properties:
      bucket: ${artifacts-bucket.name}
      name: function-source.zip
      source:
        fn::fileArchive: ../src    # or use a pre-built zip

  # 3. Service account for the function
  function-sa:
    type: gcp:serviceaccount:Account
    properties:
      accountId: my-function-sa
      displayName: My Function Service Account

  # 4. The function itself
  my-function:
    type: gcp:cloudfunctionsv2:Function
    properties:
      name: my-function-${environment}
      location: ${region}
      buildConfig:
        runtime: nodejs22
        entryPoint: handleRequest     # exports.handleRequest in your JS
        source:
          storageSource:
            bucket: ${artifacts-bucket.name}
            object: ${function-source.name}
      serviceConfig:
        maxInstanceCount: 3
        minInstanceCount: 0           # set > 0 to avoid cold starts
        availableMemory: 256M
        timeoutSeconds: 60
        serviceAccountEmail: ${function-sa.email}
        environmentVariables:
          NODE_ENV: production
          GCP_PROJECT: ${gcpProject}

  # 5. Allow unauthenticated HTTP invocation (public API)
  function-invoker:
    type: gcp:cloudfunctionsv2:FunctionIamMember
    properties:
      location: ${region}
      cloudFunction: ${my-function.name}
      role: roles/cloudfunctions.invoker
      member: allUsers

outputs:
  functionUrl: ${my-function.serviceConfig.uri}
```

### Entry point convention

The `entryPoint` field in `buildConfig` maps to a named export in your Node.js source:

```js
// src/index.js
export function handleRequest(req, res) {
  res.status(200).json({ status: 'ok' });
}

// or CommonJS:
exports.handleRequest = (req, res) => {
  res.status(200).json({ status: 'ok' });
};
```

### Cold start mitigation

Set `minInstanceCount: 1` (or higher) to keep an instance warm. This incurs continuous cost but eliminates cold start latency. Evaluate based on traffic patterns and SLA requirements.

---

## IAM patterns

### Least-privilege service account per function

```yaml
# Grant BigQuery access to a specific dataset only
bigquery-viewer-binding:
  type: gcp:bigquery:DatasetIamMember
  properties:
    datasetId: ${billing-dataset.datasetId}
    role: roles/bigquery.dataViewer
    member: serviceAccount:${function-sa.email}
```

Never use `roles/editor` or `roles/owner` for function service accounts.

### Allow Cloud Function to access Secret Manager

```yaml
secret-accessor-binding:
  type: gcp:projects:IAMMember
  properties:
    role: roles/secretmanager.secretAccessor
    member: serviceAccount:${function-sa.email}
```

---

## Backend and state

| Backend | Use case | Notes |
|---|---|---|
| Local `.pulumi/` | Solo development | Default, not suitable for teams |
| Pulumi Cloud | Team / CI/CD | Requires `PULUMI_ACCESS_TOKEN`; provides history, locking |
| GCS bucket | Self-managed teams | `pulumi login gs://my-state-bucket`; no cost beyond storage |

**Recommendation:** Use Pulumi Cloud for teams — built-in state locking prevents concurrent `pulumi up` races. Use a GCS bucket if you need full data sovereignty.

---

## Resource protection

Protect stateful resources (databases, buckets with production data) from accidental deletion:

```yaml
production-db:
  type: gcp:sql:DatabaseInstance
  options:
    protect: true    # pulumi destroy will fail; must set to false first
```

---

## Deployment commands

```bash
# From infra/
npm run preview    # pulumi preview — shows what would change
npm run up         # pulumi up --yes — deploy
npm run destroy    # pulumi destroy — tear down

# Or directly:
pulumi preview --stack dev
pulumi up --yes --stack dev
pulumi stack output functionUrl
```

---

## Recommended conventions

| Convention | Detail |
|---|---|
| Resource naming | Prefix with stack name: `${stack}-artifacts`, `my-function-${stack}` |
| Secrets | `pulumi config set --secret` only — never hardcoded in config files |
| Backend | Local `.pulumi/` for solo development — Pulumi Cloud or GCS bucket for teams and CI/CD |
| Stack separation | `dev` / `prod` stacks with separate `Pulumi.<stack>.yaml` config files |
| Source packaging | Script to zip `src/` before upload (e.g. `scripts/packageFunction.js`) |

---

## Known gaps / to research

- [ ] Pulumi ESC (Environments, Secrets, Config) — centralised secret management across stacks
- [ ] Stack references — sharing outputs between stacks (e.g., network stack → app stack)
- [ ] Pulumi Automation API — programmatic `pulumi up` from Node.js
- [ ] Cloud Functions v2 VPC connector for private resource access
- [ ] `pulumi import` — import existing GCP resources into state
