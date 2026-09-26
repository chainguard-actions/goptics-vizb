<!-- markdownlint-disable -->

# Hardening Report: goptics--vizb/v0.13.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **goptics--vizb/v0.13.0** was hardened automatically. 57 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Multiple `run:` blocks in action.yml directly interpolate `${{ }}` expressions inside shell commands, violating rule (a). This allows an attacker who controls inputs to inject arbitrary shell commands.

1. **'Resolve vizb version' step**: `REF="${{ github.action_ref }}"` — github context interpolated directly in shell.

2. **'Install vizb' step**: `VIZB_BINARY="${{ inputs.vizb-binary }}"`, `OS=$(echo "${{ runner.os }}" | ...)`, `ARCH=$(echo "${{ runner.arch }}" | ...)`, `TAG="${{ steps.version.outputs.tag }}"` — all interpolated directly in shell.

3. **'Resolve input' step**: `FILE="${{ inputs.file }}"`, `FILE="${{ inputs.bench-file }}"`, `CMD="${{ inputs.cmd }}"`, `CMD="${{ inputs.bench-cmd }}"`, `${{ inputs.merge-files }}`, `${{ inputs.merge-dir }}`, `${{ inputs.data-url }}`, `${{ inputs.output-json }}` — all interpolated directly in shell.

4. **'Convert to JSON' step**: `${{ inputs.tag }}`, `${{ inputs.name }}`, `${{ inputs.description }}`, `${{ inputs.group }}`, `${{ inputs.group-pattern }}`, `${{ inputs.group-regex }}`, `${{ inputs.sort }}`, `${{ inputs.filter }}`, `${{ inputs.mem-unit }}`, `${{ inputs.time-unit }}`, `${{ inputs.number-unit }}`, `${{ inputs.select }}`, `${{ inputs.json-path }}`, `${{ inputs.show-labels }}`, `${{ inputs.parser }}`, `${{ inputs.charts }}`, `${{ inputs.chart }}`, `${{ inputs.stat }}` — all interpolated directly. Critically, `${{ steps.resolve.outputs.cmd }} > data-input.txt` executes the resolved cmd output as a shell command directly.

5. **'Merge' step**: `${{ steps.resolve.outputs.json_file }}`, `${{ inputs.merge-files }}` (unquoted — rule b violation, allows word splitting/glob), `${{ inputs.merge-dir }}`, `${{ inputs.tag-axis }}` — all interpolated directly.

6. **'Generate HTML' step**: `${{ inputs.charts }}`, `${{ inputs.chart }}`, `${{ inputs.stat }}`, `${{ inputs.enable-3d }}`, `${{ inputs.data-url }}`, `${{ inputs.output-html }}`, `${{ steps.resolve.outputs.json_file }}` — all interpolated directly.

Locations:

- `action.yml:100`
- `action.yml:113`
- `action.yml:118`
- `action.yml:120`
- `action.yml:125`
- `action.yml:148`
- `action.yml:149`
- `action.yml:151`
- `action.yml:152`
- `action.yml:157`
- `action.yml:158`
- `action.yml:159`
- `action.yml:168`
- `action.yml:175`
- `action.yml:185`
- `action.yml:186`
- `action.yml:187`
- `action.yml:188`
- `action.yml:189`
- `action.yml:190`
- `action.yml:191`
- `action.yml:192`
- `action.yml:193`
- `action.yml:194`
- `action.yml:195`
- `action.yml:196`
- `action.yml:197`
- `action.yml:198`
- `action.yml:199`
- `action.yml:200`
- `action.yml:203`
- `action.yml:205`
- `action.yml:208`
- `action.yml:213`
- `action.yml:214`
- `action.yml:215`
- `action.yml:216`
- `action.yml:222`
- `action.yml:223`
- `action.yml:224`
- `action.yml:225`
- `action.yml:226`
- `action.yml:227`

### github-env-injection (severity: high)

Multiple `run:` blocks write values derived from untrusted inputs to `$GITHUB_OUTPUT` and `$GITHUB_PATH` without the required sanitization step (`printf '%s' ... | tr -d '\n\r'`).

1. **'Resolve vizb version' step**: `echo "tag=$TAG" >> "$GITHUB_OUTPUT"` and `echo "tag=$REF" >> "$GITHUB_OUTPUT"` — `$TAG`/`$REF` are derived from `${{ github.action_ref }}` without sanitization. A newline in the ref could inject arbitrary key=value pairs into GITHUB_OUTPUT.

2. **'Resolve input' step**: `$FILE` (from `${{ inputs.file }}` / `${{ inputs.bench-file }}`) and `$CMD` (from `${{ inputs.cmd }}` / `${{ inputs.bench-cmd }}`) are written to `$GITHUB_OUTPUT` via `echo "$FILE"` and `echo "$CMD"` without sanitization. `$OUT_JSON` (from `${{ inputs.output-json }}`) is written as `echo "json_file=$OUT_JSON" >> "$GITHUB_OUTPUT"` without sanitization.

3. **'Install vizb' step**: `echo "$HOME/.local/bin" >> "$GITHUB_PATH"` — while `$HOME` is typically safe, the step context is set up using unsanitized `${{ inputs.vizb-binary }}` which could influence the execution path.

