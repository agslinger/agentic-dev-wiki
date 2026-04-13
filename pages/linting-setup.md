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

> **Status: draft** — sourced from ESLint and Prettier official docs (April 2026).

---

## The two tools and why you need both

| Tool | Role |
|---|---|
| **ESLint** | Catches code errors, enforces code quality rules (unused vars, no-undef, etc.) |
| **Prettier** | Enforces consistent formatting (indentation, quotes, semicolons, line length) |

**Use both:** ESLint for correctness/quality, Prettier for style. ESLint should not own formatting — use `eslint-config-prettier` to disable the ESLint rules that conflict with Prettier. The tools then have non-overlapping responsibilities.

---

## Install

```bash
npm install --save-dev eslint @eslint/js prettier eslint-config-prettier
```

For Node.js-specific rules:

```bash
npm install --save-dev eslint-plugin-n           # Node.js-specific rules
npm install --save-dev eslint-plugin-security    # security rules (optional)
```

---

## ESLint flat config (`eslint.config.js`)

Flat config is the **current standard** as of ESLint v9. It replaces the legacy `.eslintrc` format.

### Key differences from legacy `.eslintrc`

- Uses a JavaScript file (`eslint.config.js`) instead of JSON/YAML
- Exports an **array** of config objects (not a single object)
- Plugins are referenced as direct object imports (no string-based names)
- File matching via explicit `files` glob patterns
- Better cascading: multiple objects matching the same file are **merged** (later objects override earlier)

### Minimal setup

```js
// eslint.config.js
import js from '@eslint/js';
import prettierConfig from 'eslint-config-prettier';

export default [
  // 1. ESLint recommended rules
  js.configs.recommended,

  // 2. Prettier: disables ESLint rules that conflict with Prettier formatting
  prettierConfig,

  // 3. Your project-specific overrides
  {
    rules: {
      'no-unused-vars': 'warn',
      'no-console': 'off',
    },
  },
];
```

### With Node.js plugin

```js
// eslint.config.js
import js from '@eslint/js';
import pluginN from 'eslint-plugin-n';
import prettierConfig from 'eslint-config-prettier';

export default [
  js.configs.recommended,
  pluginN.configs['flat/recommended'],   // Node.js-specific rules
  prettierConfig,
  {
    languageOptions: {
      ecmaVersion: 2022,
      sourceType: 'module',              // or 'commonjs' for CJS projects
    },
    rules: {
      'no-unused-vars': 'warn',
      'n/no-unsupported-features/es-syntax': ['error', { version: '>=20.0.0' }],
    },
  },
];
```

### Ignoring files

```js
// eslint.config.js — global ignores (no other properties = global ignore)
export default [
  {
    ignores: ['dist/', 'coverage/', 'node_modules/', '*.min.js'],
  },
  // ... rest of config
];
```

### TypeScript support

```bash
npm install --save-dev typescript-eslint
```

```js
import tseslint from 'typescript-eslint';

export default tseslint.config(
  js.configs.recommended,
  ...tseslint.configs.recommended,
  prettierConfig,
);
```

For TypeScript config files (`eslint.config.ts`), install `jiti`:

```bash
npm install --save-dev jiti
```

---

## Prettier configuration (`.prettierrc`)

```json
{
  "printWidth": 100,
  "tabWidth": 2,
  "useTabs": false,
  "semi": true,
  "singleQuote": true,
  "trailingComma": "es5",
  "bracketSpacing": true,
  "arrowParens": "always"
}
```

### Option reference

| Option | Default | Notes |
|---|---|---|
| `printWidth` | `80` | Soft limit — not a hard column cap |
| `tabWidth` | `2` | Spaces per indent level |
| `useTabs` | `false` | Set `true` for tabs |
| `semi` | `true` | Semicolons at end of statements |
| `singleQuote` | `false` | Use `true` for single quotes |
| `trailingComma` | `"all"` (v3+) | `"es5"` for safer compat; `"all"` requires ES2017+ |
| `bracketSpacing` | `true` | Spaces inside `{ a: 1 }` object literals |
| `arrowParens` | `"always"` | `(x) =>` vs `x =>` |

> **Note:** In Prettier v3.0.0, `trailingComma` default changed from `"es5"` to `"all"`. If targeting older runtimes, set `"es5"` explicitly.

### Ignoring files (`.prettierignore`)

```
dist/
coverage/
node_modules/
*.min.js
package-lock.json
```

---

## package.json scripts

