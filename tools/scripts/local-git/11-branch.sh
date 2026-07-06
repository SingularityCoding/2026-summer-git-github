#!/usr/bin/env bash
# Captures real, reproducible transcript output for docs/local-git/11-branch.md.
# Not something students run — an authoring tool for this repo only.
#
# design.md's `git branch -m`/`git branch -d` asides use placeholder names
# (old-name, branch-name) that don't exist in this repo — they're illustrative
# syntax, not a real transcript step, so they're intentionally not scripted.
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/10-config.sh"

git branch

git branch experiment
git branch
