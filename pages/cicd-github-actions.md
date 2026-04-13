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

> **Status: draft** — sourced from Pulumi GitHub Actions and GCP Workload Identity Federation docs (April 2026).

---

## Standard workflow structure

```
.github/
└── workflows/
    ├── ci.yml       ← runs on every push / PR (lint, test)
    └── deploy.yml   ← runs on merge to main (pulumi up)
```

Keep CI (validate) and deploy (mutate) in separate workflow files. This allows CI to run on PRs without triggering deploys.

---

## CI workflow (lint + test on every PR)

```yaml
# .github/workflows/ci.yml
name: CI

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

concurrency:
  group: ci-${{ github.ref }}
  cancel-in-progress: true

jobs:
  lint-and-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-node@v4
        with:
          node-version-file: .nvmrc   # or: node-version: '20'
          cache: npm

      - run: npm ci                   # use npm ci, not npm install

      - run: npm run lint

      - run: npm test
```

**Key points:**
- `concurrency` with `cancel-in-progress: true` cancels stale runs on new push to the same branch — prevents redundant CI queuing
- `npm ci` installs exactly what's in `package-lock.json` — reproducible, faster than `npm install`
- `actions/setup-node@v4` with `cache: npm` caches the npm cache directory automatically

---

## Deploy workflow (Pulumi on merge to main)

```yaml
# .github/workflows/deploy.yml
name: Deploy

on:
  push:
    branches: [main]

permissions:
  id-token: write    # required for OIDC / Workload Identity Federation
  contents: read

jobs:
  pulumi-up:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      # Set up language runtime BEFORE pulumi/actions
      - uses: actions/setup-node@v4
        with:
          node-version-file: .nvmrc
          cache: npm

      - name: Install app dependencies
        run: npm ci

      - name: Install infra dependencies
        run: npm ci
        working-directory: ./infra

      # Authenticate to GCP (keyless OIDC)
      - id: auth
        name: Authenticate to Google Cloud
        uses: google-github-actions/auth@v2
        with:
          workload_identity_provider: >-
            projects/${{ secrets.GCP_PROJECT_NUMBER }}/locations/global/
            workloadIdentityPools/${{ secrets.WIF_POOL_ID }}/providers/${{ secrets.WIF_PROVIDER_ID }}
          service_account: ${{ secrets.GCP_SERVICE_ACCOUNT }}

      # Pulumi deploy
      - uses: pulumi/actions@v6
        with:
          command: up
          stack-name: ${{ secrets.PULUMI_STACK }}
          work-dir: ./infra
          comment-on-summary: true
        env:
          PULUMI_ACCESS_TOKEN: ${{ secrets.PULUMI_ACCESS_TOKEN }}
```

---

## PR preview workflow (Pulumi preview on every PR)

```yaml
# In ci.yml — add this job alongside lint-and-test

  pulumi-preview:
    runs-on: ubuntu-latest
    permissions:
      id-token: write
      contents: read
      pull-requests: write    # needed for comment-on-pr

    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-node@v4
        with:
          node-version-file: .nvmrc
          cache: npm

      - run: npm ci
        working-directory: ./infra

      - uses: google-github-actions/auth@v2
        with:
          workload_identity_provider: >-
            projects/${{ secrets.GCP_PROJECT_NUMBER }}/locations/global/
            workloadIdentityPools/${{ secrets.WIF_POOL_ID }}/providers/${{ secrets.WIF_PROVIDER_ID }}
          service_account: ${{ secrets.GCP_SERVICE_ACCOUNT }}

      - uses: pulumi/actions@v6
        with:
          command: preview
          stack-name: ${{ secrets.PULUMI_STACK }}
          work-dir: ./infra
          comment-on-pr: true           # posts preview diff as PR comment
          github-token: ${{ secrets.GITHUB_TOKEN }}
        env:
          PULUMI_ACCESS_TOKEN: ${{ secrets.PULUMI_ACCESS_TOKEN }}
```

---

## Pulumi GitHub Actions reference (`pulumi/actions@v6`)

### Commands

| Command | Purpose |
|---|---|
| `preview` | Shows planned changes without applying |
| `up` / `update` | Deploys infrastructure |
| `refresh` | Syncs state with real cloud resources |
| `destroy` | Removes all resources in the stack |
| `output` | Retrieves stack outputs |

