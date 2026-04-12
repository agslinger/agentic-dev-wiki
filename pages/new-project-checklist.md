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

> **Status: stub** — items drawn from IaC-test-app gap analysis. Expand as wiki pages reach `complete` status.
> Work through this top-to-bottom when starting a new project.

---

## 1. Repository Setup

- [ ] Create repo on GitHub (private by default)
- [ ] Add `README.md` (project purpose, setup instructions, deploy commands)
- [ ] Add `.gitignore` — Node.js template + extras: `.env`, `*.pem`, `.pulumi/`, `.build/`
- [ ] Add `AGENTS.md` / `CLAUDE.md` at repo root (see [claude-md-conventions](claude-md-conventions.md))
- [ ] Pin Node.js version: add `.nvmrc` and `engines` field in `package.json`
- [ ] Add `LICENSE` if open source

## 2. Code Structure

- [ ] Separate `src/` (application) from `infra/` (IaC) — each with own `package.json`
- [ ] `"use strict"` at top of all JS files
- [ ] Entry point: `src/index.js` (server bootstrap, keep thin)
- [ ] Request handler: `src/app.js` (routing and logic)

## 3. Secret Scanning (Day 1 — before first commit)

- [ ] Install Husky: `npm install --save-dev husky && npx husky init`
- [ ] Install Gitleaks (system-level)
- [ ] Create `.gitleaks.toml` with project-specific custom rules
- [ ] Wire Gitleaks into `.husky/pre-commit`
- [ ] Test: try to commit a fake secret — confirm it's blocked
- [ ] See [security-scanning](security-scanning.md) for full setup

## 4. Code Quality

- [ ] Install ESLint + Prettier: `npm install --save-dev eslint prettier eslint-config-prettier`
- [ ] Create `eslint.config.js` (flat config)
- [ ] Create `.prettierrc`
- [ ] Add `lint`, `lint:fix`, `format` scripts to `package.json`
- [ ] Add lint step to pre-commit hook
- [ ] See [linting-setup](linting-setup.md) for full config

## 5. Testing

- [ ] Install Vitest (or Jest): `npm install --save-dev vitest`
- [ ] Create first test file for the request handler
- [ ] Add `test`, `test:watch`, `test:coverage` scripts to `package.json`
- [ ] Set coverage threshold (suggest: 70% lines minimum)
- [ ] See [testing-setup](testing-setup.md) for full setup

## 6. Infrastructure (if using Pulumi/GCP)

- [ ] Init Pulumi project in `infra/`: `pulumi new` or copy YAML structure
- [ ] Set up stack config: `infra/Pulumi.<stack>.yaml`
- [ ] Configure secrets: `pulumi config set --secret <key> <value>`
- [ ] Add `infra/` to `.gitignore` for `.build/` artifacts
- [ ] Prefix all resource names with stack: `${stack}-resource-name`
- [ ] Enable required GCP APIs before creating dependent resources
- [ ] See [pulumi-gcp-patterns](pulumi-gcp-patterns.md) for full patterns

## 7. CI/CD

- [ ] Create `.github/workflows/ci.yml` — lint and test on every PR
- [ ] Create `.github/workflows/deploy.yml` — Pulumi deploy on merge to `main`
- [ ] Set up GCP Workload Identity Federation (avoid service account keys in CI)
- [ ] Add `PULUMI_ACCESS_TOKEN` (or GCS backend config) to GitHub Secrets
- [ ] Enable branch protection: require CI to pass before merge
- [ ] See [cicd-github-actions](cicd-github-actions.md) for workflow templates

## 8. AI Agent Configuration

- [ ] Update `AGENTS.md` / `CLAUDE.md` with project-specific commands and conventions
- [ ] Add reference to this wiki: `~/.claude/wiki/agentic-dev/index.md`
- [ ] Configure Claude Code hooks for auto-lint on edit (see [claude-code-hooks](claude-code-hooks.md))
- [ ] Verify agent can run `npm test`, `npm run lint`, and Pulumi preview

## 9. Security Review

- [ ] All secrets in Pulumi config or environment variables — none hardcoded
- [ ] Security headers set on all HTTP responses
- [ ] CORS origin validation (allowlist, not wildcard `*`)
- [ ] `npm audit` — zero high/critical vulnerabilities
- [ ] `robots.txt` if publicly accessible

## 10. Documentation

- [ ] `README.md` covers: what it does, how to run locally, how to deploy
- [ ] `AGENTS.md` covers: project overview, conventions, rules, common commands
- [ ] Infrastructure resources documented (at minimum: what's deployed and why)

---

## Status of dependent wiki pages

| Page | Status | Blocks checklist section |
|------|--------|--------------------------|
| [claude-md-conventions](claude-md-conventions.md) | stub | Section 1, 8 |
| [claude-code-hooks](claude-code-hooks.md) | stub | Section 8 |
| [security-scanning](security-scanning.md) | stub | Section 3, 9 |
| [linting-setup](linting-setup.md) | stub | Section 4 |
| [testing-setup](testing-setup.md) | stub | Section 5 |
| [pulumi-gcp-patterns](pulumi-gcp-patterns.md) | stub | Section 6 |
| [cicd-github-actions](cicd-github-actions.md) | stub | Section 7 |
