#!/usr/bin/env bash
set -euo pipefail

# Sync markdown agents to Claude destination.
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
AGENTS_DIR="$SCRIPT_DIR/agents"
CLAUDE_DEST="$HOME/.claude/agents"

if [[ ! -d "$AGENTS_DIR" ]]; then
  echo "agents directory not found: $AGENTS_DIR" >&2
  exit 1
fi

sync_file() {
  local src="$1"
  local rel_path="$2"

  local target="$CLAUDE_DEST/$rel_path"
  mkdir -p "$(dirname "$target")"

  # Only update if target doesn't exist or source is newer
  if [[ ! -f "$target" ]] || [[ "$src" -nt "$target" ]]; then
    cp "$src" "$target"
    echo "Updated: $target"
  fi
}

while IFS= read -r -d '' file; do
  rel="${file#$AGENTS_DIR/}"
  sync_file "$file" "$rel"
done < <(find "$AGENTS_DIR" -type f -name '*.md' -print0)
