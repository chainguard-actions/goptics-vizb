<!-- markdownlint-disable -->

# Hardening Report: goptics--vizb/v0.19.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **goptics--vizb/v0.19.0** was hardened automatically. 38 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (a): ${{ inputs.vizb-binary }} and ${{ github.action_ref }} are interpolated directly inside the 'Resolve vizb version' run: shell script. An attacker-controlled value is expanded by the YAML template engine before the shell ever sees it, enabling command injection.

Locations:

- `action.yml:126`
- `action.yml:132`

### script-injection (severity: high)

Rule (a): ${{ runner.os }}, ${{ inputs.vizb-binary }}, ${{ runner.arch }}, and ${{ steps.version.outputs.tag }} are interpolated directly inside the 'Install vizb' run: shell script. Any ${{ }} expression inside a run: block is a script-injection risk regardless of the context it reads from.

Locations:

- `action.yml:167`
- `action.yml:173`
- `action.yml:185`
- `action.yml:187`
- `action.yml:190`

### script-injection (severity: high)

Rule (a): ${{ github.event.pull_request.base.sha }} and ${{ github.event.pull_request.head.sha }} are interpolated directly inside a run: shell script in the 'forbid-gen-commit' job. These github.* expressions flow through YAML template substitution before the shell processes them.

Locations:

- `.github/workflows/cli.yml:44`

### script-injection (severity: high)

Rule (a): ${{ inputs.example_category }} (a workflow_call input) is interpolated directly inside run: shell commands ('Prepare output directory' and 'Local preview ready' steps). inputs.* values are attacker-controllable via workflow_call or workflow_dispatch.

Locations:

- `.github/workflows/merge-examples.yml:30`
- `.github/workflows/merge-examples.yml:38`

### script-injection (severity: high)

Rule (a): ${{ matrix.id }} (and ${{ matrix.serial }} in github-legends.yml) are interpolated directly inside run: shell commands in the 'Stage json for local merge' steps. matrix.* values flow through YAML template substitution before the shell processes them.

Locations:

- `.github/workflows/comparisons-examples.yml:57`
- `.github/workflows/github-legends.yml:79`
- `.github/workflows/go-examples.yml:88`
- `.github/workflows/javascript-examples.yml:57`
- `.github/workflows/math-and-3d-examples.yml:68`
- `.github/workflows/rust-examples.yml:55`
- `.github/workflows/tabular-data-examples.yml:72`

### github-env-injection (severity: high)

In the 'Resolve vizb version' step, REF is set from ${{ github.action_ref }} (an untrusted context value). The script then writes 'echo "tag=$REF" >> "$GITHUB_OUTPUT"' without the required sanitization step (printf '%s' "$REF" | tr -d '\n\r'). A newline-containing ref value could inject additional key=value pairs into GITHUB_OUTPUT.

Locations:

- `action.yml:132`
- `action.yml:145`

### unpinned-uses (severity: high)

action.yml uses actions/cache@v6 — a mutable tag reference, not a pinned 40-character SHA commit hash. This is vulnerable to supply-chain attacks if the tag is moved.

Locations:

- `action.yml:152`

### unpinned-uses (severity: high)

Multiple unpinned uses: references found: actions/checkout@v7, actions/setup-go@v7. All use mutable tag references instead of pinned 40-character SHA commit hashes.

Locations:

- `.github/workflows/action-ci.yml:10`
- `.github/workflows/action-ci.yml:21`
- `.github/workflows/action-ci.yml:27`

### unpinned-uses (severity: high)

Multiple unpinned uses: references found: actions/checkout@v7, actions/setup-go@v7. All use mutable tag references instead of pinned SHA hashes.

Locations:

- `.github/workflows/api-contract.yml:32`
- `.github/workflows/api-contract.yml:34`
- `.github/workflows/api-contract.yml:46`

### unpinned-uses (severity: high)

