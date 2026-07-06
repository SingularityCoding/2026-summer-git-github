#!/usr/bin/env bash
# Captures real, reproducible transcript output for docs/local-git/16-aliases.md.
# Not something students run — an authoring tool for this repo only.
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/15-merge-conflict.sh"

set +e
git config --global --get-regexp '^alias\.'
set -e

git config --global alias.st status
git config --global alias.br branch
git config --global alias.sw switch
git config --global alias.lg "log --oneline --graph --all"

git st
git br
git sw main
git lg

git config --global --unset alias.st

echo "quick fix" >> foobar.txt
git status
git commit -a -m "Quick fix"
git status
