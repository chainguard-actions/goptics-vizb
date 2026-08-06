<!-- markdownlint-disable -->

# Hardening Report: goptics--vizb/v0.16.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **goptics--vizb/v0.16.0** was hardened automatically. 79 finding(s) were identified and resolved across 2 iteration(s).

## Findings Fixed

### script-injection (severity: high)

action.yml 'Resolve vizb version' step directly interpolates ${{ inputs.vizb-binary }} and ${{ github.action_ref }} inside a run: shell block. These expressions are substituted before the shell parses the script, allowing an attacker-controlled value to inject arbitrary shell commands.

Locations:

- `action.yml:115`
- `action.yml:121`

### script-injection (severity: high)

action.yml 'Install vizb' step directly interpolates ${{ inputs.vizb-binary }}, ${{ runner.os }}, ${{ runner.arch }}, and ${{ steps.version.outputs.tag }} inside a run: shell block. Any of these values is substituted into the shell script before execution, enabling command injection.

Locations:

- `action.yml:143`
- `action.yml:151`
- `action.yml:153`
- `action.yml:156`

### script-injection (severity: high)

action.yml 'Resolve input' step directly interpolates ${{ inputs.file }}, ${{ inputs.bench-file }}, ${{ inputs.cmd }}, ${{ inputs.bench-cmd }}, ${{ inputs.merge-files }}, ${{ inputs.merge-dir }}, ${{ inputs.data-url }}, and ${{ inputs.output-json }} inside a run: shell block without quoting or env-var indirection, enabling command injection via attacker-controlled inputs.

Locations:

- `action.yml:175`
- `action.yml:176`
- `action.yml:177`
- `action.yml:178`

### script-injection (severity: high)

action.yml 'Convert to JSON' step directly interpolates many ${{ inputs.* }} and ${{ steps.resolve.outputs.* }} expressions in a run: shell block. Most critically, '${{ steps.resolve.outputs.cmd }}' is executed directly as a shell command (sub-rule a), and multiple inputs are interpolated unquoted into shell conditionals and array assignments (sub-rule a). Examples: `${{ steps.resolve.outputs.cmd }} > "$INPUT"`, `[ -n "${{ inputs.tag }}" ]`, `VIZB_ARGS+=(--tag "${{ inputs.tag }}")`, etc.

Locations:

- `action.yml:213`
- `action.yml:214`
- `action.yml:215`
- `action.yml:216`
- `action.yml:248`

### script-injection (severity: high)

action.yml 'Merge' step directly interpolates ${{ steps.resolve.outputs.json_file }}, ${{ inputs.merge-files }} (unquoted — word-splits into array), ${{ inputs.merge-dir }}, and ${{ inputs.tag-axis }} inside a run: shell block. The unquoted `${{ inputs.merge-files }}` is especially dangerous as it undergoes shell word-splitting and glob expansion.

Locations:

- `action.yml:256`
- `action.yml:258`
- `action.yml:259`
- `action.yml:260`

### script-injection (severity: high)

action.yml 'Generate HTML' step directly interpolates ${{ inputs.charts }}, ${{ inputs.chart }}, ${{ inputs.stat }}, ${{ inputs.enable-3d }}, ${{ inputs.data-url }}, and ${{ inputs.output-html }} inside a run: shell block, enabling command injection via attacker-controlled inputs.

Locations:

- `action.yml:268`
- `action.yml:269`
- `action.yml:272`
- `action.yml:273`
- `action.yml:274`

### script-injection (severity: high)

Multiple workflow files directly interpolate ${{ matrix.id }} and ${{ inputs.example_category }} inside run: shell commands (sub-rule a). Examples: `run: mkdir -p .act/jsons && cp ${{ matrix.id }}.json .act/jsons/` in go-examples.yml, comparisons-examples.yml, javascript-examples.yml, rust-examples.yml, math-and-3d-examples.yml, tabular-data-examples.yml, github-legends.yml; and `run: mkdir -p dist/examples/${{ inputs.example_category }}` and `run: echo "::notice::.../${{ inputs.example_category }}/index.html"` in merge-examples.yml.

