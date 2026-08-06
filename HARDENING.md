<!-- markdownlint-disable -->

# Hardening Report: goptics--vizb/v0.18.1

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **goptics--vizb/v0.18.1** was hardened automatically. 65 finding(s) were identified and resolved across 5 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Multiple ${{ }} expressions are directly interpolated inside run: shell commands in action.yml, violating sub-rule (a). Most critically, `${{ steps.resolve.outputs.cmd }}` (which holds the user-supplied `cmd` input) is directly executed as a shell command: `${{ steps.resolve.outputs.cmd }} > "$INPUT"`. Other direct interpolations include `${{ inputs.vizb-binary }}`, `${{ inputs.file }}`, `${{ inputs.bench-file }}`, `${{ inputs.cmd }}`, `${{ inputs.bench-cmd }}`, `${{ inputs.tag }}`, `${{ inputs.id }}`, `${{ inputs.name }}`, `${{ inputs.title }}`, `${{ inputs.description }}`, `${{ inputs.group }}`, `${{ inputs.group-pattern }}`, `${{ inputs.group-regex }}`, `${{ inputs.sort }}`, `${{ inputs.filter }}`, `${{ inputs.mem-unit }}`, `${{ inputs.time-unit }}`, `${{ inputs.number-unit }}`, `${{ inputs.round }}`, `${{ inputs.col-axis }}`, `${{ inputs.json-path }}`, `${{ inputs.show-labels }}`, `${{ inputs.parser }}`, `${{ inputs.charts }}`, `${{ inputs.chart }}`, `${{ inputs.stat }}`, `${{ inputs.data-url }}`, `${{ inputs.output-html }}`, `${{ inputs.merge-files }}`, `${{ inputs.merge-dir }}`, `${{ inputs.tag-axis }}`, `${{ github.action_ref }}`, `${{ runner.os }}`, `${{ runner.arch }}`, and `${{ steps.version.outputs.tag }}`. Additionally, `${{ inputs.merge-files }}` is expanded unquoted in the Merge step: `FILES+=(${{ inputs.merge-files }})`, violating sub-rule (b).

Locations:

- `action.yml:131`
- `action.yml:136`
- `action.yml:155`
- `action.yml:160`
- `action.yml:175`
- `action.yml:200`
- `action.yml:232`
- `action.yml:241`

### script-injection (severity: high)

In .github/workflows/cli.yml, the `forbid-gen-commit` job's run: block directly interpolates `${{ github.event.pull_request.base.sha }}` and `${{ github.event.pull_request.head.sha }}` into shell commands (sub-rule a): `base="${{ github.event.pull_request.base.sha }}"` and `head="${{ github.event.pull_request.head.sha }}"`.

Locations:

- `.github/workflows/cli.yml:38`

### github-env-injection (severity: high)

In action.yml, the 'Resolve input' step writes user-controlled inputs directly to $GITHUB_OUTPUT without sanitization (no `printf '%s' ... | tr -d '\n\r'` step). Specifically: (1) `FILE` (set from `${{ inputs.file }}` and `${{ inputs.bench-file }}`) and `CMD` (set from `${{ inputs.cmd }}` and `${{ inputs.bench-cmd }}`) are written via a heredoc to $GITHUB_OUTPUT using `echo "file<<__VIZB_EOF__"` / `echo "$FILE"` / `echo "__VIZB_EOF__"` — an attacker can inject arbitrary content into GITHUB_OUTPUT by embedding `__VIZB_EOF__` in the input. (2) `OUT_JSON` (set from `${{ inputs.output-json }}`) is written as `echo "json_file=$OUT_JSON" >> "$GITHUB_OUTPUT"` without sanitization.

Locations:

- `action.yml:196`
- `action.yml:197`
- `action.yml:198`
- `action.yml:199`
- `action.yml:200`
- `action.yml:203`

### unpinned-uses (severity: high)