```json
{
  "scripts": {
    "lint": "eslint .",
    "lint:fix": "eslint . --fix",
    "format": "prettier --write .",
    "format:check": "prettier --check ."
  }
}
```

**Convention:**
- `lint` / `format:check` → read-only validation (use in CI)
- `lint:fix` / `format` → auto-fix (use locally before commit)

---

## Editor integration

### VS Code

Install extensions:
- `dbaeumer.vscode-eslint` — ESLint
- `esbenp.prettier-vscode` — Prettier

```json
// .vscode/settings.json
{
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": "explicit"
  }
}
```

### `.editorconfig` (baseline across editors)

```ini
root = true

[*]
indent_style = space
indent_size = 2
end_of_line = lf
charset = utf-8
trim_trailing_whitespace = true
insert_final_newline = true

[*.md]
trim_trailing_whitespace = false
```

---

## Pre-commit hook (Husky + lint-staged)

Run lint and format only on staged files before each commit.

### Install

```bash
npm install --save-dev husky lint-staged
```

### Initialize Husky

```bash
npx husky init
```

This creates `.husky/pre-commit` and adds the `prepare` script to `package.json`:

```json
{
  "scripts": {
    "prepare": "husky"
  }
}
```

The `prepare` script runs automatically on `npm install`, so new team members get hooks immediately.

### Directory structure

```
.husky/
├── pre-commit     ← runs before every commit
├── commit-msg     ← optional: validate commit message format
└── pre-push       ← optional: run tests before push
```

### Configure lint-staged

```json
// package.json
{
  "lint-staged": {
    "*.{js,mjs,cjs,ts}": [
      "eslint --fix",
      "prettier --write"
    ],
    "*.{json,md,yml,yaml}": [
      "prettier --write"
    ]
  }
}
```

### Pre-commit hook

```bash
# .husky/pre-commit
npx lint-staged
```

### Disable hooks temporarily

```bash
HUSKY=0 git commit -m "emergency fix"
```

### Key Husky facts

- Ultra-lightweight: 2 kB compressed, ~1 ms execution overhead, zero external dependencies
- Uses Git's native `core.hooksPath` feature
- Supports all 13 client-side Git hooks
- Compatible with monorepos, Node version managers (nvm, fnm), and Git GUIs
- Works on macOS, Linux, and Windows

---

## CI: fail on lint errors (do not auto-fix in CI)

In CI, run lint in check-only mode — never auto-fix. Auto-fixing in CI could silently mask real issues or produce inconsistent commits.

```yaml
# .github/workflows/ci.yml
- run: npm run lint           # ESLint — exits non-zero on errors
- run: npm run format:check   # Prettier -- exits non-zero if formatting differs
```

---

## Relationship between ESLint and Prettier

`eslint-config-prettier` disables all ESLint rules that conflict with Prettier's output. It must be **last** so it overrides all preceding rule sets.

### Flat config (current standard)

```js
// eslint.config.js — use the /flat entrypoint
import eslintConfigPrettier from 'eslint-config-prettier/flat';

export default [
  js.configs.recommended,
  pluginN.configs['flat/recommended'],
  eslintConfigPrettier,     // ← LAST: disables all formatting rules
  {
    rules: { /* your overrides — style rules only, never formatting */ }
  }
];
```

### Legacy config (for reference)

```json
{
  "extends": ["some-other-config", "prettier"]
}
```

### Special caveats

These rules need manual attention when using eslint-config-prettier:

| Rule | Issue |
|---|---|
| `arrow-body-style` | Can conflict with eslint-plugin-prettier's --fix |
| `prefer-arrow-callback` | Same issue as above |
| `curly` | Only safe without `"multi-line"` or `"multi-or-nest"` options |
| `max-len` | Prettier can't handle long strings/comments — keep rule off |

**Diagnostic:** Run `npx eslint-config-prettier path/to/file.js` to find any remaining conflicts in your config.

---

## Adding linting to an existing project

If a project has no linting or formatting yet, work through this in order:
1. `npm install --save-dev eslint @eslint/js prettier eslint-config-prettier eslint-plugin-n`
2. Create `eslint.config.js` (flat config) and `.prettierrc`
3. Add `lint`, `lint:fix`, `format`, `format:check` scripts to `package.json`
4. Add global ignores for `dist/`, `coverage/`, `node_modules/` in `eslint.config.js` and `.prettierignore`
5. `npm install --save-dev husky lint-staged && npx husky init` — wire up pre-commit
6. Add `npm run lint` and `npm run format:check` steps to the CI workflow
