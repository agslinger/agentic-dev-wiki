# Follow-on Questions

This file tracks source and research questions that emerged while planning the Neo4j evolution of this repository.

It exists because some implementation areas are not yet covered well enough by the current wiki pages.

## Database Design

- What is the best initial Neo4j schema for a markdown-first wiki: `Page` plus `Entity` only, or `Page` plus `Entity` plus `Fact` from the start?
- Which properties should be indexed immediately versus added later?
- What is the best stable-ID strategy for `Fact`, `Entity`, and `Observation` nodes?
- How should idempotent upserts be implemented for repeated markdown sync runs?
- Should page-to-page links be modeled directly, or always mediated through entities/facts?
- How should contradictions be represented: symmetric `CONTRADICTS` edges, directed disputes, or contradiction groups?
- How should supersession be modeled when one new fact replaces several old facts?

## Neo4j Operations

- Which local runtime should be the default for this repo: Neo4j Desktop or Docker-based workflow?
- What is the smallest reproducible CI setup for running Neo4j-backed integration tests?
- What are the recommended constraint and index patterns for a small-to-medium knowledge graph in Neo4j?
- What backup/export strategy should be used if the graph becomes more than a rebuildable cache?
- What is the cleanest migration path from local Neo4j to Aura while keeping the same repo scripts?
- Which operations should be handled by Aura CLI versus `cypher-shell` in this repo?

## Vector Search

- What should be embedded first: whole pages, summaries, facts, entities, or some mix?
- What dimensions and embedding model are most appropriate for this wiki's content?
- How should hybrid ranking combine similarity, confidence, freshness, and graph distance?
- When should vector search be introduced, given the current wiki size?

## Security

- What are the recommended practices for storing and rotating Neo4j credentials in local development and CI?
- Do Neo4j connection strings, auth tokens, or generated query logs require additional Gitleaks rules?
- If a local or hosted Neo4j service is added, what network and auth hardening guidance should be applied?

## Testing

- What is the most reliable strategy for fixture-based Neo4j integration tests in Node.js?
- Should integration tests run against an actual Neo4j container, or should some graph behavior be mocked?
- What minimal test dataset should be checked into the repo to validate sync and retrieval behavior?
- How should retrieval quality be evaluated once vector search is added?

## Ingest And Automation

- Which parts of entity extraction and fact extraction should be deterministic rules versus LLM-assisted steps?
- What confidence thresholds should gate automatic graph writes versus review-required proposals?
- Should session summaries and observations be stored in the same graph as shared wiki knowledge, or in a separate local-only scope?
- Which Claude hook events are safest to use first for graph-related automation in this repo?