Multiple `uses:` references use mutable tags instead of pinned 40-character SHA digests, making them vulnerable to supply-chain attacks. In action.yml: `actions/cache@v6`. In workflow files: `actions/checkout@v7`, `actions/setup-go@v7`, `golangci/golangci-lint-action@v9`, `codecov/codecov-action@v7`, `github/codeql-action/init@v4`, `github/codeql-action/analyze@v4`, `actions/upload-artifact@v7`, `actions/download-artifact@v8`, `peaceiris/actions-gh-pages@v4`, `docker/setup-qemu-action@v4`, `docker/setup-buildx-action@v4`, `docker/login-action@v4`, `goreleaser/goreleaser-action@v7`, `trstringer/manual-approval@v1`, `vedantmgoyal2009/winget-releaser@v2`, `actions/create-github-app-token@v2`, `stefanzweifel/git-auto-commit-action@v7`.

Locations:

- `action.yml:120`
- `.github/workflows/action-ci.yml:12`
- `.github/workflows/action-ci.yml:16`
- `.github/workflows/api-contract.yml:31`
- `.github/workflows/api-contract.yml:34`
- `.github/workflows/cli.yml:30`
- `.github/workflows/cli.yml:57`
- `.github/workflows/cli.yml:68`
- `.github/workflows/cli.yml:80`
- `.github/workflows/cli.yml:93`
- `.github/workflows/cli.yml:103`
- `.github/workflows/codeql.yml:18`
- `.github/workflows/codeql.yml:23`
- `.github/workflows/codeql.yml:31`
- `.github/workflows/codeql.yml:35`
- `.github/workflows/release.yml:16`
- `.github/workflows/release.yml:52`
- `.github/workflows/release.yml:56`
- `.github/workflows/release.yml:60`
- `.github/workflows/release.yml:65`
- `.github/workflows/release.yml:72`
- `.github/workflows/release.yml:80`
- `.github/workflows/release.yml:91`
- `.github/workflows/sync-embed-ui.yml:42`
- `.github/workflows/sync-embed-ui.yml:47`
- `.github/workflows/sync-embed-ui.yml:53`
- `.github/workflows/sync-embed-ui.yml:63`
- `.github/workflows/sync-embed-ui.yml:70`
- `.github/workflows/sync-embed-ui.yml:75`
- `.github/workflows/sync-embed-ui.yml:80`
- `.github/workflows/winget.yml:10`
- `.github/workflows/publish-site.yml:19`
- `.github/workflows/publish-site.yml:23`
- `.github/workflows/ui.yml:18`
- `.github/workflows/comparisons-examples.yml:37`
- `.github/workflows/comparisons-examples.yml:55`
- `.github/workflows/github-legends.yml:55`
- `.github/workflows/github-legends.yml:73`
- `.github/workflows/go-examples.yml:67`
- `.github/workflows/go-examples.yml:85`
- `.github/workflows/javascript-examples.yml:43`
- `.github/workflows/javascript-examples.yml:57`
- `.github/workflows/math-and-3d-examples.yml:55`
- `.github/workflows/math-and-3d-examples.yml:70`
- `.github/workflows/merge-examples.yml:14`
- `.github/workflows/merge-examples.yml:18`
- `.github/workflows/merge-examples.yml:37`
- `.github/workflows/rust-examples.yml:44`
- `.github/workflows/rust-examples.yml:60`
- `.github/workflows/tabular-data-examples.yml:60`
- `.github/workflows/tabular-data-examples.yml:79`
- `.github/workflows/installers.yml:24`
- `.github/workflows/installers.yml:36`
- `.github/workflows/installers.yml:48`

### missing-permissions (severity: medium)

The following workflow files have no top-level `permissions:` key and contain at least one job without a job-level `permissions:` block: action-ci.yml (jobs: stateless, stateful — no permissions at any level); api-contract.yml (jobs: contract, docs — no permissions at any level); comparisons-examples.yml (job: convert — no permissions); github-legends.yml (job: convert — no permissions); go-examples.yml (job: convert — no permissions); javascript-examples.yml (job: convert — no permissions); math-and-3d-examples.yml (job: convert — no permissions); rust-examples.yml (job: convert — no permissions); tabular-data-examples.yml (job: convert — no permissions); ui.yml (jobs: lint, format, test, build — no permissions).

Locations:

- `.github/workflows/action-ci.yml:1`
- `.github/workflows/api-contract.yml:1`
- `.github/workflows/comparisons-examples.yml:1`
- `.github/workflows/github-legends.yml:1`
- `.github/workflows/go-examples.yml:1`
- `.github/workflows/javascript-examples.yml:1`
- `.github/workflows/math-and-3d-examples.yml:1`
- `.github/workflows/rust-examples.yml:1`
- `.github/workflows/tabular-data-examples.yml:1`
- `.github/workflows/ui.yml:1`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.vizb-binary }}" appears directly in run: block of step "Resolve vizb version"; move to env: map

