<!-- markdownlint-disable -->

# Hardening Report: goptics--vizb--/v0.14.1

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `1`

Action **goptics--vizb--/v0.14.1** was hardened automatically. 59 finding(s) were identified and resolved across 2 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Multiple run: blocks in action.yml directly interpolate ${{ inputs.* }}, ${{ github.* }}, and ${{ steps.*.outputs.* }} expressions inside shell commands, violating rule (a). This allows an attacker who controls input values to inject arbitrary shell commands.

Step 'Resolve vizb version' (~line 86): `if [ -n "${{ inputs.vizb-binary }}" ]` and `REF="${{ github.action_ref }}"`

Step 'Install vizb' (~line 122): `VIZB_BINARY="${{ inputs.vizb-binary }}"`, `OS=$(echo "${{ runner.os }}" | ...)`, `ARCH=$(echo "${{ runner.arch }}" | ...)`, `TAG="${{ steps.version.outputs.tag }}"`

Step 'Resolve input' (~line 152): `FILE="${{ inputs.file }}"`, `CMD="${{ inputs.cmd }}"`, `${{ inputs.merge-files }}`, `${{ inputs.merge-dir }}`, `${{ inputs.data-url }}`, `${{ inputs.output-json }}`

Step 'Convert to JSON' (~line 192): Numerous `${{ inputs.* }}` interpolations including tag, id, name, description, group, group-pattern, group-regex, sort, filter, mem-unit, time-unit, number-unit, json-path, show-labels, parser, charts, chart, stat; also `${{ steps.resolve.outputs.cmd }}` is executed directly as a shell command without quoting.

Step 'Merge' (~line 236): `${{ steps.resolve.outputs.json_file }}`, `${{ inputs.merge-files }}` (unquoted, word-split), `${{ inputs.merge-dir }}`, `${{ inputs.tag-axis }}`

Step 'Generate HTML' (~line 251): `${{ inputs.charts }}`, `${{ inputs.chart }}`, `${{ inputs.stat }}`, `${{ inputs.enable-3d }}`, `${{ inputs.data-url }}`, `${{ inputs.output-html }}`, `${{ steps.resolve.outputs.json_file }}`

Locations:

- `action.yml:86`
- `action.yml:122`
- `action.yml:152`
- `action.yml:192`
- `action.yml:236`
- `action.yml:251`

### github-env-injection (severity: high)

The 'Resolve input' step writes user-controlled input values to $GITHUB_OUTPUT without sanitization. `OUT_JSON="${{ inputs.output-json }}"` is written as `echo "json_file=$OUT_JSON" >> "$GITHUB_OUTPUT"` without stripping newlines via `printf '%s' ... | tr -d '\n\r'`. An attacker could inject newlines to add arbitrary key=value pairs to GITHUB_OUTPUT. Similarly, `$FILE` (from `${{ inputs.file }}`) and `$CMD` (from `${{ inputs.cmd }}`) are written to GITHUB_OUTPUT via heredoc without sanitization of embedded newlines within the values.

Locations:

- `action.yml:152`

### unpinned-uses (severity: high)

Multiple workflow files and action.yml use actions pinned to mutable tags/versions rather than immutable full 40-character SHA digests, making them vulnerable to supply-chain attacks if the tag is moved.

action.yml: actions/cache@v6

action-ci.yml: actions/checkout@v7, actions/setup-go@v6

cli.yml: actions/checkout@v7, actions/setup-go@v6, golangci/golangci-lint-action@v9, codecov/codecov-action@v7

deploy-docs.yml: actions/checkout@v7, pnpm/action-setup@v6, actions/setup-node@v6, peaceiris/actions-gh-pages@v4

deploy-examples-csv.yml: actions/checkout@v7, actions/upload-artifact@v7

deploy-examples-go.yml: actions/checkout@v7, actions/upload-artifact@v7

deploy-examples-javascript.yml: actions/checkout@v7, actions/upload-artifact@v7

deploy-examples-json.yml: actions/checkout@v7, actions/upload-artifact@v7

deploy-examples-rust.yml: actions/checkout@v7, actions/upload-artifact@v7

merge-deploy-examples.yml: actions/checkout@v7, actions/download-artifact@v8, peaceiris/actions-gh-pages@v4

release.yml: trstringer/manual-approval@v1, actions/checkout@v7, actions/setup-go@v6, goreleaser/goreleaser-action@v7, vedantmgoyal2009/winget-releaser@v2

ui.yml: actions/checkout@v7, pnpm/action-setup@v6, actions/setup-node@v6, actions/setup-go@v6

winget.yml: vedantmgoyal2009/winget-releaser@v2

Locations:

