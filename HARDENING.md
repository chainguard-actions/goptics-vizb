<!-- markdownlint-disable -->

# Hardening Report: goptics--vizb/v0.10.1

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **goptics--vizb/v0.10.1** was hardened automatically. 44 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Multiple `${{ }}` expressions are directly interpolated inside `run:` shell command strings throughout action.yml, violating rule (a). This allows injection of arbitrary shell commands via attacker-controlled inputs.

**Step: 'Resolve vizb version' (line ~80):** `REF="${{ github.action_ref }}"` and `PATH_REF=$(basename "${{ github.action_path }}")` — github context values interpolated directly into shell.

**Step: 'Download vizb' (line ~110):** `OS=$(echo "${{ runner.os }}" | ...)`, `ARCH=$(echo "${{ runner.arch }}" | ...)`, `TAG="${{ steps.version.outputs.tag }}"` — runner/steps context values interpolated directly.

**Step: 'Resolve input' (line ~138):** `BENCH_FILE="${{ inputs.bench-file }}"`, `BENCH_CMD="${{ inputs.bench-cmd }}"`, `[ -n "${{ inputs.merge-files }}" ]`, `[ -n "${{ inputs.merge-dir }}" ]` — user inputs interpolated directly.

**Step: 'Convert to JSON' (line ~158):** Thirteen separate `${{ inputs.* }}` expressions interpolated directly, including the critically dangerous `${{ inputs.bench-cmd }} > bench-input.txt` which executes user-controlled input as a raw shell command with no quoting or validation.

**Step: 'Merge' (line ~183):** `FILES+=(${{ inputs.merge-files }})` — unquoted expansion of user input (rule b violation too), plus `${{ inputs.merge-dir }}` and `${{ inputs.tag-axis }}` interpolated directly.

**Step: 'Generate HTML' (line ~192):** `vizb html bench.json -o "${{ inputs.output-html }}"` and `echo "html=${{ inputs.output-html }}" >> "$GITHUB_OUTPUT"`.

**Step: 'Generate JSON' (line ~199):** `mkdir -p "$(dirname "${{ inputs.output-json }}")"`, `cp bench.json "${{ inputs.output-json }}"`, `echo "json=${{ inputs.output-json }}" >> "$GITHUB_OUTPUT"`.

All these must be moved to `env:` variables and then referenced as double-quoted `"$VAR"` shell variables.

Locations:

- `action.yml:80`
- `action.yml:82`
- `action.yml:110`
- `action.yml:112`
- `action.yml:114`
- `action.yml:138`
- `action.yml:139`
- `action.yml:140`
- `action.yml:141`
- `action.yml:158`
- `action.yml:175`
- `action.yml:183`
- `action.yml:192`
- `action.yml:193`
- `action.yml:199`
- `action.yml:200`

### github-env-injection (severity: high)

Several `run:` steps write values derived from untrusted inputs or github context directly to `$GITHUB_OUTPUT` and `$GITHUB_PATH` without the required sanitization step (`printf '%s' ... | tr -d '\n\r'`).

**Step: 'Resolve vizb version' (~line 100):** `echo "tag=$REF" >> "$GITHUB_OUTPUT"` and `echo "is-latest=false" >> "$GITHUB_OUTPUT"` — `$REF` is derived from `${{ github.action_ref }}` (github context), which is written to GITHUB_OUTPUT without sanitization.

**Step: 'Generate HTML' (~line 193):** `echo "html=${{ inputs.output-html }}" >> "$GITHUB_OUTPUT"` — user-controlled `inputs.output-html` written directly to GITHUB_OUTPUT without sanitization.

**Step: 'Generate JSON' (~line 200):** `echo "json=${{ inputs.output-json }}" >> "$GITHUB_OUTPUT"` — user-controlled `inputs.output-json` written directly to GITHUB_OUTPUT without sanitization.

An attacker can inject newlines into these values to poison the GITHUB_OUTPUT file and set arbitrary output variables.

Locations:

- `action.yml:100`
- `action.yml:193`
- `action.yml:200`

### unpinned-uses (severity: high)

The `uses:` reference `actions/cache@v5` in the 'Cache vizb binary' step uses a mutable version tag (`@v5`) instead of a full 40-character commit SHA. This means the action could be silently updated to a malicious version without any change to the workflow file, enabling a supply-chain attack.

Failing reference:
```
uses: actions/cache@v5
```

