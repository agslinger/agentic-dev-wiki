---
paths:
  - "infra/**"
---

# Infrastructure Rules

- Never hardcode secrets — use `pulumi config set --secret`.
- Prefix resource names with the stack or environment name.
- Enable required GCP APIs before creating dependent resources.
- Use least-privilege IAM bindings — never `roles/editor` or `roles/owner`.
- Protect stateful resources (databases, buckets with data) with `protect: true`.
- Do not run `pulumi up` or `pulumi destroy` without explicit user approval.
