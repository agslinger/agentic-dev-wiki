# Obsidian-Style Wiki Graph Viewer Plan

## Goal
Build a cloud-hosted public graph viewer for this wiki that visually feels close to Obsidian's graph view while keeping markdown files as the source of truth.

## Best-fit stack
Match the existing `talk-head-app` stack where relevant:
- **Framework:** Next.js 16 App Router
- **Language:** TypeScript strict mode
- **UI:** React 19, Tailwind CSS 4, shadcn/ui, Lucide icons, Geist fonts
- **Markdown:** `react-markdown` + `remark-gfm` if page rendering is added alongside the graph
- **Validation:** Zod
- **Testing:** Vitest + Playwright
- **Lint/format:** ESLint + Prettier
- **Security:** Gitleaks
- **Infra:** Pulumi
- **Hosting:** cloud-hosted, provisioned by Pulumi

## Best-fit approach
- **Markdown-first:** derive graph data from existing `.md` files
- **Next.js app:** serve the graph viewer as a normal route
- **TypeScript graph export script:** generate graph JSON from repo files
- **Obsidian config reuse:** use `.obsidian/graph.json` force settings as the starting point
- **Pulumi-managed cloud deployment:** keep app and infra separate, as in `talk-head-app`

## Project shape
Keep application and infrastructure separate:

```text
src/      ← Next.js app code
infra/    ← Pulumi project for cloud resources and deploy wiring
```

Suggested app paths:
- `src/app/graph/page.tsx`
- `src/lib/graph/`
- `public/wiki-graph.json`
- `scripts/build-graph.ts`

## Build shape

### 1. Graph data generator
Create a small TypeScript script that:
- scans top-level `*.md`, `pages/*.md`, `project-planning/*.md`, and optionally `templates/*.md`
- parses frontmatter where present
- extracts local markdown links
- validates the graph shape with Zod
- emits a derived JSON file with `nodes` and `links`

Suggested output:
- `public/wiki-graph.json`

Suggested location:
- `scripts/build-graph.ts`

### 2. Viewer
Create one small Next.js route:
- `src/app/graph/page.tsx`

Use a graph library:
- **Preferred:** `force-graph` for the quickest result
- **Alternative:** D3 only if tighter custom visuals are needed later

Initial features:
- dark Obsidian-like background
- pan and zoom
- node hover labels
- click node to open the markdown file in GitHub or the repo site
- color nodes by folder (`pages`, `project-planning`, root docs, `templates`)

### 3. Obsidian alignment
Use `.obsidian/graph.json` as the first-pass source for:
- repulsion
- link distance
- center strength
- node and line size

Do not try to fully clone Obsidian at first; match the feel, not every detail.

### 4. Cloud hosting via Pulumi
Use Pulumi to provision and manage the hosting setup.

Best-practice shape:
- keep `infra/` as a separate Node.js project
- keep app and infrastructure code separate
- store secrets with `pulumi config set --secret`
- document the hosting target explicitly in the repo

Initial Pulumi scope:
- app hosting target
- environment variables / secrets
- domain and DNS if needed
- any storage or cache only if the graph app later needs it

## Quality bar
- keep the first slice very small: one route, one graph JSON file, one visible graph
- run ESLint and Prettier locally and in CI
- add a small Vitest check for graph-data generation
- add one Playwright smoke test that loads the graph page successfully
- run Gitleaks in CI from day one
- add `npm audit --audit-level=high` in CI

## Delivery phases

### Phase 1
- scaffold a small Next.js 16 app with App Router and TypeScript strict mode
- add Tailwind, shadcn/ui, Lucide, and Geist only as needed for the first graph page
- add ESLint + Prettier
- implement `scripts/build-graph.ts`
- generate graph JSON from markdown files and links
- render a public `/graph` page
- tune forces from `.obsidian/graph.json`
- stand up cloud hosting with Pulumi

### Phase 2
- add search/filter
- add toggle for orphan nodes
- size nodes by link count
- show metadata panel on click
- add preview or staged deploy checks

### Phase 3
- add tag-based coloring/filtering
- add optional graph rebuild in CI
- optionally render markdown note previews with `react-markdown`
- optionally export richer graph data for future Neo4j sync

## Why this is the best fit
- stays consistent with the repo's **markdown-first** design
- reuses existing **Obsidian** settings instead of inventing new force defaults
- matches the proven `talk-head-app` app stack instead of introducing a second frontend pattern
- keeps **Pulumi** as the cloud-control layer from day one
- keeps the graph as a **derived artifact**, not a second source of truth

## Recommendation
Start with:
- `src/app/graph/page.tsx`
- `public/wiki-graph.json`
- `scripts/build-graph.ts`
- Zod schema for graph export
- ESLint + Prettier config
- one Vitest test for graph export
- one Playwright smoke test for `/graph`
- `infra/` Pulumi project for cloud hosting

Keep the first version minimal and public, then add filters/search only after the basic graph is working.
