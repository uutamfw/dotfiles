#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="$SCRIPT_DIR/ghbundle.yaml"
EXTENSIONS=$(yq e '.extensions[]' "$CONFIG_FILE")
INSTALLED=$(gh extension list | awk '{print $1}')

for ext in $EXTENSIONS; do
  if echo "$INSTALLED" | grep -q "$ext"; then
    echo "🔄 Updating $ext"
    gh extension upgrade "$ext" || gh extension install "$ext" --force
    continue
  fi

  echo "⬇️ Installing $ext"
  gh extension install "$ext"
done
