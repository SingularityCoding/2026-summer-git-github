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
SCRATCH_DIR="$REPO_ROOT/.scratch"
PLAYGROUND_DIR="$REPO_ROOT/playground"

rm -rf "$SCRATCH_DIR" "$PLAYGROUND_DIR"
mkdir -p "$SCRATCH_DIR/home"

# Sandbox $HOME for the whole chain so later --global config demos (topic 10
# writes to `~/.gitconfig` and `~/.gitignore_global`) can run for real without
# ever touching the actual machine running this script. GIT_CONFIG_NOSYSTEM
# also keeps the host's /etc/gitconfig out of the picture.
export HOME="$SCRATCH_DIR/home"
export GIT_CONFIG_NOSYSTEM=1

git config --global init.defaultBranch main
git config --global user.name "Course Instructor"
git config --global user.email "instructor@example.com"
git config --global core.autocrlf input

cd "$REPO_ROOT"
mkdir playground
cd playground
git init
ls -a
