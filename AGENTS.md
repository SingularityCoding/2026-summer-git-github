# git-github

Slidev presentation for a Git & GitHub workshop, plus the `docs/`/`assets`/`tools` pipeline that produces its content. This file is guidance for working on the *project* (structure, commands, conventions) — the actual course curriculum lives in `docs/`, not here.

## Structure

- `docs/design.md` — snapshot of the original course design/outline (curriculum, pacing, teaching notes). A planning artifact for reference; not something slides pull from directly, and not the place to make ongoing content edits.
- `docs/local-git/`, `docs/remote-github/` — one markdown file per lesson topic, numbered to mirror `docs/design.md` (e.g. `docs/local-git/06-diff.md` ↔ design doc's "#6 `git diff`"). This is the source-of-truth teaching content — explanations plus real captured command output — that `slides.md` distills into slide form. A `00`-prefixed file (e.g. `00-why-git.md`) holds pure motivation/background content that precedes a section's numbered command sequence in `docs/design.md` — it has no matching `tools/scripts/` capture script since there's no command output to capture.
- `assets/diagrams/<section>/*.mmd` — mermaid gitGraph sources, one per commit-topology moment worth visualizing (branch creation, merges, conflicts, fork/upstream). Rendered to `.svg` via `tools/render-diagrams.sh`. Diagrams use short descriptive commit labels, not real hashes, so they don't need regenerating when example output changes.
- `assets/screenshots/` — for GitHub web UI screenshots, if/when needed.
- `tools/scripts/<section>/*.sh` — one script per lesson topic, running the exact commands shown in the corresponding `docs/` file. These exist to capture real, reproducible transcript output for the docs — they're authoring tools, not something students run. See "Script chain architecture" below for how they're wired together.
- `tools/render-diagrams.sh` — batch-renders every `.mmd` under `assets/diagrams/` to `.svg`.
- `playground/` — gitignored scratch directory that `tools/scripts/*.sh` actually execute into. Never `git add -f` it and never remove the `playground/` line from `.gitignore` — it's a deliberately throwaway sandbox, isolated from this repo's own history.
- `slides.md`, `pages/` — the Slidev deck itself.

## Script chain architecture

The teaching narrative for a given project (e.g. all of `local-git`, or `hello-github` within `remote-github`) stays in **one continuous repo** across topics, exactly like a real class session — students don't tear down and recreate a repo between every command. The capture scripts mirror that:

- Each script only contains the commands *new* to its own topic — it does not repeat earlier setup.
- A script picks up where the previous topic left off by `source`-ing its immediate predecessor at the top, e.g. `03-add.sh` sources `02-status.sh`, which sources `01-init.sh`. It never sources anything further back than one step — the chain carries state forward on its own.
- The first script in a project's chain (e.g. `01-init.sh` for `local-git`) is the chain's head: it computes `REPO_ROOT` once via `${BASH_SOURCE[0]}`, exports `LANG=en_US.UTF-8` (matching the Prerequisites setup, so captured output is the English a student would actually see), `rm -rf`s the project directory, and (re)creates it. Every downstream script inherits those variables and that clean state for free through the `source` chain.
- Because sourcing replays the full chain from scratch, running *any* script standalone — not just the head — regenerates the entire history deterministically. There's no separate "run all in order" driver and no risk of capturing a topic's output against stale or partially-updated state.
- Never hardcode absolute paths. Path resolution always goes through `${BASH_SOURCE[0]}` of the current file, so scripts work regardless of the caller's cwd.
- A script becomes a new chain head — its own `rm -rf` + `mkdir`, not a `source` of the previous topic — only when the curriculum itself deliberately switches projects (e.g. `remote-github/02-publish.sh` starting the fresh `hello-github` project instead of continuing in `playground`). Don't start a new chain head just because it's convenient; only when the lesson content requires a different repo.

## Commands

- `pnpm install` — install dependencies
- `pnpm dev` — start the Slidev dev server
- `pnpm build` — build the static deck
- `pnpm export` — export to PDF/PNG/PPTX

## Conventions

- Command output shown to students (in `docs/` or on slides) must be real, captured output — never fabricate or pin values (e.g. via `GIT_AUTHOR_DATE`) to make hashes/timestamps artificially consistent across runs or students. Genuine variation (commit hash, timestamp, even `git status` locale wording) gets explained inline as expected, not hidden.
- `docs/` is the source of truth; slides are a distilled version of it, not the other way around.
- For actual curriculum/content changes, edit the relevant file under `docs/local-git/` or `docs/remote-github/` — `docs/design.md` is a historical snapshot, not the live outline.

## Writing style for `docs/`

Each file under `docs/local-git/` and `docs/remote-github/` is the actual teaching script for one topic in `docs/design.md` (matched by number) — not a copy of the outline, but that outline expanded into something a teacher could read from or a student could follow on their own.

- Written in Chinese, prose-first. Natural-language paragraphs carry the explanation; bullet points are for a handful of key facts worth scanning at a glance, not the default structure.
- Tone is relaxed and a little conversational — this is a workshop, not a reference manual. It's fine to sound like a person talking, as long as the content stays accurate and complete.
- Keep key technical terms in English (`git init`, `working directory`, `staging area`, `commit`, `HEAD`, …). On a term's first appearance in a file, gloss it with the Chinese translation in parentheses, e.g. `working directory（工作目录）`; after that, the English term alone is fine.
- Each file ends with a short transition sentence pointing to the next topic, so the docs read as one continuous session rather than isolated reference pages.
- Command output included in the text must be the real output captured via the matching `tools/scripts/` script, not hand-written — per the Conventions section above, explain genuine machine-specific variation (e.g. absolute paths) inline instead of hiding or faking it.
