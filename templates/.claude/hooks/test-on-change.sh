#!/usr/bin/env bash
set -euo pipefail

INPUT=$(cat)
FILE=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

if [[ -z "$FILE" ]] || [[ ! "$FILE" =~ \.(js|ts|jsx|tsx)$ ]]; then
  exit 0
fi

cd "$CLAUDE_PROJECT_DIR"

if [[ "$FILE" =~ \.test\. ]] || [[ "$FILE" =~ \.spec\. ]]; then
  TEST_FILE="$FILE"
else
  BASE="${FILE%.*}"
  TEST_FILE=""
  for ext in test.ts test.tsx test.js test.jsx spec.ts spec.tsx spec.js spec.jsx; do
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
