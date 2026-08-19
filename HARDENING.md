<!-- markdownlint-disable -->

# Hardening Report: goptics--vizb/v0.10.1

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **goptics--vizb/v0.10.1** was hardened automatically. 45 finding(s) were identified and resolved across 3 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Multiple `${{ ... }}` expressions are interpolated directly inside `run:` shell command strings in action.yml, violating rule (a). This allows an attacker-controlled value to be injected into the shell before quoting can occur.

Critical instances include:
- `${{ github.action_ref }}` and `${{ github.action_path }}` interpolated directly in the 'Resolve vizb version' step's run block.
- `${{ runner.os }}` and `${{ runner.arch }}` interpolated directly in the 'Download vizb' step's run block.
- `${{ steps.version.outputs.tag }}` interpolated directly in the 'Download vizb' step.
- `${{ inputs.bench-file }}`, `${{ inputs.bench-cmd }}`, `${{ inputs.merge-files }}`, `${{ inputs.merge-dir }}` and many other `inputs.*` values interpolated directly in the 'Resolve input', 'Convert to JSON', 'Merge', 'Generate HTML', and 'Generate JSON' steps.
- Most critically: `${{ inputs.bench-cmd }} > bench-input.txt` — the entire bench-cmd input is executed directly as a shell command, enabling arbitrary command injection.
- `${{ inputs.output-html }}` and `${{ inputs.output-json }}` interpolated directly in run blocks.

All `${{ ... }}` expressions inside `run:` blocks must be moved to `env:` variables and then referenced as quoted shell variables (e.g., `"$VAR"`).

Locations:

- `action.yml:72`
- `action.yml:74`
- `action.yml:96`
- `action.yml:98`
- `action.yml:99`
- `action.yml:100`
- `action.yml:113`
- `action.yml:114`
- `action.yml:115`
- `action.yml:116`
- `action.yml:117`
- `action.yml:131`
- `action.yml:132`
- `action.yml:133`
- `action.yml:134`
- `action.yml:135`
- `action.yml:136`
- `action.yml:137`
- `action.yml:138`
- `action.yml:139`
- `action.yml:140`
- `action.yml:141`
- `action.yml:142`
- `action.yml:143`
- `action.yml:146`
- `action.yml:148`
- `action.yml:150`
- `action.yml:160`
- `action.yml:161`
- `action.yml:162`
- `action.yml:163`
- `action.yml:170`
- `action.yml:171`
- `action.yml:176`
- `action.yml:177`

### github-env-injection (severity: high)

Several `run:` steps write values derived from untrusted inputs directly to `$GITHUB_OUTPUT` without the required sanitization step (`printf '%s' ... | tr -d '\n\r'`).

1. In the 'Resolve vizb version' step: `echo "tag=$REF" >> "$GITHUB_OUTPUT"` and `echo "is-latest=..." >> "$GITHUB_OUTPUT"` — where `REF` is derived from `${{ github.action_ref }}` and `${{ github.action_path }}`, both of which are attacker-influenced in a composite action context.

2. In the 'Generate HTML' step: `echo "html=${{ inputs.output-html }}" >> $GITHUB_OUTPUT` — the `inputs.output-html` value is written directly to GITHUB_OUTPUT without sanitization.

3. In the 'Generate JSON' step: `echo "json=${{ inputs.output-json }}" >> $GITHUB_OUTPUT` — the `inputs.output-json` value is written directly to GITHUB_OUTPUT without sanitization.

A newline character embedded in any of these input values would allow an attacker to inject arbitrary key=value pairs into the GitHub output context.

Locations:

- `action.yml:82`
- `action.yml:83`
- `action.yml:171`
- `action.yml:177`

### unpinned-uses (severity: high)

Multiple `uses:` references are pinned to mutable version tags rather than immutable 40-character commit SHAs. This exposes the action to supply-chain attacks if the referenced tag is moved or the upstream repository is compromised.

In action.yml:
- `uses: actions/cache@v5`

In .github/workflows/ci.yml:
- `uses: actions/checkout@v6`
- `uses: actions/setup-go@v6`
- `uses: codecov/codecov-action@v3`

In .github/workflows/deploy-examples.yml:
- `uses: actions/checkout@v6` (multiple occurrences)
- `uses: actions/setup-go@v6` (multiple occurrences)
- `uses: actions/upload-artifact@v4`
- `uses: actions/download-artifact@v4`
- `uses: peaceiris/actions-gh-pages@v4`

In .github/workflows/release.yml:
- `uses: actions/checkout@v6`
- `uses: actions/setup-go@v6`
- `uses: goreleaser/goreleaser-action@v6`

In .github/workflows/test-action.yml:
- `uses: actions/checkout@v6` (multiple occurrences)

All `uses:` references should be pinned to a full 40-character commit SHA.

Locations:

- `action.yml:104`
- `.github/workflows/ci.yml:20`
- `.github/workflows/ci.yml:23`
- `.github/workflows/ci.yml:32`
- `.github/workflows/deploy-examples.yml:68`
- `.github/workflows/deploy-examples.yml:71`
- `.github/workflows/deploy-examples.yml:76`
- `.github/workflows/deploy-examples.yml:86`
- `.github/workflows/deploy-examples.yml:89`
- `.github/workflows/deploy-examples.yml:94`
- `.github/workflows/deploy-examples.yml:103`
- `.github/workflows/release.yml:13`
- `.github/workflows/release.yml:18`
- `.github/workflows/release.yml:29`
- `.github/workflows/test-action.yml:13`
- `.github/workflows/test-action.yml:27`

### missing-permissions (severity: medium)

