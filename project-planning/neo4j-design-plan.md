# Neo4j Design Plan

## Purpose

This document describes how to extend `agentic-dev-wiki` with a structured graph and search layer using Neo4j.

It is intentionally **repo-specific**. It does not describe a general-purpose knowledge system. It describes how this repository should evolve from a markdown-only wiki into a markdown-plus-graph system while preserving the current authoring flow.

## Goals

- Keep markdown files in the repo as the primary human-readable interface.
- Keep Obsidian useful for browsing and editing the wiki.
- Add a machine-queryable graph for entities, facts, relationships, contradictions, and supersession.
- Add hybrid retrieval: semantic lookup plus graph traversal.
- Support future automation for ingest, consolidation, and stale-content detection.

## Non-Goals

- Replacing markdown authoring with a database UI
- Generating every page entirely from the graph on day one
- Building a generic multi-tenant knowledge platform
- Introducing a large operational footprint before the schema is stable

## Current State

Today the repository stores knowledge primarily in:

- `pages/*.md` for topic pages
- `index.md` for the catalog
- `log.md` for append-only operational history
- `raw-sources/sources.md` and `ingested-sources.md` for source tracking
- `.obsidian/` for human navigation

The repo already has useful governance concepts:

- page types
- confidence scores
- contradiction marking
- supersession-by-convention
- ingest/query/lint/bootstrap operations

What is missing is a structured machine layer for:

- fact-level records
- explicit typed relationships
- confidence history
- cross-page entity linking
- graph traversal
- vector retrieval

## Architecture

The target architecture has four layers:

### 1. Markdown layer

Repo files remain the human-facing system of record for readable pages and reviewable changes.

- `pages/*.md`
- `index.md`
- `log.md`
- planning docs in `plans/`

### 2. Neo4j graph layer

Neo4j stores structured knowledge extracted from markdown pages and ingested sources.

This layer is responsible for:

- nodes for pages, facts, entities, observations, and sources
- typed relationships
- contradiction and supersession links
- vector indexes for semantic retrieval

### 3. Sync and ingest layer

Scripts or services populate and maintain the graph.

This layer is responsible for:

- parsing markdown and frontmatter
- extracting links and references
- creating or updating graph nodes
- attaching embeddings
- proposing markdown updates after graph analysis

### 4. Retrieval and automation layer

This layer supports agent workflows.

It is responsible for:

- hybrid search
- contradiction detection
- stale-content checks
- session crystallization
- future Claude hook integrations

## Canonical Source Strategy

The repository should remain **markdown-first** in the first implementation.

That means:

- markdown pages are canonical for human-readable knowledge
- Neo4j is canonical for machine-structured relationships and retrieval metadata
- facts may eventually become graph-canonical, but not in phase 1

Practical rule:

- humans edit markdown
- automation syncs markdown into Neo4j
- automation may propose markdown changes, but should not silently rewrite content

## Proposed Graph Model

### Node labels

#### `Page`

Represents a markdown page in the repo.

Suggested properties:

- `path`
- `title`
- `type`
- `status`
- `confidence`
- `last_updated`
- `tags`
- `hash`

#### `Fact`

Represents a discrete claim extracted from a page or source.

Suggested properties:

- `fact_id`
- `text`
- `confidence`
- `status` (`active`, `superseded`, `disputed`)
- `created_at`
- `updated_at`

#### `Entity`

Represents a named concept, tool, product, process, or artifact.

Suggested properties:

- `entity_id`
- `name`
- `kind` (`tool`, `concept`, `provider`, `file`, `workflow`, `service`)
- `aliases`

#### `Source`

Represents an external source or internal origin document.

Suggested properties:

- `source_id`
- `title`
- `url`
- `source_type`
- `retrieved_at`

#### `Observation`

Represents a structured ingest event or discovered finding before it is fully consolidated into a page.

Suggested properties:

- `observation_id`
- `summary`
- `created_at`
- `confidence`
- `scope` (`shared`, `private`)

#### `Session`

Represents a work session or agent activity summary.

Suggested properties:

- `session_id`
- `started_at`
- `ended_at`
- `summary`

### Relationship types

