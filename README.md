# agentic-dev-wiki

A persistent knowledge base for AI-driven development best practices, maintained by and for AI coding agents (Claude, Codex, etc.).

## What this is

This wiki follows the [Karpathy LLM Wiki pattern](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f): a structured collection of markdown pages that an AI agent maintains and queries — acting as compiled, persistent knowledge rather than re-synthesising on every query.

It stores best-practice patterns for:
- AI agent configuration (`CLAUDE.md` / `AGENTS.md` conventions, hooks)
- Node.js application development
- Infrastructure as Code (Pulumi + GCP)
- Testing, linting, CI/CD
- Security scanning
- New project bootstrapping

## How Claude should use this wiki

**At the start of any new project:**
1. Read `SCHEMA.md` to understand the system
2. Read `index.md` for the full page catalog
3. Filter relevant pages by the project's tech stack (use the tags in each page's frontmatter)
4. Read `pages/new-project-checklist.md` to validate the setup
5. Generate a project-specific `CLAUDE.md` / `AGENTS.md` from the applicable patterns

**To add new knowledge (Ingest):**
See the Ingest operation defined in `SCHEMA.md`.

**To health-check the wiki (Lint):**
See the Lint operation defined in `SCHEMA.md`.

## Structure

```
/
├── README.md               ← This file
├── SCHEMA.md               ← Governance: types, operations, conventions
├── index.md                ← Content catalog — read this first
├── log.md                  ← Append-only changelog
├── pages/                  ← All knowledge pages
│   ├── claude-md-conventions.md
│   ├── claude-code-hooks.md
│   ├── nodejs-patterns.md
│   ├── pulumi-gcp-patterns.md
│   ├── testing-setup.md
│   ├── linting-setup.md
│   ├── cicd-github-actions.md
│   ├── security-scanning.md
│   └── new-project-checklist.md
└── raw-sources/
    └── sources.md          ← Links to source material, never modified by agent
```

## Status

Pages are at one of three stages: `stub` → `draft` → `complete`. Check `index.md` for current status of each page.
