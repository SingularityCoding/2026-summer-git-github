#!/usr/bin/env bash
# Renders every assets/diagrams/**/*.mmd to a sibling .svg via mermaid-cli
# (mmdc). Authoring tool for this repo only — docs/ and slides.md reference
# the rendered .svg files, never the .mmd sources directly.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DIAGRAMS_DIR="$REPO_ROOT/assets/diagrams"

if ! command -v mmdc >/dev/null 2>&1; then
  echo "error: mermaid-cli (mmdc) not found on PATH." >&2
  echo "install it with: brew install mermaid-cli" >&2
  exit 1
fi

rendered=0
skipped=0

# find, not `shopt -s globstar`, so this also works under macOS's stock
# bash 3.2 (no globstar support), not just a Homebrew bash.
while IFS= read -r -d '' src; do
  rel="${src#"$REPO_ROOT"/}"

  if [ ! -s "$src" ]; then
    echo "skip (empty, not authored yet): $rel"
    skipped=$((skipped + 1))
    continue
  fi

  out="${src%.mmd}.svg"
  echo "rendering $rel -> ${out#"$REPO_ROOT"/}"
  mmdc -i "$src" -o "$out" -b transparent
  rendered=$((rendered + 1))
done < <(find "$DIAGRAMS_DIR" -name '*.mmd' -print0)

echo "done: rendered $rendered, skipped $skipped (empty)"