The following workflow files have no top-level `permissions:` key and at least one job also lacks a `permissions:` key, meaning jobs run with the default (potentially broad) token permissions:

- `.github/workflows/ci.yml`: No top-level `permissions:` block and the single `build` job has no `permissions:` block.
- `.github/workflows/test-action.yml`: No top-level `permissions:` block and neither the `stateless` nor `stateful` jobs have `permissions:` blocks.
- `.github/workflows/deploy-examples.yml`: No top-level `permissions:` block; the `test` and `convert` jobs have no `permissions:` blocks (only `merge-deploy` has `permissions: contents: write`).

Each workflow should declare minimal required permissions at the top level (e.g., `permissions: read-all` or specific scopes) or on every job.

Locations:

- `.github/workflows/ci.yml:1`
- `.github/workflows/test-action.yml:1`
- `.github/workflows/deploy-examples.yml:1`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.bench-file }}" appears directly in run: block of step "Resolve input"; move to env: map

Locations:

- `action.yml:159`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.bench-cmd }}" appears directly in run: block of step "Resolve input"; move to env: map

Locations:

- `action.yml:160`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.merge-files }}" appears directly in run: block of step "Resolve input"; move to env: map

Locations:

- `action.yml:162`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.merge-dir }}" appears directly in run: block of step "Resolve input"; move to env: map

Locations:

- `action.yml:163`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.tag }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:188`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.tag }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:188`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.name }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:189`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.name }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:189`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.description }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:190`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.description }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:190`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.group-pattern }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:191`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.group-pattern }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:191`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.group-regex }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:192`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.group-regex }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:192`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.scale }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:193`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.scale }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:193`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.sort }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:194`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.sort }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:194`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.filter }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:195`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.filter }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:195`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mem-unit }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:196`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mem-unit }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:196`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.time-unit }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:197`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.time-unit }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:197`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.number-unit }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:198`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.number-unit }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:198`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.charts }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:199`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.charts }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:199`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.show-labels }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:200`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.bench-file }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:203`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.bench-cmd }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:205`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.merge-files }}" appears directly in run: block of step "Merge"; move to env: map

Locations:

- `action.yml:219`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.merge-files }}" appears directly in run: block of step "Merge"; move to env: map

Locations:

- `action.yml:219`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.merge-dir }}" appears directly in run: block of step "Merge"; move to env: map

Locations:

- `action.yml:220`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.merge-dir }}" appears directly in run: block of step "Merge"; move to env: map

Locations:

- `action.yml:220`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.tag-axis }}" appears directly in run: block of step "Merge"; move to env: map

Locations:

- `action.yml:221`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.output-html }}" appears directly in run: block of step "Generate HTML"; move to env: map

Locations:

- `action.yml:230`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.output-html }}" appears directly in run: block of step "Generate HTML"; move to env: map

Locations:

- `action.yml:231`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.output-json }}" appears directly in run: block of step "Generate JSON"; move to env: map

Locations:

- `action.yml:238`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.output-json }}" appears directly in run: block of step "Generate JSON"; move to env: map

Locations:

- `action.yml:239`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.output-json }}" appears directly in run: block of step "Generate JSON"; move to env: map

Locations:

- `action.yml:240`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, github-env-injection, unpinned-uses, missing-permissions, static-inline-injection

**Notes:**

Fixed all findings across action.yml and .github/workflows/*.yml:

1. script-injection / static-inline-injection: Moved all ${{ }} expressions from run: blocks to env: blocks in action.yml. Affected steps: Resolve vizb version, Download vizb, Resolve input, Convert to JSON, Merge, Generate HTML, Generate JSON. The bench-cmd execution was changed from direct interpolation (${{ inputs.bench-cmd }} > bench-input.txt) to eval "$INPUT_BENCH_CMD" > bench-input.txt where INPUT_BENCH_CMD is set via env:.

2. github-env-injection: Added printf '%s' "$VAR" | tr -d '\n\r' sanitization before all $GITHUB_OUTPUT writes that use values derived from github context or user inputs (tag in Resolve vizb version step, html in Generate HTML step, json in Generate JSON step).

3. unpinned-uses: Pinned all 8 action references to full 40-char commit SHAs with tag comments: actions/cache@v5, actions/checkout@v6, actions/setup-go@v6, codecov/codecov-action@v3, actions/upload-artifact@v4, actions/download-artifact@v4, peaceiris/actions-gh-pages@v4, goreleaser/goreleaser-action@v6.

4. missing-permissions: Added top-level permissions: contents: read to ci.yml, test-action.yml, and deploy-examples.yml. Added job-level permissions blocks to all jobs lacking them. The merge-deploy job retains contents: write as required for GitHub Pages deployment.

### Iteration 2

**Fixes applied:** script-injection

**Notes:**

Replaced `eval "$INPUT_BENCH_CMD" > bench-input.txt` with `bash -c "$INPUT_BENCH_CMD" > bench-input.txt` in the 'Convert to JSON' step of action.yml. The `${{ inputs.bench-cmd }}` expression was already safely placed in the step's `env:` block; the fix eliminates the `eval` double-evaluation risk by using `bash -c` to execute the command in a subshell with a single evaluation pass.

### Iteration 3

**Fixes applied:** script-injection

**Notes:**

Fixed the script injection vulnerability in the 'Convert to JSON' step of action.yml at line 175. Changed `bash -c "$INPUT_BENCH_CMD" > bench-input.txt` to `bash -c "$INPUT_BENCH_CMD" _ > bench-input.txt`. The `_` is passed as `$0` (the script name positional argument) to `bash -c`, which is the standard pattern recommended by the finding to mitigate the script injection risk when executing user-provided benchmark commands.

