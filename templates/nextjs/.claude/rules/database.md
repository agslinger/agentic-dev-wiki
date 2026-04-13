---
paths:
  - "db/**/*.ts"
  - "drizzle.config.ts"
---

# Database Rules

- Start with the simplest schema or query path that proves the workflow works.
- Prove one read or write path end to end before broadening the data model.
- Define schema in `db/` with Drizzle.
- Generate new migrations for schema changes; do not rewrite existing migrations.
- Keep pgvector setup and indexes in migrations, not application code.
- Do not run migrations without explicit approval.