Locations:

- `action.yml:126`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.vizb-binary }}" appears directly in run: block of step "Install vizb"; move to env: map

Locations:

- `action.yml:163`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.file }}" appears directly in run: block of step "Resolve input"; move to env: map

Locations:

- `action.yml:224`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.bench-file }}" appears directly in run: block of step "Resolve input"; move to env: map

Locations:

- `action.yml:225`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.cmd }}" appears directly in run: block of step "Resolve input"; move to env: map

Locations:

- `action.yml:226`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.bench-cmd }}" appears directly in run: block of step "Resolve input"; move to env: map

Locations:

- `action.yml:227`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.merge-files }}" appears directly in run: block of step "Resolve input"; move to env: map

Locations:

- `action.yml:231`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.merge-dir }}" appears directly in run: block of step "Resolve input"; move to env: map

Locations:

- `action.yml:231`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.data-url }}" appears directly in run: block of step "Resolve input"; move to env: map

Locations:

- `action.yml:231`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.output-json }}" appears directly in run: block of step "Resolve input"; move to env: map

Locations:

- `action.yml:247`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.tag }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:263`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.tag }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:263`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.id }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:264`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.id }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:264`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.name }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:265`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.name }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:265`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.title }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:266`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.title }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:266`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.description }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:267`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.description }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:267`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.group }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:268`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.group }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:268`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.group-pattern }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:269`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.group-pattern }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:269`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.group-regex }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:270`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.group-regex }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:270`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.sort }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:271`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.sort }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:271`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.filter }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:272`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.filter }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:272`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mem-unit }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:273`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mem-unit }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:273`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.time-unit }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:274`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.time-unit }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:274`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.number-unit }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:275`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.number-unit }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:275`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.round }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:276`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.col-axis }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:278`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.col-axis }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:278`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.json-path }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:279`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.json-path }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:279`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.show-labels }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:280`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.parser }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:281`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.parser }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:281`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.charts }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:282`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.chart }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:282`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.stat }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:282`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.merge-files }}" appears directly in run: block of step "Merge"; move to env: map

Locations:

- `action.yml:301`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.merge-files }}" appears directly in run: block of step "Merge"; move to env: map

Locations:

- `action.yml:301`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.merge-dir }}" appears directly in run: block of step "Merge"; move to env: map

Locations:

- `action.yml:302`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.merge-dir }}" appears directly in run: block of step "Merge"; move to env: map

Locations:

- `action.yml:302`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.tag-axis }}" appears directly in run: block of step "Merge"; move to env: map

Locations:

- `action.yml:303`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.charts }}" appears directly in run: block of step "Generate HTML"; move to env: map

Locations:

- `action.yml:311`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.chart }}" appears directly in run: block of step "Generate HTML"; move to env: map

Locations:

- `action.yml:311`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.stat }}" appears directly in run: block of step "Generate HTML"; move to env: map

Locations:

- `action.yml:311`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.enable-3d }}" appears directly in run: block of step "Generate HTML"; move to env: map

Locations:

- `action.yml:312`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.data-url }}" appears directly in run: block of step "Generate HTML"; move to env: map

Locations:

- `action.yml:314`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.data-url }}" appears directly in run: block of step "Generate HTML"; move to env: map

Locations:

- `action.yml:315`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.output-html }}" appears directly in run: block of step "Generate HTML"; move to env: map

Locations:

- `action.yml:315`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.output-html }}" appears directly in run: block of step "Generate HTML"; move to env: map

Locations:

- `action.yml:317`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, github-env-injection, unpinned-uses, missing-permissions, static-inline-injection

**Notes:**

Fixed all findings across action.yml and 13 workflow files:

1. script-injection & static-inline-injection (action.yml): Moved all ${{ }} expressions from run: blocks to env: blocks for all 5 steps (Resolve vizb version, Install vizb, Resolve input, Convert to JSON, Merge, Generate HTML). The RESOLVE_CMD is now passed via env var and executed with eval (acceptable since it's the action's own cmd input). The merge-files list is tokenized with xargs for safe word-splitting.

2. script-injection (cli.yml): Moved github.event.pull_request.base.sha and github.event.pull_request.head.sha to env: block (BASE_SHA, HEAD_SHA).

3. github-env-injection (action.yml): Replaced heredoc-based GITHUB_OUTPUT writes (vulnerable to EOF injection) with printf '%s' | tr -d '\n\r' sanitization for FILE, CMD, and OUT_JSON values.

4. unpinned-uses: Pinned all 18 action references to their full 40-character SHA digests across action.yml and all workflow files (cli.yml, action-ci.yml, api-contract.yml, codeql.yml, release.yml, sync-embed-ui.yml, winget.yml, publish-site.yml, ui.yml, comparisons-examples.yml, github-legends.yml, go-examples.yml, javascript-examples.yml, math-and-3d-examples.yml, merge-examples.yml, rust-examples.yml, tabular-data-examples.yml, installers.yml, deploy-docs.yml).

5. missing-permissions: Added top-level permissions: contents: read to action-ci.yml, api-contract.yml, comparisons-examples.yml, github-legends.yml, go-examples.yml, javascript-examples.yml, math-and-3d-examples.yml, rust-examples.yml, tabular-data-examples.yml, and ui.yml.

### Iteration 2

**Fixes applied:** github-env-injection, script-injection

**Notes:**

Fixed two high-severity findings in hardened/action/action.yml:

1. github-env-injection (lines 130, 133): In the 'Resolve vizb version' step, added sanitization for both $TAG (network-controlled git ls-remote output) and $REF (from github.action_ref) before writing to $GITHUB_OUTPUT. Used `safe_tag=$(printf '%s' "$TAG" | tr -d '\n\r')` and `safe_ref=$(printf '%s' "$REF" | tr -d '\n\r')` respectively.

2. script-injection (line 233): In the 'Convert to JSON' step, replaced `eval "$RESOLVE_CMD" > "$INPUT"` with a safe xargs-based tokenization approach. The command is now split into an array using `while IFS= read -r -d '' t; do cmd_args+=("$t"); done < <(printf '%s' "$RESOLVE_CMD" | xargs printf '%s\0')` and executed as `"${cmd_args[@]}" > "$INPUT"`. This prevents shell metacharacter injection while correctly handling quoted arguments in the command string (e.g., `sh -c "exit 0"`).

### Iteration 3

**Fixes applied:** script-injection

**Notes:**

Fixed two script injection vulnerabilities in .github/workflows/merge-examples.yml:
1. 'Prepare output directory' step (line 34): Added `env: EXAMPLE_CATEGORY: ${{ inputs.example_category }}` and changed `run:` to use `"dist/examples/live/$EXAMPLE_CATEGORY"` with double-quoting.
2. 'Local preview ready' step (line 45): Added `env: EXAMPLE_CATEGORY: ${{ inputs.example_category }}` and changed `run:` to use `$EXAMPLE_CATEGORY` instead of the direct expression interpolation.
Remaining uses of `${{ inputs.example_category }}` in `with:` blocks are not shell run: commands and are not vulnerable to shell injection.

### Iteration 4

**Fixes applied:** script-injection

**Notes:**

Fixed script injection in 7 workflow files by moving ${{ matrix.id }} and ${{ matrix.serial }} expressions out of run: shell commands and into env: blocks. Each affected step now declares MATRIX_ID (and MATRIX_SERIAL for github-legends.yml) in an env: block, and the run: command references the safe shell variable ("$MATRIX_ID", "$MATRIX_SERIAL") instead of directly interpolating the GitHub Actions expression. Files fixed: comparisons-examples.yml, github-legends.yml, go-examples.yml, javascript-examples.yml, math-and-3d-examples.yml, rust-examples.yml, tabular-data-examples.yml.

### Iteration 5

**Fixes applied:** unpinned-uses

**Notes:**

Pinned both mutable tag references in hardened/action/.github/actions/setup-js/action.yml:
- `pnpm/action-setup@v6` → `pnpm/action-setup@0977fd99725f1db4007ccb2928dbb4e90d06cc86 # v6` (line 14)
- `actions/setup-node@v6` → `actions/setup-node@249970729cb0ef3589644e2896645e5dc5ba9c38 # v6` (line 18)

SHAs were resolved using lookup_action_sha and are full 40-character commit digests.

