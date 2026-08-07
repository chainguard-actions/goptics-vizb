<!-- markdownlint-disable -->

# Hardening Report: goptics--vizb/v0.18.2

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **goptics--vizb/v0.18.2** was hardened automatically. 63 finding(s) were identified and resolved across 4 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Multiple ${{ ... }} expressions are directly interpolated inside run: shell command strings throughout action.yml, violating rule (a). This includes attacker-controlled inputs: ${{ inputs.vizb-binary }}, ${{ inputs.file }}, ${{ inputs.bench-file }}, ${{ inputs.cmd }}, ${{ inputs.bench-cmd }}, ${{ inputs.name }}, ${{ inputs.tag }}, ${{ inputs.id }}, ${{ inputs.title }}, ${{ inputs.description }}, ${{ inputs.group }}, ${{ inputs.group-pattern }}, ${{ inputs.group-regex }}, ${{ inputs.sort }}, ${{ inputs.filter }}, ${{ inputs.mem-unit }}, ${{ inputs.time-unit }}, ${{ inputs.number-unit }}, ${{ inputs.round }}, ${{ inputs.col-axis }}, ${{ inputs.json-path }}, ${{ inputs.show-labels }}, ${{ inputs.parser }}, ${{ inputs.charts }}, ${{ inputs.chart }}, ${{ inputs.stat }}, ${{ inputs.merge-files }}, ${{ inputs.merge-dir }}, ${{ inputs.data-url }}, ${{ inputs.output-html }}, ${{ inputs.output-json }}, ${{ inputs.tag-axis }}, ${{ inputs.enable-3d }}, and also ${{ github.action_ref }}, ${{ runner.os }}, ${{ runner.arch }}, ${{ steps.version.outputs.tag }}, ${{ steps.resolve.outputs.file }}, ${{ steps.resolve.outputs.json_file }}. Most critically, ${{ steps.resolve.outputs.cmd }} (which is derived from user-controlled inputs.cmd) is executed directly as a shell command: `${{ steps.resolve.outputs.cmd }} > "$INPUT"`. Additionally, ${{ inputs.merge-files }} is used unquoted in shell expansion `FILES+=(${{ inputs.merge-files }})`, violating rule (b).

Locations:

- `action.yml:136`
- `action.yml:143`
- `action.yml:163`
- `action.yml:168`
- `action.yml:172`
- `action.yml:178`
- `action.yml:196`
- `action.yml:200`
- `action.yml:204`
- `action.yml:208`
- `action.yml:212`
- `action.yml:216`
- `action.yml:220`
- `action.yml:224`
- `action.yml:228`
- `action.yml:232`
- `action.yml:236`
- `action.yml:240`
- `action.yml:244`
- `action.yml:248`
- `action.yml:252`
- `action.yml:256`
- `action.yml:260`
- `action.yml:264`
- `action.yml:268`
- `action.yml:272`
- `action.yml:276`
- `action.yml:280`
- `action.yml:284`
- `action.yml:288`
- `action.yml:292`
- `action.yml:296`
- `action.yml:300`
- `action.yml:304`
- `action.yml:308`
- `action.yml:312`
- `action.yml:316`
- `action.yml:320`
- `action.yml:324`
- `action.yml:328`
- `action.yml:332`
- `action.yml:336`
- `action.yml:340`
- `action.yml:344`
- `action.yml:348`
- `action.yml:352`
- `action.yml:356`
- `action.yml:360`
- `action.yml:364`
- `action.yml:368`

### github-env-injection (severity: high)

In the 'Resolve vizb version' step, $REF (set from ${{ github.action_ref }}) is written to $GITHUB_OUTPUT without sanitization: `echo "tag=$REF" >> "$GITHUB_OUTPUT"`. In the 'Resolve input' step, $FILE (derived from ${{ inputs.file }} / ${{ inputs.bench-file }}), $CMD (derived from ${{ inputs.cmd }} / ${{ inputs.bench-cmd }}), and $OUT_JSON (from ${{ inputs.output-json }}) are all written to $GITHUB_OUTPUT without the required `printf '%s' ... | tr -d '\n\r'` sanitization step. An attacker can inject newlines into these values to poison subsequent GITHUB_OUTPUT entries.