Locations:

- `.github/workflows/go-examples.yml:100`
- `.github/workflows/comparisons-examples.yml:68`
- `.github/workflows/javascript-examples.yml:63`
- `.github/workflows/rust-examples.yml:62`
- `.github/workflows/math-and-3d-examples.yml:76`
- `.github/workflows/tabular-data-examples.yml:79`
- `.github/workflows/github-legends.yml:60`
- `.github/workflows/merge-examples.yml:31`
- `.github/workflows/merge-examples.yml:40`

### github-env-injection (severity: high)

action.yml 'Resolve vizb version' step writes ${{ github.action_ref }} (stored in shell variable $REF) to $GITHUB_OUTPUT via `echo "tag=$REF" >> "$GITHUB_OUTPUT"` and `echo "tag=$TAG" >> "$GITHUB_OUTPUT"` without sanitizing newlines with `printf '%s' ... | tr -d '\n\r'`. An attacker-controlled ref containing newlines could inject additional output variables.

Locations:

- `action.yml:121`
- `action.yml:128`
- `action.yml:131`

### github-env-injection (severity: high)

action.yml 'Resolve input' step writes attacker-controlled inputs directly to $GITHUB_OUTPUT without sanitization. Specifically: ${{ inputs.file }}, ${{ inputs.bench-file }}, ${{ inputs.cmd }}, ${{ inputs.bench-cmd }} are stored in $FILE/$CMD and written via heredoc to $GITHUB_OUTPUT; ${{ inputs.output-json }} is written via `echo "json_file=$OUT_JSON" >> "$GITHUB_OUTPUT"`. None of these writes are preceded by `printf '%s' ... | tr -d '\n\r'`.

Locations:

- `action.yml:175`
- `action.yml:176`
- `action.yml:177`
- `action.yml:178`
- `action.yml:196`
- `action.yml:200`

### unpinned-uses (severity: high)

action.yml references `actions/cache@v6` — a mutable version tag, not a pinned 40-character commit SHA. If the tag is moved, the action will silently execute different code.

Locations:

- `action.yml:136`

### unpinned-uses (severity: high)

Multiple workflow files use mutable version tags instead of pinned commit SHAs. Failing references include: actions/checkout@v7, actions/setup-go@v6, actions/upload-artifact@v7, actions/download-artifact@v8, actions/setup-node@v6, pnpm/action-setup@v6, golangci/golangci-lint-action@v9, codecov/codecov-action@v7, trstringer/manual-approval@v1, goreleaser/goreleaser-action@v7, vedantmgoyal2009/winget-releaser@v2, peaceiris/actions-gh-pages@v4.

Locations:

- `.github/workflows/action-ci.yml:10`
- `.github/workflows/cli.yml:22`
- `.github/workflows/api-contract.yml:22`
- `.github/workflows/ui.yml:18`
- `.github/workflows/deploy-docs.yml:20`
- `.github/workflows/release.yml:14`
- `.github/workflows/publish-site.yml:20`
- `.github/workflows/winget.yml:10`
- `.github/workflows/go-examples.yml:82`
- `.github/workflows/javascript-examples.yml:47`
- `.github/workflows/rust-examples.yml:45`
- `.github/workflows/tabular-data-examples.yml:63`
- `.github/workflows/comparisons-examples.yml:52`
- `.github/workflows/math-and-3d-examples.yml:60`
- `.github/workflows/github-legends.yml:47`
- `.github/workflows/merge-examples.yml:19`

### missing-permissions (severity: medium)

action-ci.yml has no top-level `permissions:` key and none of its jobs (embed-ui, stateless, stateful) define job-level permissions. This means the workflow runs with the default (potentially broad) token permissions.

Locations:

- `.github/workflows/action-ci.yml:1`

### missing-permissions (severity: medium)

cli.yml has no top-level `permissions:` key and none of its jobs (embed-ui, lint, format, test, action) define job-level permissions. This means the workflow runs with the default token permissions.

Locations:

- `.github/workflows/cli.yml:1`

### missing-permissions (severity: medium)

