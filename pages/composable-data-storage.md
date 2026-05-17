---
title: Composable Data Storage
type: concept
status: draft
confidence: 72
tags: [typescript, ai-agent, llm]
last-updated: 2026-05-17
sources:
  - "pgvector: https://github.com/pgvector/pgvector"
  - "Apache AGE: https://age.apache.org/"
  - "Postgres full text search: https://www.postgresql.org/docs/current/textsearch.html"
  - "Pinecone full-text search: https://docs.pinecone.io/guides/search/full-text-search"
---

# Composable Data Storage

## Read This When

- Choosing between SQL, full-text, vector, graph, Git, and object storage
- Designing RAG or knowledge systems that need more than one query shape
- Deciding whether Postgres is enough before adding Pinecone or Neo4j

## Default Recommendation

- Start with one operational store, usually PostgreSQL.
- Add `pgvector` only when semantic retrieval is needed.
- Add full-text search before assuming embeddings solve exact-match retrieval.
- Model graph edges in SQL first.
- Add specialized stores only after the query pressure is proven.
- Keep every derived index rebuildable from source-of-truth data.

## Use This Pattern

### Storage roles

| Shape | Use for |
|---|---|
| SQL | entities, permissions, transactions, filters |
| Full-text / BM25 | names, IDs, error codes, citations, exact terms |
| Vector | semantic similarity and fuzzy intent |
| Graph edges | provenance, dependencies, multi-hop relationships |
| Git / Markdown | human-authored knowledge with reviewable history |
| Object storage | large binaries, raw source snapshots, generated exports |

### Query routing

- Exact identifier? Use SQL or full-text first.
- Natural-language similarity? Use vector search, then metadata filters.
- Multi-hop or dependency question? Seed with vector/full-text, then expand edges.
- Tenant or permission question? Enforce SQL filters before ranking.
- Auditable answer? Return source IDs, edge paths, and chunk citations.

### Scaling path

1. One Postgres database: relational tables, FTS, `pgvector`, edge tables.
2. Operational separation: read replicas, materialized views, ingestion jobs, embedding queue.
3. Specialist stores: Pinecone for managed retrieval scale, Neo4j for deep graph traversal, object storage for large artifacts.

## Commands / Config

Minimal data families:

- canonical records
- searchable text units
- extracted entities
- relationship edges
- embedding records
- retrieval telemetry

Source-of-truth rule:

- Postgres can be the authority for app entities.
- Git/Markdown can be the authority for human-authored knowledge.
- Embeddings, search indexes, and graph exports are derived unless explicitly modeled otherwise.
- For Markdown-specific serving tables, use [markdown-knowledge-webapp-architecture](markdown-knowledge-webapp-architecture.md).

## Pitfalls

- Do not split SQL and vector stores before synchronization cost is justified.
- Do not use vector-only retrieval for exact identifiers or citations.
- Do not use graph-only retrieval for fuzzy discovery.
- Do not let a derived index become the hidden source of truth.
- Multi-store systems need explicit rebuild and reconciliation rules.

## Related Pages

- [postgres-pgvector](postgres-pgvector.md)
- [markdown-knowledge-webapp-architecture](markdown-knowledge-webapp-architecture.md)
- [pinecone-retrieval](pinecone-retrieval.md)
- [drizzle-orm](drizzle-orm.md)
