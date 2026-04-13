---
title: OpenAI Model Selection
type: pattern
status: draft
confidence: 82
tags: [nodejs, typescript]
last-updated: 2026-04-12
sources:
  - "OpenAI models overview: https://platform.openai.com/docs/models"
  - "GPT-4o: https://platform.openai.com/docs/models/gpt-4o"
  - "GPT-4o mini: https://developers.openai.com/api/docs/models/gpt-4o-mini"
  - "Embeddings guide: https://platform.openai.com/docs/guides/embeddings/embedding-models"
  - "text-embedding-3-small: https://platform.openai.com/docs/models/text-embedding-3-small"
---

# OpenAI Model Selection

## Read This When

- Choosing OpenAI models for extraction, synthesis, or embeddings
- Splitting cheap metadata work from more expensive reasoning work

## Default Recommendation

- Use `gpt-4o-mini` for lightweight extraction and metadata tasks.
- Use `gpt-4o` for higher-quality synthesis when richer reasoning or multimodal input matters.
- Use `text-embedding-3-small` for low-cost semantic search embeddings.

## Use This Pattern

OpenAI docs position:

- `gpt-4o` as a versatile, high-intelligence flagship model with text and image input support
- `gpt-4o-mini` as a cheaper small model for well-defined tasks
- `text-embedding-3-small` as a low-cost embeddings model for similarity, search, clustering, and recommendations

This stack fit is strong because:

- metadata extraction often benefits from cheaper fast models
- synthesis benefits from stronger reasoning and multimodal handling
- embeddings pair naturally with `PostgreSQL + pgvector`

## Commands / Config

Use model splits deliberately:

- extraction and lightweight enrichment -> `gpt-4o-mini`
- synthesis and richer interpretation -> `gpt-4o`
- semantic indexing -> `text-embedding-3-small`

## Pitfalls

- Do not use one model for all stages if cost and quality requirements differ.
- Do not create embeddings before retrieval use cases are defined.
- Keep embedding dimension and storage assumptions aligned with the database schema.

## Related Pages

- [postgres-pgvector](postgres-pgvector.md)
- [vercel-ai-sdk](vercel-ai-sdk.md)
- [claude-bedrock-models](claude-bedrock-models.md)
