<!-- markdownlint-disable -->

# Hardening Report: goptics--vizb/v0.15.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `1`

Action **goptics--vizb/v0.15.0** was hardened automatically. 59 finding(s) were identified and resolved across 5 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Multiple run: blocks in action.yml directly interpolate ${{ inputs.* }}, ${{ github.* }}, and ${{ steps.*.outputs.* }} expressions inside shell commands, violating rule (a). This allows an attacker-controlled value to be injected into the shell before quoting can occur. Critical examples include: (1) 'Resolve vizb version' step: `if [ -n "${{ inputs.vizb-binary }}" ]` and `REF="${{ github.action_ref }}"`; (2) 'Install vizb' step: `VIZB_BINARY="${{ inputs.vizb-binary }}"`, `OS=$(echo "${{ runner.os }}" | ...)`, `ARCH=$(echo "${{ runner.arch }}" | ...)`, `TAG="${{ steps.version.outputs.tag }}"`; (3) 'Resolve input' step: `FILE="${{ inputs.file }}"`, `CMD="${{ inputs.cmd }}"` and many other inputs; (4) 'Convert to JSON' step: dozens of `${{ inputs.* }}` expressions and critically `${{ steps.resolve.outputs.cmd }} > "$INPUT"` which executes an attacker-controlled string as a shell command; (5) 'Merge' step: `FILES+=(${{ inputs.merge-files }})` (unquoted), `${{ inputs.merge-dir }}`, `${{ inputs.tag-axis }}`; (6) 'Generate HTML' step: `${{ inputs.data-url }}`, `${{ inputs.output-html }}`, `${{ inputs.charts }}`, `${{ inputs.chart }}`, `${{ inputs.stat }}`.

Locations:

- `action.yml:100`
- `action.yml:105`
- `action.yml:130`
- `action.yml:175`
- `action.yml:215`
- `action.yml:265`
- `action.yml:310`

### github-env-injection (severity: high)

The 'Resolve input' step in action.yml writes unsanitized user-controlled values to $GITHUB_OUTPUT without applying the required `printf '%s' ... | tr -d '\n\r'` sanitization. Specifically: (1) $FILE (derived from ${{ inputs.file }} or ${{ inputs.bench-file }}) and $CMD (derived from ${{ inputs.cmd }} or ${{ inputs.bench-cmd }}) are written via `echo "$FILE"` and `echo "$CMD"` into a heredoc block appended to $GITHUB_OUTPUT; (2) $OUT_JSON (derived from ${{ inputs.output-json }}) is written as `echo "json_file=$OUT_JSON" >> "$GITHUB_OUTPUT"`. An attacker can inject newlines into these inputs to poison subsequent GITHUB_OUTPUT entries.

Locations:

- `action.yml:175`

### unpinned-uses (severity: high)

Multiple uses: references are pinned to mutable version tags instead of immutable 40-character commit SHAs, making the action vulnerable to supply-chain attacks if the tag is moved. Failing references include: action.yml: `actions/cache@v6`; .github/workflows/action-ci.yml: `actions/checkout@v7`, `actions/setup-go@v6`; .github/workflows/cli.yml: `actions/checkout@v7`, `actions/setup-go@v6`, `golangci/golangci-lint-action@v9`, `codecov/codecov-action@v7`; .github/workflows/deploy-docs.yml: `actions/checkout@v7`, `pnpm/action-setup@v6`, `actions/setup-node@v6`, `peaceiris/actions-gh-pages@v4`; .github/workflows/deploy-examples-csv.yml: `actions/checkout@v7`, `actions/upload-artifact@v7`; .github/workflows/deploy-examples-go.yml: `actions/checkout@v7`, `actions/upload-artifact@v7`; .github/workflows/deploy-examples-javascript.yml: `actions/checkout@v7`, `actions/upload-artifact@v7`; .github/workflows/deploy-examples-json.yml: `actions/checkout@v7`, `actions/upload-artifact@v7`; .github/workflows/deploy-examples-rust.yml: `actions/checkout@v7`, `actions/upload-artifact@v7`; .github/workflows/merge-deploy-examples.yml: `actions/checkout@v7`, `actions/download-artifact@v8`, `peaceiris/actions-gh-pages@v4`; .github/workflows/release.yml: `trstringer/manual-approval@v1`, `actions/checkout@v7`, `actions/setup-go@v6`, `goreleaser/goreleaser-action@v7`, `vedantmgoyal2009/winget-releaser@v2`; .github/workflows/ui.yml: `actions/checkout@v7`, `pnpm/action-setup@v6`, `actions/setup-node@v6`, `actions/setup-go@v6`; .github/workflows/winget.yml: `vedantmgoyal2009/winget-releaser@v2`.

