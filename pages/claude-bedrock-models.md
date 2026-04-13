---
title: Claude Models on Amazon Bedrock
type: pattern
status: draft
confidence: 82
tags: [nodejs, typescript]
last-updated: 2026-04-12
sources:
  - "Amazon Bedrock overview: https://docs.aws.amazon.com/bedrock/latest/userguide/what-is-bedrock.html"
  - "Anthropic models on Bedrock: https://docs.aws.amazon.com/bedrock/latest/userguide/model-cards-anthropic.html"
  - "Claude Opus 4.6 model card: https://docs.aws.amazon.com/bedrock/latest/userguide/model-card-anthropic-claude-opus-4-6.html"
---

# Claude Models on Amazon Bedrock

## Read This When

- Choosing Claude models through Bedrock
- Splitting heavy reasoning work from lighter extraction work

## Default Recommendation

- Use Claude Opus 4.6 for the hardest reasoning, review, and deep analysis tasks.
- Use Claude Sonnet 4.6 for lighter or higher-throughput tasks where cost/latency matter more.

## Use This Pattern

Bedrock’s Anthropic model catalog describes:

- Claude Opus 4.6 as Anthropic’s flagship model for careful planning and long-running agentic work
- Claude Sonnet 4.6 as the upgraded mid-tier model for coding, computer use, long-context reasoning, and agent planning

This split works well in the wider stack:

- use Sonnet-class models for extraction, classification, and routine flows
- escalate to Opus-class models for difficult synthesis or review paths
- access both through Bedrock for AWS-centric hosting and governance

## Commands / Config

Use Bedrock when the app already needs:

- AWS-native model access
- centralized governance or billing through AWS
- compatibility with Bedrock model APIs

## Pitfalls

- Do not use the flagship model for every step in a pipeline.
- Do not assume “Claude Sonnet” without a version; pick the exact Bedrock model ID you intend to use.
- Separate model policy from feature code so routing can evolve over time.

## Related Pages

- [vercel-ai-sdk](vercel-ai-sdk.md)
- [openai-model-selection](openai-model-selection.md)
