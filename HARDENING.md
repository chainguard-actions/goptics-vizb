<!-- markdownlint-disable -->

# Hardening Report: goptics--vizb/v0.18.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **goptics--vizb/v0.18.0** was hardened automatically. 63 finding(s) were identified and resolved across 2 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Multiple run: blocks in action.yml directly interpolate ${{ }} expressions inside shell commands, enabling script injection. Sub-rule (a): direct expression interpolation in run: blocks.

'Resolve vizb version' step: `if [ -n "${{ inputs.vizb-binary }}" ]` and `REF="${{ github.action_ref }}"`

'Install vizb' step: `VIZB_BINARY="${{ inputs.vizb-binary }}"`, `OS=$(echo "${{ runner.os }}" | ...)`, `ARCH=$(echo "${{ runner.arch }}" | ...)`, `TAG="${{ steps.version.outputs.tag }}"`

'Resolve input' step: `FILE="${{ inputs.file }}"`, `CMD="${{ inputs.cmd }}"`, `${{ inputs.merge-files }}`, `${{ inputs.merge-dir }}`, `${{ inputs.data-url }}`, `${{ inputs.output-json }}`

'Convert to JSON' step: `${{ inputs.tag }}`, `${{ inputs.name }}`, `${{ inputs.title }}`, `${{ inputs.description }}`, `${{ inputs.group }}`, `${{ inputs.filter }}`, and critically `${{ steps.resolve.outputs.cmd }} > "$INPUT"` — the resolved command is executed directly as a shell command via expression interpolation.

'Merge' step: `${{ inputs.merge-files }}` (unquoted, sub-rule b), `${{ inputs.merge-dir }}`, `${{ inputs.tag-axis }}`

'Generate HTML' step: `${{ inputs.charts }}`, `${{ inputs.chart }}`, `${{ inputs.stat }}`, `${{ inputs.data-url }}`, `${{ inputs.output-html }}`

All these must be moved to env: variables and then double-quoted in the shell script.

Locations:

- `action.yml:113`
- `action.yml:119`
- `action.yml:134`
- `action.yml:140`
- `action.yml:142`
- `action.yml:147`
- `action.yml:163`
- `action.yml:167`
- `action.yml:168`
- `action.yml:169`
- `action.yml:170`
- `action.yml:171`
- `action.yml:195`
- `action.yml:215`
- `action.yml:230`
- `action.yml:237`

### github-env-injection (severity: high)

The 'Resolve input' step in action.yml writes user-controlled input values to $GITHUB_OUTPUT without sanitization. The variables FILE (from ${{ inputs.file }} / ${{ inputs.bench-file }}) and CMD (from ${{ inputs.cmd }} / ${{ inputs.bench-cmd }}) are written via a heredoc block (`echo "$FILE"` and `echo "$CMD"`) to $GITHUB_OUTPUT without the required `printf '%s' ... | tr -d '\n\r'` sanitization step. Similarly, OUT_JSON (from ${{ inputs.output-json }}) is written as `echo "json_file=$OUT_JSON" >> "$GITHUB_OUTPUT"` without sanitization. An attacker-controlled newline in any of these inputs can inject arbitrary key=value pairs into GITHUB_OUTPUT, potentially overwriting subsequent step outputs.

Locations:

- `action.yml:175`
- `action.yml:176`
- `action.yml:177`
- `action.yml:178`
- `action.yml:183`

### unpinned-uses (severity: high)

The action uses `actions/cache@v6` which is pinned to a mutable version tag rather than an immutable full-length commit SHA. A tag can be moved to point to a different (potentially malicious) commit, enabling supply-chain attacks. It should be pinned to a full 40-character hex SHA, e.g. `actions/cache@5a3ec84eff668545956fd18022155c47e93e2684 # v4`.

Locations:

- `action.yml:128`

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

**Fixes applied:** script-injection, static-inline-injection, github-env-injection, unpinned-uses

**Notes:**

Rewrote hardened/action/action.yml to fix all findings:
1. Pinned actions/cache@v6 to SHA 55cc8345863c7cc4c66a329aec7e433d2d1c52a9.
2. Moved all ${{ }} expressions from run: blocks into env: blocks for all 6 steps (Resolve vizb version, Install vizb, Resolve input, Convert to JSON, Merge, Generate HTML).
3. Sanitized GITHUB_OUTPUT writes in 'Resolve input' step: FILE and CMD use printf+tr -d '\n\r' before writing via heredoc; OUT_JSON is sanitized before echo to GITHUB_OUTPUT.
4. The 'merge-files' list input is tokenized via xargs into a bash array to preserve correct argument boundaries while preventing injection.
5. The resolved command (RESOLVE_CMD) in 'Convert to JSON' is tokenized via xargs into a cmd_args array before execution, preventing shell injection from step outputs.

### Iteration 2

**Fixes applied:** github-env-injection, script-injection, unpinned-uses, missing-permissions

**Notes:**

Fixed all four security findings:

1. github-env-injection (action.yml line 135): Sanitized REF and TAG variables before writing to $GITHUB_OUTPUT using `printf '%s' "$VAR" | tr -d '\n\r'` pattern.

2. script-injection: Moved all ${{ }} expressions from run: shell strings into env: blocks across 9 workflow files (cli.yml, merge-examples.yml, comparisons-examples.yml, github-legends.yml, go-examples.yml, javascript-examples.yml, math-and-3d-examples.yml, rust-examples.yml, tabular-data-examples.yml).

3. unpinned-uses: Pinned all 17 action references to full 40-character SHA commits across all 19 workflow files. All SHAs were resolved using lookup_action_sha.

4. missing-permissions: Added top-level `permissions: contents: read` to action-ci.yml, api-contract.yml, and ui.yml. Added job-level `permissions: contents: read` to the convert jobs in comparisons-examples.yml, github-legends.yml, go-examples.yml, javascript-examples.yml, math-and-3d-examples.yml, rust-examples.yml, and tabular-data-examples.yml.

