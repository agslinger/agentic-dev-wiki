---
title: Linting and Formatting Setup
type: pattern
status: stub
confidence: 15
tags: [nodejs, linting, eslint, prettier, formatting]
last-updated: 2026-04-12
sources: []
---

# Linting and Formatting Setup

> **Status: stub** — needs Ingest from ESLint and Prettier docs and community configs.

## What to research / fill in

- [ ] ESLint flat config (`eslint.config.js`) vs legacy `.eslintrc` — flat config is current standard
- [ ] Recommended ESLint rule sets: `eslint:recommended`, `@eslint/js`, security plugins
- [ ] Prettier vs ESLint formatting rules — why to use both and how they coexist
- [ ] `eslint-config-prettier` — disables ESLint rules that conflict with Prettier
- [ ] Editor integration: `.editorconfig` as baseline
- [ ] Pre-commit hook: run `eslint --fix` and `prettier --write` before commit
- [ ] CI: fail on lint errors (don't auto-fix in CI)
- [ ] `package.json` scripts: `lint`, `lint:fix`, `format`, `format:check`
- [ ] Node.js security linting: `eslint-plugin-security`
- [ ] Import ordering: `eslint-plugin-import` or `eslint-plugin-simple-import-sort`

## Known Gap (IaC-test-app)

IaC-test-app has **no linting or formatting** — only `"use strict"` convention enforced by the agent instructions.

## Suggested Minimal Setup

```bash
npm install --save-dev eslint prettier eslint-config-prettier
```

```js
// eslint.config.js (flat config)
import js from "@eslint/js";
import prettierConfig from "eslint-config-prettier";

export default [
  js.configs.recommended,
  prettierConfig,
  {
    rules: {
      "no-unused-vars": "warn",
      "no-console": "off"
    }
  }
];
```

```json
// .prettierrc
{
  "semi": true,
  "singleQuote": false,
  "trailingComma": "es5",
  "printWidth": 100
}
```

## Sources to Ingest

- ESLint flat config docs: https://eslint.org/docs/latest/use/configure/configuration-files
- Prettier docs: https://prettier.io/docs/en/
- eslint-config-prettier: https://github.com/prettier/eslint-config-prettier
