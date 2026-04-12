# Wiki Schema: Agentic Development Best Practices

## Purpose

This wiki stores compiled knowledge about AI-driven development workflows, tooling, and best practices. It is designed to be read by Claude/Codex agents at the start of new projects to bootstrap best-practice setup without requiring manual research each time.

Knowledge is compiled once and kept current — not re-synthesised on every query.

---

## Entity Types

| Type | Description | Example |
|------|-------------|---------|
| `pattern` | A repeatable approach or convention | ESLint flat config setup |
| `tool` | A specific piece of software | Husky, Vitest, Pulumi |
| `concept` | An abstract idea or principle | trunk-based development |
| `checklist` | An ordered list of steps | new project bootstrap |
| `reference` | A link to an authoritative external source | Anthropic Claude Code docs |

---

## Page Frontmatter

Every page in `pages/` starts with YAML frontmatter:

```yaml
---
title: <Human-readable title>
type: pattern|tool|concept|checklist|reference
status: stub|draft|complete
confidence: 0-100
tags: [tag1, tag2]
last-updated: YYYY-MM-DD
sources: []
---
```

**Confidence scoring:**
- `0–30` — early stub, treat as directional only
- `31–60` — draft, use with caution, verify before applying
- `61–85` — solid, well-sourced, generally applicable
- `86–100` — verified against multiple sources, production-tested

---

## Tag Taxonomy

Use these tags to filter pages by project tech stack:

**Language/Runtime:** `nodejs`, `javascript`, `typescript`, `python`
**IaC:** `pulumi`, `terraform`, `iac`
**Cloud:** `gcp`, `aws`, `azure`
**Testing:** `testing`, `jest`, `vitest`, `unit-test`, `integration-test`
**Quality:** `linting`, `eslint`, `prettier`, `formatting`
**CI/CD:** `cicd`, `github-actions`, `automation`
**Security:** `security`, `secrets`, `gitleaks`
**AI/Agent:** `claude-code`, `ai-agent`, `agents-md`, `hooks`, `llm`
**Infrastructure:** `docker`, `containers`, `cloud-functions`, `serverless`

---

## Operations

### Ingest
When new source material arrives (article, doc, experiment, PR):
1. Read and summarise the source
2. Identify which existing pages to update (check `index.md`)
3. Update relevant pages — add facts with confidence scores and source citations
4. Create new pages if the content warrants it
5. Update `index.md` with any new/changed page summaries
6. Append to `log.md`: `## [YYYY-MM-DD] ingest | <source title>`

### Query
When answering a question about a new project's setup:
1. Read `index.md` first to identify candidate pages
2. Filter by the project's tech stack tags
3. Read the relevant pages in full
4. Synthesise answer, noting confidence levels from frontmatter
5. If the exploration produced novel synthesis, save it as a new page

### New Project Bootstrap
When starting a new project with this wiki:
1. Read `SCHEMA.md` (this file) to understand the system
2. Read `index.md` for the full catalog
3. Identify the project's tech stack and filter pages by tags
4. Read `pages/new-project-checklist.md` — work through it top to bottom
5. Read tag-relevant pattern pages (e.g., `nodejs-patterns.md`, `pulumi-gcp-patterns.md`)
6. Generate a project-specific `CLAUDE.md` / `AGENTS.md` from the applicable patterns
7. Log the bootstrap: append to `log.md`

### Lint
Periodic health check (run when prompted):
1. Verify every page listed in `index.md` exists on disk
2. Flag stubs whose `last-updated` is >30 days old
3. Check for contradictions between pages (note them with a `> ⚠️ CONTRADICTION:` blockquote)
4. Identify pages on disk not listed in `index.md` (orphans)
5. Report findings — do not auto-delete, surface for human review

---

## Directory Structure

```
/
├── README.md           ← Human-facing overview
├── SCHEMA.md           ← This file — governance and conventions
├── index.md            ← Content catalog (read first for any operation)
├── log.md              ← Append-only operational log
├── pages/              ← All knowledge pages (one topic per file)
└── raw-sources/
    └── sources.md      ← Links to source material — immutable by agent
```

---

## Quality Standards

- All facts must cite a `sources` entry in frontmatter or inline link
- Contradictions between pages must be flagged in both pages with `> ⚠️ CONTRADICTION:`
- Stubs must be promoted to `draft` within 30 days of creation
- Never delete content — supersede it with a strikethrough and a note: `~~old claim~~ — superseded YYYY-MM-DD because <reason>`
- The `raw-sources/sources.md` file is **never modified by an agent** — only humans add sources there

---

## Relationship to Project-level AGENTS.md / CLAUDE.md

This wiki is the **source of truth** for patterns. A project's `AGENTS.md` / `CLAUDE.md` is a **derived artifact** — a subset of wiki knowledge tailored to that project's stack.

When updating wiki pages, consider whether the change should propagate to existing project files. When updating a project's `AGENTS.md`, consider whether the learning should be generalised back into the wiki (Ingest operation).
