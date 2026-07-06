#!/usr/bin/env bash
# Captures real, reproducible transcript output for docs/local-git/02-status.md.
# Not something students run — an authoring tool for this repo only.
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/01-init.sh"

git status

echo "hello git" > foobar.txt
git status

git status --short
git status -s
