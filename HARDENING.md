<!-- markdownlint-disable -->

# Hardening Report: goptics--vizb/v0.17.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **goptics--vizb/v0.17.0** was hardened automatically. 62 finding(s) were identified and resolved across 3 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Multiple `run:` blocks in action.yml directly interpolate GitHub Actions expressions inside shell command strings (rule a). This allows an attacker who controls the calling workflow's inputs to inject arbitrary shell commands.

**Step: 'Resolve vizb version'** — `${{ inputs.vizb-binary }}` and `${{ github.action_ref }}` are interpolated directly into the shell script:
  `if [ -n "${{ inputs.vizb-binary }}" ]; then`
  `REF="${{ github.action_ref }}"`

**Step: 'Install vizb'** — `${{ inputs.vizb-binary }}`, `${{ runner.os }}`, `${{ runner.arch }}`, and `${{ steps.version.outputs.tag }}` are interpolated directly:
  `VIZB_BINARY="${{ inputs.vizb-binary }}"`
  `OS=$(echo "${{ runner.os }}" | tr '[:upper:]' '[:lower:]')`
  `ARCH=$(echo "${{ runner.arch }}" | tr '[:upper:]' '[:lower:]')`
  `TAG="${{ steps.version.outputs.tag }}"`

**Step: 'Resolve input'** — `${{ inputs.file }}`, `${{ inputs.bench-file }}`, `${{ inputs.cmd }}`, `${{ inputs.bench-cmd }}`, `${{ inputs.merge-files }}`, `${{ inputs.merge-dir }}`, `${{ inputs.data-url }}`, `${{ inputs.output-json }}` are all interpolated directly.

**Step: 'Convert to JSON'** — Dozens of `${{ inputs.* }}` and `${{ steps.resolve.outputs.* }}` expressions are interpolated directly. Most critically, `${{ steps.resolve.outputs.cmd }}` is used as a shell command: `${{ steps.resolve.outputs.cmd }} > "$INPUT"` — this executes arbitrary attacker-controlled commands.

**Step: 'Merge'** — `${{ steps.resolve.outputs.json_file }}`, `${{ inputs.merge-files }}`, `${{ inputs.merge-dir }}`, `${{ inputs.tag-axis }}` are interpolated directly. Note: `${{ inputs.merge-files }}` is also unquoted: `FILES+=(${{ inputs.merge-files }})` (rule b).

**Step: 'Generate HTML'** — `${{ inputs.charts }}`, `${{ inputs.chart }}`, `${{ inputs.stat }}`, `${{ inputs.enable-3d }}`, `${{ inputs.data-url }}`, `${{ inputs.output-html }}`, `${{ steps.resolve.outputs.json_file }}` are interpolated directly.

Locations:

- `action.yml:119`
- `action.yml:124`
- `action.yml:151`
- `action.yml:158`
- `action.yml:160`
- `action.yml:163`
- `action.yml:196`
- `action.yml:197`
- `action.yml:198`
- `action.yml:199`
- `action.yml:230`
- `action.yml:265`
- `action.yml:275`
- `action.yml:280`
- `action.yml:285`
- `action.yml:295`

### github-env-injection (severity: high)

Multiple `run:` blocks write values derived from untrusted inputs to `$GITHUB_OUTPUT` without the required sanitization step (`printf '%s' ... | tr -d '\n\r'`).

**Step: 'Resolve vizb version'** — `$REF` is set from `${{ github.action_ref }}` and then written to `$GITHUB_OUTPUT` without sanitization:
  `echo "tag=$REF" >> "$GITHUB_OUTPUT"`
  `echo "tag=$TAG" >> "$GITHUB_OUTPUT"` (TAG derived from REF via git ls-remote)

**Step: 'Resolve input'** — `$FILE` (from `${{ inputs.file }}`/`${{ inputs.bench-file }}`), `$CMD` (from `${{ inputs.cmd }}`/`${{ inputs.bench-cmd }}`), and `$OUT_JSON` (from `${{ inputs.output-json }}`) are all written to `$GITHUB_OUTPUT` without sanitization:
  `echo "$FILE"` and `echo "$CMD"` written via heredoc to `$GITHUB_OUTPUT`
  `echo "json_file=$OUT_JSON" >> "$GITHUB_OUTPUT"`

