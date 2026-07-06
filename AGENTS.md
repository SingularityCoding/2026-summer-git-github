# git-github

Slidev presentation for a Git & GitHub workshop, plus the `docs/`/`assets`/`tools` pipeline that produces its content. This file is guidance for working on the *project* (structure, commands, conventions) — the actual course curriculum lives in `docs/`, not here.

## Structure

- `docs/design.md` — snapshot of the original course design/outline (curriculum, pacing, teaching notes). A planning artifact for reference; not something slides pull from directly, and not the place to make ongoing content edits.
- `docs/local-git/`, `docs/remote-github/` — one markdown file per lesson topic, numbered to mirror `docs/design.md` (e.g. `docs/local-git/06-diff.md` ↔ design doc's "#6 `git diff`"). This is the source-of-truth teaching content — explanations plus real captured command output — that `slides.md` distills into slide form.
- `assets/diagrams/<section>/*.mmd` — mermaid gitGraph sources, one per commit-topology moment worth visualizing (branch creation, merges, conflicts, fork/upstream). Rendered to `.svg` via `tools/render-diagrams.sh`. Diagrams use short descriptive commit labels, not real hashes, so they don't need regenerating when example output changes.
- `assets/screenshots/` — for GitHub web UI screenshots, if/when needed.
- `tools/scripts/<section>/*.sh` — one script per lesson topic, running the exact commands shown in the corresponding `docs/` file. These exist to capture real, reproducible transcript output for the docs — they're authoring tools, not something students run.
- `tools/render-diagrams.sh` — batch-renders every `.mmd` under `assets/diagrams/` to `.svg`.
- `playground/` — gitignored scratch directory that `tools/scripts/*.sh` actually execute into. Never `git add -f` it and never remove the `playground/` line from `.gitignore` — it's a deliberately throwaway nested sandbox, isolated from this repo's own history.
- `slides.md`, `pages/` — the Slidev deck itself.

## Commands

- `pnpm install` — install dependencies
- `pnpm dev` — start the Slidev dev server
- `pnpm build` — build the static deck
- `pnpm export` — export to PDF/PNG/PPTX

## Conventions

- Command output shown to students (in `docs/` or on slides) must be real, captured output — never fabricate or pin values (e.g. via `GIT_AUTHOR_DATE`) to make hashes/timestamps artificially consistent across runs or students. Genuine variation (commit hash, timestamp, even `git status` locale wording) gets explained inline as expected, not hidden.
- `docs/` is the source of truth; slides are a distilled version of it, not the other way around.
- For actual curriculum/content changes, edit the relevant file under `docs/local-git/` or `docs/remote-github/` — `docs/design.md` is a historical snapshot, not the live outline.
