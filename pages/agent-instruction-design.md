---
title: Agent Instruction Design
type: concept
status: draft
confidence: 72
tags: [claude-code, ai-agent, agents-md, llm]
last-updated: 2026-04-12
sources:
  - "Anthropic Claude Code best practices: https://code.claude.com/docs/en/best-practices"
  - "HumanLayer — writing a good CLAUDE.md: https://www.humanlayer.dev/blog/writing-a-good-claude-md"
  - "Alex Lavaee — From RPI to QRSPI: https://alexlavaee.me/blog/from-rpi-to-qrspi/"
  - "Patrick Robinson — RPI strategy: https://patrickarobinson.com/blog/introducing-rpi-strategy/"
  - "Cognizant MAKER methodology: https://www.cognizant.com/us/en/ai-lab/blog/maker"
  - "OpenAI Codex AGENTS.md: https://developers.openai.com/codex/guides/agents-md"
  - "Promplify — prompt frameworks compared: https://promplify.ai/blog/prompt-engineering-frameworks-compared/"
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
5. Give the agent **verification** (tests, screenshots) — single highest-leverage action.
6. Use **RPI or QRSPI** as the task workflow, not as CLAUDE.md content.

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
- Run `npm run lint` before committing
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

## Methodologies for Agent Workflow

These are not CLAUDE.md content — they describe how the agent should approach tasks. Embed them via skills or plan-mode habits.

### RPI (Research, Plan, Implement)

Origin: HumanLayer / Patrick Robinson. Three phases with validation gates:

| Phase | Action | Validation |
|---|---|---|
| **Research** | Read codebase, ask clarifying questions | FAR: Factual, Actionable, Relevant |
| **Plan** | Create atomic checkbox tasks | FACTS: Feasible, Atomic, Clear, Testable, Scoped |
| **Implement** | Execute plan step-by-step | Tests pass, lint clean |

Good for: feature work, bug fixes, well-scoped tasks.

### QRSPI (Questions, Research, Design, Structure, Plan, Implement, PR)

Origin: Alex Lavaee. Evolved from RPI to fix three failures at scale:

| RPI failure | QRSPI fix |
|---|---|
| Instruction budget overflow (85+ instructions) | Distribute alignment across 5 phases; each carries fewer directives |
| Magic words dependency | Design Discussion validates understanding by default |
| Plan-reading illusion (plans read well but contain false assumptions) | Research phase hides the ticket; produces only facts |

Key phases:
- **Research**: Agent maps codebase without seeing the feature ticket — prevents premature opinions
- **Design Discussion**: ~200-line markdown of current state → desired state → design choices. Engineer reviews and redirects ("brain surgery") before coding starts
- **Structure Outline**: Signatures and types defined (like C header files)

Good for: architectural changes, multi-file features, unfamiliar codebases.

### MAKER (Maximal Agentic Decomposition, K-threshold, Red-flagging)

Origin: Cognizant AI Lab. Not a prompt framework — a reliability architecture:
- Decompose tasks into millions of atomic micro-steps
- Vote across distributed agents for accuracy
- Auto-discard confused outputs before voting

Achieved 1M+ steps with zero errors. Takeaway for CLAUDE.md: **atomic task decomposition** is the path to reliability.

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

## Context Management

From QRSPI and Anthropic's own guidance:

- Keep context utilization under **40%**; start fresh sessions at **60%**
- Use `/clear` between unrelated tasks
- Use **subagents as context firewalls** — they explore in separate context
- Persist progress to disk (specs, task lists), load only what's needed
- Organise work as **vertical slices** (API → UI → DB), not horizontal layers

## Pitfalls

- Do not exceed ~100 real instructions in CLAUDE.md — silent degradation, no errors.
- Do not put linting rules in CLAUDE.md when ESLint can enforce them.
- Do not put task-specific instructions in CLAUDE.md — use skills.
- Do not auto-generate CLAUDE.md from LLM output — hand-craft every line.
- Do not assume the agent read a long plan correctly — validate Design Discussion output before coding.
- Do not let context fill above 60% — quality drops uniformly across all instructions.

## Related Pages

- [claude-md-conventions](claude-md-conventions.md)
- [claude-code-hooks](claude-code-hooks.md)
- [code-review-automation](code-review-automation.md)
- [testing-setup](testing-setup.md)
