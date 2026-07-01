<!-- markdownlint-disable -->

# Hardening Report: goptics--vizb/v0.14.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `1`

Action **goptics--vizb/v0.14.0** was hardened automatically. 58 finding(s) were identified and resolved across 2 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (a): Multiple run: blocks directly interpolate ${{ ... }} expressions inside shell scripts. Step 'Resolve vizb version': uses ${{ inputs.vizb-binary }} (line 117) and ${{ github.action_ref }} (line 123). Step 'Install vizb': uses ${{ inputs.vizb-binary }} (line 154), ${{ runner.os }} (line 163), ${{ runner.arch }} (line 165), ${{ steps.version.outputs.tag }} (line 171). Step 'Resolve input': uses ${{ inputs.file }}, ${{ inputs.bench-file }}, ${{ inputs.cmd }}, ${{ inputs.bench-cmd }}, ${{ inputs.merge-files }}, ${{ inputs.merge-dir }}, ${{ inputs.data-url }}, ${{ inputs.output-json }} (lines 185-205). Step 'Convert to JSON': uses ${{ inputs.tag }}, ${{ inputs.id }}, ${{ inputs.name }}, ${{ inputs.description }}, ${{ inputs.group }}, ${{ inputs.group-pattern }}, ${{ inputs.group-regex }}, ${{ inputs.sort }}, ${{ inputs.filter }}, ${{ inputs.mem-unit }}, ${{ inputs.time-unit }}, ${{ inputs.number-unit }}, ${{ inputs.json-path }}, ${{ inputs.show-labels }}, ${{ inputs.parser }}, ${{ inputs.charts }}, ${{ inputs.chart }}, ${{ inputs.stat }}, ${{ steps.resolve.outputs.file }}, ${{ steps.resolve.outputs.json_file }} (lines 218-248). Critically, line 246 executes '${{ steps.resolve.outputs.cmd }} > "$INPUT"' — directly running user-controlled input as a shell command. Step 'Merge': uses ${{ steps.resolve.outputs.json_file }}, ${{ inputs.merge-files }}, ${{ inputs.merge-dir }}, ${{ inputs.tag-axis }} (lines 255-261). Step 'Generate HTML': uses ${{ inputs.charts }}, ${{ inputs.chart }}, ${{ inputs.stat }}, ${{ inputs.enable-3d }}, ${{ inputs.data-url }}, ${{ inputs.output-html }}, ${{ steps.resolve.outputs.json_file }} (lines 268-278).

Locations:

- `action.yml:117`
- `action.yml:123`
- `action.yml:154`
- `action.yml:163`
- `action.yml:165`
- `action.yml:171`
- `action.yml:185`
- `action.yml:218`
- `action.yml:246`
- `action.yml:255`
- `action.yml:268`

### github-env-injection (severity: high)

Multiple run: steps write untrusted values to $GITHUB_OUTPUT without sanitization (no printf '%s' ... | tr -d '\n\r' step). (1) 'Resolve vizb version' step: REF is set from ${{ github.action_ref }} and then written directly: 'echo "tag=$REF" >> "$GITHUB_OUTPUT"' (line 136) — an attacker-controlled ref containing a newline could inject additional output variables. (2) 'Resolve input' step: OUT_JSON is set from ${{ inputs.output-json }} and written as 'echo "json_file=$OUT_JSON" >> "$GITHUB_OUTPUT"' (line 204) without sanitization.

Locations:

- `action.yml:136`
- `action.yml:204`

### unpinned-uses (severity: high)

The 'Cache vizb binary' step uses 'actions/cache@v6' — a mutable tag reference rather than a pinned full-length SHA commit hash. This allows the upstream action to be silently updated or compromised without the consuming workflow's knowledge. Use a full 40-character SHA digest instead (e.g., actions/cache@1bd1e32a3bdc45362d1e726936510720a7c6158d # v6).

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

Fixed all security findings in actions/hardened/goptics--vizb/v0.14.0/action.yml: (1) Pinned actions/cache@v6 to full SHA 55cc8345863c7cc4c66a329aec7e433d2d1c52a9 # v6. (2) Moved all ${{ }} expressions from run: blocks to env: blocks for all 6 steps (Resolve vizb version, Install vizb, Resolve input, Convert to JSON, Merge, Generate HTML) — covering all inputs.*, github.action_ref, runner.os, runner.arch, steps.version.outputs.tag, steps.resolve.outputs.* references. (3) Sanitized values written to $GITHUB_OUTPUT using printf '%s' ... | tr -d '\n\r' for the tag/ref output in 'Resolve vizb version' (both the major-version TAG and the non-major REF paths) and the json_file output in 'Resolve input'. The run: blocks now only reference plain $ENV_VAR shell variables, eliminating all template injection vectors.

### Iteration 2

**Fixes applied:** github-env-injection, script-injection

**Notes:**

Three fixes applied to actions/hardened/goptics--vizb/v0.14.0/action.yml:
1. github-env-injection: Replaced heredoc writing $FILE/$CMD to GITHUB_OUTPUT with sanitized printf '%s' ... | tr -d '\n\r' approach.
2. script-injection (eval): Replaced eval "$RESOLVE_CMD" with writing the command to a temp script file and executing it with bash, preventing shell metacharacter injection.
3. script-injection (unquoted glob): Replaced FILES+=($INPUT_MERGE_FILES) with IFS=' ' read -ra _merge_files <<< "$INPUT_MERGE_FILES"; FILES+=("${_merge_files[@]}") to prevent word splitting and glob expansion of attacker-controlled content.

