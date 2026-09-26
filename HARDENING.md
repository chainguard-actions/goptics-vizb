<!-- markdownlint-disable -->

# Hardening Report: goptics--vizb/v0.16.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **goptics--vizb/v0.16.0** was hardened automatically. 60 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### unpinned-uses (severity: high)

Multiple `uses:` references in action files use mutable tags instead of pinned 40-character SHA digests, making them vulnerable to supply-chain attacks if the tag is moved.

In `action.yml`:
- `uses: actions/cache@v6` (line ~97)

In `.github/actions/setup-embed-ui/action.yml`:
- `uses: pnpm/action-setup@v6` (line 6)
- `uses: actions/setup-node@v6` (line 9)

Locations:

- `action.yml:97`
- `.github/actions/setup-embed-ui/action.yml:6`
- `.github/actions/setup-embed-ui/action.yml:9`

### script-injection (severity: high)

Multiple `run:` blocks in `action.yml` directly interpolate `${{ ... }}` expressions (inputs, github context, steps outputs, runner context) inside shell commands — rule (a) violation. This allows an attacker who controls input values to inject arbitrary shell commands.

Key violations:

**"Resolve vizb version" step (~line 108):**
- `if [ -n "${{ inputs.vizb-binary }}" ]` — inputs.vizb-binary interpolated directly
- `REF="${{ github.action_ref }}"` — github context interpolated directly

**"Install vizb" step (~line 119):**
- `VIZB_BINARY="${{ inputs.vizb-binary }}"` — inputs.vizb-binary interpolated directly
- `OS=$(echo "${{ runner.os }}" | ...)` — runner.os interpolated directly
- `ARCH=$(echo "${{ runner.arch }}" | ...)` — runner.arch interpolated directly
- `TAG="${{ steps.version.outputs.tag }}"` — steps output interpolated directly

**"Resolve input" step (~line 152):**
- `FILE="${{ inputs.file }}"`, `FILE="${{ inputs.bench-file }}"` — inputs interpolated directly
- `CMD="${{ inputs.cmd }}"`, `CMD="${{ inputs.bench-cmd }}"` — inputs interpolated directly
- `[ -n "${{ inputs.merge-files }}" ]`, `[ -n "${{ inputs.merge-dir }}" ]`, `[ -n "${{ inputs.data-url }}" ]` — inputs interpolated directly
- `OUT_JSON="${{ inputs.output-json }}"` — input interpolated directly

**"Convert to JSON" step (~line 185):**
- `${{ steps.resolve.outputs.cmd }} > "$INPUT"` — step output executed directly as a shell command (critical: arbitrary command execution)
- Numerous `${{ inputs.* }}` interpolated as CLI arguments: tag, id, name, description, group, group-pattern, group-regex, sort, filter, mem-unit, time-unit, number-unit, col-axis, json-path, show-labels, parser, charts, chart, stat
- `INPUT="${{ steps.resolve.outputs.file }}"` and `vizb "$INPUT" -o "${{ steps.resolve.outputs.json_file }}"` — step outputs interpolated directly

**"Merge" step (~line 230):**
- `FILES+=(${{ inputs.merge-files }})` — unquoted expansion of inputs.merge-files (also rule b)
- `FILES+=("${{ inputs.merge-dir }}")` — inputs.merge-dir interpolated directly
- `--tag-axis "${{ inputs.tag-axis }}"` — input interpolated directly

**"Generate HTML" step (~line 244):**
- `${{ inputs.enable-3d }}`, `${{ inputs.data-url }}`, `${{ inputs.output-html }}`, `${{ inputs.charts }}`, `${{ inputs.chart }}`, `${{ inputs.stat }}` — all interpolated directly

Locations:

- `action.yml:108`
- `action.yml:119`
- `action.yml:152`
- `action.yml:185`
- `action.yml:230`
- `action.yml:244`

### github-env-injection (severity: high)

Multiple `run:` blocks write values derived from untrusted inputs to `$GITHUB_OUTPUT` and `$GITHUB_PATH` without the required sanitization step (`printf '%s' ... | tr -d '\n\r'`).

**"Resolve vizb version" step (~line 108):**
- `echo "tag=local" >> "$GITHUB_OUTPUT"` — written after checking `${{ inputs.vizb-binary }}` (the branch is controlled by the input)
- `echo "tag=$REF" >> "$GITHUB_OUTPUT"` where `REF="${{ github.action_ref }}"`  — github.action_ref written to GITHUB_OUTPUT without sanitization
- `echo "is-major=true/false" >> "$GITHUB_OUTPUT"` — branch controlled by unsanitized REF

**"Resolve input" step (~line 152):**
- `echo "has_input=true" >> "$GITHUB_OUTPUT"` — branch controlled by unsanitized inputs.file/cmd
- `echo "file<<__VIZB_EOF__" / echo "$FILE" / echo "__VIZB_EOF__"` written to `$GITHUB_OUTPUT` where FILE comes from `${{ inputs.file }}` / `${{ inputs.bench-file }}` — unsanitized multiline input written to GITHUB_OUTPUT
- `echo "cmd<<__VIZB_EOF__" / echo "$CMD" / echo "__VIZB_EOF__"` written to `$GITHUB_OUTPUT` where CMD comes from `${{ inputs.cmd }}` / `${{ inputs.bench-cmd }}` — unsanitized input written to GITHUB_OUTPUT
- `echo "json_file=$OUT_JSON" >> "$GITHUB_OUTPUT"` where `OUT_JSON="${{ inputs.output-json }}"` — unsanitized input written to GITHUB_OUTPUT

**"Install vizb" step (~line 119):**
- `echo "$HOME/.local/bin" >> "$GITHUB_PATH"` — while the value itself is a literal, the step also writes `$GITHUB_PATH` after processing `${{ inputs.vizb-binary }}` which could influence the path via cp.

Locations:

- `action.yml:108`
- `action.yml:152`

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

**Fixes applied:** unpinned-uses, script-injection, github-env-injection, static-inline-injection

**Notes:**

Fixed all findings in action.yml and .github/actions/setup-embed-ui/action.yml:

1. **unpinned-uses**: Pinned actions/cache@v6 → SHA 55cc8345..., pnpm/action-setup@v6 → SHA 0977fd99..., actions/setup-node@v6 → SHA 24997072...

2. **script-injection / static-inline-injection**: Moved all ${{ inputs.* }}, ${{ github.* }}, ${{ runner.* }}, and ${{ steps.*.outputs.* }} expressions out of run: blocks into env: blocks for all 6 affected steps (Resolve vizb version, Install vizb, Resolve input, Convert to JSON, Merge, Generate HTML). Shell scripts now reference only environment variables.

3. **github-env-injection**: All GITHUB_OUTPUT writes now sanitize values with `printf '%s' "$VAR" | tr -d '\n\r'` before writing. The file/cmd multiline outputs strip newlines from user-controlled values. The merge-files input is tokenized with xargs into an array to prevent word-splitting injection.

