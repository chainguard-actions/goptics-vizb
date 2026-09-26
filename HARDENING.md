<!-- markdownlint-disable -->

# Hardening Report: goptics--vizb/v0.15.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **goptics--vizb/v0.15.0** was hardened automatically. 58 finding(s) were identified and resolved across 2 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Multiple GitHub Actions expressions (${{ ... }}) are directly interpolated inside run: shell blocks throughout action.yml, violating sub-rule (a). This includes attacker-controllable inputs.* values used directly in shell commands, as well as github.action_ref, runner.os, runner.arch, and steps.*.outputs.* values. The most critical instance is `${{ steps.resolve.outputs.cmd }} > "$INPUT"` in the 'Convert to JSON' step, where the output of a prior step (itself derived from ${{ inputs.cmd }}) is executed directly as a shell command — enabling arbitrary command injection. Other violations include: 'Resolve vizb version' step: `if [ -n "${{ inputs.vizb-binary }}" ]` and `REF="${{ github.action_ref }}"`; 'Install vizb' step: `VIZB_BINARY="${{ inputs.vizb-binary }}"`, `OS=$(echo "${{ runner.os }}" | ...)`, `ARCH=$(echo "${{ runner.arch }}" | ...)`, `TAG="${{ steps.version.outputs.tag }}"`; 'Resolve input' step: `FILE="${{ inputs.file }}"`, `CMD="${{ inputs.cmd }}"`, `FILE="${{ inputs.bench-file }}"`, `CMD="${{ inputs.bench-cmd }}"`, `${{ inputs.merge-files }}`, `${{ inputs.merge-dir }}`, `${{ inputs.data-url }}`, `${{ inputs.output-json }}`; 'Convert to JSON' step: all inputs.* flags and `${{ steps.resolve.outputs.file }}`, `${{ steps.resolve.outputs.cmd }}` (executed as command), `${{ steps.resolve.outputs.json_file }}`; 'Merge' step: `${{ inputs.merge-files }}`, `${{ inputs.merge-dir }}`, `${{ inputs.tag-axis }}`, `${{ steps.resolve.outputs.json_file }}`; 'Generate HTML' step: `${{ inputs.data-url }}`, `${{ inputs.output-html }}`, `${{ steps.resolve.outputs.json_file }}`

Locations:

- `action.yml:114`
- `action.yml:120`
- `action.yml:141`
- `action.yml:152`
- `action.yml:154`
- `action.yml:156`
- `action.yml:196`
- `action.yml:197`
- `action.yml:198`
- `action.yml:199`
- `action.yml:201`
- `action.yml:215`
- `action.yml:227`
- `action.yml:248`
- `action.yml:256`
- `action.yml:258`
- `action.yml:259`
- `action.yml:260`
- `action.yml:267`

### github-env-injection (severity: high)

The 'Resolve input' step writes values derived from untrusted inputs to $GITHUB_OUTPUT without sanitization. Specifically: (1) $FILE (derived from ${{ inputs.file }} / ${{ inputs.bench-file }}) is written via `echo "$FILE"` to $GITHUB_OUTPUT; (2) $CMD (derived from ${{ inputs.cmd }} / ${{ inputs.bench-cmd }}) is written via `echo "$CMD"` to $GITHUB_OUTPUT; (3) $OUT_JSON (derived from ${{ inputs.output-json }}) is written via `echo "json_file=$OUT_JSON"` to $GITHUB_OUTPUT. None of these writes are preceded by the required sanitization step (`printf '%s' ... | tr -d '\n\r'`). An attacker can inject newlines into these inputs to poison subsequent step outputs or environment variables.

Locations:

- `action.yml:209`
- `action.yml:211`
- `action.yml:217`

### unpinned-uses (severity: high)

Multiple `uses:` references use mutable tag refs instead of pinned 40-character commit SHAs, making the action vulnerable to supply-chain attacks if the referenced tag is moved or the repository is compromised. Failing references: (1) action.yml: `uses: actions/cache@v6` — tag `v6` is not a SHA; (2) .github/actions/setup-embed-ui/action.yml: `uses: pnpm/action-setup@v6` — tag `v6` is not a SHA; (3) .github/actions/setup-embed-ui/action.yml: `uses: actions/setup-node@v6` — tag `v6` is not a SHA.

Locations:

- `action.yml:133`
- `.github/actions/setup-embed-ui/action.yml:8`
- `.github/actions/setup-embed-ui/action.yml:11`

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

Fixed all security findings in action.yml and .github/actions/setup-embed-ui/action.yml:

1. **unpinned-uses**: Pinned actions/cache@v6 to SHA 55cc8345863c7cc4c66a329aec7e433d2d1c52a9, pnpm/action-setup@v6 to SHA 0977fd99725f1db4007ccb2928dbb4e90d06cc86, and actions/setup-node@v6 to SHA 249970729cb0ef3589644e2896645e5dc5ba9c38.

2. **script-injection / static-inline-injection**: Moved all ${{ ... }} expressions from run: blocks into env: blocks for all five steps (Resolve vizb version, Install vizb, Resolve input, Convert to JSON, Merge, Generate HTML). All inputs.* values, github.action_ref, runner.os, runner.arch, and steps.*.outputs.* values are now accessed via environment variables in the shell scripts.

3. **github-env-injection**: Added sanitization (printf '%s' ... | tr -d '\n\r') before writing FILE, CMD, and OUT_JSON values to $GITHUB_OUTPUT in the 'Resolve input' step to prevent newline injection attacks.

### Iteration 2

**Fixes applied:** github-env-injection, script-injection

**Notes:**

Fixed three security findings in hardened/action/action.yml:

1. github-env-injection: In the 'Resolve vizb version' step, sanitized $TAG and $REF before writing to $GITHUB_OUTPUT using `printf '%s' "$VAR" | tr -d '\n\r'` pattern, storing results in safe_tag and safe_ref variables.

2. script-injection (eval): In the 'Convert to JSON' step, replaced `eval "$RESOLVE_CMD" > "$INPUT"` with writing the command to a temp script file using `printf '%s\n' "$RESOLVE_CMD" > "$VIZB_CMD_SCRIPT"` then executing with `bash "$VIZB_CMD_SCRIPT" > "$INPUT"`. This avoids eval's shell metacharacter interpretation.

3. script-injection (unquoted glob): In the 'Merge' step, replaced `FILES+=($INPUT_MERGE_FILES)` (unquoted, subject to word splitting and glob expansion) with a proper xargs-based tokenization loop: `while IFS= read -r -d '' t; do FILES+=("$t"); done < <(printf '%s' "$INPUT_MERGE_FILES" | xargs printf '%s\0')`, guarded by `if [ -n "$INPUT_MERGE_FILES" ]`.

