#!/usr/bin/env bash
# Captures real, reproducible transcript output for docs/local-git/04-commit.md.
# Not something students run — an authoring tool for this repo only.
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/03-add.sh"

git commit -m "Add foobar file"
git status