Fix: pin to a specific commit SHA, e.g.:
```
uses: actions/cache@5a3ec84eff668545956fd18022155c47e93e2684 # v4.2.3
```

Locations:

- `action.yml:103`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.bench-file }}" appears directly in run: block of step "Resolve input"; move to env: map

Locations:

- `action.yml:159`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.bench-cmd }}" appears directly in run: block of step "Resolve input"; move to env: map

Locations:

- `action.yml:160`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.merge-files }}" appears directly in run: block of step "Resolve input"; move to env: map

Locations:

- `action.yml:162`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.merge-dir }}" appears directly in run: block of step "Resolve input"; move to env: map

Locations:

- `action.yml:163`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.tag }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:188`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.tag }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:188`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.name }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:189`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.name }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:189`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.description }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:190`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.description }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:190`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.group-pattern }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:191`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.group-pattern }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:191`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.group-regex }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:192`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.group-regex }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:192`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.scale }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:193`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.scale }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:193`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.sort }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:194`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.sort }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:194`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.filter }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:195`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.filter }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:195`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mem-unit }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:196`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mem-unit }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:196`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.time-unit }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:197`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.time-unit }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:197`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.number-unit }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:198`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.number-unit }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:198`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.charts }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:199`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.charts }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:199`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.show-labels }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:200`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.bench-file }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:203`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.bench-cmd }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:205`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.merge-files }}" appears directly in run: block of step "Merge"; move to env: map

Locations:

- `action.yml:219`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.merge-files }}" appears directly in run: block of step "Merge"; move to env: map

Locations:

- `action.yml:219`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.merge-dir }}" appears directly in run: block of step "Merge"; move to env: map

Locations:

- `action.yml:220`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.merge-dir }}" appears directly in run: block of step "Merge"; move to env: map

Locations:

- `action.yml:220`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.tag-axis }}" appears directly in run: block of step "Merge"; move to env: map

Locations:

- `action.yml:221`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.output-html }}" appears directly in run: block of step "Generate HTML"; move to env: map

Locations:

- `action.yml:230`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.output-html }}" appears directly in run: block of step "Generate HTML"; move to env: map

Locations:

- `action.yml:231`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.output-json }}" appears directly in run: block of step "Generate JSON"; move to env: map

Locations:

- `action.yml:238`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.output-json }}" appears directly in run: block of step "Generate JSON"; move to env: map

Locations:

- `action.yml:239`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.output-json }}" appears directly in run: block of step "Generate JSON"; move to env: map

Locations:

- `action.yml:240`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, static-inline-injection, github-env-injection, unpinned-uses

**Notes:**

Fixed all findings in hardened/action/action.yml:

1. **unpinned-uses**: Pinned `actions/cache@v5` to full SHA `actions/cache@caa296126883cff596d87d8935842f9db880ef25 # v5`.

2. **script-injection / static-inline-injection**: Moved all `${{ }}` expressions from `run:` blocks into `env:` blocks for every affected step:
   - 'Resolve vizb version': `github.action_ref` → `ACTION_REF`, `github.action_path` → `ACTION_PATH`
   - 'Download vizb': `runner.os` → `RUNNER_OS`, `runner.arch` → `RUNNER_ARCH`, `steps.version.outputs.tag` → `VERSION_TAG`
   - 'Resolve input': all four inputs → `INPUT_BENCH_FILE`, `INPUT_BENCH_CMD`, `INPUT_MERGE_FILES`, `INPUT_MERGE_DIR`
   - 'Convert to JSON': all 15 inputs + resolve source → env vars; `bench-cmd` (a command+args list) tokenized safely with xargs+NUL-delimited read loop
   - 'Merge': `merge-files`, `merge-dir`, `tag-axis` → env vars; `merge-files` (space-separated list) tokenized with xargs+NUL-delimited read loop
   - 'Generate HTML': `output-html` → `INPUT_OUTPUT_HTML`
   - 'Generate JSON': `output-json` → `INPUT_OUTPUT_JSON`

3. **github-env-injection**: All values written to `$GITHUB_OUTPUT` are now sanitized with `printf '%s' "$VAR" | tr -d '\n\r'` before writing:
   - 'Resolve vizb version': `$TAG` and `$REF` sanitized → `safe_tag`/`safe_ref`
   - 'Generate HTML': `$INPUT_OUTPUT_HTML` sanitized → `safe_html`
   - 'Generate JSON': `$INPUT_OUTPUT_JSON` sanitized → `safe_json`

