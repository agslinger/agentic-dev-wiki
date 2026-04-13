---
title: Linting and Formatting Setup
type: pattern
status: draft
confidence: 82
tags: [nodejs, linting, eslint, prettier, formatting]
last-updated: 2026-04-12
sources:
  - "ESLint flat config docs: https://eslint.org/docs/latest/use/configure/configuration-files"
  - "Prettier options docs: https://prettier.io/docs/options"
  - "eslint-config-prettier README: https://github.com/prettier/eslint-config-prettier"
  - "Husky get-started: https://typicode.github.io/husky/get-started.html"
---

# Linting and Formatting Setup

## Read This When

- Adding JS/Node code quality tooling
- Choosing ESLint vs Prettier responsibilities
- Wiring pre-commit formatting

## Default Recommendation

- Use ESLint flat config.
- Use Prettier for formatting only.
- Add `eslint-config-prettier` last.
- Run lint and format before commit with Husky and lint-staged.

## Use This Pattern

Install:

```bash
npm install --save-dev eslint @eslint/js prettier eslint-config-prettier eslint-plugin-n husky lint-staged
```

Minimal ESLint config:

```js
import js from '@eslint/js';
import pluginN from 'eslint-plugin-n';
import prettierConfig from 'eslint-config-prettier';

export default [
  js.configs.recommended,
  pluginN.configs['flat/recommended'],
  prettierConfig,
];
```

Suggested scripts:

```json
{
  "scripts": {
    "lint": "eslint .",
    "lint:fix": "eslint . --fix",
    "format": "prettier . --write",
    "format:check": "prettier . --check"
  }
}
```

Pre-commit pattern:

- `lint-staged` for changed files only
- Husky pre-commit hook runs lint/format tasks

## Commands / Config

Useful defaults:

- `sourceType: "module"` for ESM projects
- ignore `dist/`, `coverage/`, `node_modules/`
- keep `eslint-config-prettier` last

## Pitfalls

- Do not make ESLint own formatting.
- Do not run full-repo format on every commit when lint-staged is enough.
- Do not mix legacy `.eslintrc` guidance with flat config defaults.

## Related Pages

- [biome](biome.md) — single-tool alternative to ESLint + Prettier
- [nodejs-patterns](nodejs-patterns.md)
- [testing-setup](testing-setup.md)
- [claude-code-hooks](claude-code-hooks.md)
