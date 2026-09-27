<!-- markdownlint-disable -->

# Hardening Report: goptics--vizb/v0.18.1

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **goptics--vizb/v0.18.1** was hardened automatically. 63 finding(s) were identified and resolved across 2 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Multiple `run:` blocks in action.yml directly interpolate `${{ ... }}` expressions (rule a), including attacker-controllable `inputs.*` values and `github.action_ref`, as well as `runner.*` and `steps.*.outputs.*` contexts. This allows shell metacharacter injection before the shell ever sees the value. Affected steps and representative offending lines:

• 'Resolve vizb version' step: `if [ -n "${{ inputs.vizb-binary }}" ]` and `REF="${{ github.action_ref }}"`
• 'Install vizb' step: `VIZB_BINARY="${{ inputs.vizb-binary }}"`, `OS=$(echo "${{ runner.os }}" | ...)`, `ARCH=$(echo "${{ runner.arch }}" | ...)`, `TAG="${{ steps.version.outputs.tag }}"`
• 'Resolve input' step: `FILE="${{ inputs.file }}"`, `CMD="${{ inputs.cmd }}"`, `${{ inputs.merge-files }}`, `${{ inputs.merge-dir }}`, `${{ inputs.data-url }}`, `${{ inputs.output-json }}`
• 'Convert to JSON' step: `${{ inputs.tag }}`, `${{ inputs.id }}`, `${{ inputs.name }}`, `${{ inputs.title }}`, `${{ inputs.description }}`, `${{ inputs.group }}`, `${{ inputs.group-pattern }}`, `${{ inputs.group-regex }}`, `${{ inputs.sort }}`, `${{ inputs.filter }}`, `${{ inputs.mem-unit }}`, `${{ inputs.time-unit }}`, `${{ inputs.number-unit }}`, `${{ inputs.round }}`, `${{ inputs.col-axis }}`, `${{ inputs.json-path }}`, `${{ inputs.show-labels }}`, `${{ inputs.parser }}`, `${{ inputs.charts }}`, `${{ inputs.chart }}`, `${{ inputs.stat }}`, `${{ steps.resolve.outputs.file }}`, `${{ steps.resolve.outputs.cmd }}` (directly executed as a shell command!), `${{ steps.resolve.outputs.json_file }}`
• 'Merge' step (rule b also): `FILES+=(${{ inputs.merge-files }})` — unquoted expansion of untrusted input; also `${{ inputs.merge-dir }}`, `${{ inputs.tag-axis }}`, `${{ steps.resolve.outputs.json_file }}`
• 'Generate HTML' step: `${{ inputs.charts }}`, `${{ inputs.chart }}`, `${{ inputs.stat }}`, `${{ inputs.enable-3d }}`, `${{ inputs.data-url }}`, `${{ inputs.output-html }}`, `${{ steps.resolve.outputs.json_file }}`

All `${{ ... }}` expressions must be moved to `env:` variables and then double-quoted in the shell script.

Locations:

- `action.yml:115`
- `action.yml:121`
- `action.yml:145`
- `action.yml:152`
- `action.yml:154`
- `action.yml:156`
- `action.yml:183`
- `action.yml:185`
- `action.yml:187`
- `action.yml:189`
- `action.yml:191`
- `action.yml:193`
- `action.yml:195`
- `action.yml:197`
- `action.yml:210`
- `action.yml:222`
- `action.yml:224`
- `action.yml:226`
- `action.yml:228`
- `action.yml:230`
- `action.yml:232`
- `action.yml:234`
- `action.yml:236`
- `action.yml:238`
- `action.yml:240`
- `action.yml:242`
- `action.yml:244`
- `action.yml:246`
- `action.yml:248`
- `action.yml:250`
- `action.yml:252`
- `action.yml:254`
- `action.yml:256`
- `action.yml:258`
- `action.yml:261`
- `action.yml:263`
- `action.yml:265`
- `action.yml:271`
- `action.yml:273`
- `action.yml:275`
- `action.yml:277`
- `action.yml:284`
- `action.yml:286`
- `action.yml:288`
- `action.yml:290`
- `action.yml:292`
- `action.yml:294`

