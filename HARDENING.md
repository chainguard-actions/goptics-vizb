<!-- markdownlint-disable -->

# Hardening Report: goptics--vizb/v0.12.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **goptics--vizb/v0.12.0** was hardened automatically. 48 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Multiple run: blocks in action.yml directly interpolate ${{ }} expressions inside shell scripts, violating rule (a). This allows an attacker who controls the calling workflow's inputs to inject arbitrary shell commands. The most critical instance is in the 'Convert to JSON' step where `${{ inputs.bench-cmd }} > bench-input.txt` directly executes user-supplied input as a shell command with no quoting or sanitization. Additional violations:
- 'Resolve vizb version' step: `REF="${{ github.action_ref }}"`
- 'Download vizb' step: `OS=$(echo "${{ runner.os }}")`, `ARCH=$(echo "${{ runner.arch }}")`, `TAG="${{ steps.version.outputs.tag }}"`
- 'Resolve input' step: `BENCH_FILE="${{ inputs.bench-file }}"`, `BENCH_CMD="${{ inputs.bench-cmd }}"`, `[ -n "${{ inputs.merge-files }}" ]`, `[ -n "${{ inputs.merge-dir }}" ]`, `[ -n "${{ inputs.data-url }}" ]`, `OUT_JSON="${{ inputs.output-json }}"`
- 'Convert to JSON' step: `${{ inputs.tag }}`, `${{ inputs.name }}`, `${{ inputs.description }}`, `${{ inputs.group-pattern }}`, `${{ inputs.group-regex }}`, `${{ inputs.scale }}`, `${{ inputs.sort }}`, `${{ inputs.filter }}`, `${{ inputs.mem-unit }}`, `${{ inputs.time-unit }}`, `${{ inputs.number-unit }}`, `${{ inputs.charts }}`, `${{ inputs.show-labels }}`, `${{ inputs.parser }}`, `${{ inputs.bench-file }}`, `${{ inputs.bench-cmd }}` (executed directly)
- 'Merge' step: `${{ inputs.merge-files }}` (unquoted array expansion), `${{ inputs.merge-dir }}`, `${{ inputs.tag-axis }}`
- 'Generate HTML' step: `${{ inputs.data-url }}`, `${{ inputs.output-html }}`
All these must be moved to env: variables and referenced as quoted shell variables.

Locations:

- `action.yml:80`
- `action.yml:108`
- `action.yml:110`
- `action.yml:113`
- `action.yml:141`
- `action.yml:142`
- `action.yml:144`
- `action.yml:145`
- `action.yml:153`
- `action.yml:158`
- `action.yml:170`
- `action.yml:188`
- `action.yml:196`
- `action.yml:199`
- `action.yml:200`
- `action.yml:207`
- `action.yml:209`
- `action.yml:211`

### github-env-injection (severity: high)

Multiple run: blocks write values derived from untrusted inputs to $GITHUB_OUTPUT without the required sanitization step (`printf '%s' ... | tr -d '\n\r'`). This allows newline injection that can poison subsequent steps' outputs or environment.

1. 'Resolve vizb version' step: `github.action_ref` is assigned to REF/TAG and then written unsanitized: `echo "tag=$TAG" >> "$GITHUB_OUTPUT"` and `echo "tag=$REF" >> "$GITHUB_OUTPUT"`.
2. 'Resolve input' step: `inputs.output-json` is assigned to OUT_JSON and written unsanitized: `echo "json_file=$OUT_JSON" >> "$GITHUB_OUTPUT"`.
3. 'Generate HTML' step: `inputs.output-html` is interpolated directly and written unsanitized: `echo "html=${{ inputs.output-html }}" >> "$GITHUB_OUTPUT"`.

Locations:

- `action.yml:91`
- `action.yml:93`
- `action.yml:160`
- `action.yml:211`

### unpinned-uses (severity: high)

