#!/usr/bin/env bash
# Hook: PostToolUse (Write|Edit)
# Purpose: Run ESLint on the file that was just written or edited.
# Exits 0 always — PostToolUse cannot block, but stderr reaches Claude.

set -euo pipefail

INPUT=$(cat)
FILE=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

# Only lint JS/TS files
if [[ -z "$FILE" ]] || [[ ! "$FILE" =~ \.(js|mjs|cjs|ts|mts|cts)$ ]]; then
  exit 0
fi

# Only lint if the file exists (Write may have been to a new file)
if [[ ! -f "$FILE" ]]; then
  exit 0
fi

# Run ESLint on the single file — quiet mode suppresses warnings, shows only errors
cd "$CLAUDE_PROJECT_DIR"
npx eslint --quiet "$FILE" 2>&1 || true

exit 0
