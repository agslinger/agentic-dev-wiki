# Wiki Schema: Agentic Development Best Practices

## Purpose

This wiki stores compact, reusable guidance for AI-driven software projects.

It is optimized for agents that need to:

1. find the right page quickly
2. extract the default recommendation quickly
3. read only deeper detail when necessary

## Core Rule

Optimize every page for **selection before reading**.

That means:

- `index.md` helps an agent choose the right page
- each page starts with when it should be read
- the default recommendation appears before long examples
- pages stay narrow and short

## Entity Types

| Type | Use |
|---|---|
| `pattern` | Repeatable implementation guidance |
| `tool` | Specific tool recommendation or setup |
| `concept` | Abstract idea or decision model |
| `checklist` | Ordered implementation steps |
| `reference` | Pointer to authoritative material |

## Page Frontmatter

Every page in `pages/` starts with:

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

Confidence guide:

- `0-30` stub
- `31-60` directional draft
- `61-85` solid guidance
- `86-100` verified and production-tested

## Required Page Shape

For `pattern`, `tool`, and `concept` pages, use this order:

```md
## Read This When
## Default Recommendation
## Use This Pattern
## Commands / Config
## Pitfalls
## Related Pages
```

For `checklist` pages, use:

```md
## Read This When
## Default Flow
## Checklist
## Related Pages
```

## Writing Rules

- Put the answer near the top.
- Prefer short bullets over long prose.
- Use stable headings across pages.
- Repeat exact tool and tech names in summaries and headings.
- Keep one topic per page.
- Link related pages directly.
- Use examples only when they change implementation, not just to restate it.

## Length Rules

- Target `80-160` lines for most pages.
- Split a page when it exceeds `220` lines after cleanup.
- Split a page when it answers more than one major decision question.

Good split examples:

- setup vs recipes
- defaults vs reference tables
- policy vs implementation

## Tag Taxonomy

Language/runtime:

- `nodejs`
- `javascript`
- `typescript`
- `python`

IaC/cloud:

- `pulumi`
- `terraform`
- `iac`
- `gcp`
- `aws`
- `azure`

Quality/testing:

- `linting`
- `eslint`
- `prettier`
- `testing`
- `jest`
- `vitest`
- `unit-test`
- `integration-test`

Delivery/security:

- `cicd`
- `github-actions`
- `automation`
- `security`
- `secrets`
- `gitleaks`

AI/agent:

- `claude-code`
- `ai-agent`
- `agents-md`
- `hooks`
- `llm`
- `code-review`

Infra/runtime:

- `docker`
- `containers`
- `cloud-functions`
- `serverless`

## Operations

### Query

1. Read `index.md`
2. Filter by tags and page summary
3. Read only the few relevant pages
4. Use confidence and status to weight the answer

### Ingest

1. Read the relevant existing pages first
2. Update the smallest number of pages possible
3. Keep the default recommendation short and current
4. Add deeper detail only when it changes implementation
5. Update `index.md` if page meaning changes
6. Append to `log.md`

### Lint

Check for:

- missing pages listed in `index.md`
- orphan pages not listed in `index.md`
- stale stubs
- contradictory claims
- oversized pages that should be split
- missing or weak sources

## Quality Standards

- Every page must be skimmable in under a minute.
- The first useful recommendation should appear near the top.
- Contradictions must be marked with `> ⚠️ CONTRADICTION:`.
- Superseded claims must be clearly marked.
- `raw-sources/` and `project-planning/` are not canonical knowledge pages.

## Relationship To CLAUDE.md

This wiki stores reusable patterns.

Project-level `CLAUDE.md` files should contain only the subset needed for that project, not the whole wiki.
