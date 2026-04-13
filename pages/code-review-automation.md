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

## Read This When

- Adding an AI review layer to pull requests
- Wanting a second pass on AI-generated code
- Tightening PR review quality without more human toil

## Default Recommendation

- Install CodeRabbit on the repo.
- Keep lint, test, and security checks in CI first.
- Use CodeRabbit as a second AI reviewer, not the only reviewer.
- Prefer assertive review settings for team or production repos.

## Use This Pattern

Recommended role in the stack:

1. pre-commit checks
2. CI lint/test/security
3. CodeRabbit PR review
4. human review

Useful config ideas:

- exclude generated files and lockfiles
- add path-specific instructions
- point CodeRabbit at `CLAUDE.md` and `.claude/rules/*.md`
- enable slop detection for high-volume AI PRs

## Commands / Config

Minimal repo config should focus on:

- review profile
- path filters
- path instructions
- knowledge base files
- slop detection

## Pitfalls

- Do not use AI review as a replacement for CI.
- Do not let path instructions become huge policy dumps.
- Do not assume CodeRabbit knows repo conventions unless you point it at them.

## Related Pages

- [claude-md-conventions](claude-md-conventions.md)
- [cicd-github-actions](cicd-github-actions.md)
- [testing-setup](testing-setup.md)
