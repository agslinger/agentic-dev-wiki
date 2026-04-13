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

## Read This When

- Building GCP infrastructure with Pulumi YAML
- Setting defaults for serverless Node.js deployments
- Separating app and infra responsibilities

## Default Recommendation

- Keep `infra/` as a separate Node/Pulumi project.
- Use Pulumi YAML for declarative stacks.
- Prefix resource names by environment or stack.
- Prefer OIDC in CI over long-lived service-account keys.
- Treat secrets as Pulumi encrypted config, not plaintext values.

## Use This Pattern

Suggested structure:

```text
infra/
  Pulumi.yaml
  Pulumi.dev.yaml
  package.json
  scripts/
```

Pulumi YAML shape:

- `name`
- `runtime: yaml`
- `config`
- `resources`
- `outputs`

GCP defaults:

- enable required APIs before dependent resources
- use least-privilege IAM
- prefer Cloud Functions v2 / current runtimes
- keep artifact buckets, service accounts, and IAM bindings explicit

## Commands / Config

Useful patterns:

- `${resource.attribute}` for references
- `pulumi config set --secret ...` for secrets
- separate stack config per environment

## Pitfalls

- Do not mix app and infra dependencies.
- Do not hardcode secrets in stack files.
- Do not assume APIs are enabled implicitly.
- Do not create broad IAM bindings when narrow ones work.

## Related Pages

- [cicd-github-actions](cicd-github-actions.md)
- [security-scanning](security-scanning.md)
- [new-project-checklist](new-project-checklist.md)
