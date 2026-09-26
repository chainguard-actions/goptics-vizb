<!-- markdownlint-disable -->

# Hardening Report: goptics--vizb/v0.14.1

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **goptics--vizb/v0.14.1** was hardened automatically. 64 finding(s) were identified and resolved across 3 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Step 'Resolve vizb version' (run: block) directly interpolates ${{ inputs.vizb-binary }} and ${{ github.action_ref }} inside shell commands. Any expression interpolated via ${{ }} in a run: block is a script-injection risk (rule a), as the value is substituted into the shell script before the shell parses it, allowing an attacker to inject arbitrary shell commands.

Locations:

- `action.yml:117`
- `action.yml:123`

### script-injection (severity: high)

Step 'Install vizb' (run: block) directly interpolates ${{ inputs.vizb-binary }}, ${{ runner.os }}, ${{ runner.arch }}, and ${{ steps.version.outputs.tag }} inside shell commands (rule a). For example: `VIZB_BINARY="${{ inputs.vizb-binary }}"`, `OS=$(echo "${{ runner.os }}" | tr ...)`, `ARCH=$(echo "${{ runner.arch }}" | tr ...)`, `TAG="${{ steps.version.outputs.tag }}"`. These are substituted into the shell script before execution, enabling injection.

Locations:

- `action.yml:154`
- `action.yml:163`
- `action.yml:165`
- `action.yml:168`

### script-injection (severity: high)

Step 'Resolve input' (run: block) directly interpolates multiple ${{ inputs.* }} expressions inside shell commands (rule a): ${{ inputs.file }}, ${{ inputs.bench-file }}, ${{ inputs.cmd }}, ${{ inputs.bench-cmd }}, ${{ inputs.merge-files }}, ${{ inputs.merge-dir }}, ${{ inputs.data-url }}, ${{ inputs.output-json }}. These are substituted into the shell script before execution, enabling injection.

Locations:

- `action.yml:199`
- `action.yml:200`
- `action.yml:201`
- `action.yml:202`

### script-injection (severity: high)

Step 'Convert to JSON' (run: block) directly interpolates dozens of ${{ inputs.* }} and ${{ steps.resolve.outputs.* }} expressions inside shell commands (rule a). Most critically, `${{ steps.resolve.outputs.cmd }} > "$INPUT"` executes the step output directly as a shell command with no quoting or sanitization, enabling arbitrary command execution. Other instances include ${{ inputs.tag }}, ${{ inputs.id }}, ${{ inputs.name }}, ${{ inputs.description }}, ${{ inputs.group }}, ${{ inputs.group-pattern }}, ${{ inputs.group-regex }}, ${{ inputs.sort }}, ${{ inputs.filter }}, ${{ inputs.mem-unit }}, ${{ inputs.time-unit }}, ${{ inputs.number-unit }}, ${{ inputs.json-path }}, ${{ inputs.show-labels }}, ${{ inputs.parser }}, ${{ inputs.charts }}, ${{ inputs.chart }}, ${{ inputs.stat }}, ${{ steps.resolve.outputs.file }}, ${{ steps.resolve.outputs.json_file }}.

Locations:

- `action.yml:232`
- `action.yml:247`

### script-injection (severity: high)

Step 'Merge' (run: block) directly interpolates ${{ steps.resolve.outputs.json_file }}, ${{ inputs.merge-files }} (unquoted in array expansion — rule b), ${{ inputs.merge-dir }}, and ${{ inputs.tag-axis }} inside shell commands (rule a/b). The unquoted `FILES+=(${{ inputs.merge-files }})` is particularly dangerous as it allows word-splitting and glob expansion of attacker-controlled input.

Locations:

- `action.yml:256`
- `action.yml:259`
- `action.yml:260`
- `action.yml:261`

### script-injection (severity: high)

Step 'Generate HTML' (run: block) directly interpolates ${{ inputs.charts }}, ${{ inputs.chart }}, ${{ inputs.stat }}, ${{ inputs.enable-3d }}, ${{ inputs.data-url }}, ${{ inputs.output-html }}, and ${{ steps.resolve.outputs.json_file }} inside shell commands (rule a). These are substituted into the shell script before execution, enabling injection.

Locations:

- `action.yml:267`
- `action.yml:268`
- `action.yml:271`
- `action.yml:273`

### github-env-injection (severity: high)

