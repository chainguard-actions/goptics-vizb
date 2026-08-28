<!-- markdownlint-disable -->

# Hardening Report: goptics--vizb/v0.20.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **goptics--vizb/v0.20.0** was hardened automatically. 3 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### unpinned-uses (severity: high)

action.yml uses `actions/cache@v6` — a mutable version tag rather than a pinned 40-character SHA commit hash. All workflow files under .github/workflows/ also use mutable version tags (e.g. @v7, @v4, @v2, @v9) for every external action reference, including: actions/checkout@v7, actions/setup-go@v7, actions/upload-artifact@v7, actions/download-artifact@v8, actions/cache@v6, actions/create-github-app-token@v2, codecov/codecov-action@v7, dorny/paths-filter@v4, golangci/golangci-lint-action@v9, goreleaser/goreleaser-action@v7, docker/setup-qemu-action@v4, docker/setup-buildx-action@v4, docker/login-action@v4, github/codeql-action/init@v4, github/codeql-action/analyze@v4, peaceiris/actions-gh-pages@v4, stefanzweifel/git-auto-commit-action@v7, trstringer/manual-approval@v1, vedantmgoyal2009/winget-releaser@v2. None are pinned to a full SHA digest.

Locations:

- `action.yml:148`
- `.github/workflows/action-ci.yml:29`
- `.github/workflows/cli.yml:44`
- `.github/workflows/codeql.yml:28`
- `.github/workflows/comparisons-examples.yml:43`
- `.github/workflows/deploy-docs.yml:24`
- `.github/workflows/github-legends.yml:60`
- `.github/workflows/go-examples.yml:72`
- `.github/workflows/installers.yml:30`
- `.github/workflows/javascript-examples.yml:43`
- `.github/workflows/math-and-3d-examples.yml:55`
- `.github/workflows/merge-examples.yml:17`
- `.github/workflows/publish-site.yml:18`
- `.github/workflows/release.yml:14`
- `.github/workflows/rust-examples.yml:43`
- `.github/workflows/sync-embed-ui.yml:44`
- `.github/workflows/tabular-data-examples.yml:68`
- `.github/workflows/ui.yml:21`
- `.github/workflows/winget.yml:11`

### script-injection (severity: high)

Multiple run: blocks directly interpolate ${{ ... }} expressions into shell commands (rule a), allowing script injection. Specific violations:

(1) cli.yml `forbid-gen-commit` job: `base="${{ github.event.pull_request.base.sha }}"` and `head="${{ github.event.pull_request.head.sha }}"` are interpolated directly into a multi-line run block. An attacker-controlled branch name could embed newlines or shell metacharacters.

(2) merge-examples.yml: `run: mkdir -p dist/examples/live/${{ inputs.example_category }}` and `run: echo "::notice::Local preview at dist/examples/live/${{ inputs.example_category }}/index.html"` — the workflow_call input is interpolated directly into shell commands.

(3) comparisons-examples.yml, go-examples.yml, javascript-examples.yml, math-and-3d-examples.yml, rust-examples.yml, tabular-data-examples.yml: `run: mkdir -p .act/jsons && cp ${{ matrix.id }}.json .act/jsons/` — matrix context interpolated directly into shell.

(4) github-legends.yml: `run: mkdir -p .act/jsons && cp ${{ matrix.serial }}-${{ matrix.id }}.json .act/jsons/` — matrix context interpolated directly into shell.

Fix: move values into env: vars and reference them as quoted shell variables (e.g. "$MATRIX_ID").

Locations:

- `.github/workflows/cli.yml:65`
- `.github/workflows/merge-examples.yml:27`
- `.github/workflows/merge-examples.yml:33`
- `.github/workflows/comparisons-examples.yml:50`
- `.github/workflows/github-legends.yml:76`
- `.github/workflows/go-examples.yml:88`
- `.github/workflows/javascript-examples.yml:52`
- `.github/workflows/math-and-3d-examples.yml:68`
- `.github/workflows/rust-examples.yml:52`
- `.github/workflows/tabular-data-examples.yml:82`

### missing-permissions (severity: medium)

Several workflow files have no top-level permissions block and at least one job with no job-level permissions block:

- api-contract.yml: no top-level permissions and neither the `contract` nor `docs` job defines permissions.
- ui.yml: no top-level permissions; only the `e2e` job has permissions. The `lint`, `format`, `test`, and `build` jobs have no permissions.
- comparisons-examples.yml: no top-level permissions; the `convert` job has no permissions (only `merge` and `publish` do).
- github-legends.yml: no top-level permissions; the `convert` job has no permissions.
- go-examples.yml: no top-level permissions; the `convert` job has no permissions.
- javascript-examples.yml: no top-level permissions; the `convert` job has no permissions.
- math-and-3d-examples.yml: no top-level permissions; the `convert` job has no permissions.
- rust-examples.yml: no top-level permissions; the `convert` job has no permissions.
- tabular-data-examples.yml: no top-level permissions; the `convert` job has no permissions.

Without explicit permissions, jobs inherit the default repository token permissions which may be overly broad.

Locations:

- `.github/workflows/api-contract.yml:1`
- `.github/workflows/ui.yml:1`
- `.github/workflows/comparisons-examples.yml:1`
- `.github/workflows/github-legends.yml:1`
- `.github/workflows/go-examples.yml:1`
- `.github/workflows/javascript-examples.yml:1`
- `.github/workflows/math-and-3d-examples.yml:1`
- `.github/workflows/rust-examples.yml:1`
- `.github/workflows/tabular-data-examples.yml:1`

## Iteration Notes

### Iteration 1

**Fixes applied:** unpinned-uses, script-injection, missing-permissions

**Notes:**

Fixed all three finding types across 19 workflow files and action.yml:

1. unpinned-uses: Pinned all 19 external action references to full SHA digests using lookup_action_sha. All @v tags replaced with 40-character commit SHAs while preserving the tag as a comment.

2. script-injection: Moved all ${{ }} expressions from run: blocks into env: blocks:
   - cli.yml forbid-gen-commit: base.sha and head.sha → BASE_SHA/HEAD_SHA env vars
   - merge-examples.yml: inputs.example_category → EXAMPLE_CATEGORY env var (mkdir and echo steps)
   - comparisons/go/javascript/math-and-3d/rust/tabular-data examples: matrix.id → MATRIX_ID env var
   - github-legends.yml: matrix.serial and matrix.id → MATRIX_SERIAL/MATRIX_ID env vars

3. missing-permissions: Added top-level 'permissions: contents: read' to api-contract.yml, ui.yml, comparisons-examples.yml, github-legends.yml, go-examples.yml, javascript-examples.yml, math-and-3d-examples.yml, rust-examples.yml, and tabular-data-examples.yml.