- `(:Page)-[:MENTIONS]->(:Entity)`
- `(:Page)-[:CONTAINS]->(:Fact)`
- `(:Fact)-[:SUPPORTED_BY]->(:Source)`
- `(:Fact)-[:ABOUT]->(:Entity)`
- `(:Fact)-[:SUPERSEDES]->(:Fact)`
- `(:Fact)-[:CONTRADICTS]->(:Fact)`
- `(:Entity)-[:DEPENDS_ON]->(:Entity)`
- `(:Entity)-[:USES]->(:Entity)`
- `(:Observation)-[:DERIVED_FROM]->(:Source)`
- `(:Observation)-[:PROPOSES]->(:Fact)`
- `(:Session)-[:TOUCHED]->(:Page)`
- `(:Session)-[:GENERATED]->(:Observation)`

## Vector Search Strategy

Neo4j should be used for semantic retrieval in addition to graph traversal.

Initial embedding targets:

- `Page` summaries
- `Fact` text
- selected `Entity` descriptions

Initial query flow:

1. Embed the user query
2. Run vector search against `Page` and `Fact`
3. Expand to neighboring entities, supporting sources, and superseding facts
4. Rank final context using a blend of similarity, confidence, freshness, and graph distance

This keeps vector search grounded in the graph instead of returning isolated chunks.

## Sync Model

### Markdown to graph

Initial sync job should:

1. Read frontmatter from every page
2. Create or update `Page` nodes
3. Parse wiki-links and markdown links
4. Create basic `MENTIONS` and page-to-page relationship hints
5. Extract candidate facts conservatively
6. Attach sources from frontmatter or inline references

### Graph to markdown

Phase 1 should avoid fully automatic graph-to-markdown generation.

Instead, graph analysis should create:

- contradiction reports
- stale-content reports
- proposed page updates
- possible new digest pages

Humans or agents can then review and apply those changes in git.

## Ingest Pipeline

Proposed ingest stages:

1. `Capture`
   - register source metadata
   - store retrieval timestamp
2. `Extract`
   - identify entities, claims, and relationships
3. `Normalize`
   - deduplicate entities
   - map aliases
4. `Link`
   - attach claims to pages, entities, and sources
5. `Embed`
   - generate vectors for pages/facts/entities
6. `Consolidate`
   - propose markdown updates
   - mark contradictions or supersessions

## Automation Opportunities

After the Neo4j layer exists, the repo can add automation in `.claude/` for:

- session-end summaries into `Session` and `Observation`
- post-ingest contradiction scans
- stale-page checks using `last_updated` plus source freshness
- page-write validation for missing sources or weak confidence
- digest creation for repeated query patterns

These should start as report-only automations before becoming write-capable.

## Claude Configuration Strategy

The wiki guidance in `index.md`, `pages/claude-md-conventions.md`, and `pages/claude-code-hooks.md` suggests a clear structure for Claude configuration in this repo:

- keep shared, reviewable automation in `.claude/settings.json`
- keep personal or machine-specific settings in `.claude/settings.local.json`
- keep larger behaviors in single-purpose scripts under `.claude/hooks/`
- keep instruction content in `CLAUDE.md` or `.claude/rules/*.md`, not in settings JSON

This matters for the Neo4j rollout because the automation layer will likely grow beyond a small inline JSON file.

### Recommended role for `.claude/settings.local.json`

This file should remain narrowly scoped to:

- personal permission allowances
- local-only endpoints or credentials
- machine-specific hook overrides
- experimentation that should not be committed yet

It should not become the main place where repo automation logic lives.

### Recommended role for `.claude/settings.json`

When the graph work becomes real, shared repo automation should move into `.claude/settings.json` so it is:

- version controlled
- visible in code review
- consistent across contributors
- easier to document and debug

### Recommended structure for settings files

Use a small top-level structure and avoid long inline shell commands where possible:

```json
{
  "permissions": {
    "allow": []
  },
  "hooks": {
    "SessionEnd": [],
    "PostToolUse": [],
    "ConfigChange": []
  }
}
```

Practical guidance:

- group hooks by event, not by feature name
- keep each hook handler focused on one job
- prefer calling checked-in scripts rather than embedding large commands inline
- use `async: true` for logging/reporting tasks that should not block
- use `PreToolUse` only for real guardrails
- use `PostToolUse` and `SessionEnd` first for graph-sync and report generation

