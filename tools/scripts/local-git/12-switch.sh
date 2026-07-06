#!/usr/bin/env bash
# Captures real, reproducible transcript output for docs/local-git/12-switch.md.
# Not something students run — an authoring tool for this repo only.
#
# design.md's `git switch -c feature-name` and `git switch -` asides are bare
# syntax mentions with no expected-output block, not a real transcript step
# (a "-c" demo here would also leave a stray branch complicating later
# topics' state) — intentionally not scripted.
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/11-branch.sh"

git switch experiment
git branch
git status

echo "experiment idea" >> foobar.txt
git status
git add foobar.txt
git commit -m "Try experiment idea"
git log --oneline

git switch main
git branch
cat foobar.txt
git log --oneline

git log --oneline --graph --all
