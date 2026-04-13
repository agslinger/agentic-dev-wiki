---
title: Claude Code Hooks
type: pattern
status: draft
confidence: 85
tags: [claude-code, ai-agent, hooks, automation]
last-updated: 2026-04-12
sources:
  - "Anthropic Claude Code hooks docs: https://code.claude.com/docs/en/hooks"
---

# Claude Code Hooks

> **Status: draft** — sourced from official Anthropic Claude Code docs (April 2026).

---

## What hooks are

Hooks are shell commands (or HTTP endpoints, prompts, or agents) that Claude Code executes at specific lifecycle points. They let you enforce guardrails, run linters automatically, log activity, and block unwanted actions — all without modifying your codebase.

---

## Hook event types

### Tool execution events

| Event | When it fires | Can block? |
|---|---|---|
| `PreToolUse` | Before any tool runs | Yes (exit 2 or JSON deny) |
| `PostToolUse` | After tool succeeds | No (tool already ran) |
| `PostToolUseFailure` | After tool fails | No |
| `PermissionRequest` | When permission dialog appears | Yes |
| `PermissionDenied` | When auto-mode classifier denies a call | No |

### Session events

| Event | When it fires |
|---|---|
| `SessionStart` | Session begins or resumes |
| `SessionEnd` | Session terminates |
| `UserPromptSubmit` | User submits a prompt (before processing) — can block/erase |
| `Stop` | Claude finishes responding — can prevent stop |
| `StopFailure` | Turn ends due to API error |

### Agent / task events

| Event | When it fires |
|---|---|
| `SubagentStart` | Subagent spawned |
| `SubagentStop` | Subagent finishes — can prevent stop |
| `TaskCreated` | Task creation via TaskCreate tool — can roll back |
| `TaskCompleted` | Task marked complete |

### Other events

| Event | When it fires |
|---|---|
| `Notification` | Claude Code sends a notification |
| `InstructionsLoaded` | CLAUDE.md or rules files loaded — useful for debugging |
| `FileChanged` | Watched file changes (async) |
| `CwdChanged` | Working directory changes |
| `ConfigChange` | Configuration file changes — can block |
| `PreCompact` / `PostCompact` | Context compaction events |
| `Elicitation` / `ElicitationResult` | MCP server user input requests |
| `WorktreeCreate` / `WorktreeRemove` | Worktree lifecycle |

---

## Configuration locations

```
~/.claude/settings.json              ← all projects (local machine only)
.claude/settings.json                ← single project (committable, shareable)
.claude/settings.local.json          ← single project (gitignored, personal)
Plugin hooks/hooks.json              ← when plugin is enabled
Skill / Agent frontmatter            ← while that component is active
```

Prefer `.claude/settings.json` for shared team hooks. Use `.claude/settings.local.json` for personal or machine-specific hooks you don't want committed.

---

## Configuration schema

Three-level nesting: `hooks → EVENT_NAME → array of matcher groups → array of hook handlers`:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/lint.sh",
            "timeout": 30,
            "async": false
          }
        ]
      }
    ]
  }
}
```

### Matcher patterns

| Pattern | Evaluation |
|---|---|
| `"*"`, `""`, omitted | Match all — fires on every occurrence of this event |
| Letters, digits, `_`, `\|` | Exact tool name or pipe-delimited list (e.g. `Write\|Edit`) |
| Any other characters | JavaScript regex (e.g. `^Notebook`, `mcp__memory__.*`) |

**MCP tool naming:** `mcp__<server>__<tool>` — e.g. match all memory server tools with `mcp__memory__.*`

---

## Hook handler types

### `command` (most common)

```json
{
  "type": "command",
  "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/my-hook.sh",
  "timeout": 60,
  "shell": "bash",
  "async": false
}
```

The script receives JSON on stdin and communicates back via exit code + stdout/stderr.

### `http`

```json
{
  "type": "http",
  "url": "http://localhost:8080/hooks/pre-tool-use",
  "timeout": 30,
  "headers": { "Authorization": "Bearer $MY_TOKEN" },
  "allowedEnvVars": ["MY_TOKEN"]
}
```

POSTs JSON body; response uses same format as command hooks.

### `prompt` / `agent`

```json
{ "type": "prompt", "prompt": "Should this be allowed? $ARGUMENTS", "model": "claude-opus" }
{ "type": "agent",  "prompt": "Verify this action is safe: $ARGUMENTS", "timeout": 60 }
```

---

## Hook input format (stdin JSON)

All hooks receive this JSON on stdin (or as the HTTP POST body):

```json
{
  "session_id": "abc123",
  "transcript_path": "/path/to/transcript.jsonl",
  "cwd": "/home/user/project",
  "permission_mode": "default",
  "hook_event_name": "PreToolUse",
  "agent_id": "agent-xyz",
  "agent_type": "Explore"
}
```

**`PreToolUse` adds:** `tool_name`, `tool_input` (object with tool-specific fields), `tool_use_id`

**`PostToolUse` adds:** `tool_name`, `tool_input`, `tool_response`, `tool_use_id`

---

## Exit codes and return behaviour

| Exit code | Meaning | Effect |
|---|---|---|
| `0` | Success | Parses JSON from stdout for fine-grained control |
| `2` | **Blocking error** | Ignores stdout; stderr is fed to Claude as context |
| Any other | Non-blocking error | Logs to debug; execution continues |

**Only exit code 2 blocks.** Exit code 1 is non-blocking — a common mistake.

### What exit 2 does per event

| Event | Effect |
|---|---|
| `PreToolUse` | Blocks the tool call |
| `PermissionRequest` | Denies the permission |
| `UserPromptSubmit` | Blocks and erases the prompt |
| `Stop` | Prevents Claude from stopping (forces another response) |
| `SubagentStop` | Prevents subagent stop |
| `TaskCreated` | Rolls back the task creation |
| `ConfigChange` | Blocks the config change |
| `PostToolUse` | Tool already ran; stderr shown to Claude |

---

## JSON output schema (exit 0)

Return JSON on stdout for fine-grained control:

```json
{
  "continue": true,
  "suppressOutput": false,
  "systemMessage": "Warning: this action modifies prod data",
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "allow|deny|ask|defer",
    "permissionDecisionReason": "Reason shown to user",
    "updatedInput": { "command": "safe_modified_command" },
    "additionalContext": "Extra context injected into Claude"
  }
}
```

**Permission decisions:**
- `"allow"` — skip permission prompt, proceed
- `"deny"` — block the tool call
- `"ask"` — prompt the user to confirm
- `"defer"` — pause for external handling (SDK/headless only)

---

## Environment variables in hooks

| Variable | Value |
|---|---|
| `$CLAUDE_PROJECT_DIR` | Absolute path to the project root |
| `$CLAUDE_PLUGIN_ROOT` | Plugin installation directory |
| `$CLAUDE_PLUGIN_DATA` | Plugin persistent data directory |
| `$CLAUDE_CODE_REMOTE` | `"true"` in remote environments |
| `$CLAUDE_ENV_FILE` | File path for persisting env vars (SessionStart, CwdChanged, FileChanged only) |

**Persisting environment variables** across the session (SessionStart hook):

```bash
#!/bin/bash
if [ -n "$CLAUDE_ENV_FILE" ]; then
  echo 'export NODE_ENV=production' >> "$CLAUDE_ENV_FILE"
  echo 'export PATH="$PATH:./node_modules/.bin"' >> "$CLAUDE_ENV_FILE"
