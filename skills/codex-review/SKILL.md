---
name: codex-review
description: tmux で動作する Codex CLI にプロンプトを送信し、ポーリングでレスポンスが完了するまで待機して取得する。「codex に聞いて」「codex で調べて」などのリクエストで使用。
allowed-tools: Bash(tmux:*)
---

# Codex tmux Skill

Sends a prompt to a Codex CLI session running in a tmux pane and polls until
the response is complete.

## Procedure

### 1. Identify the Codex pane

```bash
tmux list-panes -a -F '#{session_name}:#{window_index}.#{pane_index}  #{pane_current_command}  #{pane_title}'
```

Find the pane whose command is `codex` (or `node` if Codex is running via Node).
If the user didn't specify a pane, pick the first match.

If **no matching pane is found**, proceed to Step 1.5 to auto-launch Codex.
Otherwise, set `<pane>` to the matched pane and skip to Step 2.

### 1.5. Auto-launch Codex (only if no pane found in Step 1)

```bash
# Create a new window named "codex" in the main session
tmux new-window -t main -n codex
# Launch codex (inherits env from shell, including API keys via ~/.zshrc)
tmux send-keys -t main:codex 'codex' C-m
```

Then poll every 2 s until the `› ` idle prompt appears (max 30 s):

```bash
for i in $(seq 1 15); do
  sleep 2
  output=$(tmux capture-pane -p -t main:codex -S -50)
  echo "$output" | grep -qE '›\s*$' && break
done
```

Set `<pane>` to `main:codex`.

If the loop completes without seeing `› `, abort and report:
> "Codex の起動を確認できませんでした。`codex` コマンドが PATH にあるか確認してください。"

### 2. Capture a baseline snapshot

```bash
tmux capture-pane -p -t <pane> -S -200
```

Save this as the **baseline** so you know where the new response starts.

### 3. Send the prompt

Detect whether `$prompt` contains newlines and use the appropriate method:

**Single-line prompt:**
```bash
tmux send-keys -t <pane> '<prompt>' C-m
```

**Multi-line prompt (contains `\n`):**
```bash
# 1. Write to temp file
printf '%s' "$prompt" > /tmp/tmux_send.txt
# 2. Load into tmux buffer
tmux load-buffer /tmp/tmux_send.txt
# 3. Paste into pane (preserves newlines)
tmux paste-buffer -t <pane>
sleep 0.5
# 4. Execute
tmux send-keys -t <pane> C-m
```

### 4. Poll until response is complete

Repeat every 3 seconds (max 120 s total):

```bash
tmux capture-pane -p -t <pane> -S -200
```

Stop polling when **either** condition is met:
- The last non-empty line of the captured output ends with `› ` (Codex idle prompt)
- Two consecutive captures are identical (output has stabilised)

### 5. Extract and return the response

Take the diff between the baseline and the final capture. Strip the trailing
`› ` prompt line. Return the extracted text to the user.

### 6. Timeout handling

If 120 s elapse without detecting completion, return whatever was captured
and note that the timeout was reached so the user can check manually.
