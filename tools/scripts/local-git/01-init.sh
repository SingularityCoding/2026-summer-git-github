#!/usr/bin/env bash
# Captures real, reproducible transcript output for docs/local-git/01-init.md.
# Not something students run — an authoring tool for this repo only.
#
# This is the head of the local-git script chain: 02-status.sh sources this
# file, 03-add.sh sources 02-status.sh, and so on. Running any later script
# standalone replays the whole chain from scratch (this script's `rm -rf`
# included), so captured output always reflects the exact same sequence of
# commands a student would have run, in one continuous playground repo.
set -euo pipefail

# Match the Prerequisites section's LANG setting so captured output mirrors
# what a student who followed the course setup actually sees.
export LANG=en_US.UTF-8

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"

rm -rf "$REPO_ROOT/playground"
cd "$REPO_ROOT"

mkdir playground
cd playground
git init
ls -a
