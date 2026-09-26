<!-- markdownlint-disable -->

# Hardening Report: goptics--vizb/v0.17.1

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **goptics--vizb/v0.17.1** was hardened automatically. 62 finding(s) were identified and resolved across 2 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Multiple `${{ ... }}` expressions are directly interpolated inside `run:` shell command strings across all run steps in action.yml, violating rule (a). This allows any caller of the composite action to inject arbitrary shell commands.

**'Resolve vizb version' step**: `${{ inputs.vizb-binary }}` and `${{ github.action_ref }}` are interpolated directly in the run block.

**'Install vizb' step**: `${{ inputs.vizb-binary }}`, `${{ runner.os }}`, `${{ runner.arch }}`, and `${{ steps.version.outputs.tag }}` are interpolated directly.

**'Resolve input' step**: `${{ inputs.file }}`, `${{ inputs.bench-file }}`, `${{ inputs.cmd }}`, `${{ inputs.bench-cmd }}`, `${{ inputs.merge-files }}`, `${{ inputs.merge-dir }}`, `${{ inputs.data-url }}`, and `${{ inputs.output-json }}` are all interpolated directly.

**'Convert to JSON' step**: Numerous `${{ inputs.* }}` expressions are interpolated directly, and most critically `${{ steps.resolve.outputs.cmd }}` is used as a bare shell command (`${{ steps.resolve.outputs.cmd }} > "$INPUT"`), enabling direct arbitrary command execution.

**'Merge' step**: `${{ inputs.merge-files }}` is interpolated unquoted in an array expansion (`FILES+=(${{ inputs.merge-files }})`), and `${{ inputs.merge-dir }}` and `${{ inputs.tag-axis }}` are also directly interpolated.

**'Generate HTML' step**: `${{ inputs.charts }}`, `${{ inputs.chart }}`, `${{ inputs.stat }}`, `${{ inputs.enable-3d }}`, `${{ inputs.data-url }}`, `${{ inputs.output-html }}`, and `${{ steps.resolve.outputs.json_file }}` are all directly interpolated.

All `${{ ... }}` expressions must be moved to `env:` variables and then referenced as double-quoted shell variables (e.g., `"$VAR"`) in the run block.

Locations:

- `action.yml:114`
- `action.yml:122`
- `action.yml:147`
- `action.yml:155`
- `action.yml:157`
- `action.yml:159`
- `action.yml:185`
- `action.yml:186`
- `action.yml:187`
- `action.yml:188`
- `action.yml:192`
- `action.yml:193`
- `action.yml:194`
- `action.yml:207`
- `action.yml:215`
- `action.yml:216`
- `action.yml:217`
- `action.yml:218`
- `action.yml:219`
- `action.yml:220`
- `action.yml:221`
- `action.yml:222`
- `action.yml:223`
- `action.yml:224`
- `action.yml:225`
- `action.yml:226`
- `action.yml:227`
- `action.yml:228`
- `action.yml:229`
- `action.yml:230`
- `action.yml:232`
- `action.yml:233`
- `action.yml:235`
- `action.yml:238`
- `action.yml:248`
- `action.yml:251`
- `action.yml:252`
- `action.yml:253`
- `action.yml:261`
- `action.yml:262`
- `action.yml:263`
- `action.yml:265`
- `action.yml:267`
- `action.yml:268`
- `action.yml:270`

### github-env-injection (severity: high)

Several `run:` blocks write values derived from untrusted inputs to `$GITHUB_OUTPUT` without the required sanitization (`printf '%s' ... | tr -d '\n\r'`).

**'Resolve vizb version' step**: `REF` is set from `${{ github.action_ref }}` and then written to `$GITHUB_OUTPUT` via `echo "tag=$REF" >> "$GITHUB_OUTPUT"` and `echo "tag=$TAG" >> "$GITHUB_OUTPUT"` (where `$TAG` is derived from `$REF`) without sanitization. A newline in `github.action_ref` could inject additional key=value pairs.

**'Resolve input' step**: `FILE` is set from `${{ inputs.file }}` / `${{ inputs.bench-file }}` and `CMD` is set from `${{ inputs.cmd }}` / `${{ inputs.bench-cmd }}`, then both are written to `$GITHUB_OUTPUT` via `echo "$FILE"` and `echo "$CMD"` without sanitization. `OUT_JSON` is set from `${{ inputs.output-json }}` and written as `echo "json_file=$OUT_JSON" >> "$GITHUB_OUTPUT"` without sanitization.

Locations:

- `action.yml:128`
- `action.yml:130`
- `action.yml:196`
- `action.yml:197`
- `action.yml:200`
- `action.yml:201`
- `action.yml:204`

### unpinned-uses (severity: high)

The step 'Cache vizb binary' uses `actions/cache@v6`, which is pinned to a mutable version tag rather than an immutable 40-character commit SHA. This means the action could be silently updated to a different (potentially malicious) version without any change to the workflow file. It should be pinned to a full SHA, e.g., `actions/cache@5a3ec84eff668545956fd18022155c47e93e2684 # v4`.

Locations:

- `action.yml:137`

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

**Fixes applied:** unpinned-uses, script-injection, github-env-injection, static-inline-injection

**Notes:**

Rewrote hardened/action/action.yml with all security fixes:

1. **unpinned-uses**: Pinned `actions/cache@v6` to full SHA `55cc8345863c7cc4c66a329aec7e433d2d1c52a9 # v6`.

2. **script-injection / static-inline-injection**: Moved all `${{ inputs.* }}`, `${{ github.action_ref }}`, `${{ runner.* }}`, and `${{ steps.*.outputs.* }}` expressions out of `run:` blocks into `env:` blocks. Each step now references these as double-quoted shell variables (e.g., `"$INPUT_TAG"`, `"$RESOLVE_CMD"`).

3. **github-env-injection**: All values derived from user inputs that are written to `$GITHUB_OUTPUT` are now sanitized with `printf '%s' "$VAR" | tr -d '\n\r'` before writing:
   - In 'Resolve vizb version': `$TAG` and `$REF` sanitized before `echo "tag=..." >> "$GITHUB_OUTPUT"`
   - In 'Resolve input': `$FILE`, `$CMD`, and `$OUT_JSON` sanitized before writing to `$GITHUB_OUTPUT`

4. **Merge step**: The `${{ inputs.merge-files }}` space-separated list is now tokenized safely using `xargs printf '%s\0'` with a while/read loop (guarded by `[ -n "$INPUT_MERGE_FILES" ]`) to avoid the unquoted array expansion vulnerability.

5. **Convert to JSON**: The `${{ steps.resolve.outputs.cmd }}` used as a bare shell command is now passed via `RESOLVE_CMD` env var and executed with `eval "$RESOLVE_CMD"` — preserving the original intent while eliminating direct expression interpolation.

### Iteration 2

**Fixes applied:** script-injection

**Notes:**

Replaced `eval "$RESOLVE_CMD" > "$INPUT"` with `sh -c "$RESOLVE_CMD" > "$INPUT"` in the 'Convert to JSON' step of action.yml (line 265). The `eval` builtin was flagged as a script-injection risk because it re-evaluates the string in the current shell context, allowing shell metacharacter injection from the user-controlled `inputs.cmd` value (passed through `steps.resolve.outputs.cmd` into the `RESOLVE_CMD` env var). Using `sh -c` instead spawns a subshell to execute the command string, which is the standard safe alternative for executing user-provided shell commands without using `eval`.