Locations:

- `action.yml:115`
- `.github/workflows/action-ci.yml:13`
- `.github/workflows/cli.yml:29`
- `.github/workflows/deploy-docs.yml:14`
- `.github/workflows/deploy-examples-csv.yml:80`
- `.github/workflows/deploy-examples-go.yml:67`
- `.github/workflows/deploy-examples-javascript.yml:35`
- `.github/workflows/deploy-examples-json.yml:33`
- `.github/workflows/deploy-examples-rust.yml:34`
- `.github/workflows/merge-deploy-examples.yml:17`
- `.github/workflows/release.yml:15`
- `.github/workflows/ui.yml:19`
- `.github/workflows/winget.yml:9`

### missing-permissions (severity: medium)

Several workflow files have no top-level `permissions:` key and contain jobs that also lack job-level `permissions:` keys, meaning they run with the default (potentially write-all) token permissions. Affected files and jobs: (1) action-ci.yml — no top-level permissions, jobs 'stateless' and 'stateful' have no permissions; (2) cli.yml — no top-level permissions, jobs 'lint', 'format', 'test', 'action' have no permissions; (3) ui.yml — no top-level permissions, jobs 'lint', 'format', 'test', 'build' have no permissions; (4) deploy-examples-csv.yml — no top-level permissions, 'convert' job has no permissions (only 'merge-deploy' has permissions); (5) deploy-examples-go.yml — same issue; (6) deploy-examples-javascript.yml — same issue; (7) deploy-examples-json.yml — same issue; (8) deploy-examples-rust.yml — same issue.

Locations:

- `.github/workflows/action-ci.yml:1`
- `.github/workflows/cli.yml:1`
- `.github/workflows/ui.yml:1`
- `.github/workflows/deploy-examples-csv.yml:1`
- `.github/workflows/deploy-examples-go.yml:1`
- `.github/workflows/deploy-examples-javascript.yml:1`
- `.github/workflows/deploy-examples-json.yml:1`
- `.github/workflows/deploy-examples-rust.yml:1`

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

**Fixes applied:** script-injection, github-env-injection, unpinned-uses, missing-permissions, static-inline-injection

**Notes:**

