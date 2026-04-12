# CLAUDE.md — Agentic Dev Wiki

This repo is a persistent knowledge base following the Karpathy LLM Wiki pattern.
It stores best-practice patterns for AI-driven development (Node.js, Pulumi/GCP, CI/CD, testing, security).

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
1. Fetch and read the source
2. Identify which pages in `index.md` it updates — read those pages
3. Update or create pages with sourced facts + confidence scores
4. Update `index.md` if new pages were created
5. Append to `log.md`: `## [YYYY-MM-DD] ingest | <source title>`

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
- Always update `log.md` after any write operation

---

## Tools

For **Ingest** operations you need `WebFetch` and `WebSearch` — both are allowed in `.claude/settings.json`.
