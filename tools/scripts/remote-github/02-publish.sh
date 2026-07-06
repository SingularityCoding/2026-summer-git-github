#!/usr/bin/env bash
# Captures real, reproducible transcript output for docs/remote-github/02-publish.md.
# Not something students run — an authoring tool for this repo only.
#
# Unlike local-git's chain, this hits the real GitHub API (creates/recreates
# the real ukeSJTU/hello-github repo) and pushes over the network, so it does
# NOT sandbox $HOME/git config the way local-git's chain does — it needs the
# real `gh`/git credentials on this machine to authenticate as ukeSJTU.
set -euo pipefail

export LANG=en_US.UTF-8

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
WORK_DIR="$REPO_ROOT/.scratch/hello-github"
GH_OWNER="ukeSJTU"
GH_REPO="hello-github"

rm -rf "$WORK_DIR"
mkdir -p "$WORK_DIR"
cd "$WORK_DIR"

mkdir hello-github
cd hello-github

printf 'def greet(name):\n    return f"Hello, {name}!"\n\nif __name__ == "__main__":\n    print(greet("GitHub"))\n' > hello.py
printf '# hello-github\n\nA tiny Python project for learning Git and GitHub.\n' > README.md
printf '__pycache__/\n*.pyc\n' > .gitignore

python hello.py

git init
git status
git add .
git commit -m "Initial commit"
git log --oneline

# Recreate the real remote repo from scratch so this script stays repeatable,
# same "replay from scratch" philosophy as local-git's chain, just against
# the GitHub API instead of a local directory. Empty repo, no auto-generated
# README/.gitignore/license — this repo's own files are what get pushed.
if gh repo view "$GH_OWNER/$GH_REPO" >/dev/null 2>&1; then
  gh repo delete "$GH_OWNER/$GH_REPO" --yes
fi
gh repo create "$GH_OWNER/$GH_REPO" --public --description "A tiny Python project for learning Git and GitHub."

git remote add origin "https://github.com/$GH_OWNER/$GH_REPO.git"
git remote -v
git branch -M main
git push -u origin main

printf '\n## Usage\n\nRun `python hello.py`.\n' >> README.md
git status
git diff
git add README.md
git commit -m "Document usage"
git push
