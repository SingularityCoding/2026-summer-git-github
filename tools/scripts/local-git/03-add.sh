#!/usr/bin/env bash
# Captures real, reproducible transcript output for docs/local-git/03-add.md.
# Not something students run — an authoring tool for this repo only.
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/02-status.sh"

git add foobar.txt
git status
