---
title: Drizzle ORM
type: tool
status: draft
confidence: 84
tags: [typescript]
last-updated: 2026-04-12
sources:
  - "Drizzle overview: https://orm.drizzle.team/docs/overview"
  - "Drizzle RLS docs: https://orm.drizzle.team/docs/rls"
---

# Drizzle ORM

## Read This When

- Choosing the data access layer for a TypeScript app
- Deciding between a SQL-centric ORM and a heavier data framework

## Default Recommendation

- Use Drizzle when the team wants type-safe SQL access without giving up SQL thinking.
- Pair Drizzle with strict TypeScript and PostgreSQL.

## Use This Pattern

Drizzle describes itself as a headless TypeScript ORM that supports both SQL-like and relational query APIs. It also emphasizes lightweight, serverless-ready design.

This stack fit is strong because:

- `TypeScript strict mode` improves schema and query safety
- `PostgreSQL + pgvector` works naturally with SQL-first tooling
- `Zod` complements Drizzle for validating app and AI-layer data before it reaches typed queries

Use Drizzle when:

- the team is comfortable with SQL
- schema should live in TypeScript
- migrations and relational queries should stay close to the database model

## Commands / Config

Typical Drizzle use:

- define schema in TypeScript
- generate migrations
- query with SQL-like or relational APIs

## Pitfalls

- Do not choose Drizzle if the team wants a higher-level data framework that owns more of the application architecture.
- Do not weaken TypeScript settings when using Drizzle’s typed schema approach.

## Related Pages

- [typescript-strict-mode](typescript-strict-mode.md)
- [postgres-pgvector](postgres-pgvector.md)
- [zod-4-validation](zod-4-validation.md)
