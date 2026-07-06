#!/usr/bin/env bash
# Captures real, reproducible transcript output for docs/local-git/15-merge-conflict.md.
# Not something students run — an authoring tool for this repo only.
#
# Includes the --no-ff/--ff-only asides at the end, matching design.md's own
# section boundary (they're textually part of "#### 15. Merge conflict").
# The `git merge conflict-a` line is expected to fail (that's the whole
# point), so it's the one command in this whole chain allowed to fail.
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/14-merge.sh"

git switch main
git status
git switch -c conflict-a
printf "hello from conflict-a\nsecond line\nexperiment idea\n" > foobar.txt
git add foobar.txt
git commit -m "Update greeting on conflict branch"

git switch main
printf "hello from main\nsecond line\nexperiment idea\n" > foobar.txt
git add foobar.txt
git commit -m "Update greeting on main"

set +e
git merge conflict-a
set -e
git status
cat foobar.txt

git config --global merge.conflictstyle zdiff3

printf "hello from main and conflict branch\nsecond line\nexperiment idea\n" > foobar.txt
git add foobar.txt
git status
git commit -m "Resolve greeting conflict"
git log --oneline --graph --all

git branch -d conflict-a

git switch -c feature-note
echo "feature note" >> foobar.txt
git add foobar.txt
git commit -m "Add feature note"

git switch main
git merge --no-ff feature-note
git log --oneline --graph --all

git branch -d feature-note
git switch -c feature-two
echo "feature two" >> foobar.txt
git add foobar.txt
git commit -m "Add feature two"

git switch main
git merge --ff-only feature-two
git log --oneline --graph --all
