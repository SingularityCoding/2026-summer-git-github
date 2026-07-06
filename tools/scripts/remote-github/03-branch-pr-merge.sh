#!/usr/bin/env bash
# Captures real, reproducible transcript output for docs/remote-github/03-branch-pr-merge.md.
# Not something students run — an authoring tool for this repo only.
#
# Unlike 02-publish.sh, this does NOT delete/recreate the remote repo (the
# `gh` token here still lacks the delete_repo scope) — it clones whatever
# ukeSJTU/hello-github currently is and continues from there, same as a
# student would in a real second session. That also means this script is
# NOT perfectly idempotent yet: re-running it a second time would add a
# second "## Development" block, since the previous run's PR is already
# merged. Fix properly once 02-publish.sh's delete-and-recreate is usable
# again (see AGENTS.md's note on the missing gh scope).
#
# Also does not sandbox $HOME (unlike the local-git chain) — it needs the
# real `gh`/git credentials on this machine to authenticate as ukeSJTU, so
# it never runs any `--global` config-mutating command for real either.
set -euo pipefail

export LANG=en_US.UTF-8

GH_OWNER="ukeSJTU"
GH_REPO="hello-github"

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
WORK_DIR="$REPO_ROOT/.scratch/hello-github"

rm -rf "$WORK_DIR"
mkdir -p "$WORK_DIR"
cd "$WORK_DIR"

git clone "https://github.com/$GH_OWNER/$GH_REPO.git"
cd "$GH_REPO"

git switch main
git pull
git switch -c improve-readme

printf '\n## Development\n\nNotes on how this project is organized.\n' >> README.md
git status
git diff
git add README.md
git commit -m "Add development notes"

git push -u origin improve-readme

gh pr create --title "Add development notes" \
  --body "Adds a short Development section to the README." \
  --base main --head improve-readme
gh pr merge improve-readme --merge

git push origin --delete improve-readme

git switch main
git pull
git branch -d improve-readme

git fetch --prune
git branch -r
