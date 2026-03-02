---
name: codex-worker
description: Delegate large-scale or context-heavy implementation tasks to OpenAI Codex via MCP. Use when 10+ files need changing, extensive boilerplate, framework migrations, or context window is above 150K tokens.
allowed-tools: mcp__codex__codex, mcp__codex__codex-reply, Read, Bash
---

# Codex Worker (MCP)

Calls OpenAI Codex directly via the `mcp__codex__codex` MCP tool to handle
large-scale or pattern-based implementation work.

## When to Use (MUST)
- 10+ files need to be changed in a single task
- Primarily boilerplate generation (CRUD, schema stubs, test fixtures)
- Framework migration (e.g., class components → hooks, ORM swap)
- Single implementation step exceeds 50 lines across multiple files
- Context usage is above 150K tokens

## When NOT to Use (MUST NOT)
- TDD cycle iteration (test → implement → refactor)
- Architecture decisions requiring back-and-forth with user
- Change is under 20 lines
- Security review or credential handling
- Requirement clarification still in progress

## Gray Zone (Use Judgment)
- 20–50 lines: use if context above 100K tokens
- Files over 500 lines: prefer Codex even for targeted edits

## Procedure

### 1. Prepare a self-contained prompt for Codex
Include all context Codex needs (it has no shared context):
- Exact file paths
- What change is required and why
- Acceptance criteria
- Relevant code snippets / type definitions

### 2. Call Codex via MCP
```
mcp__codex__codex({ prompt: "..." })
```

### 3. Continue if needed
If Codex returns a partial result or asks a clarifying question, continue with:
```
mcp__codex__codex-reply({ message: "..." })
```

### 4. Validate the result
- Read modified files to verify changes match acceptance criteria
- Run test commands via Bash if applicable
- Retry with a corrected prompt on failure (max 2 retries)

### 5. Confirm result on feature branch
Codex operates independently — always run `git diff` to review what was changed
before committing.
