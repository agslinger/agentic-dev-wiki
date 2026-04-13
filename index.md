# Wiki Index

Read this first. Use it to choose the smallest useful set of pages.

Last updated: 2026-04-12

## How To Use This Index

- Start with the section that matches the task.
- Prefer pages tagged to the project stack.
- Read the page whose `Read This When` best matches the problem.
- Prefer `draft` and `complete` pages over `stub` pages.

## AI Agent Configuration

| Page | Read when | Status | Tags |
|---|---|---|---|
| [claude-md-conventions](pages/claude-md-conventions.md) | Writing or restructuring `CLAUDE.md`, `AGENTS.md`, or `.claude/rules/` | draft | `claude-code` `ai-agent` `agents-md` |
| [claude-code-hooks](pages/claude-code-hooks.md) | Adding Claude automation, guardrails, or local/shared hook configuration | draft | `claude-code` `ai-agent` `hooks` |

## Node.js Application Patterns

| Page | Read when | Status | Tags |
|---|---|---|---|
| [nodejs-patterns](pages/nodejs-patterns.md) | Starting a Node.js service or choosing service structure defaults | draft | `nodejs` `javascript` |
| [linting-setup](pages/linting-setup.md) | Adding linting, formatting, or pre-commit quality checks | draft | `nodejs` `linting` `eslint` `prettier` |
| [testing-setup](pages/testing-setup.md) | Choosing a Node.js test runner or setting up HTTP and unit tests | draft | `nodejs` `testing` `jest` `vitest` |

## Infrastructure As Code

| Page | Read when | Status | Tags |
|---|---|---|---|
| [pulumi-gcp-patterns](pages/pulumi-gcp-patterns.md) | Building Pulumi YAML stacks on GCP or wiring serverless infrastructure | draft | `pulumi` `iac` `gcp` `nodejs` `serverless` |

## CI/CD And Review

| Page | Read when | Status | Tags |
|---|---|---|---|
| [cicd-github-actions](pages/cicd-github-actions.md) | Adding CI, deploy workflows, PR previews, or OIDC auth | draft | `cicd` `github-actions` `automation` `pulumi` `gcp` |
| [code-review-automation](pages/code-review-automation.md) | Adding CodeRabbit or an AI review layer on pull requests | draft | `cicd` `github-actions` `automation` `ai-agent` `code-review` |

## Security

| Page | Read when | Status | Tags |
|---|---|---|---|
| [security-scanning](pages/security-scanning.md) | Adding secret scanning, dependency checks, or secret-handling rules | draft | `security` `secrets` `gitleaks` `nodejs` `cicd` |

## Bootstrapping

| Page | Read when | Status | Tags |
|---|---|---|---|
| [new-project-checklist](pages/new-project-checklist.md) | Bootstrapping a new project and needing the default order of work | stub | `checklist` `nodejs` `pulumi` `claude-code` |

## Status Legend

| Status | Meaning |
|---|---|
| `stub` | Structure only |
| `draft` | Useful but still evolving |
| `complete` | Verified and stable |