The composite action step 'Cache vizb binary' uses `actions/cache@v5`, which is a mutable tag reference rather than a pinned 40-character commit SHA. A supply-chain attacker who compromises the actions/cache repository could push malicious code to the v5 tag and have it executed by all users of this action. It should be pinned to a full SHA, e.g. `actions/cache@5a3ec84eff668545956fd18022155c47e93e2684 # v5`.

Locations:

- `action.yml:103`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.bench-file }}" appears directly in run: block of step "Resolve input"; move to env: map

Locations:

- `action.yml:158`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.bench-cmd }}" appears directly in run: block of step "Resolve input"; move to env: map

Locations:

- `action.yml:159`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.merge-files }}" appears directly in run: block of step "Resolve input"; move to env: map

Locations:

- `action.yml:161`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.merge-dir }}" appears directly in run: block of step "Resolve input"; move to env: map

Locations:

- `action.yml:162`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.data-url }}" appears directly in run: block of step "Resolve input"; move to env: map

Locations:

- `action.yml:173`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.output-json }}" appears directly in run: block of step "Resolve input"; move to env: map

Locations:

- `action.yml:181`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.tag }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:197`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.tag }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:197`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.name }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:198`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.name }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:198`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.description }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:199`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.description }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:199`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.group-pattern }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:200`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.group-pattern }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:200`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.group-regex }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:201`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.group-regex }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:201`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.scale }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:202`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.scale }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:202`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.sort }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:203`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.sort }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:203`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.filter }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:204`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.filter }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:204`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mem-unit }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:205`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mem-unit }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:205`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.time-unit }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:206`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.time-unit }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:206`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.number-unit }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:207`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.number-unit }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:207`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.charts }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:208`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.charts }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:208`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.show-labels }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:209`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.parser }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:210`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.parser }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:210`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.bench-file }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:213`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.bench-cmd }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:215`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.merge-files }}" appears directly in run: block of step "Merge"; move to env: map

Locations:

- `action.yml:230`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.merge-files }}" appears directly in run: block of step "Merge"; move to env: map

Locations:

- `action.yml:230`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.merge-dir }}" appears directly in run: block of step "Merge"; move to env: map

Locations:

- `action.yml:231`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.merge-dir }}" appears directly in run: block of step "Merge"; move to env: map

Locations:

- `action.yml:231`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.tag-axis }}" appears directly in run: block of step "Merge"; move to env: map

Locations:

- `action.yml:232`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.data-url }}" appears directly in run: block of step "Generate HTML"; move to env: map

Locations:

- `action.yml:241`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.data-url }}" appears directly in run: block of step "Generate HTML"; move to env: map

Locations:

- `action.yml:242`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.output-html }}" appears directly in run: block of step "Generate HTML"; move to env: map

Locations:

- `action.yml:242`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.output-html }}" appears directly in run: block of step "Generate HTML"; move to env: map

Locations:

- `action.yml:244`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.output-html }}" appears directly in run: block of step "Generate HTML"; move to env: map

Locations:

- `action.yml:246`

## Iteration Notes

### Iteration 1

**Fixes applied:** unpinned-uses, script-injection, static-inline-injection, github-env-injection

**Notes:**

Rewrote hardened/action/action.yml with all security fixes:
1. Pinned actions/cache@v5 to full SHA caa296126883cff596d87d8935842f9db880ef25
2. Moved all ${{ }} expressions from run: blocks into env: maps for all 6 steps (Resolve vizb version, Download vizb, Resolve input, Convert to JSON, Merge, Generate HTML)
3. Sanitized all GITHUB_OUTPUT writes with printf '%s' | tr -d '\n\r' (Resolve vizb version TAG/REF, Resolve input OUT_JSON, Generate HTML output-html)
4. Tokenized merge-files (space-separated list) using xargs printf '%s\0' + while IFS= read -r -d '' loop to preserve argument boundaries
5. Tokenized bench-cmd using the same xargs pattern for quote-aware splitting before execution

