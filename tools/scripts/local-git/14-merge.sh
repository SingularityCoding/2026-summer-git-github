#!/usr/bin/env bash
# Captures real, reproducible transcript output for docs/local-git/14-merge.md.
# Not something students run — an authoring tool for this repo only.
#
# design.md's "#### 14. `git merge`" section covers fast-forward only — the
# --no-ff/--ff-only asides are textually part of "#### 15. Merge conflict"
# (they come after the conflict scenario in design.md), so they're scripted
# in 15-merge-conflict.sh instead, not here.
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/13-checkout.sh"

git switch main
git status
git branch

git merge experiment
git status
cat foobar.txt
git log --oneline --graph --all

git branch -d experiment
git branch
