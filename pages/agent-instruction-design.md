---
title: Agent Instruction Design
type: concept
status: draft
confidence: 76
tags: [claude-code, ai-agent, agents-md, llm]
last-updated: 2026-05-17
sources:
  - "Anthropic Claude Code best practices: https://code.claude.com/docs/en/best-practices"
  - "HumanLayer — writing a good CLAUDE.md: https://www.humanlayer.dev/blog/writing-a-good-claude-md"
  - "OpenAI Codex AGENTS.md: https://developers.openai.com/codex/guides/agents-md"
  - "Promplify — prompt frameworks compared: https://promplify.ai/blog/prompt-engineering-frameworks-compared/"
  - "YouTube — A love letter to Pi | Lucas Meijer: https://www.youtube.com/watch?v=fdbXNWkpPMY"
---

# Agent Instruction Design

## Read This When

- Writing or restructuring a `CLAUDE.md` or `AGENTS.md`
- Agent output quality is inconsistent or degrading
- Deciding what goes in instructions vs hooks vs skills vs linters

## The Hard Constraint

Frontier LLMs reliably follow **~150-200 instructions per prompt**. Claude Code's system prompt consumes ~50 of those. That leaves **~100-150 instructions** for your CLAUDE.md plus any loaded rules.

Beyond this limit, adherence degrades **silently** — instructions get quietly skipped with no error. If your CLAUDE.md is too long, adding more rules makes existing rules less likely to be followed.

## Default Recommendation

1. Keep CLAUDE.md under 100 lines of real instructions.
2. Use the **RISEN structure** for the file itself.
3. Enforce deterministic rules with **hooks and linters**, not instructions.
4. Use **progressive disclosure** — point to docs, don't paste them.
5. Decide **before the task starts** how a human will evaluate the result.
6. Tell the agent which verification and review artifacts are expected.
7. Link to task workflow guidance instead of embedding lifecycle detail in `CLAUDE.md`.

## Use This Pattern

## RISEN Structure for CLAUDE.md

RISEN (Role, Instructions, Steps, End Goal, Narrowing) is the most relevant prompt framework for coding agent instruction files:

| Section | CLAUDE.md mapping | Example |
|---|---|---|
| **Role** | Project overview and stack context | "Node.js API on GCP Cloud Functions, Pulumi IaC" |
| **Instructions** | Workflow rules that apply to all tasks | "Use ESM imports, validate inputs with zod" |
| **Steps** | Standard commands and procedures | "Run `npm test` before committing" |
| **End Goal** | Quality gates the agent must pass | "All tests pass, no type errors, lint clean" |
| **Narrowing** | Hard constraints and prohibitions | "Never modify migration files, never use `var`" |

### Example CLAUDE.md skeleton

```markdown
# Project
Node.js 22 API on GCP Cloud Functions. ESM. Pulumi YAML for IaC.
src/ for app, infra/ for Pulumi. Separate package.json each.

# Workflow
- Run `npm test` after code changes
- Run `npm run lint` before handoff
- End each task with a short handoff summary
- Use plan mode for changes touching >3 files

# Quality gates
- Tests pass with >70% coverage
- Zero ESLint errors
- No secrets in source (Gitleaks pre-commit active)

# Rules
- Use `import`, never `require`
- Validate all inputs with zod
- Never expose stack traces in error responses
- Never modify files under `infra/migrations/`

# Commands
- `npm test` — Vitest
- `npm run lint` — ESLint flat config
- `npm run format:check` — Prettier
```

That is ~25 instructions. It leaves room for `.claude/rules/` and skills without hitting the budget.

### Evaluation-first handoff

Ask this before launching the agent: **how will a human review the result?**

If you decide the review method up front, put it in the prompt. This helps the agent:

- know what "done" means
- produce the right artifacts while it works
- make the final human review faster instead of leaving all the synthesis to the reviewer

Default handoff pattern after automated checks:

1. run the narrowest relevant tests during implementation
2. run broader checks at the slice boundary
3. prepare a short handoff summary before commit
4. commit only after the slice is both green and easy to inspect manually

Good handoff defaults:

- backend or API change -> files changed, commands run, exact request to replay, expected behavior
- UI change -> screenshots plus a short click path; add a demo clip for richer motion or state changes
- build or tooling change -> exact build/test command, what was broken before, what is now expected to pass

After the run, review the transcript or trace for avoidable detours. Use those detours to tighten docs, commands, and repo instructions.

## Workflow Boundary

Keep `CLAUDE.md` focused on project rules, commands, and quality gates.

Task lifecycle choices belong in [agent-development-lifecycle](agent-development-lifecycle.md).

## The Enforcement Pyramid

Not all rules belong in CLAUDE.md. Use the right enforcement mechanism:

| Mechanism | Certainty | Use for |
|---|---|---|
| **Linters and formatters** | Deterministic | Code style, formatting, import order |
| **Pre-commit hooks** (Husky) | Deterministic | Secret scanning, lint gate |
| **Claude Code hooks** | Deterministic | Block destructive commands, auto-lint after edit |
| **CI checks** | Deterministic | Test coverage, security audit, format check |
| **CodeRabbit** | AI (second perspective) | Logic errors, security patterns, missing tests |
| **CLAUDE.md rules** | Advisory | Architectural decisions, workflow, naming conventions |
| **Skills** | On-demand advisory | Domain knowledge, multi-step procedures |

**Rule of thumb**: if you can enforce it deterministically, don't waste an instruction slot on it.

## Commands / Config

Useful defaults to encode:

- keep `CLAUDE.md` under roughly 100 lines of real instructions
- move deterministic behavior into hooks and CI
- move path-specific guidance into `.claude/rules/`
- require verification steps like tests or screenshots before completion
- require a short handoff summary after automated checks and before commit
- tell the agent how a human will manually inspect the slice
- use transcript reviews to fix stale docs, noisy warnings, and missing commands
- link to [agent-development-lifecycle](agent-development-lifecycle.md) for task workflow selection

## Context Management

Context guidance:

- Keep context utilization under **40%**; start fresh sessions at **60%**
- Use `/clear` between unrelated tasks
- Use **subagents as context firewalls** — they explore in separate context
- Persist progress to disk (specs, task lists), load only what's needed
- Organise work as **vertical slices** (API → UI → DB), not horizontal layers

## Pitfalls

- Do not exceed ~100 real instructions in CLAUDE.md — silent degradation, no errors.
- Do not decide how to review the result only after the agent says it is done.
- Do not put linting rules in CLAUDE.md when ESLint can enforce them.
- Do not put task-specific instructions in CLAUDE.md — use skills.
- Do not auto-generate CLAUDE.md from LLM output — hand-craft every line.
- Do not assume the agent read a long plan correctly — validate Design Discussion output before coding.
- Do not let context fill above 60% — quality drops uniformly across all instructions.
- Do not stop at "tests passed" if the human still has to reverse-engineer what changed and how to spot-check it.
- Do not leave stale docs or noisy build warnings in place — agents follow them literally and waste context fixing avoidable detours.

## Related Pages

- [agent-development-lifecycle](agent-development-lifecycle.md)
- [html-prototyping-for-agent-review](html-prototyping-for-agent-review.md)
- [claude-md-conventions](claude-md-conventions.md)
- [claude-code-hooks](claude-code-hooks.md)
- [code-review-automation](code-review-automation.md)
- [testing-setup](testing-setup.md)
