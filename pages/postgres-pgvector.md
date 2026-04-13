---
title: PostgreSQL + pgvector
type: pattern
status: draft
confidence: 82
tags: [typescript]
last-updated: 2026-04-12
sources:
  - "pgvector GitHub org: https://github.com/pgvector"
  - "pgvector repo: https://github.com/pgvector/pgvector"
  - "pgvector setup for GitHub Actions: https://github.com/pgvector/setup-pgvector"
---

# PostgreSQL + pgvector

## Read This When

- Choosing the main database for structured data plus vector search
- Deciding whether relational data and embeddings should live together

## Default Recommendation

- Use PostgreSQL as the primary database when the app needs strong relational modeling.
- Add `pgvector` when semantic search or embedding similarity should live in the same database.

## Use This Pattern

`pgvector` adds vector similarity search to Postgres. The project docs show vector columns, nearest-neighbor queries, multiple distance functions, and extension setup patterns.

This stack works well when:

- relational data remains the core model
- embeddings are an enhancement, not a separate retrieval system
- the team wants one operational data store instead of a separate vector database

It pairs well with:

- `Drizzle ORM` for typed relational access
- `text-embedding-3-small` for embedding generation

## Commands / Config

Common pgvector usage patterns:

- add a `vector(n)` column
- store embeddings alongside relational entities
- query nearest neighbors with vector distance operators

## Pitfalls

- Do not add vectors before the app actually needs semantic retrieval.
- Do not separate structured metadata from embeddings unless scale or operations truly require it.
- CI and local dev need explicit pgvector setup, not just plain Postgres.

## Related Pages

- [drizzle-orm](drizzle-orm.md)
- [openai-model-selection](openai-model-selection.md)
- [vercel-ai-sdk](vercel-ai-sdk.md)
