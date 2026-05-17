---
title: HTML Prototyping for Agent Review
type: pattern
status: draft
confidence: 68
tags: [claude-code, ai-agent, code-review, javascript, typescript]
last-updated: 2026-05-17
sources:
  - "UCI design review paper: https://www.ics.uci.edu/~redmiles/publications/C030-VRR99.pdf"
  - "Decode: https://decode.dev/"
  - "Relayer: https://relayer.app/"
---

# HTML Prototyping for Agent Review

## Read This When

- The user needs to refine layout, flow, copy, or interaction before production code
- A screenshot or clickable preview would make review faster than reading a diff
- The agent is about to make UI-heavy changes with unclear target behavior

## Default Recommendation

- Create a disposable HTML prototype before production edits when visual alignment matters.
- Use fake data and local assets.
- Stop for review before promoting the idea into app code.
- Keep prototype CSS out of the production design system unless deliberately converted.

## Use This Pattern

Good prototype targets:

- one screen
- one modal
- one flow with fake data
- before/after UI refactor preview
- review pack artifact for a larger product change

Default rules:

- Name it clearly, such as `prototype.html` or a throwaway preview route.
- Mark it as disposable.
- Keep data inline and small.
- Avoid production dependencies unless the prototype is inside the app.
- Delete or supersede it after promotion.

Promotion rules:

- If the user rejects the direction, discard the prototype.
- If the user approves the direction, convert the relevant structure into production components.
- If the prototype reveals missing requirements, update the plan before coding.

## Commands / Config

Prompt pattern:

```text
Produce a disposable HTML prototype first. Use fake data. Stop for review.
Do not edit production files until the prototype direction is approved.
```

Review pack additions for UI work:

- prototype path or preview URL
- screenshot
- click path
- what is intentionally fake
- what will change when promoted to production

## Pitfalls

- Do not let prototype styling silently become the production design system.
- Do not spend production-hardening time on a disposable artifact.
- Do not prototype every tiny UI edit; use it when alignment risk is real.
- Do not mix fake prototype data with real customer data.

## Related Pages

- [agent-development-lifecycle](agent-development-lifecycle.md)
- [react-frontend-patterns](react-frontend-patterns.md)
- [nextjs-patterns](nextjs-patterns.md)
- [code-review-automation](code-review-automation.md)
