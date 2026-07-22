<!-- markdownlint-disable -->

# Hardening Report: goptics--vizb/v0.14.1

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **goptics--vizb/v0.14.1** was hardened automatically. 64 finding(s) were identified and resolved across 2 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (a): The 'Resolve vizb version' run: block directly interpolates `${{ inputs.vizb-binary }}` and `${{ github.action_ref }}` inside shell commands. These expressions are substituted by the Actions runner before the shell sees them, allowing an attacker-controlled value to inject arbitrary shell commands. Example offending lines: `if [ -n "${{ inputs.vizb-binary }}" ]; then` and `REF="${{ github.action_ref }}"`

Locations:

- `action.yml:117`
- `action.yml:125`

### script-injection (severity: high)

Rule (a): The 'Install vizb' run: block directly interpolates `${{ inputs.vizb-binary }}`, `${{ runner.os }}`, `${{ runner.arch }}`, and `${{ steps.version.outputs.tag }}` inside shell commands. Any of these values flowing through YAML template substitution before the shell parses them enables script injection. Example: `VIZB_BINARY="${{ inputs.vizb-binary }}"`, `OS=$(echo "${{ runner.os }}" | tr ...)`, `TAG="${{ steps.version.outputs.tag }}"`

Locations:

- `action.yml:149`
- `action.yml:156`
- `action.yml:158`
- `action.yml:161`

### script-injection (severity: high)

Rule (a) and (b): The 'Resolve input' run: block directly interpolates multiple `${{ inputs.* }}` expressions inside shell commands: `FILE="${{ inputs.file }}"`, `FILE="${{ inputs.bench-file }}"`, `CMD="${{ inputs.cmd }}"`, `CMD="${{ inputs.bench-cmd }}"`, `${{ inputs.merge-files }}`, `${{ inputs.merge-dir }}`, `${{ inputs.data-url }}`, and `${{ inputs.output-json }}`. These allow attacker-controlled input values to inject shell commands.

Locations:

- `action.yml:196`
- `action.yml:197`
- `action.yml:198`
- `action.yml:199`
- `action.yml:202`

### script-injection (severity: high)

Rule (a) and (b): The 'Convert to JSON' run: block directly interpolates dozens of `${{ inputs.* }}` and `${{ steps.resolve.outputs.* }}` expressions inside shell commands. Most critically, `${{ steps.resolve.outputs.cmd }}` is executed directly as a shell command (`${{ steps.resolve.outputs.cmd }} > "$INPUT"`), which allows arbitrary command execution. Additionally, `${{ inputs.merge-files }}` is expanded unquoted in an array context. Offending lines include: `[ -n "${{ inputs.tag }}" ] && VIZB_ARGS+=(--tag "${{ inputs.tag }}")`, `${{ steps.resolve.outputs.cmd }} > "$INPUT"`, and many others.

Locations:

- `action.yml:228`
- `action.yml:253`

### script-injection (severity: high)

Rule (a) and (b): The 'Merge' run: block directly interpolates `${{ steps.resolve.outputs.json_file }}`, `${{ inputs.merge-files }}` (unquoted — `FILES+=(${{ inputs.merge-files }})`), `${{ inputs.merge-dir }}`, and `${{ inputs.tag-axis }}` inside shell commands. The unquoted `${{ inputs.merge-files }}` expansion is especially dangerous as it allows word-splitting and glob expansion of attacker-controlled content.

Locations:

- `action.yml:261`
- `action.yml:263`
- `action.yml:264`
- `action.yml:265`

### script-injection (severity: high)

Rule (a): The 'Generate HTML' run: block directly interpolates `${{ inputs.charts }}`, `${{ inputs.chart }}`, `${{ inputs.stat }}`, `${{ inputs.enable-3d }}`, `${{ inputs.data-url }}`, `${{ inputs.output-html }}`, and `${{ steps.resolve.outputs.json_file }}` inside shell commands. Example: `append_chart_stat_flags VIZB_UI_ARGS "${{ inputs.charts }}" "${{ inputs.chart }}" "${{ inputs.stat }}"` and `vizb ui -U "${{ inputs.data-url }}" -o "${{ inputs.output-html }}" ...`

Locations:

- `action.yml:272`
- `action.yml:275`
- `action.yml:277`
- `action.yml:279`

### github-env-injection (severity: high)

The 'Resolve vizb version' run: block writes `$REF` (derived directly from `${{ github.action_ref }}`) to `$GITHUB_OUTPUT` without sanitization (no `printf '%s' ... | tr -d '\n\r'` step). A newline in the ref value could inject additional key=value pairs into GITHUB_OUTPUT. Offending lines: `REF="${{ github.action_ref }}"` followed by `echo "tag=$REF" >> "$GITHUB_OUTPUT"` and `echo "tag=$TAG" >> "$GITHUB_OUTPUT"` where TAG is derived from REF.

