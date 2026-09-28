<!-- markdownlint-disable -->

# Hardening Report: goptics--vizb/v0.14.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **goptics--vizb/v0.14.0** was hardened automatically. 58 finding(s) were identified and resolved across 2 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Multiple run: blocks in action.yml directly interpolate ${{ ... }} expressions inside shell command strings, violating rule (a). This allows an attacker who controls action inputs to inject arbitrary shell commands.

Key violations:

1. 'Resolve vizb version' step: `if [ -n "${{ inputs.vizb-binary }}" ]` and `REF="${{ github.action_ref }}"` — inputs and github context interpolated directly into shell.

2. 'Install vizb' step: `VIZB_BINARY="${{ inputs.vizb-binary }}"`, `OS=$(echo "${{ runner.os }}" | ...)`, `ARCH=$(echo "${{ runner.arch }}" | ...)`, `TAG="${{ steps.version.outputs.tag }}"` — all interpolated directly into shell.

3. 'Resolve input' step: `FILE="${{ inputs.file }}"`, `FILE="${{ inputs.bench-file }}"`, `CMD="${{ inputs.cmd }}"`, `CMD="${{ inputs.bench-cmd }}"`, `${{ inputs.merge-files }}`, `${{ inputs.merge-dir }}`, `${{ inputs.data-url }}`, `${{ inputs.output-json }}` — all interpolated directly.

4. 'Convert to JSON' step: Massive direct interpolation of `${{ inputs.tag }}`, `${{ inputs.id }}`, `${{ inputs.name }}`, `${{ inputs.description }}`, `${{ inputs.group }}`, `${{ inputs.group-pattern }}`, `${{ inputs.group-regex }}`, `${{ inputs.sort }}`, `${{ inputs.filter }}`, `${{ inputs.mem-unit }}`, `${{ inputs.time-unit }}`, `${{ inputs.number-unit }}`, `${{ inputs.json-path }}`, `${{ inputs.show-labels }}`, `${{ inputs.parser }}`, `${{ inputs.charts }}`, `${{ inputs.chart }}`, `${{ inputs.stat }}`. Most critically: `${{ steps.resolve.outputs.cmd }} > "$INPUT"` — a step output derived from user-controlled inputs.cmd is executed directly as a shell command, enabling arbitrary command execution.

5. 'Merge' step: `${{ inputs.merge-files }}` is unquoted in array expansion `FILES+=(${{ inputs.merge-files }})`, `${{ inputs.merge-dir }}`, `${{ inputs.tag-axis }}` interpolated directly.

6. 'Generate HTML' step: `${{ inputs.charts }}`, `${{ inputs.chart }}`, `${{ inputs.stat }}`, `${{ inputs.enable-3d }}`, `${{ inputs.data-url }}`, `${{ inputs.output-html }}` interpolated directly.

Locations:

- `action.yml:118`
- `action.yml:124`
- `action.yml:152`
- `action.yml:160`
- `action.yml:162`
- `action.yml:164`
- `action.yml:183`
- `action.yml:184`
- `action.yml:185`
- `action.yml:186`
- `action.yml:207`
- `action.yml:230`
- `action.yml:244`
- `action.yml:258`

### github-env-injection (severity: high)

The 'Resolve input' step writes values derived from untrusted inputs directly to $GITHUB_OUTPUT without sanitization (no `printf '%s' ... | tr -d '\n\r'` step).

(c/d) `$FILE` (derived from `${{ inputs.file }}` / `${{ inputs.bench-file }}`) and `$CMD` (derived from `${{ inputs.cmd }}` / `${{ inputs.bench-cmd }}`) are written to $GITHUB_OUTPUT via a heredoc block:
```
echo "file<<__VIZB_EOF__" >> "$GITHUB_OUTPUT"
echo "$FILE"
echo "__VIZB_EOF__"
echo "cmd<<__VIZB_EOF__" >> "$GITHUB_OUTPUT"
echo "$CMD"
echo "__VIZB_EOF__"
```
An attacker can inject newlines into these inputs to write arbitrary key=value pairs into $GITHUB_OUTPUT, poisoning subsequent step outputs.

Additionally, `$OUT_JSON` (derived from `${{ inputs.output-json }}`) is written as `echo "json_file=$OUT_JSON" >> "$GITHUB_OUTPUT"` without sanitization.

Locations:

- `action.yml:196`
- `action.yml:197`
- `action.yml:198`
- `action.yml:199`
- `action.yml:200`
- `action.yml:201`
- `action.yml:203`
- `action.yml:204`

### unpinned-uses (severity: high)

The 'Cache vizb binary' step uses `actions/cache@v6`, which is a mutable tag reference rather than a pinned full-length SHA commit hash. This means the action could be silently updated to a malicious version without any change to the workflow file. It should be pinned to a specific commit SHA, e.g. `actions/cache@5a3ec84eff668545956fd18022155c47e93e2684 # v4`.

Locations:

- `action.yml:141`

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

**Fixes applied:** unpinned-uses, script-injection, static-inline-injection, github-env-injection

**Notes:**

Fixed all security findings in hardened/action/action.yml:

1. Pinned actions/cache@v6 to actions/cache@55cc8345863c7cc4c66a329aec7e433d2d1c52a9 # v6

2. Moved all ${{ inputs.* }}, ${{ github.* }}, ${{ runner.* }}, and ${{ steps.*.outputs.* }} expressions from run: blocks into env: maps for all 5 affected steps (Resolve vizb version, Install vizb, Resolve input, Convert to JSON, Merge, Generate HTML).

3. Sanitized GITHUB_OUTPUT writes: $FILE and $CMD are now written via 'printf "%s" "$VAR" | tr -d "\n\r"' to strip newlines before the heredoc delimiter; $OUT_JSON is similarly sanitized before writing json_file= to GITHUB_OUTPUT.

4. Fixed the merge-files list expansion: replaced the unsafe unquoted ${{ inputs.merge-files }} glob expansion with a proper xargs-based tokenization loop (with guard) that handles quoted arguments correctly and prevents word-splitting injection.

### Iteration 2

**Fixes applied:** github-env-injection, script-injection

**Notes:**

Fixed two high-severity findings in hardened/action/action.yml:

1. github-env-injection (lines 130, 133): In the 'Resolve vizb version' step, sanitized both $TAG (from git ls-remote) and $REF (from $GITHUB_ACTION_REF) before writing to $GITHUB_OUTPUT. Used `safe_tag=$(printf '%s' "$TAG" | tr -d '\n\r')` and `safe_ref=$(printf '%s' "$REF" | tr -d '\n\r')` to strip newlines/carriage returns, preventing GITHUB_OUTPUT poisoning via newline injection.

2. script-injection (line 310): In the 'Convert to JSON' step, replaced `eval "$RESOLVE_CMD" > "$INPUT"` with `bash -c "$RESOLVE_CMD" > "$INPUT"`. This runs the user-provided command in a subshell rather than in the current shell context, preventing the command from modifying the parent shell's state (variables, functions, etc.). The `cmd` input is explicitly documented as a shell command to run, so running it in a subshell is the appropriate secure approach.

