#!/usr/bin/env bash
# Captures real, reproducible transcript output for docs/local-git/07-restore.md.
# Not something students run — an authoring tool for this repo only.
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/06-diff.sh"

git status
git restore --staged foobar.txt
git status
git diff

git restore foobar.txt
git status
