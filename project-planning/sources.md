# Raw Sources

> This file is **never modified by an agent**. Only humans add entries here.
> These are the authoritative input sources that feed Ingest operations.

---

## Wiki Pattern (Architecture)

| Source | URL | Notes |
|--------|-----|-------|
| Karpathy LLM Wiki v1 | https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f | Original pattern: three layers, operations, schema |
| Rohitg00 LLM Wiki v2 | https://gist.github.com/rohitg00/2067ab416f7bbe447c1977edaaa681e2 | Extensions: confidence scoring, knowledge graph, event-driven |

## AI Agent Configuration

| Source | URL | Notes |
|--------|-----|-------|
| Anthropic Claude Code docs | https://docs.anthropic.com/en/docs/claude-code | Official docs — CLAUDE.md guide, hooks, settings |
| Claude Code GitHub repo | https://github.com/anthropics/claude-code | Issues, examples, community patterns |

## Node.js

| Source | URL | Notes |
|--------|-----|-------|
| Node.js Best Practices | https://github.com/goldbergyoni/nodebestpractices | Community-maintained comprehensive guide |
| Node.js test runner | https://nodejs.org/api/test.html | Built-in test runner (Node 20+) |

## Testing

| Source | URL | Notes |
|--------|-----|-------|
| Vitest docs | https://vitest.dev/ | Fast unit test framework, ESM-native |
| Jest docs | https://jestjs.io/ | Mature, widely used |
| Supertest | https://github.com/ladjs/supertest | HTTP assertion library for Node.js |

## Linting / Formatting

| Source | URL | Notes |
|--------|-----|-------|
| ESLint flat config | https://eslint.org/docs/latest/use/configure/configuration-files | New config format (eslint.config.js) |
| Prettier | https://prettier.io/docs/en/ | Opinionated formatter |
| eslint-config-prettier | https://github.com/prettier/eslint-config-prettier | Disables ESLint rules that conflict with Prettier |

## Infrastructure

| Source | URL | Notes |
|--------|-----|-------|
| Pulumi YAML | https://www.pulumi.com/docs/languages-sdks/yaml/ | YAML-based Pulumi config |
| Pulumi GCP provider | https://www.pulumi.com/registry/packages/gcp/ | All GCP resource types |
| GCP Cloud Functions v2 | https://cloud.google.com/functions/docs | Serverless compute docs |

## CI/CD

| Source | URL | Notes |
|--------|-----|-------|
| GitHub Actions | https://docs.github.com/en/actions | Official docs |
| Pulumi GitHub Actions | https://github.com/pulumi/actions | `pulumi/actions` workflow steps |
| GCP OIDC for GitHub | https://cloud.google.com/blog/products/identity-security/enabling-keyless-authentication-from-github-actions | Keyless auth from CI |

## Security

| Source | URL | Notes |
|--------|-----|-------|
| Gitleaks | https://github.com/gitleaks/gitleaks | Secret scanner |
| Husky | https://typicode.github.io/husky/ | Git hooks manager |
| OWASP Node.js cheat sheet | https://cheatsheetseries.owasp.org/cheatsheets/Nodejs_Security_Cheat_Sheet.html | Security hardening for Node.js |

