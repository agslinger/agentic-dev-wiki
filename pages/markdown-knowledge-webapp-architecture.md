---
title: Markdown Knowledge Web App Architecture
type: pattern
status: draft
confidence: 74
tags: [typescript, ai-agent, llm]
last-updated: 2026-05-17
sources:
  - "Obsidian Sync help: https://obsidian.md/help/sync-notes"
  - "Obsidian headless sync: https://obsidian.md/help/sync/headless"
  - "GitHub REST repository contents API: https://docs.github.com/en/rest/repos/contents"
  - "Amazon S3 versioning: https://docs.aws.amazon.com/AmazonS3/latest/userguide/versioning-workflows.html"
  - "Outstatic: https://outstatic.com/"
  - "GitCMS: https://gitcms.dev/docs/"
  - "Dhub: https://dhub.dev/"
  - "TinaCMS overview: https://cmsconf.com/knowledge/tinacms/"
---

# Markdown Knowledge Web App Architecture

## Read This When

- Building a web app over Markdown, Git, Obsidian, search, graph, or RAG
- Deciding whether the browser app should be read-only or read/write
- Designing ingestion from Markdown into Postgres or another serving index

## Default Recommendation

- Treat Markdown/Git/Obsidian as the human authoring source.
- Treat Postgres as a derived serving and retrieval index.
- Start with a read-only web app unless browser authoring is a real product need.
- Add web writes through branches/PRs, drafts, or versioned objects; do not write blindly to `main`.
- Show ingestion status so stale indexes are visible.
- Use [composable-data-storage](composable-data-storage.md) for broader SQL/vector/graph store selection.

## Use This Pattern

### Read-only mode

Use when Obsidian/Git is the authoring path.

Flow:

1. User edits Markdown locally.
2. Git or Obsidian Sync publishes changes.
3. Webhook or scheduled job fetches changed Markdown.
4. Ingestion parses frontmatter, headings, wikilinks, links, and sections.
5. Postgres stores documents, sections, links, search, and embeddings.
6. Web app, graph, and chatbot read from derived indexes.

Benefits:

- simplest operating model
- Git history remains the audit trail
- no browser write conflicts
- Postgres can be rebuilt from Markdown

### Read/write mode

Use when non-local users need browser editing, review, moderation, or forms.

Write paths:

- branch + pull request
- direct commit with optimistic concurrency
- draft row in Postgres, later published to Markdown/Git
- object version in object storage, later indexed

Required guardrails:

- optimistic concurrency with commit SHA, blob SHA, ETag, or version ID
- draft vs published state
- conflict handling UI
- server-side Markdown/frontmatter validation
- review path for risky edits
- clear attachment ownership

## Commands / Config

Suggested derived tables:

- `documents`: path, title, frontmatter, source version, published state
- `sections`: heading path, text, ordinal, offsets, checksum
- `links`: source section, target, link type, unresolved flag
- `assets`: path/key, MIME type, source version, linked docs
- `embeddings`: section ID, model, vector, checksum
- `ingestion_runs`: source version, status, error, duration

These are Markdown-serving tables, not the general data architecture default.

Ingestion rules:

- Re-embed only changed sections.
- Preserve source path and section anchor for citations.
- Store unresolved wikilinks; do not silently drop them.
- Normalize Obsidian links to stable internal targets.
- Treat graph JSON as a derived artifact.

## Pitfalls

- Do not let Obsidian and the web app edit the same file without conflict strategy.
- Do not treat embeddings as source of truth.
- Do not hide ingestion failures while serving stale RAG answers.
- Do not mix drafts and published content in one production retrieval index.
- Do not put large binary assets in Git by default.

## Related Pages

- [composable-data-storage](composable-data-storage.md)
- [postgres-pgvector](postgres-pgvector.md)
- [document-parsing-stack](document-parsing-stack.md)
- [markdown-rendering](markdown-rendering.md)
- [gitignore-best-practices](gitignore-best-practices.md)