Multiple unpinned uses: references found: actions/checkout@v7, actions/setup-go@v7, golangci/golangci-lint-action@v9, codecov/codecov-action@v7. All use mutable tag references instead of pinned SHA hashes.

Locations:

- `.github/workflows/cli.yml:37`
- `.github/workflows/cli.yml:55`
- `.github/workflows/cli.yml:64`
- `.github/workflows/cli.yml:79`
- `.github/workflows/cli.yml:91`
- `.github/workflows/cli.yml:100`
- `.github/workflows/cli.yml:110`
- `.github/workflows/cli.yml:120`
- `.github/workflows/cli.yml:130`

### unpinned-uses (severity: high)

Multiple unpinned uses: references found: actions/checkout@v7, actions/setup-go@v7, github/codeql-action/init@v4, github/codeql-action/analyze@v4. All use mutable tag references instead of pinned SHA hashes.

Locations:

- `.github/workflows/codeql.yml:28`
- `.github/workflows/codeql.yml:32`
- `.github/workflows/codeql.yml:38`
- `.github/workflows/codeql.yml:42`

### unpinned-uses (severity: high)

Unpinned uses: actions/checkout@v7 and actions/upload-artifact@v7 use mutable tag references instead of pinned SHA hashes.

Locations:

- `.github/workflows/comparisons-examples.yml:42`
- `.github/workflows/comparisons-examples.yml:61`

### unpinned-uses (severity: high)

Unpinned uses: actions/checkout@v7 and actions/upload-artifact@v7 use mutable tag references instead of pinned SHA hashes.

Locations:

- `.github/workflows/deploy-docs.yml:24`
- `.github/workflows/deploy-docs.yml:33`

### unpinned-uses (severity: high)

Unpinned uses: actions/checkout@v7 and actions/upload-artifact@v7 use mutable tag references instead of pinned SHA hashes.

Locations:

- `.github/workflows/github-legends.yml:57`
- `.github/workflows/github-legends.yml:76`

### unpinned-uses (severity: high)

Unpinned uses: actions/checkout@v7 and actions/upload-artifact@v7 use mutable tag references instead of pinned SHA hashes.

Locations:

- `.github/workflows/go-examples.yml:67`
- `.github/workflows/go-examples.yml:85`

### unpinned-uses (severity: high)

Unpinned uses: actions/checkout@v7 use mutable tag references instead of pinned SHA hashes.

Locations:

- `.github/workflows/installers.yml:29`
- `.github/workflows/installers.yml:42`
- `.github/workflows/installers.yml:55`

### unpinned-uses (severity: high)

Unpinned uses: actions/checkout@v7 and actions/upload-artifact@v7 use mutable tag references instead of pinned SHA hashes.

Locations:

- `.github/workflows/javascript-examples.yml:42`
- `.github/workflows/javascript-examples.yml:60`

### unpinned-uses (severity: high)

Unpinned uses: actions/checkout@v7 and actions/upload-artifact@v7 use mutable tag references instead of pinned SHA hashes.

Locations:

- `.github/workflows/math-and-3d-examples.yml:52`
- `.github/workflows/math-and-3d-examples.yml:70`

### unpinned-uses (severity: high)

Unpinned uses: actions/checkout@v7, actions/download-artifact@v8, and actions/upload-artifact@v7 use mutable tag references instead of pinned SHA hashes.

Locations:

- `.github/workflows/merge-examples.yml:16`
- `.github/workflows/merge-examples.yml:20`
- `.github/workflows/merge-examples.yml:44`

### unpinned-uses (severity: high)

Unpinned uses: actions/download-artifact@v8 and peaceiris/actions-gh-pages@v4 use mutable tag references instead of pinned SHA hashes.

Locations:

- `.github/workflows/publish-site.yml:16`
- `.github/workflows/publish-site.yml:21`

### unpinned-uses (severity: high)

