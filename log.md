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

**Source of initial structure:** audit of a private Node.js/Pulumi/GCP reference project (Husky/Gitleaks setup) and gap analysis identifying missing: tests, linting, CI/CD, monitoring.

**Next step:** Run Ingest operation against Anthropic Claude Code docs and community CLAUDE.md templates to fill page stubs.

## [2026-04-12] create | Add Gitleaks repo scanning

Added repository-level secret scanning for this wiki.

**Files created:**
- `.gitleaks.toml` — repo-specific Gitleaks config extending the default ruleset
- `.github/workflows/gitleaks.yml` — GitHub Actions workflow for PR and `main` branch scanning

**Files updated:**
- `pages/security-scanning.md` — documented the active repo setup

**Notes:**
- The config allowlists `pages/security-scanning.md` because it contains example secret patterns that would otherwise create false positives.

## [2026-04-12] create | Add Obsidian vault scaffolding

Added a lightweight Obsidian setup to make the wiki easier to explore visually.

**Files created:**
- `Home.md` — Obsidian-friendly landing page with wiki-links to core notes and topic pages
- `.obsidian/graph.json` — graph view defaults tuned for vault navigation

**Files updated:**
- `.obsidian/app.json` — preview mode and link behavior defaults
- `.obsidian/appearance.json` — readable editor defaults and visible ribbon

## [2026-04-12] create | Add Neo4j repo design plan

Added a repo-specific planning document for evolving this wiki into a markdown-plus-Neo4j system.

**Files created:**
- `plans/neo4j-design-plan.md` — architecture, graph model, sync strategy, and phased implementation plan

## [2026-04-12] create | Refine Neo4j plan with Claude settings structure

Updated the Neo4j design plan with repo-specific guidance for Claude configuration structure based on the wiki's agent-configuration pages.

**Files updated:**
- `plans/neo4j-design-plan.md` — added `.claude/settings.json` vs `.claude/settings.local.json` guidance and hook/script layout recommendations

## [2026-04-12] create | Expand Neo4j plan with security and testing guidance

Updated the Neo4j design plan with recommendations drawn from the wiki's security, testing, CI/CD, and Node.js pages.

**Files updated:**
- `plans/neo4j-design-plan.md` — added security, testing, database-design notes, and phase-level validation guidance

**Files created:**
- `raw-sources/follow-on-questions.md` — captured unresolved research questions where the current wiki does not yet provide enough guidance

## [2026-04-12] ingest | Anthropic Claude Code docs — CLAUDE.md memory guide

**Source:** https://code.claude.com/docs/en/memory  
**Page updated:** `pages/claude-md-conventions.md` — stub → draft (confidence 82)

Key facts ingested: file placement hierarchy (managed/project/user/local), discovery/load order (walk up dir tree, concatenate), subdirectory lazy-loading, @path import syntax, 200-line size target, .claude/rules/ path-scoped rules, AGENTS.md import pattern, HTML comment stripping, CLAUDE.local.md gitignore convention, auto memory system.

## [2026-04-12] ingest | Anthropic Claude Code docs — hooks

**Source:** https://code.claude.com/docs/en/hooks  
**Page updated:** `pages/claude-code-hooks.md` — stub → draft (confidence 85)

Key facts ingested: full event type list (PreToolUse, PostToolUse, PostToolUseFailure, PermissionRequest, SessionStart/End, Stop, SubagentStart/Stop, TaskCreated, Notification, InstructionsLoaded, FileChanged, PreCompact/PostCompact, WorktreeCreate/Remove, Elicitation), settings.json schema with 3-level nesting, matcher pattern rules, handler types (command/http/prompt/agent), stdin JSON format, exit code semantics (0/2/other), JSON output schema with permissionDecision, env vars ($CLAUDE_PROJECT_DIR, $CLAUDE_ENV_FILE), async/once flags.

## [2026-04-12] ingest | Vitest docs + Node.js Best Practices — testing

**Sources:** https://vitest.dev/ · https://vitest.dev/guide/ · https://github.com/goldbergyoni/nodebestpractices  
**Page updated:** `pages/testing-setup.md` — stub → draft (confidence 72)

Key facts ingested: Vitest requires Node ≥20 + Vite ≥6, ESM/TS/JSX via Oxc, Jest-compatible API, vitest.config.js setup, test file naming (.test./.spec.), vitest run vs vitest (watch), @vitest/coverage-v8, supertest HTTP testing pattern (createServer() without listen), GCP client mocking, AAA pattern, 3-part test names, per-test data, coverage thresholds (70% lines/branches), test priority order (component > unit > e2e).

## [2026-04-12] ingest | Pulumi GitHub Actions + GCP OIDC — CI/CD

**Sources:** https://github.com/pulumi/actions · https://docs.cloud.google.com/iam/docs/workload-identity-federation-with-deployment-pipelines  
**Page updated:** `pages/cicd-github-actions.md` — stub → draft (confidence 75)

Key facts ingested: pulumi/actions@v6 commands (preview/up/refresh/destroy/output), required inputs (command, stack-name), comment-on-pr/comment-on-summary, expect-no-changes, suppress-outputs, stack outputs as action outputs, runtime setup required before action, GCP Workload Identity Federation gcloud commands (pool, OIDC provider, IAM binding), attribute-mapping with numeric IDs for security, google-github-actions/auth@v2 YAML, required permissions: id-token: write, concurrency cancel-in-progress pattern, npm ci vs npm install.