### Recommended script layout

As automation grows, prefer this structure:

```text
/.claude/
  settings.json
  settings.local.json
  hooks/
    session-summary.ps1
    graph-sync.ps1
    contradiction-report.ps1
    config-guard.ps1
```

This matches the hook guidance in the wiki and keeps logic out of JSON blobs.

### Recommended rollout for this repo

#### Phase A: keep local settings minimal

Continue using `.claude/settings.local.json` mainly for local permissions, as it is used today.

#### Phase B: add shared hooks only when scripts exist

When the first Neo4j scripts are added, introduce `.claude/settings.json` with shared hooks that call repo scripts.

Example responsibilities:

- `SessionEnd` → write session summary or observation candidate
- `PostToolUse` on write/edit events → trigger a lightweight graph-sync report
- `ConfigChange` → warn when Claude config changes affect repo automation

#### Phase C: separate instructions from automation

Keep project instructions in `CLAUDE.md` and, if needed, `.claude/rules/`.

Do not encode architecture guidance, workflow policy, or documentation standards inside settings JSON.

## Security Implications For This Repo

The current wiki has relevant security guidance in `pages/security-scanning.md`, `pages/nodejs-patterns.md`, and `pages/cicd-github-actions.md`.

Those recommendations should shape the Neo4j rollout in this repo as follows:

### Secrets and local development

- do not commit Neo4j credentials into repo config, scripts, or docs
- keep local credentials in environment variables or local-only Claude settings
- add Neo4j-related secret patterns to `.gitleaks.toml` only if we encounter false negatives during implementation
- keep generated reports and debug outputs out of version control if they may contain credentials or query output

### CI and automation security

- shared automation should run in GitHub Actions with least-privilege permissions
- prefer short-lived auth and environment injection over checked-in config files with credentials
- if cloud-hosted Neo4j is introduced later, CI should use repo secrets and minimal-scoped credentials
- treat graph sync and ingest scripts as privileged code because they can read project content and external sources

### Application-layer safety

If this repo grows a local service for ingest or querying, it should follow the Node.js guidance already in the wiki:

- validate config at startup
- use structured logging
- separate route, service, and data-access responsibilities
- do not leak internal errors or stack traces in responses
- add health endpoints if a persistent service is introduced

## Testing Strategy For Neo4j Work

The current wiki's testing guidance is relevant even though this repo does not yet have an application test harness.

The rollout should add tests in this order:

### 1. Sync unit tests

Test markdown parsing and graph-mapping logic in isolation:

- frontmatter extraction
- wiki-link extraction
- source extraction
- entity normalization
- fact extraction heuristics

These should be deterministic fixture-based tests.

### 2. Integration tests for graph writes

Test sync scripts against a disposable local Neo4j instance:

- constraints apply successfully
- page sync is idempotent
- re-sync updates changed pages correctly
- relationships are created without duplication

### 3. Query tests

Test graph retrieval behavior:

- exact path/title lookups
- entity traversal
- contradiction and supersession expansion
- ranking behavior for hybrid retrieval once embeddings exist

### 4. CI verification

When script-based implementation begins, CI should run:

- lint
- unit tests
- integration tests against local Neo4j or a containerized service

This aligns with the wiki's recommendation to keep validation and deployment separate and to run test commands in CI on every PR.

## Database Design Notes

The current wiki does not yet contain a dedicated database-design page, so this repo-specific plan should treat database design as an open area that needs explicit follow-up research.

For now, the repo should prefer a conservative graph model:

- small set of node labels
- small set of relationship types
- unique constraints for stable IDs
- reproducible sync from markdown
- idempotent writes

Early schema choices should optimize for:

- clarity over cleverness
- rebuildability from repo content
- easy querying during debugging
- safe future expansion to fact-level and vector-indexed retrieval

This is one of the areas where the wiki still needs more source-backed guidance, so follow-on questions have been added under `project-planning/`.

## Suggested Repository Additions

These paths are likely useful in later phases:

```text
/plans/
  neo4j-design-plan.md
/.claude/
  settings.json
  hooks/
    session-summary.ps1
    graph-sync.ps1
    contradiction-report.ps1
    config-guard.ps1
/scripts/
  sync-pages-to-neo4j.js
  ingest-source.js
  lint-graph.js
  query-graph.js
/neo4j/
  schema.cypher
  constraints.cypher
  seed.cypher
/aura/
  README.md
  provision.ps1
  apply-schema.ps1
/tmp/
  reports/
```

## Suggested Neo4j Constraints

Examples:

- unique `Page.path`
- unique `Entity.entity_id`
- unique `Fact.fact_id`
- unique `Source.source_id`
- unique `Observation.observation_id`
- unique `Session.session_id`

## Phased Implementation Plan

### Phase 1: Foundation

- choose local Neo4j runtime approach
- define labels, relationships, and constraints
- create `schema.cypher`
- build markdown-to-page sync only
- define secret-handling and local-env conventions before adding any DB connection code
- add fixture-based tests for markdown parsing and page-node sync
- keep connection handling compatible with both local Neo4j and future Aura targets

### Phase 2: Relationship extraction

- parse wiki-links and sources
- create `MENTIONS`, `CONTAINS`, and `SUPPORTED_BY`
- add entity normalization rules
- add integration tests against disposable Neo4j
- verify sync remains idempotent under repeated runs

### Phase 3: Facts and quality checks

- store fact nodes
- add contradiction and supersession relationships
- build graph lint reports
- add test fixtures for contradiction and supersession scenarios

### Phase 4: Vector retrieval

- add embeddings
- create vector indexes
- build hybrid query flow for agents
- add retrieval-quality tests before relying on semantic ranking in workflows

### Phase 5: Automation

- wire Claude hooks or scripts for ingest and session crystallization
- generate digests and proposed updates
- move shared automation into `.claude/settings.json`
- keep `.claude/settings.local.json` limited to personal overrides and local permissions
- add CI jobs for graph lint, sync verification, and automated tests
- introduce Aura CLI-based operational scripts only after the local workflow is stable

## Operational Considerations

### Local development

Preferred starting point:

- local Neo4j via Docker Desktop or Neo4j Desktop
- scripts run from this repo against a local instance

This avoids early cloud cost and operational overhead.

### Hosted progression

The intended progression for this repo is:

1. start with local Neo4j for schema design, sync development, and test iteration
2. move to Neo4j Aura only after the local scripts and graph model are stable

This keeps early development fast and low-risk while preserving a path to a managed hosted environment later.

### CLI operations model

Both stages should remain CLI-runnable.

For local development:

- run Neo4j locally
- execute schema, sync, lint, and query scripts from this repository
- use local environment variables for connection details

For hosted Aura:

- use Aura CLI for instance-level operations
- use `cypher-shell` or language drivers for database-level operations
- continue using the same repo-local sync, lint, and query scripts with different connection settings

Practical rule:

- Aura CLI manages the hosted environment
- `cypher-shell` and application drivers manage the graph contents

This allows the repo to keep one operational model while changing only the connection target.

### Change review

Graph updates should be reproducible from repo content wherever possible.

That means:

- schema lives in version control
- sync scripts live in version control
- generated reports can be committed when useful
- opaque manual DB edits should be avoided

### Backup and recoverability

In early phases, the graph should be treated as rebuildable from:

- markdown pages
- source registry
- sync scripts

That makes experimentation safer.

## Risks

- extracting low-quality facts too early creates noisy graph data
- dual sources of truth can drift if sync rules are vague
- vector search may feel impressive before it is actually useful
- graph complexity may outpace the repo’s current size

## Open Questions

- Should facts become canonical later, or stay derived from pages?
- How much of ingest should be automatic vs review-gated?
- Should private observations live in the same graph with scope tags, or a separate local-only database?
- Do we want graph writes only from scripts, or also from Claude hooks directly?

## Recommendation

Start small:

1. Keep markdown canonical for authoring.
2. Add Neo4j only for `Page`, `Entity`, and basic relationships first.
3. Delay fact extraction until page/entity sync is stable.
4. Add vector retrieval only after graph queries are already useful.
5. Start locally and move to Aura only after the local workflow is proven.

This gives the repo a real structured foundation without losing the simplicity that makes the current wiki easy to use.