### github-env-injection (severity: high)

Multiple `run:` blocks write untrusted-input values to `$GITHUB_OUTPUT` without the required sanitization step (`printf '%s' ... | tr -d '\n\r'`):

1. 'Resolve vizb version' step: `${{ github.action_ref }}` is assigned to shell variable `REF`, then written unsanitized to `$GITHUB_OUTPUT` via `echo "tag=$REF" >> "$GITHUB_OUTPUT"`. An attacker-controlled action ref containing newlines could inject arbitrary key=value pairs into GITHUB_OUTPUT.

2. 'Resolve input' step: `${{ inputs.file }}` and `${{ inputs.bench-file }}` are assigned to `FILE`; `${{ inputs.cmd }}` and `${{ inputs.bench-cmd }}` are assigned to `CMD`. Both `$FILE` and `$CMD` are written to `$GITHUB_OUTPUT` via a heredoc (`echo "$FILE"` / `echo "$CMD"` inside `{ ... } >> "$GITHUB_OUTPUT"`). An attacker-supplied newline in these inputs could inject additional output variables.

3. 'Resolve input' step: `${{ inputs.output-json }}` is assigned to `OUT_JSON`, then written unsanitized via `echo "json_file=$OUT_JSON" >> "$GITHUB_OUTPUT"`.

All values derived from `inputs.*` or `github.*` must be sanitized with `printf '%s' "$VAR" | tr -d '\n\r'` before being written to special environment files.

Locations:

- `action.yml:121`
- `action.yml:131`
- `action.yml:183`
- `action.yml:197`
- `action.yml:205`
- `action.yml:210`

### unpinned-uses (severity: high)

The `uses:` reference `actions/cache@v6` is pinned to a mutable version tag (`v6`) rather than an immutable 40-character commit SHA. A compromised or modified tag could cause the action to execute arbitrary code. It should be pinned to a full SHA, e.g. `actions/cache@5a3ec84eff668545956fd18022155c47e93e2684 # v4`.

Locations:

- `action.yml:139`

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

Rewrote hardened/action/action.yml with all security fixes:

1. **unpinned-uses**: Pinned `actions/cache@v6` to full SHA `actions/cache@55cc8345863c7cc4c66a329aec7e433d2d1c52a9 # v6`.

2. **script-injection / static-inline-injection**: Moved all `${{ ... }}` expressions out of `run:` blocks into `env:` blocks for all 6 steps. Shell scripts now reference plain environment variables (e.g. `$INPUT_TAG`, `$RESOLVE_FILE`, `$ACTION_REF`) instead of inline expressions.

3. **github-env-injection**: All values derived from `inputs.*` or `github.*` that are written to `$GITHUB_OUTPUT` are now sanitized with `printf '%s' "$VAR" | tr -d '\n\r'` before writing — covering `tag=` in 'Resolve vizb version', and `file`, `cmd`, `json_file` outputs in 'Resolve input'.

4. **Merge step**: The `inputs.merge-files` space-separated list is now safely tokenized using the xargs+NUL-delimited read loop pattern to preserve argument boundaries without injection risk.

### Iteration 2

**Fixes applied:** script-injection, unpinned-uses

**Notes:**

1. Fixed script-injection in action.yml line ~290: replaced `eval "$RESOLVE_CMD"` with `sh -c "$RESOLVE_CMD"` to run the user-controlled command in a subprocess rather than the current shell context, preventing shell state modification. 2. Pinned pnpm/action-setup@v6 to @0977fd99725f1db4007ccb2928dbb4e90d06cc86 # v6 in .github/actions/setup-js/action.yml. 3. Pinned actions/setup-node@v6 to @249970729cb0ef3589644e2896645e5dc5ba9c38 # v6 in .github/actions/setup-js/action.yml.