### Key inputs

| Input | Required | Notes |
|---|---|---|
| `command` | Yes | `preview`, `up`, `refresh`, `destroy`, `output` |
| `stack-name` | Yes | Format: `org/stack` for shared stacks |
| `work-dir` | No | Defaults to `./` |
| `comment-on-pr` | No | Posts result as PR comment |
| `comment-on-summary` | No | Adds result to GitHub step summary |
| `expect-no-changes` | No | Fails workflow if any changes are detected |
| `suppress-outputs` | No | Hides sensitive output values |
| `refresh` | No | Adds `--refresh` flag to preview/up |

### Using stack outputs in subsequent steps

```yaml
- uses: pulumi/actions@v6
  id: deploy
  with:
    command: up
    stack-name: my-stack
- run: echo "API URL is ${{ steps.deploy.outputs.api-url }}"
```

### Runtime requirement

`pulumi/actions` does **not** auto-install language runtimes or run `npm install`. Always set up Node.js and run `npm ci` before `pulumi/actions`:

```yaml
- uses: actions/setup-node@v4
  with:
    node-version-file: .nvmrc
    cache: npm
- run: npm ci
  working-directory: ./infra
- uses: pulumi/actions@v6
  with:
    command: up
    ...
```

---

## GCP authentication: Workload Identity Federation (OIDC)

Prefer OIDC keyless auth over long-lived service account key files. No credentials need to be stored — GitHub's ephemeral OIDC token is exchanged for a short-lived GCP access token.

### One-time setup (gcloud CLI)

```bash
# 1. Create the Workload Identity Pool
gcloud iam workload-identity-pools create POOL_ID \
    --location="global" \
    --description="GitHub Actions pool" \
    --display-name="GitHub Actions"

# 2. Create the GitHub OIDC provider
gcloud iam workload-identity-pools providers create-oidc PROVIDER_ID \
    --location="global" \
    --workload-identity-pool="POOL_ID" \
    --issuer-uri="https://token.actions.githubusercontent.com/" \
    --attribute-mapping="google.subject=assertion.sub,attribute.repository=assertion.repository,attribute.repository_id=assertion.repository_id" \
    --attribute-condition="assertion.repository_owner_id=='YOUR_ORG_ID'"

# 3. Grant the service account impersonation
gcloud iam service-accounts add-iam-policy-binding SERVICE_ACCOUNT_EMAIL \
    --role="roles/iam.workloadIdentityUser" \
    --member="principalSet://iam.googleapis.com/projects/PROJECT_NUMBER/locations/global/workloadIdentityPools/POOL_ID/attribute.repository_id/REPO_ID"
```

**Security note:** Use numeric IDs (`repository_id`, `repository_owner_id`) in attribute conditions, not name-based fields. This prevents typosquatting/cybersquatting attacks where an attacker could claim an organisation name that looks similar to yours.

### GitHub Actions configuration

```yaml
permissions:
  id-token: write    # REQUIRED — allows requesting the OIDC JWT
  contents: read

- id: auth
  uses: google-github-actions/auth@v2
  with:
    workload_identity_provider: >-
      projects/PROJECT_NUMBER/locations/global/workloadIdentityPools/POOL_ID/providers/PROVIDER_ID
    service_account: my-service-account@my-project.iam.gserviceaccount.com
```

### Required GitHub secrets

| Secret | Value |
|---|---|
| `GCP_PROJECT_NUMBER` | Numeric GCP project number |
| `WIF_POOL_ID` | Workload Identity Pool ID |
| `WIF_PROVIDER_ID` | OIDC Provider ID |
| `GCP_SERVICE_ACCOUNT` | Full service account email |
| `PULUMI_ACCESS_TOKEN` | Pulumi Cloud access token |
| `PULUMI_STACK` | Stack name (e.g. `myorg/dev`) |

---

## Best practices summary