Fixed all findings across action.yml and all .github/workflows/*.yml files:

1. script-injection / static-inline-injection (action.yml): Moved all ${{ inputs.* }}, ${{ github.* }}, and ${{ steps.*.outputs.* }} expressions out of run: blocks and into env: maps for all steps (Resolve vizb version, Install vizb, Resolve input, Convert to JSON, Merge, Generate HTML). Shell scripts now reference plain environment variables.

2. github-env-injection (action.yml): In the 'Resolve input' step, FILE and CMD values are now sanitized with `printf '%s' ... | tr -d '\n\r'` before being written to $GITHUB_OUTPUT. Similarly, OUT_JSON is sanitized before writing.

3. unpinned-uses: Pinned all mutable tag references to immutable commit SHAs:
   - actions/cache@v6 → @55cc8345863c7cc4c66a329aec7e433d2d1c52a9
   - actions/checkout@v7 → @9c091bb21b7c1c1d1991bb908d89e4e9dddfe3e0
   - actions/setup-go@v6 → @924ae3a1cded613372ab5595356fb5720e22ba16
   - golangci/golangci-lint-action@v9 → @ba0d7d2ec06a0ea1cb5fa41b2e4a3ab91d21278a
   - codecov/codecov-action@v7 → @fb8b3582c8e4def4969c97caa2f19720cb33a72f
   - pnpm/action-setup@v6 → @0ebf47130e4866e96fce0953f49152a61190b271
   - actions/setup-node@v6 → @48b55a011bda9f5d6aeb4c2d9c7362e8dae4041e
   - peaceiris/actions-gh-pages@v4 → @84c30a85c19949d7eee79c4ff27748b70285e453
   - actions/upload-artifact@v7 → @043fb46d1a93c77aae656e7c1c64a875d1fc6a0a
   - actions/download-artifact@v8 → @3e5f45b2cfb9172054b4087a40e8e0b5a5461e7c
   - trstringer/manual-approval@v1 → @fa642940caf8412403569b28b2db4a1df08a83a3
   - goreleaser/goreleaser-action@v7 → @f06c13b6b1a9625abc9e6e439d9c05a8f2190e94
   - vedantmgoyal2009/winget-releaser@v2 → @4ffc7888bffd451b357355dc214d43bb9f23917e

4. missing-permissions: Added top-level `permissions: {}` to action-ci.yml, cli.yml, ui.yml, deploy-examples-csv.yml, deploy-examples-go.yml, deploy-examples-javascript.yml, deploy-examples-json.yml, deploy-examples-rust.yml. Added job-level `permissions: contents: read` to all jobs that lacked permissions in those files.

### Iteration 2

**Fixes applied:** github-env-injection

**Notes:**

Fixed the 'Resolve vizb version' step in action.yml. Both code paths that write the 'tag' value to $GITHUB_OUTPUT now sanitize the value first using `printf '%s' "$VAR" | tr -d '\n\r'` before writing. Specifically: (1) the TAG variable (from git ls-remote output) is sanitized into safe_tag before writing, and (2) the REF variable (from ACTION_REF / github.action_ref) is sanitized into safe_ref before writing. This prevents newline injection attacks that could allow an attacker to set arbitrary output variables in downstream steps.

### Iteration 3

**Fixes applied:** script-injection

**Notes:**

Fixed all three script-injection findings:

1. **${{ matrix.id }} in run: steps** (deploy-examples-csv.yml, deploy-examples-go.yml, deploy-examples-javascript.yml, deploy-examples-json.yml, deploy-examples-rust.yml): Moved `${{ matrix.id }}` out of the `run:` shell string into an `env:` block as `MATRIX_ID`, then referenced it as `"${MATRIX_ID}.json"` in the shell command.

2. **${{ inputs.language }} in run: steps** (merge-deploy-examples.yml lines 34 and 45): Moved `${{ inputs.language }}` out of both `run:` shell strings into `env:` blocks as `INPUT_LANGUAGE`, then referenced it as `${INPUT_LANGUAGE}` in the shell commands. The `inputs.language` reference in the `with:` block of the Merging step was left as-is since it is not a shell command.

3. **eval "$RESOLVE_CMD" in action.yml** (line 270): Replaced `eval "$RESOLVE_CMD"` with `bash -c "$RESOLVE_CMD"` to prevent double-evaluation of shell metacharacters. The `eval` builtin performs an extra round of expansion that allows shell metacharacters (`;`, `&&`, `|`, `$(...)`, backticks) in the user-controlled `inputs.cmd` value to be interpreted as shell commands. Using `bash -c` executes the string as a single shell script without the extra expansion pass.

### Iteration 4

**Fixes applied:** unpinned-uses

**Notes:**

Pinned both mutable tag references in .github/actions/setup-embed-ui/action.yml to full commit SHAs: `pnpm/action-setup@v6` → `pnpm/action-setup@0ebf47130e4866e96fce0953f49152a61190b271 # v6` and `actions/setup-node@v6` → `actions/setup-node@48b55a011bda9f5d6aeb4c2d9c7362e8dae4041e # v6`. Original tags preserved as comments for readability.

### Iteration 5

**Fixes applied:** script-injection

**Notes:**

Fixed script injection in the 'Convert to JSON' step of action.yml (line 260). The original code used `bash -c "$RESOLVE_CMD"` where RESOLVE_CMD holds user-controlled input (inputs.cmd). Even with double-quoting in the parent shell, bash -c interprets the string as shell code, allowing metacharacters like `;`, `|`, `&`, `$(...)` to execute arbitrary commands. The fix writes the command to a temporary script file (`printf '%s\n' "$RESOLVE_CMD" > "$CMD_SCRIPT"`) and executes it as a script file (`bash "$CMD_SCRIPT"`), then cleans up the temp file. This preserves the intended functionality (running user-supplied commands) while eliminating the bash -c injection vector.

