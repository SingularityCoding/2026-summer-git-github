#!/usr/bin/env bash
# Captures real, reproducible transcript output for docs/local-git/05-log.md.
# Not something students run — an authoring tool for this repo only.
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/04-commit.sh"

git log

echo "second line" >> foobar.txt
git status
git add foobar.txt
git commit -m "Update foobar file"
git log

git log --oneline
