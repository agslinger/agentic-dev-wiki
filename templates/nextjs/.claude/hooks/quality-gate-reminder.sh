#!/usr/bin/env bash
# Hook: Stop
# Purpose: When Claude finishes a response, check whether quality gates have been
#          verified in this session. If not, inject a reminder into Claude's context.
# This hook cannot block (Stop hooks with exit 2 prevent Claude from stopping,
# which is usually not what you want). Instead it provides advisory context.

set -euo pipefail

INPUT=$(cat)
TRANSCRIPT=$(echo "$INPUT" | jq -r '.transcript_path // empty')

# Check if tests and lint were run in this session by scanning the transcript
TESTS_RUN=false
LINT_RUN=false

if [[ -n "$TRANSCRIPT" ]] && [[ -f "$TRANSCRIPT" ]]; then
  if grep -q '"npm test\|vitest run\|npm run test' "$TRANSCRIPT" 2>/dev/null; then
    TESTS_RUN=true
  fi
  if grep -q '"npm run lint\|npx eslint' "$TRANSCRIPT" 2>/dev/null; then
    LINT_RUN=true
  fi
fi

WARNINGS=""
if [[ "$TESTS_RUN" == "false" ]]; then
  WARNINGS="${WARNINGS}Tests were not run in this session. "
fi
if [[ "$LINT_RUN" == "false" ]]; then
  WARNINGS="${WARNINGS}Lint was not run in this session. "
fi

if [[ -n "$WARNINGS" ]]; then
  jq -n --arg w "$WARNINGS" '{
    decision: "block",
    reason: ("Quality gate reminder: " + $w + "Consider running npm test and npm run lint before finishing.")
  }'
  exit 0
fi

exit 0