- `action.yml:113`
- `.github/workflows/action-ci.yml:13`
- `.github/workflows/cli.yml:26`
- `.github/workflows/deploy-docs.yml:16`
- `.github/workflows/deploy-examples-csv.yml:75`
- `.github/workflows/deploy-examples-go.yml:72`
- `.github/workflows/deploy-examples-javascript.yml:29`
- `.github/workflows/deploy-examples-json.yml:40`
- `.github/workflows/deploy-examples-rust.yml:29`
- `.github/workflows/merge-deploy-examples.yml:18`
- `.github/workflows/release.yml:18`
- `.github/workflows/ui.yml:22`
- `.github/workflows/winget.yml:10`

### missing-permissions (severity: medium)

Several workflow files have no top-level permissions block and at least one job also lacks a job-level permissions block, meaning the workflow runs with the default (potentially broad) GITHUB_TOKEN permissions.

- action-ci.yml: No top-level permissions; neither 'stateless' nor 'stateful' jobs have permissions blocks.
- cli.yml: No top-level permissions; 'lint', 'format', 'test', and 'action' jobs have no permissions blocks.
- ui.yml: No top-level permissions; 'lint', 'format', 'test', and 'build' jobs have no permissions blocks.
- deploy-examples-csv.yml: No top-level permissions; the 'convert' job has no permissions block (only 'merge-deploy' does).
- deploy-examples-go.yml: No top-level permissions; the 'convert' job has no permissions block (only 'merge-deploy' does).
- deploy-examples-javascript.yml: No top-level permissions; the 'convert' job has no permissions block (only 'merge-deploy' does).
- deploy-examples-json.yml: No top-level permissions; the 'convert' job has no permissions block (only 'merge-deploy' does).
- deploy-examples-rust.yml: No top-level permissions; the 'convert' job has no permissions block (only 'merge-deploy' does).

Locations:

- `.github/workflows/action-ci.yml:1`
- `.github/workflows/cli.yml:1`
- `.github/workflows/ui.yml:1`
- `.github/workflows/deploy-examples-csv.yml:1`
- `.github/workflows/deploy-examples-go.yml:1`
- `.github/workflows/deploy-examples-javascript.yml:1`
- `.github/workflows/deploy-examples-json.yml:1`
- `.github/workflows/deploy-examples-rust.yml:1`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.vizb-binary }}" appears directly in run: block of step "Resolve vizb version"; move to env: map

Locations:

- `action.yml:117`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.vizb-binary }}" appears directly in run: block of step "Install vizb"; move to env: map

Locations:

- `action.yml:154`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.file }}" appears directly in run: block of step "Resolve input"; move to env: map

Locations:

- `action.yml:215`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.bench-file }}" appears directly in run: block of step "Resolve input"; move to env: map

Locations:

- `action.yml:216`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.cmd }}" appears directly in run: block of step "Resolve input"; move to env: map

Locations:

- `action.yml:217`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.bench-cmd }}" appears directly in run: block of step "Resolve input"; move to env: map

Locations:

- `action.yml:218`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.merge-files }}" appears directly in run: block of step "Resolve input"; move to env: map

Locations:

- `action.yml:222`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.merge-dir }}" appears directly in run: block of step "Resolve input"; move to env: map

Locations:

- `action.yml:222`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.data-url }}" appears directly in run: block of step "Resolve input"; move to env: map

Locations:

- `action.yml:222`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.output-json }}" appears directly in run: block of step "Resolve input"; move to env: map

Locations:

- `action.yml:238`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.tag }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:254`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.tag }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:254`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.id }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:255`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.id }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:255`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.name }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:256`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.name }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:256`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.description }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:257`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.description }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:257`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.group }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:258`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.group }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:258`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.group-pattern }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:259`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.group-pattern }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:259`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.group-regex }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:260`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.group-regex }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:260`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.sort }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:261`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.sort }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:261`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.filter }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:262`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.filter }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:262`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mem-unit }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:263`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mem-unit }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:263`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.time-unit }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:264`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.time-unit }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:264`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.number-unit }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:265`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.number-unit }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:265`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.json-path }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:267`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.json-path }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:267`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.show-labels }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:268`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.parser }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:269`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.parser }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:269`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.charts }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:270`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.chart }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:270`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.stat }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:270`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.merge-files }}" appears directly in run: block of step "Merge"; move to env: map

Locations:

- `action.yml:289`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.merge-files }}" appears directly in run: block of step "Merge"; move to env: map

Locations:

- `action.yml:289`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.merge-dir }}" appears directly in run: block of step "Merge"; move to env: map

Locations:

- `action.yml:290`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.merge-dir }}" appears directly in run: block of step "Merge"; move to env: map

Locations:

- `action.yml:290`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.tag-axis }}" appears directly in run: block of step "Merge"; move to env: map

Locations:

- `action.yml:291`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.charts }}" appears directly in run: block of step "Generate HTML"; move to env: map

Locations:

- `action.yml:299`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.chart }}" appears directly in run: block of step "Generate HTML"; move to env: map

