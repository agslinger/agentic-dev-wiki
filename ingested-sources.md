# Ingested Sources

> **Agent-maintained.** Updated after every Ingest operation.
> Before fetching any URL, check this file. If a source was ingested within the last 90 days, skip re-fetching unless the user explicitly asks to refresh it.
>
> Compare against `raw-sources/sources.md` to find sources that have **not** yet been ingested.

---

## How to read this table

| Column | Meaning |
|---|---|
| **URL** | The exact URL fetched |
| **Date** | Date first ingested (YYYY-MM-DD) |
| **Pages updated** | Wiki pages that received content from this source |
| **Staleness** | How quickly this source changes — guides re-ingest priority |

---

## Ingested sources

| URL | Date | Pages updated | Staleness |
|---|---|---|---|
| https://code.claude.com/docs/en/memory | 2026-04-12 | `claude-md-conventions.md` | Low — official docs, updated with releases |
| https://code.claude.com/docs/en/hooks | 2026-04-12 | `claude-code-hooks.md` | Low — official docs, updated with releases |
| https://vitest.dev/ | 2026-04-12 | `testing-setup.md` | Low — framework homepage |
| https://vitest.dev/guide/ | 2026-04-12 | `testing-setup.md` | Low — getting started guide |
| https://github.com/goldbergyoni/nodebestpractices | 2026-04-12 | `testing-setup.md`, `nodejs-patterns.md` | Medium — community guide, updated periodically |
| https://eslint.org/docs/latest/use/configure/configuration-files | 2026-04-12 | `linting-setup.md` | Low — official docs |
| https://prettier.io/docs/options | 2026-04-12 | `linting-setup.md` | Low — official docs |
| https://github.com/pulumi/actions | 2026-04-12 | `cicd-github-actions.md` | Medium — action releases change inputs |
| https://docs.cloud.google.com/iam/docs/workload-identity-federation-with-deployment-pipelines | 2026-04-12 | `cicd-github-actions.md` | Low — GCP docs |
| https://nodejs.org/api/test.html | 2026-04-12 | `testing-setup.md` | Medium — updated with Node.js releases |
| https://jestjs.io/ | 2026-04-12 | `testing-setup.md` | Low — framework homepage |
| https://github.com/ladjs/supertest | 2026-04-12 | `testing-setup.md` | Low — stable library |
| https://github.com/prettier/eslint-config-prettier | 2026-04-12 | `linting-setup.md` | Low — stable config package |
| https://typicode.github.io/husky/get-started.html | 2026-04-12 | `linting-setup.md` | Low — stable tool |
| https://www.pulumi.com/docs/languages-sdks/yaml/ | 2026-04-12 | `pulumi-gcp-patterns.md` | Low — Pulumi YAML docs |
| https://www.pulumi.com/registry/packages/gcp/ | 2026-04-12 | `pulumi-gcp-patterns.md` | Medium — GCP provider registry |
| https://docs.cloud.google.com/functions/docs/concepts/execution-environment | 2026-04-12 | `pulumi-gcp-patterns.md` | Low — GCP runtime support schedule |
| https://github.com/gitleaks/gitleaks | 2026-04-12 | `security-scanning.md` | Medium — active project, new rules added |
| https://cheatsheetseries.owasp.org/cheatsheets/Nodejs_Security_Cheat_Sheet.html | 2026-04-12 | `nodejs-patterns.md` | Low — OWASP updates infrequently |
| https://docs.github.com/en/actions/writing-workflows/workflow-syntax-for-github-actions | 2026-04-12 | `cicd-github-actions.md` | Low — GitHub Actions syntax docs |
| https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f | 2026-04-12 | `SCHEMA.md` (informed initial design) | Static — gist won't change |
| https://gist.github.com/rohitg00/2067ab416f7bbe447c1977edaaa681e2 | 2026-04-12 | `SCHEMA.md` (informed initial design) | Static — gist won't change |
| https://docs.coderabbit.ai/reference/configuration | 2026-04-12 | `code-review-automation.md` | Medium — config schema updated with new features |
| https://docs.coderabbit.ai/guides/review-instructions | 2026-04-12 | `code-review-automation.md` | Low — guide content stable |
| https://docs.coderabbit.ai/getting-started/quickstart | 2026-04-12 | `code-review-automation.md` | Low — quickstart stable |

---

## Sources not yet ingested

All sources from `raw-sources/sources.md` have now been ingested. The following are **supplementary sources** worth ingesting in future sessions if the relevant pages need deeper coverage:

| URL | Target page | Priority | Notes |
|---|---|---|---|
| https://cloud.google.com/functions/docs/writing/write-http-functions | `pulumi-gcp-patterns.md` | Medium | HTTP function writing guide — entry point patterns |
| https://cloud.google.com/functions/docs/configuring/env-var | `pulumi-gcp-patterns.md` | Medium | Cloud Functions env var configuration |
| https://cloud.google.com/functions/docs/bestpractices/tips | `pulumi-gcp-patterns.md` | Medium | GCP official best practices |
| https://www.pulumi.com/docs/concepts/secrets/ | `pulumi-gcp-patterns.md` | High | Pulumi ESC secrets management |
| https://www.pulumi.com/docs/concepts/stack/ | `pulumi-gcp-patterns.md` | Medium | Stack references and outputs |
| https://github.com/gitleaks/gitleaks-action | `security-scanning.md` | Medium | Gitleaks GitHub Action details |
| https://vitest.dev/guide/coverage | `testing-setup.md` | Low | Coverage configuration deep-dive |
| https://jestjs.io/docs/configuration | `testing-setup.md` | Low | Jest config reference |
| https://docs.npmjs.com/cli/v10/commands/npm-audit | `security-scanning.md` | Low | npm audit flags and exit codes |