## [2026-04-12] ingest | ESLint flat config + Prettier — linting

**Sources:** https://eslint.org/docs/latest/use/configure/configuration-files · https://prettier.io/docs/options  
**Page updated:** `pages/linting-setup.md` — stub → draft (confidence 78)

Key facts ingested: ESLint flat config (eslint.config.js) exports array, config object fields (files/ignores/rules/languageOptions/plugins/extends), cascading merge semantics, eslint-plugin-n for Node.js rules, eslint-config-prettier must be last, TypeScript support via typescript-eslint + jiti, Prettier options (printWidth 80, tabWidth 2, semi true, singleQuote false, trailingComma "all" in v3+), --check vs --write CLI flags, .prettierrc format, lint-staged + Husky pre-commit pattern.

## [2026-04-12] create | ingested-sources.md — source deduplication index

Created `ingested-sources.md` to track which sources have been fetched and which remain pending, preventing redundant re-fetches in future sessions.

**Files created:** `ingested-sources.md`  
**Files updated:** `CLAUDE.md` — Ingest operation now has step 1 (check ingested-sources.md) and step 6 (update it after fetching); Conventions section notes it as agent-maintained.

---

## [2026-04-12] ingest | Round 2 — all remaining sources (14 URLs)

Completed ingest of all sources listed in `raw-sources/sources.md`. All 9 wiki pages are now at `draft` status. `ingested-sources.md` updated to reflect full coverage; supplementary sources listed for future sessions.

**Pages updated:**
- `testing-setup.md` (confidence 72 → 80) — node:test full reference, supertest patterns, Jest comparison
- `linting-setup.md` (confidence 78 → 82) — eslint-config-prettier/flat import, rule caveats, Husky init + lint-staged
- `pulumi-gcp-patterns.md` (confidence 30 → 72) — full Pulumi YAML format, GCP resource types, Cloud Functions v2 pattern, Node.js runtime schedule, IAM patterns, backends, resource protection
- `cicd-github-actions.md` (confidence 75 → 80) — GitHub Actions syntax (triggers, matrix, permissions, outputs, concurrency, reusable workflows)
- `security-scanning.md` (confidence 40 → 75) — Gitleaks install/config/allowlist/CI, npm audit, .gitignore patterns, Pulumi secrets, tool comparison
- `nodejs-patterns.md` (confidence 70 → 76) — OWASP section: input validation, cookie flags, error handling, npm audit, Node.js Permissions Model, hpp middleware

Note: `cloud.google.com/functions/docs` is a landing page; used execution-environment sub-page instead. Karpathy and Rohitg00 gists informed the existing SCHEMA.md design — no new pages warranted.

---

## [2026-04-12] ingest | goldbergyoni/nodebestpractices — Node.js patterns

**Source:** https://github.com/goldbergyoni/nodebestpractices  
**Page updated:** `pages/nodejs-patterns.md` — stub → draft (confidence 70)

Key facts ingested: component-based structure (domain folders not layer folders), 3-tier separation (routes/service/DAL), IaC isolation (separate package.json), testable createServer() pattern, ESM vs CJS recommendation, .nvmrc + package.json engines, config validation on startup (zod), operational vs catastrophic error distinction, centralised error handler, SIGTERM graceful shutdown, security headers (Helmet), structured logging to stdout (pino), health endpoint convention, CORS allowlist pattern, Docker multi-stage build, non-root USER, direct node command (not npm start), Alpine base images.

## [2026-04-12] create | Mission reframe + CodeRabbit page

Reframed the wiki's purpose from "AI-driven development best practices" to the more specific mission: high-quality vibe coding via a seven-layer guardrail stack.

**Files updated:**
- `README.md` — new mission statement with guardrail layer table
- `CLAUDE.md` — updated purpose paragraph naming all seven layers
- `SCHEMA.md` — new "design philosophy" section with numbered guardrail stack
- `index.md` — added mission note; renamed CI/CD section to "CI/CD & Code Review"
- `pages/new-project-checklist.md` — added Section 7b (CodeRabbit setup); updated dependent pages table

**Files created:**
- `pages/code-review-automation.md` — draft (confidence 72): CodeRabbit installation, .coderabbit.yaml full config, path-specific instructions, knowledge_base pointing at CLAUDE.md, slop detection, pre-merge checks, position in the guardrail stack

**Sources ingested:**
- https://docs.coderabbit.ai/reference/configuration
- https://docs.coderabbit.ai/guides/review-instructions
- https://docs.coderabbit.ai/getting-started/quickstart

**Key finding:** CodeRabbit is a strong fit for vibe coding workflows — it provides a second AI perspective that doesn't share Claude's biases, enforces the same standards documented in CLAUDE.md (via `knowledge_base.code_guidelines`), and includes `slop_detection` specifically for flagging low-quality AI-generated PRs.

## [2026-04-12] create | Clarify Neo4j hosting progression

Updated the project planning docs to make the intended hosting path explicit: local Neo4j first, then Neo4j Aura managed via Aura CLI once the local workflow is stable.

**Files updated:**
- `project-planning/neo4j-design-plan.md` — added local-to-Aura progression, CLI operations model, and phase guidance
- `project-planning/follow-on-questions.md` — refined Neo4j operations questions around local runtime defaults and Aura transition
