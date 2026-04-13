#!/usr/bin/env bash
# Hook: PostToolUse (Write|Edit)
# Purpose: Run the related test file when a source or test file changes.
# Handles both .ts and .tsx extensions common in Next.js projects.
# Exits 0 always — informational feedback to Claude.

set -euo pipefail

INPUT=$(cat)
FILE=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

# Only act on JS/TS/JSX/TSX files
if [[ -z "$FILE" ]] || [[ ! "$FILE" =~ \.(js|ts|jsx|tsx)$ ]]; then
  exit 0
fi

cd "$CLAUDE_PROJECT_DIR"

# Determine which test file to run
if [[ "$FILE" =~ \.test\. ]] || [[ "$FILE" =~ \.spec\. ]]; then
  TEST_FILE="$FILE"
else
  # Look for co-located test file with same base name
  BASE="${FILE%.*}"
  TEST_FILE=""
  for ext in test.ts test.tsx test.js test.jsx spec.ts spec.tsx; do
    if [[ -f "${BASE}.${ext}" ]]; then
      TEST_FILE="${BASE}.${ext}"
      break
    fi
  done
fi

if [[ -z "$TEST_FILE" ]]; then
  exit 0
fi

npx vitest run "$TEST_FILE" --reporter=verbose 2>&1 || true

exit 0
