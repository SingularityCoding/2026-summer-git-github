#!/usr/bin/env bash
# Captures real, reproducible transcript output for docs/local-git/09-gitignore.md.
# Not something students run — an authoring tool for this repo only.
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/08-reset.sh"

echo "debug log" > debug.log
echo "SECRET_KEY=dev-secret" > .env
git status

echo "*.log" > .gitignore
echo ".env" >> .gitignore
git status

git add .gitignore
git commit -m "Add gitignore"
git status

git status --ignored

echo "content" > extra.txt
rm foobar.txt
git status
git add -A
git status

# Clean the git-add--A demo back up so later topics see the same foobar.txt
# history as if this detour never happened.
git restore --staged --worktree foobar.txt
git restore --staged extra.txt
rm extra.txt
git status

echo "some local content" > local-only.txt
git add local-only.txt
git commit -m "Accidentally commit local-only file"

echo "local-only.txt" >> .gitignore
git rm --cached local-only.txt
git add .gitignore
git status
git commit -m "Stop tracking local-only file"
