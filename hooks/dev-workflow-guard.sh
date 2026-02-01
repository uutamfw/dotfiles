#!/bin/bash

# PreToolUse hook: Inject dev workflow state into system-reminder
# Reads docs/{branch_name}/dev-workflow.yaml and directs the agent
# to execute the correct workflow phase (save → split → execute)

# Get branch name using same logic as plan-on-md
# feature/#468 -> 468, hotfix/#123 -> 123
raw_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
if [ -z "$raw_branch" ]; then exit 0; fi

branch_name=$(echo "$raw_branch" | sed 's|.*/||' | sed 's|^#||')

STATUS_FILE="docs/${branch_name}/dev-workflow.yaml"

if [ ! -f "$STATUS_FILE" ]; then exit 0; fi

# Find the first phase with status: Ready or In progress
# Phases are checked in order: save → split → execute
for phase in save split execute; do
  status=$(grep -A1 "^${phase}:" "$STATUS_FILE" | grep "status:" | awk '{print $2}')
  if [ "$status" = "Ready" ]; then
    case "$phase" in
      save)
        echo "DEV WORKFLOW: save=Ready. Use tmux to delegate: tmux send-keys -t <pane> 'claude \"/plan-on-md\"' Enter. Update YAML before/after."
        ;;
      split)
        echo "DEV WORKFLOW: split=Ready. Use tmux to delegate: tmux send-keys -t <pane> 'claude \"/plan-steps-split\"' Enter. Update YAML before/after."
        ;;
      execute)
        echo "DEV WORKFLOW: execute=Ready. Use tmux to delegate: tmux send-keys -t <pane> 'claude \"/proceed-by-step\"' Enter. Update YAML before/after."
        ;;
    esac
    exit 0
  fi
  if [ "$status" = "In progress" ]; then
    echo "DEV WORKFLOW: ${phase}=In progress. Continue the current phase. Do NOT skip ahead."
    exit 0
  fi
done

exit 0
