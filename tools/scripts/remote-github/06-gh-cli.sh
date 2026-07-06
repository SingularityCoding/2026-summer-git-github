#!/usr/bin/env bash
# Captures real, reproducible transcript output for docs/remote-github/06-gh-cli.md.
# Not something students run — an authoring tool for this repo only.
#
# All read-only against the real hello-github/first-contributions repos, so
# unlike the other remote-github scripts this doesn't need to set up or
# mutate any repo state — it just needs `gh` authenticated as ukeSJTU.
#
# `gh`'s keychain-backed auth on macOS has been intermittently flaky when run
# non-interactively (occasional "token in keyring is invalid" or GraphQL
# "EOF"/TLS timeout, gone on retry) — if this fails, just retry a few times
# before assuming something's actually wrong with the auth.
set -euo pipefail

export LANG=en_US.UTF-8

gh auth status

gh repo view ukeSJTU/hello-github

gh issue list --repo SingularityCoding/first-contributions
gh issue view 1 --repo SingularityCoding/first-contributions

gh pr list --repo ukeSJTU/hello-github --state all
