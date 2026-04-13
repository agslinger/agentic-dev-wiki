---
title: Code Review Automation (CodeRabbit)
type: tool
status: draft
confidence: 72
tags: [cicd, github-actions, automation, ai-agent, code-review]
last-updated: 2026-04-12
sources:
  - "CodeRabbit configuration reference: https://docs.coderabbit.ai/reference/configuration"
  - "CodeRabbit review instructions guide: https://docs.coderabbit.ai/guides/review-instructions"
  - "CodeRabbit quickstart: https://docs.coderabbit.ai/getting-started/quickstart"
---

# Code Review Automation (CodeRabbit)

> **Status: draft** — sourced from CodeRabbit docs (April 2026).

---

## Why this matters in a vibe coding workflow

When an AI agent writes most of the code, there are two quality problems:

1. **The agent makes mistakes** it doesn't notice — logic errors, missing edge cases, introduced security issues
2. **The human reviewer gets fatigued** reviewing large diffs produced quickly by an agent

CodeRabbit solves both: it reviews every PR automatically using a separate AI model, providing inline comments, a PR summary, and a walkthrough of changes — before any human spends time on the diff. It acts as a **second AI perspective** that doesn't share Claude's assumptions or blind spots.

It also has `slop_detection` — literally a feature for catching low-quality, AI-mass-generated PRs.

---

## What CodeRabbit does

- **PR summary** — auto-generates a description of what changed and why, in plain English
- **Walkthrough** — file-by-file breakdown of changes with context
- **Inline review comments** — specific, line-level suggestions (bugs, security issues, missing tests, style violations)
- **Sequence diagrams** — auto-generates architecture diagrams for complex changes
- **Review effort estimate** — signals how much human attention the PR needs
- **Finishing touches** — can generate missing docstrings or unit tests on request
- **Custom checks** — define pass/fail gates (e.g. "all exported functions must have JSDoc")
- **Slop detection** — flags low-quality/spam PRs (useful when agent output is high volume)

---

## Installation

