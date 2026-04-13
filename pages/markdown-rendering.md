---
title: Markdown Rendering with react-markdown + remark-gfm
type: pattern
status: draft
confidence: 82
tags: [javascript, typescript]
last-updated: 2026-04-12
sources:
  - "react-markdown README: https://github.com/remarkjs/react-markdown"
  - "remark-gfm README: https://github.com/remarkjs/remark-gfm"
---

# Markdown Rendering with react-markdown + remark-gfm

## Read This When

- Rendering user or model-produced markdown in React
- Supporting GitHub-flavored markdown in chat, reviews, or document views

## Default Recommendation

- Use `react-markdown` for safe markdown-to-React rendering.
- Add `remark-gfm` when you need tables, task lists, footnotes, autolinks, or strikethrough.

## Use This Pattern

`react-markdown` is useful because its README describes it as safe by default, plugin-based, and CommonMark-compliant. `remark-gfm` adds GitHub-flavored markdown features without changing the overall rendering model.

This stack fits especially well for:

- chat transcripts
- review comments
- rich text summaries
- markdown document previews

## Commands / Config

```bash
npm install react-markdown remark-gfm
```

Typical pattern:

- render markdown with `react-markdown`
- pass `remarkPlugins={[remarkGfm]}`
- map selected HTML tags to custom React components where design-system control matters

## Pitfalls

- Do not assume markdown rendering is identical to arbitrary HTML rendering.
- Be deliberate about allowed elements and custom components.
- Markdown support is broader with `remark-gfm`, but still needs design styling for tables and task lists.

## Related Pages

- [react-tailwind-shadcn-ui](react-tailwind-shadcn-ui.md)
- [nextjs-patterns](nextjs-patterns.md)