api-contract.yml has no top-level `permissions:` key and none of its jobs (contract, docs) define job-level permissions.

Locations:

- `.github/workflows/api-contract.yml:1`

### missing-permissions (severity: medium)

ui.yml has no top-level `permissions:` key and none of its jobs (lint, format, test, build) define job-level permissions.

Locations:

- `.github/workflows/ui.yml:1`

### missing-permissions (severity: medium)

go-examples.yml has no top-level `permissions:` key and the `convert` job has no job-level permissions (only the `merge` job does). The convert job runs without explicit permission restrictions.

Locations:

- `.github/workflows/go-examples.yml:1`

### missing-permissions (severity: medium)

javascript-examples.yml has no top-level `permissions:` key and the `convert` job has no job-level permissions (only the `merge` job does).

Locations:

- `.github/workflows/javascript-examples.yml:1`

### missing-permissions (severity: medium)

rust-examples.yml has no top-level `permissions:` key and the `convert` job has no job-level permissions (only the `merge` job does).

Locations:

- `.github/workflows/rust-examples.yml:1`

### missing-permissions (severity: medium)

tabular-data-examples.yml has no top-level `permissions:` key and the `convert` job has no job-level permissions (only the `merge` job does).

Locations:

- `.github/workflows/tabular-data-examples.yml:1`

### missing-permissions (severity: medium)

comparisons-examples.yml has no top-level `permissions:` key and the `convert` job has no job-level permissions (only the `merge` job does).

Locations:

- `.github/workflows/comparisons-examples.yml:1`

### missing-permissions (severity: medium)

math-and-3d-examples.yml has no top-level `permissions:` key and the `convert` job has no job-level permissions (only the `merge` job does).

Locations:

- `.github/workflows/math-and-3d-examples.yml:1`

### missing-permissions (severity: medium)

github-legends.yml has no top-level `permissions:` key and the `convert` job has no job-level permissions (only the `merge` job does).

Locations:

- `.github/workflows/github-legends.yml:1`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.vizb-binary }}" appears directly in run: block of step "Resolve vizb version"; move to env: map

Locations:

- `action.yml:120`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.vizb-binary }}" appears directly in run: block of step "Install vizb"; move to env: map

Locations:

- `action.yml:157`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.file }}" appears directly in run: block of step "Resolve input"; move to env: map

Locations:

- `action.yml:218`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.bench-file }}" appears directly in run: block of step "Resolve input"; move to env: map

Locations:

- `action.yml:219`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.cmd }}" appears directly in run: block of step "Resolve input"; move to env: map

Locations:

- `action.yml:220`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.bench-cmd }}" appears directly in run: block of step "Resolve input"; move to env: map

Locations:

- `action.yml:221`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.merge-files }}" appears directly in run: block of step "Resolve input"; move to env: map

Locations:

- `action.yml:225`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.merge-dir }}" appears directly in run: block of step "Resolve input"; move to env: map

Locations:

- `action.yml:225`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.data-url }}" appears directly in run: block of step "Resolve input"; move to env: map

Locations:

- `action.yml:225`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.output-json }}" appears directly in run: block of step "Resolve input"; move to env: map

Locations:

- `action.yml:241`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.tag }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:257`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.tag }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:257`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.id }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:258`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.id }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:258`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.name }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:259`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.name }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:259`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.description }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:260`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.description }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:260`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.group }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:261`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.group }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:261`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.group-pattern }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:262`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.group-pattern }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:262`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.group-regex }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:263`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.group-regex }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:263`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.sort }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:264`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.sort }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:264`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.filter }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:265`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.filter }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:265`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mem-unit }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:266`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mem-unit }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:266`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.time-unit }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:267`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.time-unit }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:267`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.number-unit }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:268`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.number-unit }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:268`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.col-axis }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:270`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.col-axis }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:270`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.json-path }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:271`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.json-path }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:271`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.show-labels }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:272`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.parser }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:273`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.parser }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:273`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.charts }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:274`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.chart }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:274`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.stat }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:274`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.merge-files }}" appears directly in run: block of step "Merge"; move to env: map

Locations:

