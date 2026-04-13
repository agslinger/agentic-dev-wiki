#!/usr/bin/env bash
# Hook: PostToolUse (Write|Edit)
# Purpose: Run Biome on the file that was just written or edited.
# Falls back to next lint if Biome is not installed.
# Exits 0 always — PostToolUse cannot block, but stderr reaches Claude.

set -euo pipefail

INPUT=$(cat)
FILE=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

# Only lint JS/TS/JSX/TSX/JSON files
if [[ -z "$FILE" ]] || [[ ! "$FILE" =~ \.(js|mjs|cjs|ts|mts|cts|jsx|tsx|json)$ ]]; then
  exit 0
fi

if [[ ! -f "$FILE" ]]; then
  exit 0
fi

cd "$CLAUDE_PROJECT_DIR"

# Prefer Biome if installed, fall back to next lint
if npx --no-install @biomejs/biome --version >/dev/null 2>&1; then
  npx @biomejs/biome check "$FILE" 2>&1 || true
elif command -v npx >/dev/null 2>&1; then
  npx next lint --file "$FILE" 2>&1 || true
fi

exit 0
