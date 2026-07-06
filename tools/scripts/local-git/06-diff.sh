#!/usr/bin/env bash
# Captures real, reproducible transcript output for docs/local-git/06-diff.md.
# Not something students run — an authoring tool for this repo only.
#
# NOTE: design.md's git-diff topic also covers `git add -p` (notes.md). That
# subsection is being dropped from the course design, so it's intentionally
# not scripted here.
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/05-log.sh"

echo "third line" >> foobar.txt
git status
git diff

git add foobar.txt
git status
git diff
git diff --staged
