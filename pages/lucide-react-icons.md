---
title: Lucide React Icons
type: tool
status: draft
confidence: 70
tags: [javascript, typescript]
last-updated: 2026-04-12
sources:
  - "Lucide React guide: https://lucide.dev/guide/packages/lucide-react"
  - "shadcn/ui manual installation: https://ui.shadcn.com/docs/installation/manual"
---

# Lucide React Icons

## Read This When

- Choosing an icon set for a React app
- Standardizing icon usage across shadcn/ui and custom components

## Default Recommendation

- Use `lucide-react` as the default icon set for this stack.
- Keep icons consistent across app UI and scaffolded shadcn/ui components.

## Use This Pattern

Lucide React fits well here because:

- it provides React components directly
- it matches shadcn/ui defaults
- it keeps icon usage consistent without introducing a separate design-system dependency

## Commands / Config

```bash
npm install lucide-react
```

In shadcn config, Lucide is the default `iconLibrary`.

## Pitfalls

- Do not mix multiple icon libraries without a real reason.
- Do not treat icons as decorative only when they carry interaction meaning; keep accessibility in mind.

## Related Pages

- [react-tailwind-shadcn-ui](react-tailwind-shadcn-ui.md)
- [geist-fonts](geist-fonts.md)