Locations:

- `action.yml:136`
- `action.yml:143`
- `action.yml:163`
- `action.yml:168`
- `action.yml:172`
- `action.yml:178`
- `action.yml:196`
- `action.yml:200`

### unpinned-uses (severity: high)

The composite action uses `actions/cache@v6` which is pinned to a mutable version tag rather than an immutable 40-character commit SHA. This is vulnerable to supply-chain attacks if the tag is moved to a different commit.

Locations:

- `action.yml:121`

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

**Fixes applied:** unpinned-uses, script-injection, github-env-injection, static-inline-injection

**Notes:**

Fixed all findings in action.yml:
1. Pinned actions/cache@v6 to full SHA 55cc8345863c7cc4c66a329aec7e433d2d1c52a9
2. Moved all ${{ inputs.* }}, ${{ github.action_ref }}, ${{ runner.* }}, and ${{ steps.*.outputs.* }} expressions from run: blocks into env: maps for every step (Resolve vizb version, Install vizb, Resolve input, Convert to JSON, Merge, Generate HTML)
3. Sanitized all GITHUB_OUTPUT writes with printf '%s' ... | tr -d '\n\r' to prevent newline injection
4. Fixed merge-files list handling using xargs-based tokenization with proper guarded while/read loop
5. Fixed cmd execution: RESOLVE_CMD env var is passed as a string argument to sh -c rather than being directly interpolated into the script

### Iteration 2

**Fixes applied:** unpinned-uses, script-injection, missing-permissions

**Notes:**

Fixed all three finding types across 19 workflow files:

1. unpinned-uses: Pinned all 17 distinct action references to full 40-char SHAs with tag comments. All actions resolved via lookup_action_sha. Note: actions/upload-artifact@v8 was not found in the repo (only v7 was used); actions/cache@v6 was also not present in workflow files.

2. script-injection: (a) cli.yml forbid-gen-commit job: moved github.event.pull_request.base.sha and github.event.pull_request.head.sha into env vars BASE_SHA/HEAD_SHA. (b) merge-examples.yml: moved inputs.example_category into env var EXAMPLE_CATEGORY for both the 'Prepare output directory' run step and the 'Local preview ready' run step.

3. missing-permissions: Added top-level 'permissions: contents: read' to action-ci.yml, api-contract.yml, comparisons-examples.yml, github-legends.yml, go-examples.yml, javascript-examples.yml, math-and-3d-examples.yml, rust-examples.yml, tabular-data-examples.yml, and ui.yml. Added job-level permissions blocks to the convert jobs in example workflows and to lint/format/test/build jobs in ui.yml.

### Iteration 3

**Fixes applied:** script-injection

**Notes:**

Fixed script injection in 7 workflow files by moving ${{ matrix.id }} and ${{ matrix.serial }} expressions from run: shell strings into env: blocks. Files fixed: comparisons-examples.yml, go-examples.yml, javascript-examples.yml, math-and-3d-examples.yml, rust-examples.yml, tabular-data-examples.yml, github-legends.yml. Each 'Stage json for local merge' step now uses MATRIX_ID and MATRIX_SERIAL environment variables (properly double-quoted) instead of inline template expressions.

### Iteration 4

**Fixes applied:** unpinned-uses

**Notes:**

Pinned both unpinned action references in hardened/action/.github/actions/setup-js/action.yml:
- pnpm/action-setup@v6 → pnpm/action-setup@0977fd99725f1db4007ccb2928dbb4e90d06cc86 # v6
- actions/setup-node@v6 → actions/setup-node@249970729cb0ef3589644e2896645e5dc5ba9c38 # v6
Original version tags preserved as inline comments for readability.