Locations:

- `action.yml:299`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.stat }}" appears directly in run: block of step "Generate HTML"; move to env: map

Locations:

- `action.yml:299`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.enable-3d }}" appears directly in run: block of step "Generate HTML"; move to env: map

Locations:

- `action.yml:300`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.data-url }}" appears directly in run: block of step "Generate HTML"; move to env: map

Locations:

- `action.yml:302`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.data-url }}" appears directly in run: block of step "Generate HTML"; move to env: map

Locations:

- `action.yml:303`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.output-html }}" appears directly in run: block of step "Generate HTML"; move to env: map

Locations:

- `action.yml:303`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.output-html }}" appears directly in run: block of step "Generate HTML"; move to env: map

Locations:

- `action.yml:305`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, github-env-injection, unpinned-uses, missing-permissions, static-inline-injection

**Notes:**

Fixed all findings in action.yml and all workflow files under .github/workflows/.

1. script-injection / static-inline-injection (action.yml): All ${{ inputs.* }}, ${{ github.* }}, and ${{ steps.*.outputs.* }} expressions in run: blocks were moved to env: blocks. Each step now references environment variables instead of inline expressions.

2. github-env-injection (action.yml, Resolve input step): Values written to $GITHUB_OUTPUT are now sanitized using `printf '%s' "$VAR" | tr -d '\n\r'` before writing. The file and cmd outputs use heredoc with sanitized values; output-json is sanitized via safe_out_json variable.

3. unpinned-uses: All action references pinned to full 40-character SHA digests:
   - actions/cache@v6 → @55cc8345863c7cc4c66a329aec7e433d2d1c52a9
   - actions/checkout@v7 → @9c091bb21b7c1c1d1991bb908d89e4e9dddfe3e0
   - actions/setup-go@v6 → @924ae3a1cded613372ab5595356fb5720e22ba16
   - golangci/golangci-lint-action@v9 → @ba0d7d2ec06a0ea1cb5fa41b2e4a3ab91d21278a
   - codecov/codecov-action@v7 → @fb8b3582c8e4def4969c97caa2f19720cb33a72f
   - pnpm/action-setup@v6 → @0ebf47130e4866e96fce0953f49152a61190b271
   - actions/setup-node@v6 → @48b55a011bda9f5d6aeb4c2d9c7362e8dae4041e
   - peaceiris/actions-gh-pages@v4 → @84c30a85c19949d7eee79c4ff27748b70285e453
   - actions/upload-artifact@v7 → @043fb46d1a93c77aae656e7c1c64a875d1fc6a0a
   - actions/download-artifact@v8 → @3e5f45b2cfb9172054b4087a40e8e0b5a5461e7c
   - trstringer/manual-approval@v1 → @fa642940caf8412403569b28b2db4a1df08a83a3
   - goreleaser/goreleaser-action@v7 → @f06c13b6b1a9625abc9e6e439d9c05a8f2190e94
   - vedantmgoyal2009/winget-releaser@v2 → @4ffc7888bffd451b357355dc214d43bb9f23917e

4. missing-permissions: Added `permissions: {}` at top-level and job-level `permissions: { contents: read }` to action-ci.yml, cli.yml, ui.yml, deploy-examples-csv.yml, deploy-examples-go.yml, deploy-examples-javascript.yml, deploy-examples-json.yml, and deploy-examples-rust.yml.

### Iteration 2

**Fixes applied:** script-injection, github-env-injection

**Notes:**

Fixed all four security findings:
1. script-injection (matrix.id): In deploy-examples-csv.yml, deploy-examples-go.yml, deploy-examples-javascript.yml, deploy-examples-json.yml, and deploy-examples-rust.yml, moved `${{ matrix.id }}` out of the `run:` shell string into an `env:` block as `MATRIX_ID`, and quoted it as `"${MATRIX_ID}.json"` in the shell command.
2. script-injection (inputs.language): In merge-deploy-examples.yml, moved `${{ inputs.language }}` into `env:` blocks as `INPUT_LANGUAGE` for both the 'Prepare output directory' step and the 'Local preview ready' step.
3. github-env-injection: In action.yml 'Resolve vizb version' step, sanitized `$TAG` and `$REF` before writing to GITHUB_OUTPUT using `safe_tag=$(printf '%s' "$TAG" | tr -d '\n\r')` and `safe_ref=$(printf '%s' "$REF" | tr -d '\n\r')` respectively.
4. script-injection (unquoted $INPUT_MERGE_FILES): In action.yml 'Merge' step, replaced the unquoted `FILES+=($INPUT_MERGE_FILES)` with `read -ra _merge_files <<< "$INPUT_MERGE_FILES"; FILES+=("${_merge_files[@]}")` to prevent glob expansion and word-splitting of attacker-controlled content.

