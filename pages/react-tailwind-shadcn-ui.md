---
title: React 19 + Tailwind CSS 4 + shadcn/ui
type: pattern
status: draft
confidence: 78
tags: [nodejs, javascript, typescript]
last-updated: 2026-04-12
sources:
  - "React 19 blog: https://react.dev/blog/2024/12/05/react-19"
  - "Tailwind CSS v4.0: https://tailwindcss.com/blog/tailwindcss-v4"
  - "shadcn/ui installation: https://ui.shadcn.com/docs/installation"
  - "shadcn/ui CLI docs: https://ui.shadcn.com/docs/cli"
  - "shadcn/ui manual installation: https://ui.shadcn.com/docs/installation/manual"
---

# React 19 + Tailwind CSS 4 + shadcn/ui

## Read This When

- Choosing the main UI stack for a modern React app
- Deciding how much frontend infrastructure to adopt at bootstrap time
- Pairing React, utility CSS, and a component toolkit

## Default Recommendation

- Use React 19 for the app runtime.
- Use Tailwind CSS 4 for utility-first styling and rapid layout work.
- Use shadcn/ui when the team wants reusable, editable components instead of a locked design-system package.

## Use This Pattern

This stack works well together because:

- React 19 adds modern primitives and improvements around forms, actions, optimistic updates, and server-component support
- Tailwind 4 reduces setup friction and is optimized for modern CSS features
- shadcn/ui is designed to scaffold components into your repo, which fits teams that want source-controlled UI building blocks

Use this stack when:

- the team wants fast product iteration
- UI consistency matters
- components should be editable in-project, not consumed as a black box

## Commands / Config

Useful bootstrap commands:

```bash
pnpm dlx shadcn@latest init -t next
pnpm dlx shadcn@latest add button card dialog
```

shadcn CLI config supports:

- framework templates like `next`
- CSS variables
- aliases for `@/components`, `@/lib`, and `@/hooks`
- Lucide as the icon library

## Pitfalls

- Do not add shadcn/ui if the team wants a fully managed component package with minimal copied code.
- Do not assume Tailwind alone provides component structure or accessibility.
- React 19 features are useful, but framework support still matters, especially in Next.js App Router.

## Related Pages

- [nextjs-patterns](nextjs-patterns.md)
- [lucide-react-icons](lucide-react-icons.md)
- [geist-fonts](geist-fonts.md)
