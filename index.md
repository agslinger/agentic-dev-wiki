# Wiki Index

Read this first. Use it to choose the smallest useful set of pages.

Last updated: 2026-04-12

## How To Use This Index

- Start with the section that matches the task.
- Prefer pages tagged to the project stack.
- Read the page whose `Read This When` best matches the problem.
- Prefer `draft` and `complete` pages over `stub` pages.

## AI Agent Configuration

| Page | Read when | Status | Tags |
|---|---|---|---|
| [claude-md-conventions](pages/claude-md-conventions.md) | Writing or restructuring `CLAUDE.md`, `AGENTS.md`, or `.claude/rules/` | draft | `claude-code` `ai-agent` `agents-md` |
| [claude-code-hooks](pages/claude-code-hooks.md) | Adding Claude automation, guardrails, or local/shared hook configuration | draft | `claude-code` `ai-agent` `hooks` |
| [agent-instruction-design](pages/agent-instruction-design.md) | Improving agent output quality, structuring instructions with RISEN, choosing RPI vs QRSPI workflow, enforcement pyramid | draft | `claude-code` `ai-agent` `agents-md` `llm` |

## Node.js Application Patterns

| Page | Read when | Status | Tags |
|---|---|---|---|
| [nodejs-patterns](pages/nodejs-patterns.md) | Starting a Node.js service or choosing service structure defaults | draft | `nodejs` `javascript` |
| [typescript-strict-mode](pages/typescript-strict-mode.md) | Choosing TypeScript defaults and deciding whether strict mode should be mandatory | draft | `typescript` `javascript` |
| [react-tailwind-shadcn-ui](pages/react-tailwind-shadcn-ui.md) | Choosing the main React UI stack and deciding when Tailwind + shadcn/ui is a good fit | draft | `nodejs` `javascript` `typescript` |
| [lucide-react-icons](pages/lucide-react-icons.md) | Standardizing icons across a React and shadcn/ui stack | draft | `javascript` `typescript` |
| [geist-fonts](pages/geist-fonts.md) | Deciding whether to keep Geist as the default typography pair in a Next.js app | draft | `javascript` `typescript` |
| [recharts](pages/recharts.md) | Adding dashboard charts and deciding when Recharts is the right complexity level | draft | `javascript` `typescript` |
| [markdown-rendering](pages/markdown-rendering.md) | Rendering markdown safely in React with GFM support | draft | `javascript` `typescript` |
| [react-frontend-patterns](pages/react-frontend-patterns.md) | Bootstrapping a React frontend and deciding which early project defaults to lock down | draft | `nodejs` `javascript` `typescript` |
| [nextjs-patterns](pages/nextjs-patterns.md) | Bootstrapping a Next.js app and deciding when App Router and scaffold defaults are the right fit | draft | `nodejs` `javascript` `typescript` |
| [drizzle-orm](pages/drizzle-orm.md) | Choosing a SQL-centric TypeScript ORM and deciding when Drizzle fits better than a heavier data layer | draft | `typescript` |
| [postgres-pgvector](pages/postgres-pgvector.md) | Choosing one database for relational data plus vector similarity search | draft | `typescript` |
| [vercel-ai-sdk](pages/vercel-ai-sdk.md) | Building streaming, tool-calling, or structured AI features with a provider-agnostic SDK | draft | `nodejs` `typescript` |
| [claude-bedrock-models](pages/claude-bedrock-models.md) | Choosing between Claude Opus and Sonnet on Amazon Bedrock | draft | `nodejs` `typescript` |
| [openai-model-selection](pages/openai-model-selection.md) | Splitting OpenAI models across extraction, synthesis, and embeddings | draft | `nodejs` `typescript` |
| [document-parsing-stack](pages/document-parsing-stack.md) | Building a multi-format document ingestion pipeline | draft | `nodejs` `typescript` |
| [zod-4-validation](pages/zod-4-validation.md) | Validating runtime and AI-produced data with inferred TypeScript types | draft | `typescript` |
| [biome](pages/biome.md) | Choosing one tool for formatting, linting, and import organization | draft | `linting` `formatting` `javascript` `typescript` |
| [linting-setup](pages/linting-setup.md) | Adding linting, formatting, or pre-commit quality checks | draft | `nodejs` `linting` `eslint` `prettier` |
| [testing-setup](pages/testing-setup.md) | Choosing a Node.js test runner or setting up HTTP and unit tests | draft | `nodejs` `testing` `jest` `vitest` |
| [nextjs-testing](pages/nextjs-testing.md) | Adding a practical test stack for Next.js with Vitest fast feedback and Playwright E2E | draft | `nodejs` `testing` `vitest` `integration-test` |

## Infrastructure As Code

| Page | Read when | Status | Tags |
|---|---|---|---|
| [pulumi-gcp-patterns](pages/pulumi-gcp-patterns.md) | Building Pulumi YAML stacks on GCP or wiring serverless infrastructure | draft | `pulumi` `iac` `gcp` `nodejs` `serverless` |

## CI/CD And Review

| Page | Read when | Status | Tags |
|---|---|---|---|
| [cicd-github-actions](pages/cicd-github-actions.md) | Adding CI, deploy workflows, PR previews, or OIDC auth | draft | `cicd` `github-actions` `automation` `pulumi` `gcp` |
| [vercel-deployment](pages/vercel-deployment.md) | Choosing Vercel as the default low-friction deploy path for a Next.js app | draft | `cicd` `automation` `nodejs` |
| [code-review-automation](pages/code-review-automation.md) | Adding CodeRabbit or an AI review layer on pull requests | draft | `cicd` `github-actions` `automation` `ai-agent` `code-review` |

## Security

| Page | Read when | Status | Tags |
|---|---|---|---|
| [security-scanning](pages/security-scanning.md) | Adding secret scanning, dependency checks, or secret-handling rules | draft | `security` `secrets` `gitleaks` `nodejs` `cicd` |

## Bootstrapping

| Page | Read when | Status | Tags |
|---|---|---|---|
| [new-project-checklist](pages/new-project-checklist.md) | Bootstrapping a new project and needing the default order of work | stub | `checklist` `nodejs` `pulumi` `claude-code` |
| [project-templates](pages/project-templates.md) | Copying ready-to-use CLAUDE.md, AGENTS.md, hooks, and rules into a new project | draft | `claude-code` `ai-agent` `agents-md` `hooks` `nodejs` |

## Status Legend

| Status | Meaning |
|---|---|
| `stub` | Structure only |
| `draft` | Useful but still evolving |
| `complete` | Verified and stable |
