# Wiki Log

Append-only chronological record of all operations. Format:
`## [YYYY-MM-DD] <operation> | <title>`

Operations: `ingest` | `query` | `lint` | `bootstrap` | `create`

---

## [2026-04-12] create | Initial wiki structure

Created wiki infrastructure based on Karpathy LLM Wiki pattern (v1) with extensions from Rohitg00 (v2).

**Files created:**
- `README.md` — human-facing overview
- `SCHEMA.md` — governance, operations, tag taxonomy
- `index.md` — content catalog (9 pages registered)
- `log.md` — this file
- `pages/claude-md-conventions.md` — stub
- `pages/claude-code-hooks.md` — stub
- `pages/nodejs-patterns.md` — stub
- `pages/pulumi-gcp-patterns.md` — stub
- `pages/testing-setup.md` — stub
- `pages/linting-setup.md` — stub
- `pages/cicd-github-actions.md` — stub
- `pages/security-scanning.md` — stub
- `pages/new-project-checklist.md` — stub
- `raw-sources/sources.md` — source links added

**Source of initial structure:** repo audit of `agslinger/IaC-test-app` (Node.js, Pulumi/GCP, Husky/Gitleaks) and gap analysis identifying missing: tests, linting, CI/CD, monitoring.

**Next step:** Run Ingest operation against Anthropic Claude Code docs and community CLAUDE.md templates to fill page stubs.
