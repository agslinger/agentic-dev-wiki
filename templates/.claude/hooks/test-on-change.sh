#!/usr/bin/env bash
# Hook: PostToolUse (Write|Edit)
# Purpose: Run the related test file when a source or test file changes.
# Exits 0 always — informational feedback to Claude.

set -euo pipefail

INPUT=$(cat)
FILE=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

# Only act on JS/TS files
if [[ -z "$FILE" ]] || [[ ! "$FILE" =~ \.(js|mjs|cjs|ts|mts|cts)$ ]]; then
  exit 0
fi

cd "$CLAUDE_PROJECT_DIR"

# Determine which test file to run
if [[ "$FILE" =~ \.test\. ]] || [[ "$FILE" =~ \.spec\. ]]; then
  # File is itself a test — run it directly
  TEST_FILE="$FILE"
else
  # Look for a co-located test file
  BASE="${FILE%.*}"
  EXT="${FILE##*.}"
  TEST_FILE=""
  for pattern in "${BASE}.test.${EXT}" "${BASE}.spec.${EXT}"; do
    if [[ -f "$pattern" ]]; then
      TEST_FILE="$pattern"
      break
    fi
  done
fi

if [[ -z "$TEST_FILE" ]]; then
  # No related test found — skip silently
  exit 0
fi

# Run only the related test (fast feedback, not the full suite)
npx vitest run "$TEST_FILE" --reporter=verbose 2>&1 || true

exit 0
