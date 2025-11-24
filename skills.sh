#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
SKILLS_DIR="$SCRIPT_DIR/skills"
CLAUDE_DEST="$HOME/.claude/skills"

if [[ ! -d "$SKILLS_DIR" ]]; then
  echo "skills directory not found: $SKILLS_DIR" >&2
  exit 1
fi

get_mtime() {
  local target="$1"

  if [[ ! -e "$target" ]]; then
    echo 0
    return
  fi

  if stat -f %m "$target" >/dev/null 2>&1; then
    stat -f %m "$target"
  else
    stat -c %Y "$target"
  fi
}

if [[ -d "$CLAUDE_DEST" ]]; then
  src_mtime=$(get_mtime "$SKILLS_DIR")
  dest_mtime=$(get_mtime "$CLAUDE_DEST")
  if (( src_mtime <= dest_mtime )); then
    echo "skills directory not newer than destination; nothing to do."
    exit 0
  fi
fi

mkdir -p "$CLAUDE_DEST"

sync_file() {
  local src="$1"
  local rel_path="$2"
  local target="$CLAUDE_DEST/$rel_path"

  mkdir -p "$(dirname "$target")"
  if [[ ! -f "$target" ]] || ! cmp -s "$src" "$target"; then
    cp "$src" "$target"
    echo "Updated: $target"
    return 0
  fi

  return 1
}

updated=0
while IFS= read -r -d '' file; do
  rel_path="${file#$SKILLS_DIR/}"
  if sync_file "$file" "$rel_path"; then
    updated=1
  fi
done < <(find "$SKILLS_DIR" -type f -name '*.md' -print0)

if [[ $updated -eq 0 ]]; then
  echo "All skill markdown files already up to date."
fi