Locations:

- `action.yml:125`
- `action.yml:133`
- `action.yml:135`

### github-env-injection (severity: high)

The 'Resolve input' run: block writes `$FILE` (derived from `${{ inputs.file }}` / `${{ inputs.bench-file }}`) and `$CMD` (derived from `${{ inputs.cmd }}` / `${{ inputs.bench-cmd }}`) to `$GITHUB_OUTPUT` using a heredoc without sanitization. A newline embedded in these input values could escape the heredoc delimiter or inject additional output variables. Offending block: `echo "$FILE"` and `echo "$CMD"` written into `$GITHUB_OUTPUT`. Additionally, `$OUT_JSON` (from `${{ inputs.output-json }}`) is written as `echo "json_file=$OUT_JSON" >> "$GITHUB_OUTPUT"` without sanitization.

Locations:

- `action.yml:207`
- `action.yml:209`
- `action.yml:211`
- `action.yml:215`

### unpinned-uses (severity: high)

The 'Cache vizb binary' step uses `actions/cache@v6` which is pinned to a mutable version tag (`v6`) rather than an immutable 40-character commit SHA. This means the action could be silently updated to a different (potentially malicious) version without the workflow author's knowledge. It should be pinned to a full SHA, e.g. `actions/cache@1bd1e32a3bdc45362d1e726936510720a7c6158d # v4`.

Locations:

- `action.yml:140`

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

**Fixes applied:** script-injection, static-inline-injection, github-env-injection, unpinned-uses

**Notes:**

Fixed all security findings in hardened/action/action.yml:

1. **unpinned-uses**: Pinned `actions/cache@v6` to full SHA `actions/cache@55cc8345863c7cc4c66a329aec7e433d2d1c52a9 # v6`.

2. **script-injection / static-inline-injection**: Moved ALL `${{ }}` expressions out of `run:` blocks and into `env:` blocks for all 6 affected steps (Resolve vizb version, Install vizb, Resolve input, Convert to JSON, Merge, Generate HTML). Shell scripts now reference plain environment variables only.

3. **github-env-injection**: Added `printf '%s' "$VAR" | tr -d '\n\r'` sanitization before writing derived values to `$GITHUB_OUTPUT` in both the 'Resolve vizb version' step (for TAG/REF) and the 'Resolve input' step (for FILE, CMD, and OUT_JSON).

4. **Merge step unquoted expansion**: Fixed the dangerous `FILES+=(${{ inputs.merge-files }})` unquoted expansion by using `read -ra _merge_files <<< "$INPUT_MERGE_FILES"` to safely split the space-separated list.

5. **Convert to JSON cmd execution**: The dangerous direct `${{ steps.resolve.outputs.cmd }} > "$INPUT"` execution is now done via `eval "$RESOLVE_CMD" > "$INPUT"` where `RESOLVE_CMD` is a safely-assigned env var.

### Iteration 2

**Fixes applied:** script-injection, missing-permissions, unpinned-uses

**Notes:**

Fixed all three finding types across 13 files:

1. script-injection in action.yml: Replaced `eval "$RESOLVE_CMD"` with `bash -c "$RESOLVE_CMD"` to avoid eval builtin with user-controlled input.

2. script-injection in 5 deploy-examples-*.yml files: Moved `${{ matrix.id }}` from run block shell commands into env: blocks as MATRIX_ID env var.

3. script-injection in merge-deploy-examples.yml: Moved `${{ inputs.language }}` from both run block shell commands into env: blocks as INPUT_LANGUAGE env var.

4. missing-permissions in 8 workflow files: Added `permissions: {}` top-level blocks to action-ci.yml, cli.yml, deploy-examples-csv.yml, deploy-examples-go.yml, deploy-examples-javascript.yml, deploy-examples-json.yml, deploy-examples-rust.yml, and ui.yml.

5. unpinned-uses in 12 workflow files: Pinned all 12 action references (actions/checkout@v7, actions/setup-go@v6, golangci/golangci-lint-action@v9, codecov/codecov-action@v7, pnpm/action-setup@v6, actions/setup-node@v6, peaceiris/actions-gh-pages@v4, actions/upload-artifact@v7, actions/download-artifact@v8, trstringer/manual-approval@v1, goreleaser/goreleaser-action@v7, vedantmgoyal2009/winget-releaser@v2) to full 40-character commit SHAs with tag comments.

