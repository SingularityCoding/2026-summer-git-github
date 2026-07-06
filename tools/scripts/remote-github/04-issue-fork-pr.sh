#!/usr/bin/env bash
# NOT YET RUN FOR REAL. This is a reference script for docs/remote-github/04-issue-fork-pr.md,
# whose command output is currently illustrative (placeholder usernames), not
# a captured transcript — see that file's note at the top.
#
# Why: there's no separate "student" GitHub identity available right now, only
# ukeSJTU (who also owns the SingularityCoding org). Actually running this
# would fork SingularityCoding/first-contributions to ukeSJTU, open a real PR
# with "Closes #1", and merge it — which for real closes the shared class
# issue and leaves a real merge in the fixture's history. That's an
# acceptable outcome (the issue body already tells students this is normal),
# but it's a real, visible action on a shared fixture, so it was deliberately
# deferred rather than run automatically. Once a second test account (or a
# genuine student fork) is available, run this for real and update the doc
# with the real transcript.
set -euo pipefail

export LANG=en_US.UTF-8

TEACHER_OWNER="SingularityCoding"
STUDENT_OWNER="ukeSJTU"
REPO="first-contributions"

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
WORK_DIR="$REPO_ROOT/.scratch/first-contributions-student"

rm -rf "$WORK_DIR"
mkdir -p "$WORK_DIR"
cd "$WORK_DIR"

gh repo fork "$TEACHER_OWNER/$REPO" --clone
cd "$REPO"

git status
git remote -v
git branch -vv

git branch
git branch -r
git branch -a

git remote add upstream "https://github.com/$TEACHER_OWNER/$REPO.git"
git remote -v

git switch -c "add-$STUDENT_OWNER"
printf -- "- %s\n" "$STUDENT_OWNER" >> CONTRIBUTORS.md
git status
git diff
git add CONTRIBUTORS.md
git commit -m "Add $STUDENT_OWNER to contributors"
git push -u origin "add-$STUDENT_OWNER"

gh pr create --repo "$TEACHER_OWNER/$REPO" \
  --title "Add $STUDENT_OWNER to contributors" \
  --body "Closes #1" \
  --base main --head "$STUDENT_OWNER:add-$STUDENT_OWNER"
gh pr merge --repo "$TEACHER_OWNER/$REPO" --merge

git switch main
git fetch upstream
git merge upstream/main
git push origin main
