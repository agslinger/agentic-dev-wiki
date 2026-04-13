---
title: New Project Bootstrap Checklist
type: checklist
status: stub
confidence: 25
tags: [checklist, nodejs, pulumi, claude-code, security, testing, cicd]
last-updated: 2026-04-12
sources: []
---

# New Project Bootstrap Checklist

## Read This When

- Starting a new project from this wiki
- Needing the default order of setup work

## Default Flow

Build the guardrail stack in this order:

1. repo and instructions
2. code structure
3. secret scanning
4. linting
5. testing
6. infrastructure
7. CI/CD
8. agent automation
9. review and docs

## Checklist

### 1. Repo

- [ ] Create repo and `README.md`
- [ ] Add `.gitignore`
- [ ] Add `CLAUDE.md`
- [ ] Pin Node version with `.nvmrc` and `package.json#engines`

### 2. Code

- [ ] Separate `src/` and `infra/`
- [ ] Use `createServer()` pattern
- [ ] Add env validation

### 3. Security

- [ ] Install Gitleaks
- [ ] Add `.gitleaks.toml`
- [ ] Block secrets in pre-commit

### 4. Quality

- [ ] Add ESLint flat config
- [ ] Add Prettier
- [ ] Add Husky/lint-staged

### 5. Testing

- [ ] Add Vitest
- [ ] Add first HTTP test
- [ ] Add coverage threshold

### 6. Infra

- [ ] Set up `infra/` as separate project
- [ ] Add Pulumi stack config
- [ ] Store secrets with `pulumi config set --secret`

### 7. CI/CD

- [ ] Add `ci.yml`
- [ ] Add deploy workflow if needed
- [ ] Use OIDC for GCP auth

### 8. Agent Tooling

- [ ] Add shared Claude rules
- [ ] Add hooks only where they help

### 9. Review And Docs

- [ ] Add CodeRabbit or equivalent review layer
- [ ] Make sure `README.md` and `CLAUDE.md` match reality

## Related Pages

- [claude-md-conventions](claude-md-conventions.md)
- [linting-setup](linting-setup.md)
- [testing-setup](testing-setup.md)
- [security-scanning](security-scanning.md)
- [cicd-github-actions](cicd-github-actions.md)
- [code-review-automation](code-review-automation.md)
