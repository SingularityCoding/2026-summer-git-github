#!/usr/bin/env bash
# Captures real, reproducible transcript output for docs/remote-github/07-actions.md.
# Not something students run — an authoring tool for this repo only.
#
# Like 03/06, this clones whatever ukeSJTU/hello-github currently is rather
# than replaying a full from-scratch chain (same delete_repo scope
# limitation as 02-publish.sh). Triggers two real Actions runs: one passing,
# one intentionally broken, then fixes it — waits on each with `gh run
# watch`, which blocks until the run finishes (real CI time, roughly a
# minute per run).
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

printf 'from hello import greet\n\n\ndef test_greet():\n    assert greet("GitHub") == "Hello, GitHub!"\n' > test_hello.py
python -m pip install --quiet pytest
python -m pytest

git status
git add test_hello.py
git commit -m "Add greeting test"

mkdir -p .github/workflows
cat > .github/workflows/ci.yml <<'EOF'
name: CI

on:
  push:
    branches: [main]
  pull_request:

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: "3.12"
      - run: python -m pip install pytest
      - run: python -m pytest
EOF

git add .github/workflows/ci.yml
git commit -m "Add CI workflow"
git push

sleep 15
run_id="$(gh run list --repo "$GH_OWNER/$GH_REPO" --limit 1 --json databaseId --jq '.[0].databaseId')"
gh run watch "$run_id" --repo "$GH_OWNER/$GH_REPO" --exit-status
gh run view "$run_id" --repo "$GH_OWNER/$GH_REPO"

# Intentionally break the test to see a real failing run.
sed -i '' 's/Hello, GitHub!/Hello, World!/' test_hello.py
git add test_hello.py
git commit -m "Break the test on purpose"
git push

sleep 15
fail_run_id="$(gh run list --repo "$GH_OWNER/$GH_REPO" --limit 1 --json databaseId --jq '.[0].databaseId')"
gh run watch "$fail_run_id" --repo "$GH_OWNER/$GH_REPO" --exit-status || true
gh run view "$fail_run_id" --repo "$GH_OWNER/$GH_REPO"

# Fix it back so the repo doesn't sit broken.
sed -i '' 's/Hello, World!/Hello, GitHub!/' test_hello.py
git add test_hello.py
git commit -m "Fix the test"
git push
