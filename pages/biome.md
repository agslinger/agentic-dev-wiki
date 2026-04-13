---
title: Biome
type: tool
status: draft
confidence: 84
tags: [linting, formatting, javascript, typescript]
last-updated: 2026-04-12
sources:
  - "Biome getting started: https://biomejs.dev/guides/getting-started/"
  - "Biome formatter docs: https://biomejs.dev/formatter"
  - "Biome linter docs: https://biomejs.dev/linter"
---

# Biome

## Read This When

- Choosing a combined formatter and linter
- Deciding whether to replace or avoid the ESLint + Prettier split

## Default Recommendation

- Use Biome when the team wants one tool for formatting, linting, and import organization.
- Pin the Biome version in the project.

## Use This Pattern

Biome docs describe it as a formatter, linter, and CLI that can run with little or no configuration. The formatter is intentionally opinionated, and the linter is designed to find and fix common errors.

Use Biome when:

- the team wants fewer tools to manage
- formatting and linting should share one CLI and config file
- fast bootstrap matters more than fine-grained tool composition

## Commands / Config

```bash
npm i -D -E @biomejs/biome
npx @biomejs/biome init
npx @biomejs/biome check --write
```

In CI, Biome docs recommend `biome ci`.

## Pitfalls

- Do not mix Biome with overlapping formatter/linter tools without a clear boundary.
- Biome is opinionated; adopt it because the team wants that, not because it supports every preference.
- Pin the version to reduce formatting drift.

## Related Pages

- [typescript-strict-mode](typescript-strict-mode.md)
- [react-tailwind-shadcn-ui](react-tailwind-shadcn-ui.md)
