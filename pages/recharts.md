---
title: Recharts
type: tool
status: draft
confidence: 76
tags: [javascript, typescript]
last-updated: 2026-04-12
sources:
  - "Recharts guide: https://recharts.github.io/en-US/guide/"
  - "Recharts getting started: https://recharts.github.io/en-US/guide/getting-started/"
  - "Recharts chart size guide: https://recharts.github.io/en-US/guide/sizes/"
  - "Recharts performance guide: https://recharts.github.io/en-US/guide/performance/"
---

# Recharts

## Read This When

- Adding dashboard charts to a React app
- Choosing a React-native charting library for product analytics or reports

## Default Recommendation

- Use Recharts for application dashboards and straightforward business charts.
- Keep charts responsive and scoped to clear product questions.

## Use This Pattern

Recharts fits this stack because it is React-native and works well with component-based UI composition.

Use it when:

- charts are primarily line, bar, area, pie, or reference-based visuals
- the app needs fast dashboard development more than low-level charting control

Important practical rules from the docs:

- charts need width or height to render
- use responsive sizing patterns for layouts that resize
- isolate frequently changing chart parts for better performance

## Commands / Config

```bash
npm install recharts
```

## Pitfalls

- Do not render charts without explicit size rules.
- Do not use a charting library as the first solution if static tables answer the question better.
- Large or highly interactive datasets may need extra performance care.

## Related Pages

- [react-tailwind-shadcn-ui](react-tailwind-shadcn-ui.md)
- [nextjs-patterns](nextjs-patterns.md)
