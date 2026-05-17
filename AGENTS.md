# AGENTS.md

## Repo
- This repo is a markdown wiki of reusable guidance for AI-assisted software projects.
- Read in order: `README.md`, `SCHEMA.md`, `index.md`, then only the smallest relevant files.
- Canonical knowledge lives in `pages/`.
- `templates/` contains reusable starter files.
- `project-planning/` is working material, not canonical guidance.
- `log.md` is append-only.

## Current repo tech
- Content: Markdown wiki + Obsidian vault config.
- Agent config: root `AGENTS.md`, `CLAUDE.md`, `.claude/settings.json`, `.claude/rules/`, `.claude/hooks/`.
- Linting: `scripts/wiki-lint.ps1`.
- CI: GitHub Actions in `.github/workflows/`.
- Security: Gitleaks is already configured with `.gitleaks.toml` and `.github/workflows/gitleaks.yml`.
- This repo does **not** currently have a Next.js/TypeScript app checked in.

## Core workflows
- **Query:** read `index.md`, then the few relevant pages, then answer.
- **Ingest:** check `project-planning/ingested-sources.md` first; update the smallest useful set of pages; update `index.md` if needed; update `project-planning/ingested-sources.md`; append to `log.md`.
- **Bootstrap:** read `pages/new-project-checklist.md` plus stack-matching pages; output tailored project instructions.
- **Lint:** run `pwsh ./scripts/wiki-lint.ps1` before finishing substantial wiki edits.

## Writing rules
- Be extremely concise.
- Use the fewest words that fully answer the user.
- Prefer bullets over prose.
- Do not add background unless asked.
- Keep wiki edits small and targeted.
- Follow `SCHEMA.md` for page shape and headings.
- Every page in `pages/` needs YAML frontmatter.
- Never delete content; supersede it with a note.
- Always append a brief entry to `log.md` after repo writes.
- Prefer the simplest proving slice.