Multiple unpinned uses: references found: trstringer/manual-approval@v1, actions/checkout@v7, docker/setup-qemu-action@v4, docker/setup-buildx-action@v4, docker/login-action@v4, actions/setup-go@v7, goreleaser/goreleaser-action@v7, vedantmgoyal2009/winget-releaser@v2. All use mutable tag references instead of pinned SHA hashes.

Locations:

- `.github/workflows/release.yml:16`
- `.github/workflows/release.yml:51`
- `.github/workflows/release.yml:55`
- `.github/workflows/release.yml:59`
- `.github/workflows/release.yml:64`
- `.github/workflows/release.yml:70`
- `.github/workflows/release.yml:78`
- `.github/workflows/release.yml:93`

### unpinned-uses (severity: high)

Unpinned uses: actions/checkout@v7 and actions/upload-artifact@v7 use mutable tag references instead of pinned SHA hashes.

Locations:

- `.github/workflows/rust-examples.yml:43`
- `.github/workflows/rust-examples.yml:61`

### unpinned-uses (severity: high)

Multiple unpinned uses: references found: actions/checkout@v7, actions/setup-go@v7, actions/upload-artifact@v7, actions/create-github-app-token@v2, actions/download-artifact@v8, stefanzweifel/git-auto-commit-action@v7. All use mutable tag references instead of pinned SHA hashes.

Locations:

- `.github/workflows/sync-embed-ui.yml:40`
- `.github/workflows/sync-embed-ui.yml:44`
- `.github/workflows/sync-embed-ui.yml:50`
- `.github/workflows/sync-embed-ui.yml:60`
- `.github/workflows/sync-embed-ui.yml:65`
- `.github/workflows/sync-embed-ui.yml:70`
- `.github/workflows/sync-embed-ui.yml:76`

### unpinned-uses (severity: high)

Unpinned uses: actions/checkout@v7 and actions/upload-artifact@v7 use mutable tag references instead of pinned SHA hashes.

Locations:

- `.github/workflows/tabular-data-examples.yml:55`
- `.github/workflows/tabular-data-examples.yml:73`

### unpinned-uses (severity: high)

Multiple unpinned uses: references found: actions/checkout@v7, codecov/codecov-action@v7. All use mutable tag references instead of pinned SHA hashes.

Locations:

- `.github/workflows/ui.yml:22`
- `.github/workflows/ui.yml:35`
- `.github/workflows/ui.yml:48`
- `.github/workflows/ui.yml:57`
- `.github/workflows/ui.yml:70`
- `.github/workflows/ui.yml:83`

### unpinned-uses (severity: high)

Unpinned uses: vedantmgoyal2009/winget-releaser@v2 uses a mutable tag reference instead of a pinned SHA hash.

Locations:

- `.github/workflows/winget.yml:12`

### permissions (severity: medium)

missing-permissions: action-ci.yml has no top-level permissions: key and none of its jobs (unit, stateless, stateful) define a job-level permissions: block. The workflow runs with default (broad) permissions.

Locations:

- `.github/workflows/action-ci.yml:1`

### permissions (severity: medium)

missing-permissions: api-contract.yml has no top-level permissions: key and none of its jobs (contract, docs) define a job-level permissions: block. The workflow runs with default (broad) permissions.

Locations:

- `.github/workflows/api-contract.yml:1`

### permissions (severity: medium)

missing-permissions: comparisons-examples.yml has no top-level permissions: key and the 'convert' job has no job-level permissions: block. Only the 'merge' and 'publish' jobs define permissions.

Locations:

- `.github/workflows/comparisons-examples.yml:1`

### permissions (severity: medium)

missing-permissions: github-legends.yml has no top-level permissions: key and the 'convert' job has no job-level permissions: block. Only the 'merge' and 'publish' jobs define permissions.

Locations:

- `.github/workflows/github-legends.yml:1`

### permissions (severity: medium)