Step 'Resolve vizb version': The variable $REF is set from ${{ github.action_ref }} (an untrusted expression) and then written to $GITHUB_OUTPUT without sanitization: `echo "tag=$REF" >> "$GITHUB_OUTPUT"`. The required sanitization step (`printf '%s' "$REF" | tr -d '\n\r'`) is absent, allowing newline injection into the output file which can poison subsequent steps' environment.

Locations:

- `action.yml:123`
- `action.yml:136`

### github-env-injection (severity: high)

Step 'Resolve input': Multiple user-controlled inputs are written to $GITHUB_OUTPUT without sanitization. (1) $FILE (from ${{ inputs.file }} / ${{ inputs.bench-file }}) is written via `echo "$FILE"` inside a heredoc block to $GITHUB_OUTPUT. (2) $CMD (from ${{ inputs.cmd }} / ${{ inputs.bench-cmd }}) is similarly written. (3) $OUT_JSON (from ${{ inputs.output-json }}) is written via `echo "json_file=$OUT_JSON" >> "$GITHUB_OUTPUT"`. None of these writes are preceded by the required `printf '%s' ... | tr -d '\n\r'` sanitization.

Locations:

- `action.yml:199`
- `action.yml:201`
- `action.yml:218`

### unpinned-uses (severity: high)

The step 'Cache vizb binary' uses `actions/cache@v6`, which is pinned to a mutable version tag rather than an immutable 40-character SHA commit hash. A tag can be moved to point to a different (potentially malicious) commit, enabling supply-chain attacks. It should be pinned to a full SHA, e.g. `actions/cache@5a3ec84eff668545956fd18022155c47e93e2684 # v4`.

Locations:

- `action.yml:143`

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

**Fixes applied:** script-injection, static-inline-injection, github-env-injection, unpinned-uses

**Notes:**

Rewrote hardened/action/action.yml to fix all findings:

1. **unpinned-uses**: Pinned `actions/cache@v6` to full SHA `55cc8345863c7cc4c66a329aec7e433d2d1c52a9`.

2. **script-injection / static-inline-injection**: Moved all `${{ }}` expressions from `run:` blocks to `env:` blocks across all 5 affected steps (Resolve vizb version, Install vizb, Resolve input, Convert to JSON, Merge, Generate HTML). Shell scripts now reference plain environment variables.

3. **github-env-injection**: Added `printf '%s' "$VAR" | tr -d '\n\r'` sanitization before all writes to `$GITHUB_OUTPUT` in 'Resolve vizb version' (for TAG and REF) and 'Resolve input' (for FILE, CMD, and OUT_JSON).

4. **Merge step list injection**: Replaced the dangerous unquoted `FILES+=(${{ inputs.merge-files }})` with a proper xargs-based tokenization loop (`while IFS= read -r -d '' t; do FILES+=("$t"); done < <(printf '%s' "$INPUT_MERGE_FILES" | xargs printf '%s\0')`) that handles quoted arguments correctly and prevents word-splitting/glob injection.

### Iteration 2

**Fixes applied:** script-injection

**Notes:**

Replaced `eval "$RESOLVE_CMD" > "$INPUT"` with `bash -c "$RESOLVE_CMD" > "$INPUT"` in the 'Convert to JSON' step. The `eval` builtin executes the string as shell code in the current shell context, allowing manipulation of shell variables and functions. Using `bash -c` spawns a subshell instead, limiting the scope of execution and preventing the command from modifying the parent shell's state. Since `cmd` is explicitly documented as a shell command to execute, the fix preserves the intended functionality while removing the use of the dangerous `eval` builtin.

### Iteration 3

**Fixes applied:** script-injection

**Notes:**

Fixed the script injection vulnerability in the 'Convert to JSON' step of action.yml. The dangerous `bash -c "$RESOLVE_CMD" > "$INPUT"` pattern was replaced with a safe xargs-based tokenization approach: the RESOLVE_CMD value is tokenized using `printf '%s' "$RESOLVE_CMD" | xargs printf '%s\0'` into a bash array `cmd_args`, then executed directly as `"${cmd_args[@]}" > "$INPUT"`. This prevents shell injection because xargs performs quote-aware tokenization without evaluating shell metacharacters (`;`, `|`, `&&`, `$()`, backticks, etc.), which are passed through as literal argument text rather than being interpreted as shell operators.

