---
title: Document Parsing Stack
type: pattern
status: draft
confidence: 64
tags: [nodejs, typescript]
last-updated: 2026-04-12
sources:
  - "Mammoth.js: https://github.com/mwilliamson/mammoth.js"
  - "pdf-parse package: https://www.npmjs.com/package/pdf-parse"
  - "adm-zip package: https://www.npmjs.com/package/adm-zip"
  - "fast-xml-parser docs: https://naturalintelligence.github.io/fast-xml-parser/"
  - "xlsx package: https://www.npmjs.com/package/xlsx"
---

# Document Parsing Stack

## Read This When

- Building ingestion for PDFs, DOCX, ZIP archives, XML, or spreadsheets
- Deciding whether one parser can handle every document source

## Default Recommendation

- Use a small parsing stack with one library per file family.
- Normalize extracted output into one app schema before downstream AI or database steps.

## Use This Pattern

Recommended responsibilities:

- `pdf-parse` for PDFs
- `mammoth` for `.docx` to clean HTML or raw text
- `adm-zip` for archive inspection and extraction
- `fast-xml-parser` for XML inputs
- `xlsx` for spreadsheet parsing

This stack works when:

- documents arrive in multiple business formats
- extraction needs to feed AI metadata, search, or review flows

## Commands / Config

Key design rule:

- treat parsing output as untrusted input
- validate normalized output before storage or model calls

## Pitfalls

- Do not expect perfect semantic extraction from every document type.
- `mammoth` explicitly warns that complex DOCX-to-HTML conversion is imperfect and that untrusted inputs require care.
- Keep parsing separate from validation and AI enrichment.

## Related Pages

- [zod-4-validation](zod-4-validation.md)
- [openai-model-selection](openai-model-selection.md)