missing-permissions: go-examples.yml has no top-level permissions: key and the 'convert' job has no job-level permissions: block. Only the 'merge' and 'publish' jobs define permissions.

Locations:

- `.github/workflows/go-examples.yml:1`

### permissions (severity: medium)

missing-permissions: javascript-examples.yml has no top-level permissions: key and the 'convert' job has no job-level permissions: block. Only the 'merge' and 'publish' jobs define permissions.

Locations:

- `.github/workflows/javascript-examples.yml:1`

### permissions (severity: medium)

missing-permissions: math-and-3d-examples.yml has no top-level permissions: key and the 'convert' job has no job-level permissions: block. Only the 'merge' and 'publish' jobs define permissions.

Locations:

- `.github/workflows/math-and-3d-examples.yml:1`

### permissions (severity: medium)

missing-permissions: rust-examples.yml has no top-level permissions: key and the 'convert' job has no job-level permissions: block. Only the 'merge' and 'publish' jobs define permissions.

Locations:

- `.github/workflows/rust-examples.yml:1`

### permissions (severity: medium)

missing-permissions: tabular-data-examples.yml has no top-level permissions: key and the 'convert' job has no job-level permissions: block. Only the 'merge' and 'publish' jobs define permissions.

Locations:

- `.github/workflows/tabular-data-examples.yml:1`

### permissions (severity: medium)

missing-permissions: ui.yml has no top-level permissions: key and the 'lint', 'format', 'test', and 'build' jobs have no job-level permissions: block. Only the 'e2e' job defines permissions.

Locations:

- `.github/workflows/ui.yml:1`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.vizb-binary }}" appears directly in run: block of step "Resolve vizb version"; move to env: map

Locations:

- `action.yml:126`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.vizb-binary }}" appears directly in run: block of step "Install vizb"; move to env: map

Locations:

- `action.yml:173`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, github-env-injection, unpinned-uses, permissions

**Notes:**

Fixed all findings across action.yml and 17 workflow files:

1. script-injection (action.yml): Moved inputs.vizb-binary, github.action_ref, runner.os, runner.arch, steps.version.outputs.tag to env: blocks in 'Resolve vizb version' and 'Install vizb' steps.

2. github-env-injection (action.yml): Added printf '%s' | tr -d '\n\r' sanitization before writing tag/ref values to GITHUB_OUTPUT.

3. script-injection (cli.yml): Moved github.event.pull_request.base.sha and head.sha to env: block.

4. script-injection (merge-examples.yml): Moved inputs.example_category to env: block in 'Prepare output directory' and 'Local preview ready' steps.

5. script-injection (comparisons-examples.yml, github-legends.yml, go-examples.yml, javascript-examples.yml, math-and-3d-examples.yml, rust-examples.yml, tabular-data-examples.yml): Moved matrix.id (and matrix.serial in github-legends.yml) to env: blocks in 'Stage json for local merge' steps.

6. missing-permissions: Added top-level permissions: contents: read to action-ci.yml, api-contract.yml, ui.yml. Added job-level permissions: contents: read to convert jobs in 7 example workflow files, and to lint/format/test/build jobs in ui.yml.

7. unpinned-uses: Pinned all actions to full SHA hashes across all workflow files and action.yml. Actions pinned: actions/cache@v6, actions/checkout@v7, actions/setup-go@v7, golangci/golangci-lint-action@v9, codecov/codecov-action@v7, github/codeql-action/init@v4, github/codeql-action/analyze@v4, actions/upload-artifact@v7, actions/download-artifact@v8, peaceiris/actions-gh-pages@v4, trstringer/manual-approval@v1, docker/setup-qemu-action@v4, docker/setup-buildx-action@v4, docker/login-action@v4, goreleaser/goreleaser-action@v7, vedantmgoyal2009/winget-releaser@v2, actions/create-github-app-token@v2, stefanzweifel/git-auto-commit-action@v7.

