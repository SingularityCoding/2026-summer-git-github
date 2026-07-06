#!/usr/bin/env bash
# One-time, per-course-offering setup for SingularityCoding/first-contributions.
#
# Unlike everything else under tools/scripts/, this is NOT part of the
# capture/replay pipeline and is NOT safe to re-run blindly: the repo holds
# real state across a real class (real student forks/PRs), so this script
# refuses to touch it if it already exists. Run by hand, once, before each
# course offering — not sourced by any other script.
set -euo pipefail

export LANG=en_US.UTF-8

GH_OWNER="SingularityCoding"
GH_REPO="first-contributions"

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
WORK_DIR="$REPO_ROOT/.scratch/first-contributions-bootstrap"

if gh repo view "$GH_OWNER/$GH_REPO" >/dev/null 2>&1; then
  echo "error: $GH_OWNER/$GH_REPO already exists — refusing to touch it." >&2
  echo "this repo holds real per-course state (student forks/PRs); if you" >&2
  echo "really want to reset it for a new course offering, do that by hand." >&2
  exit 1
fi

rm -rf "$WORK_DIR"
mkdir -p "$WORK_DIR"
cd "$WORK_DIR"

cat > README.md <<'EOF'
# first-contributions

这是「Git & GitHub」课程用的共享练习仓库，灵感来自 [firstcontributions/first-contributions](https://github.com/firstcontributions/first-contributions)——一个专门帮初学者完成人生第一次开源贡献的项目。我们用小得多的规模，练一遍同样的流程：fork、clone、开分支、改动、提交、发 Pull Request。

## 你要做的事

打开本仓库的 [Issues](../../issues) 页面，找到 "Add your name to CONTRIBUTORS.md" 这个 issue，跟着里面的说明走一遍。具体的 fork / clone / branch / commit / push / PR 步骤，课堂上会带着一起过。

## 仓库里有什么

- `CONTRIBUTORS.md` —— 每个完成练习的人，在这里加一行自己的 GitHub username
EOF

cat > CONTRIBUTORS.md <<'EOF'
# Contributors

People who've completed the "add your name" exercise for this course.

- ukeSJTU
EOF

git init
git add README.md CONTRIBUTORS.md
git commit -m "Initial commit"
git branch -M main

gh repo create "$GH_OWNER/$GH_REPO" --public \
  --description "Shared first-PR practice repo for the Git & GitHub course."

git remote add origin "https://github.com/$GH_OWNER/$GH_REPO.git"
git push -u origin main

gh issue create --repo "$GH_OWNER/$GH_REPO" \
  --title "Add your name to CONTRIBUTORS.md" \
  --body "$(cat <<'EOF'
Add your own GitHub username to `CONTRIBUTORS.md` and open a Pull Request.

## Steps

1. Fork this repository.
2. Clone your fork locally.
3. Create a new branch.
4. Add a line with your GitHub username to `CONTRIBUTORS.md`.
5. Commit, push, and open a Pull Request back to this repository.
6. In the PR description, write `Closes #1` so it links back to this issue.

Note: the whole class shares this one issue. Once the first PR is merged, this issue will show as "Closed" — that's expected. Keep writing `Closes #1` in your own PR anyway; it'll still link correctly and merge normally.

This is the same "first PR" exercise as [firstcontributions/first-contributions](https://github.com/firstcontributions/first-contributions), just for this course.
EOF
)"

echo "done: https://github.com/$GH_OWNER/$GH_REPO"
