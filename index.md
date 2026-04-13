# Wiki Index

> Read this first. Every page is listed here with a one-line summary and current status.
> Filter by tags to find pages relevant to your project's tech stack.

Last updated: 2026-04-12

> **Design philosophy:** This wiki documents the guardrail stack for high-quality vibe coding — agent structure, code quality, correctness, security, infrastructure, CI/CD, and AI code review. A project bootstrapped here has all seven layers active from day one.

---

## AI Agent Configuration

| Page | Summary | Status | Tags |
|------|---------|--------|------|
| [claude-md-conventions](pages/claude-md-conventions.md) | CLAUDE.md file placement, load order, recommended sections, token budget, .claude/rules/, AGENTS.md import pattern | draft | `claude-code` `ai-agent` `agents-md` |
| [claude-code-hooks](pages/claude-code-hooks.md) | All hook event types, settings.json schema, exit codes, JSON output format, env vars, and common patterns (lint, block-rm, notify) | draft | `claude-code` `ai-agent` `hooks` |

## Node.js Application Patterns

| Page | Summary | Status | Tags |
|------|---------|--------|------|
| [nodejs-patterns](pages/nodejs-patterns.md) | Component-based structure, ESM vs CJS, config validation, error handling, graceful shutdown, security headers, Docker best practices | draft | `nodejs` `javascript` |
| [linting-setup](pages/linting-setup.md) | ESLint flat config (eslint.config.js), Prettier options, eslint-config-prettier, Husky + lint-staged pre-commit hook | draft | `nodejs` `linting` `eslint` `prettier` |
| [testing-setup](pages/testing-setup.md) | Vitest setup (ESM-native, Jest-compatible), supertest HTTP testing, mocking GCP clients, coverage thresholds | draft | `nodejs` `testing` `jest` `vitest` |

## Infrastructure as Code

| Page | Summary | Status | Tags |
|------|---------|--------|------|
| [pulumi-gcp-patterns](pages/pulumi-gcp-patterns.md) | Pulumi YAML format, GCP provider resource types, Cloud Functions v2 full pattern (SA, bucket, function, IAM), supported Node.js runtimes, stack backends | draft | `pulumi` `iac` `gcp` `nodejs` `serverless` |

## CI/CD & Code Review

| Page | Summary | Status | Tags |
|------|---------|--------|------|
| [cicd-github-actions](pages/cicd-github-actions.md) | CI workflow (lint+test), Pulumi deploy workflow, GCP Workload Identity Federation OIDC setup, pulumi/actions@v6 reference, workflow syntax reference | draft | `cicd` `github-actions` `automation` `pulumi` `gcp` |
| [code-review-automation](pages/code-review-automation.md) | CodeRabbit AI PR review — installation, .coderabbit.yaml config, path-specific instructions, slop detection, integration with CLAUDE.md, position in the guardrail stack | draft | `cicd` `github-actions` `automation` `ai-agent` `code-review` |

## Security

| Page | Summary | Status | Tags |
|------|---------|--------|------|
| [security-scanning](pages/security-scanning.md) | Gitleaks installation, .gitleaks.toml config, allowlisting, pre-commit/GitHub Actions integration, npm audit, dependency scanning, Pulumi encrypted secrets | draft | `security` `secrets` `gitleaks` `nodejs` `cicd` |

## Project Bootstrapping

| Page | Summary | Status | Tags |
|------|---------|--------|------|
| [new-project-checklist](pages/new-project-checklist.md) | Ordered checklist to bootstrap a new project with all best practices in place | stub | `checklist` `nodejs` `pulumi` `claude-code` |

---

## Status Legend

| Status | Meaning |
|--------|---------|
| `stub` | Structure only — needs research and content |
| `draft` | Content present but not fully sourced or verified |
| `complete` | Well-sourced, verified, confidence ≥ 70 |
