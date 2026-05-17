---
title: Pinecone Retrieval
type: tool
status: draft
confidence: 70
tags: [typescript, ai-agent, llm]
last-updated: 2026-05-17
sources:
  - "Pinecone full-text search docs: https://docs.pinecone.io/guides/search/full-text-search"
  - "Pinecone local development docs: https://docs.pinecone.io/guides/operations/local-development"
  - "Pinecone dedicated read nodes docs: https://docs.pinecone.io/guides/index-data/dedicated-read-nodes"
  - "Pinecone full-text search announcement: https://www.pinecone.io/blog/full-text-search/"
  - "Pinecone Nexus announcement: https://www.pinecone.io/blog/knowledge-infrastructure-for-agents/"
  - "Pinecone Builder plan: https://www.pinecone.io/blog/builder-plan/"
  - "Pinecone BYOC: https://www.pinecone.io/blog/byoc/"
---

# Pinecone Retrieval

## Read This When

- Postgres + `pgvector` is no longer enough for retrieval operations
- You need managed vector, hybrid, sparse, or full-text retrieval capacity
- You are evaluating Pinecone for agent knowledge infrastructure

## Default Recommendation

- Use Postgres + `pgvector` first for small and medium apps.
- Use Pinecone when managed retrieval scale, isolation, latency, or operations outweigh single-store simplicity.
- Use [composable-data-storage](composable-data-storage.md) for the broader store-selection decision.
- Treat Pinecone full-text document-schema indexes as preview-era unless the current docs say otherwise.
- Keep source records and reindex jobs outside Pinecone so retrieval indexes remain rebuildable.

## Use This Pattern

Pinecone is attractive when:

- vector data is large enough to strain Postgres operations
- high-QPS retrieval needs predictable latency
- tenant isolation or managed capacity matters
- hybrid dense/sparse/text retrieval is central to the product
- the team wants a retrieval service rather than database extension ownership

Keep Postgres first when:

- relational filters and transactions dominate
- retrieval volume is modest
- local development and CI simplicity matter most
- the team is still proving the product shape

### Current capability notes

As of 2026-05-17:

- Pinecone document-schema indexes can combine text, dense vector, sparse vector, and metadata fields.
- Full-text search uses BM25/Lucene-style text search over declared fields.
- Search chooses a ranking signal per request.
- Schema migration is not yet supported for full-text document-schema indexes.
- Pinecone Local is Docker-only, in-memory, and not production-suitable.
- Dedicated Read Nodes are GA for predictable high-throughput reads.
- BYOC and newer knowledge-engine features should be treated as fast-moving product areas.

## Commands / Config

Architecture rules:

- Store canonical documents in Postgres, Git, or object storage.
- Store source version/checksum beside every vector or document record.
- Rebuild indexes from source when schema, chunking, or embedding model changes.
- Keep retrieval telemetry: query, filters, scores, selected sources, and answer ID.

Testing rule:

- Use Pinecone Local for client integration tests only when its limitations match the feature under test.
- Use contract tests around your own retrieval interface so Pinecone can be swapped or mocked.

## Pitfalls

- Do not move to Pinecone just because embeddings exist.
- Do not depend on preview features for production-critical schema flexibility.
- Do not lose exact-match retrieval; vector search alone misses identifiers and citations.
- Do not let Pinecone become the only copy of source content.
- Do not skip tenant and permission filtering before ranking.

## Related Pages

- [composable-data-storage](composable-data-storage.md)
- [postgres-pgvector](postgres-pgvector.md)
- [openai-model-selection](openai-model-selection.md)
- [document-parsing-stack](document-parsing-stack.md)