An attacker can inject newlines into these values to set arbitrary environment variables or outputs.

Locations:

- `action.yml:133`
- `action.yml:136`
- `action.yml:207`
- `action.yml:210`
- `action.yml:215`

### unpinned-uses (severity: high)

The `uses:` reference `actions/cache@v6` in the 'Cache vizb binary' step uses a mutable tag (`v6`) instead of a pinned 40-character commit SHA. This is vulnerable to supply-chain attacks if the tag is moved to point to a malicious commit.

Failing reference: `uses: actions/cache@v6`

Fix: pin to a full SHA, e.g. `uses: actions/cache@5a3ec84eff668545956fd18022155c47e93e2684 # v4`

Locations:

- `action.yml:143`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.vizb-binary }}" appears directly in run: block of step "Resolve vizb version"; move to env: map

Locations:

- `action.yml:123`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.vizb-binary }}" appears directly in run: block of step "Install vizb"; move to env: map

Locations:

- `action.yml:160`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.file }}" appears directly in run: block of step "Resolve input"; move to env: map

Locations:

- `action.yml:221`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.bench-file }}" appears directly in run: block of step "Resolve input"; move to env: map

Locations:

- `action.yml:222`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.cmd }}" appears directly in run: block of step "Resolve input"; move to env: map

Locations:

- `action.yml:223`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.bench-cmd }}" appears directly in run: block of step "Resolve input"; move to env: map

Locations:

- `action.yml:224`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.merge-files }}" appears directly in run: block of step "Resolve input"; move to env: map

Locations:

- `action.yml:228`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.merge-dir }}" appears directly in run: block of step "Resolve input"; move to env: map

Locations:

- `action.yml:228`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.data-url }}" appears directly in run: block of step "Resolve input"; move to env: map

Locations:

- `action.yml:228`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.output-json }}" appears directly in run: block of step "Resolve input"; move to env: map

Locations:

- `action.yml:244`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.tag }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:260`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.tag }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:260`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.id }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:261`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.id }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:261`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.name }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:262`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.name }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:262`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.title }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:263`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.title }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:263`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.description }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:264`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.description }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:264`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.group }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:265`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.group }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:265`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.group-pattern }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:266`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.group-pattern }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:266`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.group-regex }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:267`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.group-regex }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:267`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.sort }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:268`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.sort }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:268`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.filter }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:269`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.filter }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:269`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mem-unit }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:270`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mem-unit }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:270`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.time-unit }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:271`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.time-unit }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:271`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.number-unit }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:272`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.number-unit }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:272`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.col-axis }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:274`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.col-axis }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:274`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.json-path }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:275`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.json-path }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:275`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.show-labels }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:276`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.parser }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:277`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.parser }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:277`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.charts }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:278`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.chart }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:278`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.stat }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:278`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.merge-files }}" appears directly in run: block of step "Merge"; move to env: map

Locations:

- `action.yml:297`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.merge-files }}" appears directly in run: block of step "Merge"; move to env: map

Locations:

- `action.yml:297`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.merge-dir }}" appears directly in run: block of step "Merge"; move to env: map

Locations:

- `action.yml:298`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.merge-dir }}" appears directly in run: block of step "Merge"; move to env: map

Locations:

- `action.yml:298`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.tag-axis }}" appears directly in run: block of step "Merge"; move to env: map

Locations:

- `action.yml:299`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.charts }}" appears directly in run: block of step "Generate HTML"; move to env: map

Locations:

- `action.yml:307`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.chart }}" appears directly in run: block of step "Generate HTML"; move to env: map

Locations:

- `action.yml:307`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.stat }}" appears directly in run: block of step "Generate HTML"; move to env: map

Locations:

- `action.yml:307`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.enable-3d }}" appears directly in run: block of step "Generate HTML"; move to env: map

Locations:

- `action.yml:308`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.data-url }}" appears directly in run: block of step "Generate HTML"; move to env: map

Locations:

- `action.yml:310`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.data-url }}" appears directly in run: block of step "Generate HTML"; move to env: map

Locations:

- `action.yml:311`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.output-html }}" appears directly in run: block of step "Generate HTML"; move to env: map

Locations:

- `action.yml:311`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.output-html }}" appears directly in run: block of step "Generate HTML"; move to env: map

Locations:

- `action.yml:313`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, static-inline-injection, github-env-injection, unpinned-uses

**Notes:**

Fixed all findings in hardened/action/action.yml:

1. **unpinned-uses**: Pinned `actions/cache@v6` to full SHA `actions/cache@55cc8345863c7cc4c66a329aec7e433d2d1c52a9 # v6`.

2. **script-injection / static-inline-injection**: Moved all `${{ }}` expressions out of `run:` blocks into `env:` blocks for all 6 steps (Resolve vizb version, Install vizb, Resolve input, Convert to JSON, Merge, Generate HTML). This covers all 60+ injection findings across inputs.vizb-binary, github.action_ref, runner.os, runner.arch, steps.version.outputs.tag, inputs.file, inputs.bench-file, inputs.cmd, inputs.bench-cmd, inputs.merge-files, inputs.merge-dir, inputs.data-url, inputs.output-json, inputs.tag, inputs.id, inputs.name, inputs.title, inputs.description, inputs.group, inputs.group-pattern, inputs.group-regex, inputs.sort, inputs.filter, inputs.mem-unit, inputs.time-unit, inputs.number-unit, inputs.col-axis, inputs.json-path, inputs.show-labels, inputs.parser, inputs.charts, inputs.chart, inputs.stat, inputs.enable-3d, inputs.output-html, steps.resolve.outputs.file, steps.resolve.outputs.cmd, steps.resolve.outputs.json_file, inputs.tag-axis. The previously dangerous `${{ steps.resolve.outputs.cmd }}` used directly as a shell command is now `eval "$RESOLVE_CMD"` where RESOLVE_CMD is an env var. The unquoted `${{ inputs.merge-files }}` in Merge is now properly tokenized with xargs.

3. **github-env-injection**: All values written to $GITHUB_OUTPUT are now sanitized with `printf '%s' "$VAR" | tr -d '\n\r'` before writing: TAG and REF in 'Resolve vizb version', FILE and CMD in 'Resolve input' (via sanitized heredoc), and OUT_JSON in 'Resolve input'.

### Iteration 2

**Fixes applied:** unpinned-uses

**Notes:**

Pinned both unpinned action references in hardened/action/.github/actions/setup-embed-ui/action.yml:
- pnpm/action-setup@v6 → pnpm/action-setup@0977fd99725f1db4007ccb2928dbb4e90d06cc86 # v6
- actions/setup-node@v6 → actions/setup-node@249970729cb0ef3589644e2896645e5dc5ba9c38 # v6
Original version tags preserved as inline comments for readability.

### Iteration 3

**Fixes applied:** suspicious-run-content, script-injection

**Notes:**

Replaced `eval "$RESOLVE_CMD" > "$INPUT"` in the 'Convert to JSON' step with a safe xargs-based tokenization approach. The command string is now tokenized using `printf '%s' "$RESOLVE_CMD" | xargs printf '%s\0'` with a NUL-delimited read loop into a bash array, then executed directly as `"${cmd_tokens[@]}" > "$INPUT"`. This eliminates the eval-based command injection vulnerability: shell metacharacters (;, |, &, $(...), backticks) in the user-controlled `cmd` input are no longer interpreted as shell syntax. The xargs tokenizer handles quoted arguments properly (e.g., `sh -c "exit 0"` tokenizes correctly), and the `if [ -n "$RESOLVE_CMD" ]` guard prevents xargs from emitting an empty token when the value is empty.

