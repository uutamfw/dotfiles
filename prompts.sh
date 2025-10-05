#!/usr/bin/env bash
set -euo pipefail

# Sync markdown prompts to Codex and Claude destinations.
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
PROMPTS_DIR="$SCRIPT_DIR/prompts"
CODEX_DEST="$HOME/.codex/prompts"
CLAUDE_DEST="$HOME/.claude/commands"

if [[ ! -d "$PROMPTS_DIR" ]]; then
  echo "prompts directory not found: $PROMPTS_DIR" >&2
  exit 1
fi

sync_file() {
  local src="$1"
  local rel_path="$2"

  local codex_rel
  codex_rel="${rel_path//\//_}"
  local codex_target="$CODEX_DEST/$codex_rel"
  mkdir -p "$(dirname "$codex_target")"
  if [[ ! -f "$codex_target" ]] || ! cmp -s "$src" "$codex_target"; then
    cp "$src" "$codex_target"
    echo "Updated Codex: $codex_target"
  fi

  local claude_target="$CLAUDE_DEST/$rel_path"
  mkdir -p "$(dirname "$claude_target")"
  if [[ ! -f "$claude_target" ]] || ! cmp -s "$src" "$claude_target"; then
    cp "$src" "$claude_target"
    echo "Updated Claude: $claude_target"
  fi
}

while IFS= read -r -d '' file; do
  rel="${file#$PROMPTS_DIR/}"
  sync_file "$file" "$rel"
done < <(find "$PROMPTS_DIR" -type f -name '*.md' -print0)
