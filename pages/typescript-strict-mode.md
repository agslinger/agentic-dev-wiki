---
title: TypeScript Strict Mode
type: pattern
status: draft
confidence: 84
tags: [typescript, javascript]
last-updated: 2026-04-12
sources:
  - "TypeScript strict docs: https://www.typescriptlang.org/tsconfig/strict.html"
  - "TypeScript TSConfig reference: https://www.typescriptlang.org/tsconfig"
  - "Zod intro: https://zod.dev/"
---

# TypeScript Strict Mode

## Read This When

- Choosing TypeScript defaults for a new app
- Deciding whether strict mode is worth the extra friction
- Pairing TypeScript with Zod, Drizzle, and AI output validation

## Default Recommendation

- Enable `strict: true` for new TypeScript apps.
- Treat strict mode as the default, then disable individual checks only if there is a concrete reason.
- Use strict mode especially when the stack relies on schema validation, database typing, and AI-generated structured data.

## Use This Pattern

TypeScript docs say `strict` enables the full strict-mode family of checks and is recommended. It improves guarantees of program correctness, though future TypeScript upgrades can surface new type errors.

This fits the wider stack well because:

- `Zod` explicitly recommends TypeScript strict mode
- `Drizzle` benefits from strong inferred database types
- AI outputs validated with `Zod` are easier to use safely when the rest of the app is strictly typed

## Commands / Config

```json
{
  "compilerOptions": {
    "strict": true
  }
}
```

## Pitfalls

- Do not start with loose typing and hope to tighten it later.
- Do not disable strict mode globally just to silence a few problem areas.
- Expect occasional new errors when upgrading TypeScript, because stricter checks can expand over time.

## Related Pages

- [zod-4-validation](zod-4-validation.md)
- [drizzle-orm](drizzle-orm.md)
- [vercel-ai-sdk](vercel-ai-sdk.md)