fi
exit 0
```

---

## Common hook patterns

### Auto-lint on Write/Edit

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/lint-check.sh"
          }
        ]
      }
    ]
  }
}
```

```bash
#!/bin/bash
# .claude/hooks/lint-check.sh
FILE=$(jq -r '.tool_input.file_path // .tool_input.new_string' < /dev/stdin)
npx eslint --quiet "$FILE" 2>&1
# exit 0 regardless: PostToolUse can't block, but stderr goes to Claude
exit 0
```

### Block destructive shell commands

```bash
#!/bin/bash
# .claude/hooks/block-rm.sh
COMMAND=$(jq -r '.tool_input.command' < /dev/stdin)

if echo "$COMMAND" | grep -qE 'rm -rf|DROP TABLE|DELETE FROM'; then
  jq -n '{
    hookSpecificOutput: {
      hookEventName: "PreToolUse",
      permissionDecision: "deny",
      permissionDecisionReason: "Destructive command blocked by project hook"
    }
  }'
  exit 0
fi
exit 0
```

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [{ "type": "command", "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/block-rm.sh" }]
      }
    ]
  }
}
```

### Log all tool calls

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "*",
        "hooks": [
          {
            "type": "command",
            "command": "jq -c '{ts: now|todate, event: .hook_event_name, tool: .tool_name}' >> ~/claude-audit.log; exit 0",
            "async": true
          }
        ]
      }
    ]
  }
}
```

### Notify on task completion

```json
{
  "hooks": {
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "osascript -e 'display notification \"Claude finished\" with title \"Claude Code\"'; exit 0",
            "async": true
          }
        ]
      }
    ]
  }
}
```

---

## Advanced options

| Option | Effect |
|---|---|
| `"async": true` | Runs hook in background without blocking Claude |
| `"once": true` | Runs only once per session then removes itself (skills only) |
| `"disableAllHooks": true` | Disables all hooks (in settings JSON) |
| `allowManagedHooksOnly` | Enterprise: blocks user/project hooks while allowing managed hooks |

---

## Security considerations

- Hooks run with the same OS permissions as Claude Code — they can read/write files, access the network, and execute arbitrary code
- Treat `.claude/settings.json` like executable code — review before committing
- Use `.claude/settings.local.json` (gitignored) for hooks with secrets or personal credentials
- Managed policy hooks (`/etc/claude-code/`) cannot be disabled by user settings

---

## Troubleshooting

| Symptom | Cause | Fix |
|---|---|---|
| JSON validation failed | Shell profile prints text on startup, corrupting stdout | Guard profile output with `[ -z "$PS1" ] && return` |
| Hook not firing | Wrong matcher or event name | Check with `/hooks` menu in Claude Code |
| Exit 1 not blocking | Only exit 2 blocks | Change `exit 1` to `exit 2` in your script |
| Hook output not reaching Claude | Using `PostToolUse` | Switch to `PreToolUse` if you need to block; PostToolUse is informational only |
