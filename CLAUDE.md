# CLAUDE.md — Agentic Dev Wiki

This repo is a persistent knowledge base for **high-quality vibe coding** — the guardrails, tooling, and agent configuration that make AI-assisted development reliable without constant human supervision.

The wiki documents seven layers of guardrails: agent structure (CLAUDE.md/hooks), code quality (ESLint/Prettier), correctness (testing), security (Gitleaks/OWASP), infrastructure (Pulumi/GCP), CI/CD (GitHub Actions), and code review (CodeRabbit). A project bootstrapped from this wiki has all layers in place from day one.

**You maintain this wiki.** Humans source material. You ingest, synthesise, cross-reference, and keep it current.

---

## Read First

1. **This file** — orientation
2. **`SCHEMA.md`** — full spec: entity types, tag taxonomy, all operations, quality standards
3. **`index.md`** — catalog of all pages with status and tags

---

## Operations (summary — full spec in SCHEMA.md)

### Ingest
Process new source material (URL, doc, experiment):
1. **Check `ingested-sources.md` first** — if the URL was ingested within the last 90 days, skip re-fetching unless the user explicitly asks to refresh it
2. Fetch and read the source
3. Identify which pages in `index.md` it updates — read those pages
4. Update or create pages with sourced facts + confidence scores
5. Update `index.md` if new pages were created
6. **Update `ingested-sources.md`** — move the URL from "not yet ingested" to the ingested table, or add it if new
7. Append to `log.md`: `## [YYYY-MM-DD] ingest | <source title>`

### Query
Answer a question about a project's setup:
1. Read `index.md` → filter by tech stack tags → read relevant pages
2. Synthesise answer with page confidence noted
3. If the synthesis is novel, save it as a new page

### Bootstrap (for a new project)
Generate a project-specific `CLAUDE.md` / `AGENTS.md`:
1. Read `pages/new-project-checklist.md`
2. Read pages tagged to match the project's stack
3. Output a tailored `CLAUDE.md` / `AGENTS.md` the user can drop into their repo

### Lint
Health-check the wiki:
1. Verify every page in `index.md` exists on disk
2. Flag stubs with `last-updated` > 30 days
3. Check for contradictions — mark with `> ⚠️ CONTRADICTION:`
4. Report orphaned pages (on disk but not in `index.md`)

---

## Current State (2026-04-12)

All 9 pages are `stub` status — structure only, no sourced content yet.

**Priority Ingest queue** (in order):
1. `pages/claude-md-conventions.md` — fetch Anthropic Claude Code docs (CLAUDE.md guide)
2. `pages/claude-code-hooks.md` — fetch Anthropic Claude Code hooks documentation
3. `pages/testing-setup.md` — Vitest docs + Node.js testing patterns
4. `pages/cicd-github-actions.md` — Pulumi GitHub Actions + GCP OIDC
5. `pages/linting-setup.md` — ESLint flat config + Prettier
6. `pages/nodejs-patterns.md` — Node.js best practices guide

All source URLs are in `raw-sources/sources.md`.

---

## Conventions

- Every page has YAML frontmatter: `title`, `type`, `status`, `confidence` (0–100), `tags`, `last-updated`, `sources`
- Confidence: 0–30 stub · 31–60 draft · 61–85 solid · 86–100 verified
- Never delete content — supersede with strikethrough + note
- `raw-sources/sources.md` is human-only — never modify it
- `ingested-sources.md` is agent-maintained — update it after every Ingest operation
- Always update `log.md` after any write operation

---

## Tools

For **Ingest** operations you need `WebFetch` and `WebSearch` — both are allowed in `.claude/settings.json`.