| Practice | Why |
|---|---|
| `npm ci` instead of `npm install` | Reproducible, locked installs |
| `concurrency: cancel-in-progress: true` | Prevents stale CI runs piling up |
| OIDC over service account keys | No long-lived credentials in GitHub Secrets |
| `pulumi preview` on PR, `pulumi up` on merge | Review infra changes before they deploy |
| Install runtime before `pulumi/actions` | The action won't install Node.js for you |
| `expect-no-changes` in non-deploy workflows | Catch unintended drift |
| `suppress-outputs` when stack has secrets | Prevent sensitive values appearing in logs |

---

## GitHub Actions workflow syntax reference

### Trigger events (`on`)

```yaml
on:
  push:
    branches: [main]
    paths: ['src/**', 'package*.json']   # only trigger when these change
  pull_request:
    branches: [main]
  workflow_dispatch:                      # manual trigger with optional inputs
    inputs:
      environment:
        description: 'Target environment'
        required: true
        default: 'dev'
  schedule:
    - cron: '0 2 * * 1'                  # Mondays at 02:00 UTC (min interval: 5 min)
```

### Job structure and dependencies

```yaml
jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: npm ci && npm run lint

  test:
    runs-on: ubuntu-latest
    needs: lint           # runs after lint completes
    steps:
      - uses: actions/checkout@v4
      - run: npm ci && npm test

  deploy:
    runs-on: ubuntu-latest
    needs: [lint, test]   # runs after both complete
    if: github.ref == 'refs/heads/main'
    steps:
      - run: echo "deploying"
```

### Passing outputs between jobs

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    outputs:
      version: ${{ steps.get-version.outputs.version }}
    steps:
      - id: get-version
        run: echo "version=$(node -p 'require(\"./package.json\").version')" >> $GITHUB_OUTPUT

  deploy:
    needs: build
    runs-on: ubuntu-latest
    steps:
      - run: echo "Deploying version ${{ needs.build.outputs.version }}"
```

### Matrix strategy (multi-version testing)

```yaml
jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        node-version: ['20', '22']
        os: [ubuntu-latest, windows-latest]
    steps:
      - uses: actions/setup-node@v4
        with:
          node-version: ${{ matrix.node-version }}
```

### Permissions (principle of least privilege)

Always restrict permissions at the workflow or job level:

```yaml
# Workflow-level default
permissions:
  contents: read        # read repo code
  id-token: write       # needed for OIDC (GCP/AWS keyless auth)
  pull-requests: write  # needed for PR comments

# Override at job level (more restrictive)
jobs:
  lint:
    permissions:
      contents: read    # this job only needs to read
```

Common permission values: `read`, `write`, `none`

### Secrets and environment variables

```yaml
env:
  NODE_ENV: production                   # workflow-level env var

jobs:
  deploy:
    env:
      API_KEY: ${{ secrets.API_KEY }}    # job-level from GitHub Secrets
    steps:
      - run: echo "key=${{ secrets.PULUMI_ACCESS_TOKEN }}" >> $GITHUB_ENV
```

Access secrets via `${{ secrets.SECRET_NAME }}`. The built-in `GITHUB_TOKEN` grants default read/write access to the repo.

### Concurrency control

```yaml
concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true    # cancel queued/running jobs on new push to same branch
```

Use `cancel-in-progress: false` for deploy workflows where you want queuing, not cancellation.

### Conditional execution

```yaml
steps:
  - name: Deploy to prod
    if: github.ref == 'refs/heads/main' && github.event_name == 'push'
    run: pulumi up --yes

  - name: Only on manual trigger
    if: github.event_name == 'workflow_dispatch'
    run: echo "Input was ${{ github.event.inputs.environment }}"
```

### Reusable workflows (DRY CI)

```yaml
# .github/workflows/ci.yml — caller
jobs:
  test:
    uses: ./.github/workflows/reusable-test.yml
    with:
      node-version: '22'
    secrets: inherit
```

---

## Adding CI/CD to an existing project

If a project has no pipeline yet, add them in this order to avoid blocking on infrastructure setup:
1. Add `.github/workflows/ci.yml` — lint + test on every PR (no GCP auth needed)
2. Set up Workload Identity Federation for the GCP project (one-time gcloud setup)
3. Add `.github/workflows/deploy.yml` — `pulumi up` on merge to `main`
4. Enable branch protection on `main`: require CI to pass, require PR review