1. Go to [coderabbit.ai](https://coderabbit.ai) and sign in with GitHub
2. Grant access to your repository (granular — no need to give org-wide access)
3. Open any PR — CodeRabbit posts its review automatically within minutes

No YAML, no GitHub Actions workflow needed for basic use. CodeRabbit operates as a GitHub App.

**Pricing:** Free for open-source public repositories. Paid plans for private repos.

---

## Configuration (`.coderabbit.yaml`)

Place at the repository root. All fields are optional — defaults are sensible.

### Minimal config for a Node.js project

```yaml
# .coderabbit.yaml
language: "en-US"

reviews:
  profile: "assertive"           # chill | assertive — assertive requests changes rather than just commenting
  request_changes_workflow: true # auto-request changes until comments are resolved

  high_level_summary: true       # generate PR description
  sequence_diagrams: true        # architectural diagrams for complex changes
  estimate_code_review_effort: true

  auto_review:
    enabled: true
    auto_incremental_review: true  # re-review on each new push
    drafts: false                  # skip draft PRs

  # Don't review these paths (mirrors .eslintignore)
  path_filters:
    - "!package-lock.json"
    - "!dist/**"
    - "!coverage/**"
    - "!*.snap"

  # Path-specific review focus
  path_instructions:
    - path: "src/**/*.js"
      instructions: |
        - Enforce ESLint flat config rules (no var, prefer const, no-unused-vars)
        - Check all user inputs are validated with zod or similar before use
        - Verify no stack traces or internal paths are exposed in error responses
        - Confirm async functions have proper error handling (try/catch or .catch())
    - path: "**/*.test.js"
      instructions: |
        - Each test should follow the AAA pattern (Arrange / Act / Assert)
        - Test names should describe: what, under what conditions, expected outcome
        - No shared mutable state between tests — each test sets up its own data
    - path: "infra/**"
      instructions: |
        - Check that no secrets or credentials are hardcoded in Pulumi config
        - Verify new GCP resources have least-privilege IAM bindings
        - Confirm required GCP APIs are enabled before dependent resources
    - path: ".github/workflows/**"
      instructions: |
        - Verify OIDC authentication is used (not service account keys in secrets)
        - Check concurrency groups are set to cancel stale runs
        - Confirm npm ci is used, not npm install

  slop_detection:
    enabled: true    # flag low-quality PRs — useful when agent output is high volume

knowledge_base:
  code_guidelines:
    enabled: true
    filePatterns:
      - "CLAUDE.md"        # point CodeRabbit at your agent instructions
      - "AGENTS.md"
      - ".eslintrc*"
      - "eslint.config.*"
```

---

## Key configuration options

### Review profile

| Value | Behaviour |
|---|---|
| `"chill"` | Suggests improvements, doesn't request changes — good for solo projects |
| `"assertive"` | Requests changes, blocks merge until resolved — good for team/production repos |

### `request_changes_workflow`

When `true`, CodeRabbit posts a "Changes Requested" GitHub review status. The PR cannot be merged until the reviewer resolves or dismisses it. Set `true` for production repos; `false` if you want advisory-only comments.

### Path-specific instructions

The most powerful customisation. Point CodeRabbit at the parts of the codebase that need specific attention:

```yaml
path_instructions:
  - path: "src/api/**"
    instructions: |
      - Validate all inputs against the schema before processing
      - Check for missing authentication/authorisation guards
      - Ensure error responses don't leak internal details
  - path: "**/*.test.js"
    instructions: |
      - Tests must use Vitest (not Jest globals without import)
      - Coverage of error paths, not just happy paths
```

### Pointing at your CLAUDE.md / AGENTS.md

Set `knowledge_base.code_guidelines.filePatterns` to include your agent instructions files. CodeRabbit will read your CLAUDE.md conventions and enforce them in reviews — ensuring the same standards apply whether the code was written by a human or an AI agent.

```yaml
knowledge_base:
  code_guidelines:
    enabled: true
    filePatterns:
      - "CLAUDE.md"
      - ".claude/rules/*.md"
```

### Finishing touches

CodeRabbit can generate missing unit tests or docstrings on a per-PR basis:

```yaml
reviews:
  finishing_touches:
    unit_tests:
      enabled: true     # offers to generate missing tests
    docstrings:
      enabled: true     # offers to improve/add docstrings
```

These are offered as suggestions — not applied automatically.

---

## Pre-merge checks

Enforce standards that must pass before merge:

```yaml
reviews:
  pre_merge_checks:
    docstrings:
      mode: "warning"     # off | warning | error
      threshold: 80       # % of exported functions with docs
    description:
      mode: "warning"     # PR must have a description
    custom_checks:
      - description: "All new API endpoints must have input validation"
        enabled: true
        instructions: "Check that every new route handler validates the request body/params with zod before use"
        fail_on_error: true
```

---

## Interacting with CodeRabbit in PRs

Once installed, you can chat with CodeRabbit in PR comments:

```
@coderabbitai review           ← trigger a fresh review
@coderabbitai summary          ← regenerate the PR summary
@coderabbitai generate tests   ← generate unit tests for changed files
@coderabbitai ignore           ← mark a comment as resolved without addressing it
@coderabbitai help             ← list available commands
```

---

## CodeRabbit in the guardrail stack

CodeRabbit sits at the outermost layer — it reviews what the CI pipeline has already validated:

```
Code written by agent
    ↓
Pre-commit hooks (Husky)
  ├─ ESLint --fix
  ├─ Prettier --write
  └─ Gitleaks protect --staged
    ↓
GitHub Actions CI (on PR)
  ├─ npm run lint
  ├─ npm test (with coverage threshold)
  └─ npm audit --audit-level=high
    ↓
CodeRabbit review (on PR)        ← catches what linting and tests can't
  ├─ Logic errors and edge cases
  ├─ Security anti-patterns
  ├─ Missing error handling
  ├─ Architectural concerns
  └─ Standards enforcement (via path_instructions pointing at CLAUDE.md)
    ↓
Human review (async, advisory)   ← can focus on intent rather than mechanics
```

The value of this stack: the human reviewer's time is spent on **intent and architecture**, not on catching the mistakes that automated tooling and AI review already caught.

---

## Slop detection

```yaml
reviews:
  slop_detection:
    enabled: true
    label: "needs-review"   # label applied to flagged PRs
```

Slop detection flags PRs that appear to be low-quality or mass-generated — PRs with large diffs, boilerplate-heavy changes, or patterns that suggest unreviewed AI output. Enable this when using agents that produce PRs at high volume.

---

## Known gaps / to research

- [ ] CodeRabbit AST-based instructions (`ast-grep` rules for syntax-aware review)
- [ ] CodeRabbit Plan — converting issues to implementation plans (separate product feature)
- [ ] CodeRabbit IDE extension for VS Code (review uncommitted changes locally)
- [ ] Integration with Linear / Jira for issue-linked reviews
- [ ] Exact pricing tiers for private repos (check coderabbit.ai)
