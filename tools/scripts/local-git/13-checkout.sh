#!/usr/bin/env bash
# Captures real, reproducible transcript output for docs/local-git/13-checkout.md.
# Not something students run — an authoring tool for this repo only.
#
# design.md's `git checkout -b feature-name` aside isn't scripted, same
# reasoning as 12-switch.sh's `-c` aside — it's a syntax equivalence mention,
# not a transcript step, and would leave a stray branch behind.
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/12-switch.sh"

git checkout experiment
git branch
git checkout main
git branch

echo "temp edit" >> foobar.txt
git checkout -- foobar.txt
git status
