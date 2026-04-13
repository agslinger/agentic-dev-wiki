---
title: Geist Sans + Geist Mono
type: tool
status: draft
confidence: 70
tags: [javascript, typescript]
last-updated: 2026-04-12
sources:
  - "next/font optimization docs: https://nextjs.org/docs/app/building-your-application/optimizing/fonts"
  - "Next.js installation guide: https://nextjs.org/docs/app/getting-started/installation"
---

# Geist Sans + Geist Mono

## Read This When

- Choosing typography defaults for a Next.js app
- Deciding whether to keep the scaffolded font choice

## Default Recommendation

- Keep Geist as the default starting font pair when using the current Next.js starter.
- Use `next/font` so fonts are optimized and self-hosted automatically.

## Use This Pattern

Next.js docs say `next/font` optimizes fonts, removes external network requests, and self-hosts font assets. That makes Geist a good bootstrap choice because it has low setup cost and fits the default Next.js path well.

Use Geist when:

- the team needs a neutral product font quickly
- typography is not yet a differentiating design decision

## Commands / Config

Apply fonts in the root layout so they cover the whole app.

## Pitfalls

- Do not keep Geist just because the scaffold includes it if the product needs a different brand system.
- Do not load fonts outside `next/font` if you want the default Next.js optimization path.

## Related Pages

- [nextjs-patterns](nextjs-patterns.md)
- [react-tailwind-shadcn-ui](react-tailwind-shadcn-ui.md)
