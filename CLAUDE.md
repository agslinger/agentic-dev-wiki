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
1. **Check `project-planning/ingested-sources.md` first** — if the URL was ingested within the last 90 days, skip re-fetching unless the user explicitly asks to refresh it
2. Fetch and read the source
3. Identify which pages in `index.md` it updates — read those pages
4. Update or create pages with sourced facts + confidence scores
5. Update `index.md` if new pages were created
6. **Update `project-planning/ingested-sources.md`** — move the URL from "not yet ingested" to the ingested table, or add it if new
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
5. Run `pwsh ./scripts/wiki-lint.ps1` for structural checks before finishing substantial wiki edits

---

## Current State (2026-04-12)

The wiki now contains multiple draft pages across:

- agent configuration
- Node.js and frontend stack choices
- testing, security, CI/CD, and review
- project templates
- repo-specific planning in `project-planning/`

This repo also applies some of its own guidance back onto itself:

- `.claude/rules/` for wiki maintenance
- `scripts/wiki-lint.ps1` for structural linting
- GitHub Actions workflows for Gitleaks and wiki lint

---

## Conventions

- Every page has YAML frontmatter: `title`, `type`, `status`, `confidence` (0–100), `tags`, `last-updated`, `sources`
- Confidence: 0–30 stub · 31–60 draft · 61–85 solid · 86–100 verified
- Never delete content — supersede with strikethrough + note
- `project-planning/sources.md` is human-maintained source collection
- `project-planning/ingested-sources.md` is agent-maintained — update it after every Ingest operation
- Always update `log.md` after any write operation
- Prefer the simplest proving slice over the smallest arbitrary slice when changing the wiki itself

---

## Tools

For **Ingest** operations you need `WebFetch` and `WebSearch` — both are allowed in `.claude/settings.json`.