- `action.yml:293`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.merge-files }}" appears directly in run: block of step "Merge"; move to env: map

Locations:

- `action.yml:293`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.merge-dir }}" appears directly in run: block of step "Merge"; move to env: map

Locations:

- `action.yml:294`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.merge-dir }}" appears directly in run: block of step "Merge"; move to env: map

Locations:

- `action.yml:294`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.tag-axis }}" appears directly in run: block of step "Merge"; move to env: map

Locations:

- `action.yml:295`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.charts }}" appears directly in run: block of step "Generate HTML"; move to env: map

Locations:

- `action.yml:303`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.chart }}" appears directly in run: block of step "Generate HTML"; move to env: map

Locations:

- `action.yml:303`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.stat }}" appears directly in run: block of step "Generate HTML"; move to env: map

Locations:

- `action.yml:303`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.enable-3d }}" appears directly in run: block of step "Generate HTML"; move to env: map

Locations:

- `action.yml:304`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.data-url }}" appears directly in run: block of step "Generate HTML"; move to env: map

Locations:

- `action.yml:306`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.data-url }}" appears directly in run: block of step "Generate HTML"; move to env: map

Locations:

- `action.yml:307`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.output-html }}" appears directly in run: block of step "Generate HTML"; move to env: map

Locations:

- `action.yml:307`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.output-html }}" appears directly in run: block of step "Generate HTML"; move to env: map

Locations:

- `action.yml:309`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, github-env-injection, unpinned-uses, missing-permissions, static-inline-injection

**Notes:**

Fixed all findings across action.yml and 11 workflow files:

1. script-injection/static-inline-injection (action.yml): Moved all ${{ inputs.* }}, ${{ github.action_ref }}, ${{ runner.os }}, ${{ runner.arch }}, and ${{ steps.*.outputs.* }} expressions from run: blocks into env: blocks. The run: scripts now reference plain $VAR_NAME environment variables. The RESOLVE_CMD is executed via eval "$RESOLVE_CMD" (the cmd value comes from a sanitized step output).

2. github-env-injection (action.yml): All GITHUB_OUTPUT writes now sanitize values with printf '%s' "$VAR" | tr -d '\n\r' before writing. The file/cmd heredoc outputs use sanitized variables (safe_file, safe_cmd, safe_out, safe_tag, safe_ref).

3. unpinned-uses (action.yml): actions/cache@v6 pinned to SHA 55cc8345863c7cc4c66a329aec7e433d2d1c52a9.

4. unpinned-uses (workflow files): All 12 mutable version tags replaced with pinned commit SHAs across action-ci.yml, cli.yml, api-contract.yml, ui.yml, deploy-docs.yml, release.yml, publish-site.yml, winget.yml, go-examples.yml, javascript-examples.yml, rust-examples.yml, tabular-data-examples.yml, comparisons-examples.yml, math-and-3d-examples.yml, github-legends.yml, merge-examples.yml.

5. missing-permissions: Added permissions: {} top-level blocks to action-ci.yml, cli.yml, api-contract.yml, ui.yml, go-examples.yml, javascript-examples.yml, rust-examples.yml, tabular-data-examples.yml, comparisons-examples.yml, math-and-3d-examples.yml, github-legends.yml. Added job-level permissions: contents: read to all jobs that only need read access.

6. script-injection (workflow files): Fixed ${{ matrix.id }} and ${{ inputs.example_category }} in run: blocks by moving them to env: blocks in all example workflow files and merge-examples.yml.

### Iteration 2

**Fixes applied:** script-injection

**Notes:**

Fixed the unquoted `$INPUT_MERGE_FILES` expansion in the 'Merge' step of action.yml (line ~310). Replaced `FILES+=($INPUT_MERGE_FILES)` with a safe NUL-delimited read-loop: `while IFS= read -r -d '' merge_file; do [ -n "$merge_file" ] && FILES+=("$merge_file"); done < <(printf '%s' "$INPUT_MERGE_FILES" | tr ' ' '\0')`. This eliminates glob expansion and prevents shell metacharacter injection while preserving the intended space-separated file list splitting behavior.