Locations:

- `action.yml:100`
- `action.yml:104`
- `action.yml:106`
- `action.yml:131`
- `action.yml:148`
- `action.yml:149`
- `action.yml:151`
- `action.yml:152`
- `action.yml:160`
- `action.yml:163`
- `action.yml:168`
- `action.yml:170`
- `action.yml:175`

### unpinned-uses (severity: high)

The composite action uses `actions/cache@v6` which is pinned to a mutable version tag rather than an immutable 40-character commit SHA. This means the action could be silently updated to a malicious version without any change to this repository.

Failing reference: `uses: actions/cache@v6`

Fix: pin to a full SHA, e.g. `uses: actions/cache@5a3ec84eff668545956fd18022155c47e93e2684 # v4.2.3`

Locations:

- `action.yml:109`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.vizb-binary }}" appears directly in run: block of step "Install vizb"; move to env: map

Locations:

- `action.yml:145`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.file }}" appears directly in run: block of step "Resolve input"; move to env: map

Locations:

- `action.yml:206`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.bench-file }}" appears directly in run: block of step "Resolve input"; move to env: map

Locations:

- `action.yml:207`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.cmd }}" appears directly in run: block of step "Resolve input"; move to env: map

Locations:

- `action.yml:208`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.bench-cmd }}" appears directly in run: block of step "Resolve input"; move to env: map

Locations:

- `action.yml:209`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.merge-files }}" appears directly in run: block of step "Resolve input"; move to env: map

Locations:

- `action.yml:213`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.merge-dir }}" appears directly in run: block of step "Resolve input"; move to env: map

Locations:

- `action.yml:213`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.data-url }}" appears directly in run: block of step "Resolve input"; move to env: map

Locations:

- `action.yml:213`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.output-json }}" appears directly in run: block of step "Resolve input"; move to env: map

Locations:

- `action.yml:229`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.tag }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:243`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.tag }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:243`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.name }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:244`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.name }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:244`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.description }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:245`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.description }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:245`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.group }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:246`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.group }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:246`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.group-pattern }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:247`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.group-pattern }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:247`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.group-regex }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:248`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.group-regex }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:248`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.sort }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:249`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.sort }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:249`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.filter }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:250`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.filter }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:250`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mem-unit }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:251`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mem-unit }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:251`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.time-unit }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:252`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.time-unit }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:252`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.number-unit }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:253`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.number-unit }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:253`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.select }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:254`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.select }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:254`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.json-path }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:255`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.json-path }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:255`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.show-labels }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:256`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.parser }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:257`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.parser }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:257`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.charts }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:258`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.chart }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:258`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.stat }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:258`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.merge-files }}" appears directly in run: block of step "Merge"; move to env: map

Locations:

- `action.yml:277`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.merge-files }}" appears directly in run: block of step "Merge"; move to env: map

Locations:

- `action.yml:277`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.merge-dir }}" appears directly in run: block of step "Merge"; move to env: map

Locations:

- `action.yml:278`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.merge-dir }}" appears directly in run: block of step "Merge"; move to env: map

Locations:

- `action.yml:278`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.tag-axis }}" appears directly in run: block of step "Merge"; move to env: map

Locations:

- `action.yml:279`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.charts }}" appears directly in run: block of step "Generate HTML"; move to env: map

Locations:

- `action.yml:287`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.chart }}" appears directly in run: block of step "Generate HTML"; move to env: map

Locations:

- `action.yml:287`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.stat }}" appears directly in run: block of step "Generate HTML"; move to env: map

Locations:

- `action.yml:287`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.enable-3d }}" appears directly in run: block of step "Generate HTML"; move to env: map

Locations:

- `action.yml:288`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.data-url }}" appears directly in run: block of step "Generate HTML"; move to env: map

Locations:

- `action.yml:290`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.data-url }}" appears directly in run: block of step "Generate HTML"; move to env: map

Locations:

- `action.yml:291`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.output-html }}" appears directly in run: block of step "Generate HTML"; move to env: map

Locations:

- `action.yml:291`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.output-html }}" appears directly in run: block of step "Generate HTML"; move to env: map

Locations:

- `action.yml:293`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, static-inline-injection, github-env-injection, unpinned-uses

**Notes:**

Rewrote action.yml to fix all findings:
1. unpinned-uses: Pinned actions/cache@v6 to full SHA 55cc8345863c7cc4c66a329aec7e433d2d1c52a9 with # v6 comment.
2. script-injection / static-inline-injection: Moved all ${{ }} expressions from run: blocks into env: blocks across all 6 steps (Resolve vizb version, Install vizb, Resolve input, Convert to JSON, Merge, Generate HTML). All inputs and context values are now referenced as plain shell variables.
3. github-env-injection: Added tr -d '\n\r' sanitization for all values written to $GITHUB_OUTPUT (action_ref→tag, file, cmd, output-json/json_file).
4. For merge-files (space-separated list input): used xargs-based tokenization loop to safely split into array elements without collapsing into a single argument.
5. The intentional user-command execution (cmd input) uses eval "$RESOLVE_CMD" after the value has been moved to an env var — this preserves the action's intended behavior while eliminating the direct ${{ }} interpolation in the shell string.

