#!/usr/bin/env bash
# Captures real, reproducible transcript output for docs/local-git/10-config.md.
# Not something students run — an authoring tool for this repo only.
#
# Safe to actually run the --global demos for real: 01-init.sh sandboxes
# $HOME for the whole chain, so these never touch the machine running the
# script.
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/09-gitignore.sh"

git config --list
git config --global --list

git config --global user.name "Your Name"
git config --global user.email "foobar@example.com"

git config --local user.email "course@example.com"
git config --local --list

git config --get user.name
git config --get user.email
git config --list --show-origin

git config --global core.quotepath false
git config --global core.excludesfile ~/.gitignore_global
git config --global core.editor "vim"

echo ".DS_Store" >> ~/.gitignore_global
echo ".idea/" >> ~/.gitignore_global
