#!/usr/bin/env bash
# Hook: PreToolUse (Bash)
# Purpose: Block dangerous shell commands before they execute.
# Exit 0 with JSON deny → blocks the command.
# Exit 0 with no output → allows the command.

set -euo pipefail

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

# Patterns to block unconditionally
BLOCKED_PATTERNS=(
  'rm -rf /'
  'rm -rf ~'
  'rm -rf \.'
  'DROP TABLE'
  'DROP DATABASE'
  'DELETE FROM'
  'TRUNCATE TABLE'
  'pulumi destroy'
  'git push --force'
  'git reset --hard'
  'chmod 777'
)

for pattern in "${BLOCKED_PATTERNS[@]}"; do
  if echo "$COMMAND" | grep -qi "$pattern"; then
    jq -n \
      --arg reason "Blocked by project hook: pattern '$pattern' matched" \
      '{
        hookSpecificOutput: {
          hookEventName: "PreToolUse",
          permissionDecision: "deny",
          permissionDecisionReason: $reason
        }
      }'
    exit 0
  fi
done

# Warn (but allow) for commands that modify infra
if echo "$COMMAND" | grep -qi 'pulumi up'; then
  jq -n '{
    hookSpecificOutput: {
      hookEventName: "PreToolUse",
      permissionDecision: "ask",
      permissionDecisionReason: "pulumi up modifies live infrastructure — confirm with user"
    }
  }'
  exit 0
fi

# Allow everything else
exit 0
