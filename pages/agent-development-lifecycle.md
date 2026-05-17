---
title: Agent Development Lifecycle
type: concept
status: draft
confidence: 74
tags: [claude-code, ai-agent, agents-md, llm, code-review]
last-updated: 2026-05-17
sources:
  - "HumanLayer / ZenML CRISPY summary: https://www.zenml.io/llmops-database/evolving-ai-coding-agent-workflows-from-research-plan-implement-to-crispy"
  - "HumanLayer advanced context engineering: https://www.humanlayer.dev/blog/advanced-context-engineering"
  - "AI Pattern Book RPI: https://aipatternbook.com/research-plan-implement"
  - "Alex Lavaee QRSPI: https://alexlavaee.me/blog/from-rpi-to-qrspi/"
  - "Patrick Robinson RPI: https://patrickarobinson.com/blog/introducing-rpi-strategy/"
  - "Cognizant MAKER methodology: https://www.cognizant.com/us/en/ai-lab/blog/maker"
---

# Agent Development Lifecycle

## Read This When

- Choosing how much process an agent task needs
- Work is ambiguous, multi-file, UI-heavy, data-heavy, or high-risk
- The agent needs reviewable artifacts before production edits

## Default Recommendation

- Use RPI for bounded bugs and small features.
- Escalate to QRSPI or CRISPY for ambiguous, multi-file, UI-heavy, or high-risk work.
- Use MAKER as a reliability principle: break work into atomic proving slices.
- End every meaningful slice with a review pack, not just "done".

## Use This Pattern

### Lifecycle selection

| Task shape | Use |
|---|---|
| One-file bug or clear config change | RPI |
| Cross-module feature | QRSPI |
| UI/product flow with unclear target | QRSPI + HTML prototype |
| Architecture or data model change | CRISPY/QRSPI |
| Security-sensitive or destructive change | QRSPI with explicit red flags |

### Minimal lifecycle

1. Questions: ask only what blocks safe progress.
2. Research: gather facts from code/docs before forming opinions.
3. Design: compare current state, desired state, and options.
4. Structure: define boundaries, interfaces, data shape, and tests.
5. Plan: create atomic, testable steps.
6. Implement: ship the smallest proving slice first.
7. Review: provide files changed, checks run, spot-check path, risks, and screenshots/prototypes when relevant.

### Red flags

Pause or escalate when:

- requirements are still ambiguous after research
- tests fail for reasons unrelated to the slice
- the diff touches unexpected files
- secrets, auth, permissions, migrations, billing, or destructive commands are involved
- the user-facing flow cannot be reviewed from the final diff alone

## Commands / Config

Prompt pattern:

```text
Use RPI for this bounded change. Research the relevant files, make a short plan,
implement the smallest proving slice, run focused checks, then provide a review pack.
```

For ambiguous work:

```text
Use QRSPI. Start with questions and factual research. Produce a design discussion
and stop for review before production edits.
```

## Pitfalls

- Do not force full lifecycle ceremony onto a small one-file fix.
- Do not let a polished plan substitute for factual codebase research.
- Do not start production UI work before the user can review the intended flow.
- Do not treat autonomous implementation as success if human review is still hard.

## Related Pages

- [agent-instruction-design](agent-instruction-design.md)
- [html-prototyping-for-agent-review](html-prototyping-for-agent-review.md)
- [code-review-automation](code-review-automation.md)
- [project-templates](project-templates.md)
