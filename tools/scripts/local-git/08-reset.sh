#!/usr/bin/env bash
# Captures real, reproducible transcript output for docs/local-git/08-reset.md.
# Not something students run — an authoring tool for this repo only.
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/07-restore.sh"

echo "bad experiment" >> foobar.txt
git add foobar.txt
git commit -m "Bad experiment"
git log --oneline

git reset --soft HEAD~1
git status
git log --oneline

git commit -m "Bad experiment"
git reset HEAD~1
git status

echo "another bad experiment" >> foobar.txt
git add foobar.txt
git commit -m "Another bad experiment"
git log --oneline

git reset --hard HEAD~1
git status
git log --oneline
cat foobar.txt

git restore foobar.txt
git status
