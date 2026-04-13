# agentic-dev-wiki

A persistent knowledge base for building high-quality software in an AI-driven ("vibe coding") workflow — compiled once, queried by agents at project start rather than re-synthesised every session.

## The problem this solves

Vibe coding — letting an AI agent write most of the code while you direct at a higher level — is fast. Without structure, it's also fragile: the agent skips tests, forgets linting, repeats setup mistakes, and gradually erodes code quality across sessions.

This wiki is the antidote. It encodes the **guardrails, tooling, and agent configuration** that make high-velocity AI-assisted development produce consistently high-quality output:

| Layer | What it does |
|---|---|
| **Agent structure** | `CLAUDE.md` conventions, hooks, memory — how to direct the agent reliably |
| **Code quality guardrails** | ESLint flat config, Prettier, pre-commit hooks — catch style and correctness issues automatically |
| **Correctness guardrails** | Vitest / node:test — make it hard to ship broken code |
| **Security guardrails** | Gitleaks pre-commit, secret scanning CI, OWASP patterns — prevent the agent from leaking secrets |
| **Infrastructure guardrails** | Pulumi YAML patterns, GCP best practices — IaC that's readable and reviewable |
| **CI guardrails** | GitHub Actions pipelines — automated validation on every PR before merge |
| **Review guardrail** | CodeRabbit AI code review — a second AI perspective that catches what the coding agent missed |

A new project bootstrapped from this wiki starts with all layers in place. The agent then operates within those constraints, producing code that doesn't need constant human supervision to stay clean.

## How Claude should use this wiki

**At the start of any new project:**
1. Read `SCHEMA.md` to understand the system
2. Read `index.md` for the full page catalog
3. Filter relevant pages by the project's tech stack (use the tags in each page's frontmatter)
4. Read `pages/new-project-checklist.md` — work through it top-to-bottom
5. Generate a project-specific `CLAUDE.md` / `AGENTS.md` from the applicable patterns

**To add new knowledge (Ingest):**
Check `project-planning/ingested-sources.md` first, then see the Ingest operation in `SCHEMA.md`.

**To health-check the wiki (Lint):**
See the Lint operation defined in `SCHEMA.md`.

## Structure

```
/
├── README.md                   ← This file — mission and orientation
├── SCHEMA.md                   ← Governance: types, operations, quality standards
├── CLAUDE.md                   ← Instructions for AI agents maintaining this wiki
├── index.md                    ← Content catalog — read this first
├── log.md                      ← Append-only changelog
├── pages/                      ← All knowledge pages
├── .claude/                    ← Repo-specific Claude settings, hooks, and rules
├── .github/workflows/          ← Gitleaks + wiki-lint CI
├── pages/                      ← All reusable knowledge pages
├── project-planning/           ← Repo-specific plans, sources, and follow-on questions
│   ├── ingested-sources.md     ← Track what has been fetched (agent-maintained)
│   ├── sources.md              ← Links to source material
│   └── *.md                    ← Plans and follow-on questions
├── scripts/
│   └── wiki-lint.ps1           ← Structural lint for this wiki
└── templates/                  ← Reusable CLAUDE/AGENTS/hooks/rules templates
```

## Repo Guardrails

This repo applies its own guidance back onto itself:

- Gitleaks runs in GitHub Actions
- wiki-specific Claude rules live under `.claude/rules/`
- `scripts/wiki-lint.ps1` checks page structure, index coverage, required headings, and orphan pages
- `Wiki Lint` runs in CI on PRs and pushes to `main`

## Status

Check `index.md` for the current status of each page.
