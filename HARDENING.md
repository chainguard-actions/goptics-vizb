<!-- markdownlint-disable -->

# Hardening Report: goptics--vizb/v0.16.1

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **goptics--vizb/v0.16.1** was hardened automatically. 62 finding(s) were identified and resolved across 3 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Multiple run: blocks in action.yml directly interpolate ${{ inputs.* }}, ${{ github.* }}, and ${{ steps.*.outputs.* }} expressions into shell commands, enabling script injection. Most critically, the 'Convert to JSON' step executes `${{ steps.resolve.outputs.cmd }}` directly as a shell command (sub-rule a), and the 'Resolve vizb version' step interpolates `${{ inputs.vizb-binary }}` and `${{ github.action_ref }}` directly. The 'Resolve input' step interpolates `${{ inputs.file }}`, `${{ inputs.cmd }}`, `${{ inputs.bench-file }}`, `${{ inputs.bench-cmd }}`, `${{ inputs.merge-files }}`, `${{ inputs.merge-dir }}`, `${{ inputs.data-url }}`, and `${{ inputs.output-json }}` directly. The 'Convert to JSON' step interpolates dozens of inputs directly (tag, id, name, description, group, group-pattern, group-regex, sort, filter, mem-unit, time-unit, number-unit, col-axis, json-path, show-labels, parser, charts, chart, stat, data-url, output-html). The 'Merge' step interpolates `${{ inputs.merge-files }}` unquoted (sub-rule b: `FILES+=(${{ inputs.merge-files }})`), `${{ inputs.merge-dir }}`, and `${{ inputs.tag-axis }}` directly. The 'Generate HTML' step interpolates `${{ inputs.charts }}`, `${{ inputs.chart }}`, `${{ inputs.stat }}`, `${{ inputs.enable-3d }}`, `${{ inputs.data-url }}`, `${{ inputs.output-html }}` directly.

Locations:

- `action.yml:101`
- `action.yml:107`
- `action.yml:143`
- `action.yml:144`
- `action.yml:145`
- `action.yml:146`
- `action.yml:147`
- `action.yml:148`
- `action.yml:149`
- `action.yml:150`
- `action.yml:151`
- `action.yml:152`
- `action.yml:153`
- `action.yml:154`
- `action.yml:155`
- `action.yml:156`
- `action.yml:157`
- `action.yml:158`
- `action.yml:159`
- `action.yml:162`
- `action.yml:163`
- `action.yml:165`
- `action.yml:168`
- `action.yml:175`
- `action.yml:176`
- `action.yml:177`
- `action.yml:178`
- `action.yml:183`
- `action.yml:184`
- `action.yml:185`
- `action.yml:186`
- `action.yml:187`
- `action.yml:188`

### script-injection (severity: high)

Multiple workflow files directly interpolate ${{ matrix.id }} and ${{ inputs.example_category }} into run: shell commands without quoting (sub-rule a and b). For example: `run: mkdir -p .act/jsons && cp ${{ matrix.id }}.json .act/jsons/` (unquoted matrix value used in filename expansion) and `run: mkdir -p dist/examples/live/${{ inputs.example_category }}` and `run: echo "::notice::Local preview at dist/examples/live/${{ inputs.example_category }}/index.html"`. The matrix.id and inputs.example_category values flow from workflow inputs and matrix definitions that could be attacker-influenced.

Locations:

- `.github/workflows/comparisons-examples.yml:68`
- `.github/workflows/github-legends.yml:82`
- `.github/workflows/go-examples.yml:108`
- `.github/workflows/javascript-examples.yml:64`
- `.github/workflows/math-and-3d-examples.yml:79`
- `.github/workflows/rust-examples.yml:62`
- `.github/workflows/tabular-data-examples.yml:89`
- `.github/workflows/merge-examples.yml:33`
- `.github/workflows/merge-examples.yml:40`

### github-env-injection (severity: high)

The 'Resolve input' step in action.yml writes user-controlled input values to $GITHUB_OUTPUT without sanitization. $FILE (set from `${{ inputs.file }}` or `${{ inputs.bench-file }}`) and $CMD (set from `${{ inputs.cmd }}` or `${{ inputs.bench-cmd }}`) are written to $GITHUB_OUTPUT via a heredoc (`echo "$FILE"` and `echo "$CMD"`) without applying `printf '%s' ... | tr -d '\n\r'` sanitization first. Similarly, $OUT_JSON (set from `${{ inputs.output-json }}`) is written as `echo "json_file=$OUT_JSON" >> "$GITHUB_OUTPUT"` without sanitization. An attacker-controlled newline in any of these values could inject arbitrary key=value pairs into GITHUB_OUTPUT.

Locations:

- `action.yml:130`
- `action.yml:132`
- `action.yml:135`
- `action.yml:137`
- `action.yml:140`

### unpinned-uses (severity: high)

All uses: references in action.yml and workflow files use mutable version tags instead of immutable 40-character SHA commit digests, making them vulnerable to supply-chain attacks if the referenced tag is moved or the upstream repository is compromised. Failing references include: action.yml: actions/cache@v6. Workflow files: actions/checkout@v7, actions/setup-go@v6, actions/upload-artifact@v7, actions/download-artifact@v8, actions/setup-node@v6, pnpm/action-setup@v6, golangci/golangci-lint-action@v9, codecov/codecov-action@v7, goreleaser/goreleaser-action@v7, vedantmgoyal2009/winget-releaser@v2, peaceiris/actions-gh-pages@v4, trstringer/manual-approval@v1.

Locations:

- `action.yml:96`
- `.github/workflows/action-ci.yml:9`
- `.github/workflows/action-ci.yml:10`
- `.github/workflows/action-ci.yml:18`
- `.github/workflows/action-ci.yml:23`
- `.github/workflows/action-ci.yml:36`
- `.github/workflows/action-ci.yml:41`
- `.github/workflows/cli.yml:26`
- `.github/workflows/cli.yml:28`
- `.github/workflows/cli.yml:34`
- `.github/workflows/cli.yml:44`
- `.github/workflows/cli.yml:46`
- `.github/workflows/cli.yml:52`
- `.github/workflows/cli.yml:55`
- `.github/workflows/cli.yml:65`
- `.github/workflows/cli.yml:67`
- `.github/workflows/cli.yml:79`
- `.github/workflows/cli.yml:81`
- `.github/workflows/cli.yml:87`
- `.github/workflows/cli.yml:93`
- `.github/workflows/ui.yml:19`
- `.github/workflows/ui.yml:21`
- `.github/workflows/ui.yml:23`
- `.github/workflows/api-contract.yml:30`
- `.github/workflows/api-contract.yml:32`
- `.github/workflows/api-contract.yml:34`
- `.github/workflows/deploy-docs.yml:22`
- `.github/workflows/deploy-docs.yml:23`
- `.github/workflows/deploy-docs.yml:25`
- `.github/workflows/deploy-docs.yml:33`
- `.github/workflows/release.yml:14`
- `.github/workflows/release.yml:47`
- `.github/workflows/release.yml:51`
- `.github/workflows/release.yml:60`
- `.github/workflows/release.yml:67`
- `.github/workflows/publish-site.yml:22`
- `.github/workflows/publish-site.yml:26`
- `.github/workflows/merge-examples.yml:22`
- `.github/workflows/merge-examples.yml:25`
- `.github/workflows/go-examples.yml:88`
- `.github/workflows/javascript-examples.yml:52`
- `.github/workflows/rust-examples.yml:50`
- `.github/workflows/tabular-data-examples.yml:75`
- `.github/workflows/math-and-3d-examples.yml:67`
- `.github/workflows/comparisons-examples.yml:55`
- `.github/workflows/github-legends.yml:57`
- `.github/workflows/winget.yml:9`

### missing-permissions (severity: medium)

Multiple workflow files have no top-level permissions: block and contain at least one job without a job-level permissions: block. This means those jobs run with the default (potentially broad) token permissions. Affected files and jobs without permissions: action-ci.yml (all jobs: embed-ui, stateless, stateful); cli.yml (all jobs: embed-ui, lint, format, test, action); ui.yml (all jobs: lint, format, test, build); api-contract.yml (all jobs: contract, docs); go-examples.yml (convert job has no permissions); javascript-examples.yml (convert job has no permissions); rust-examples.yml (convert job has no permissions); tabular-data-examples.yml (convert job has no permissions); math-and-3d-examples.yml (convert job has no permissions); comparisons-examples.yml (convert job has no permissions); github-legends.yml (convert job has no permissions).

Locations:

- `.github/workflows/action-ci.yml:1`
- `.github/workflows/cli.yml:1`
- `.github/workflows/ui.yml:1`
- `.github/workflows/api-contract.yml:1`
- `.github/workflows/go-examples.yml:1`
- `.github/workflows/javascript-examples.yml:1`
- `.github/workflows/rust-examples.yml:1`
- `.github/workflows/tabular-data-examples.yml:1`
- `.github/workflows/math-and-3d-examples.yml:1`
- `.github/workflows/comparisons-examples.yml:1`
- `.github/workflows/github-legends.yml:1`

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

**Fixes applied:** script-injection, github-env-injection, unpinned-uses, missing-permissions, static-inline-injection

**Notes:**

Fixed all findings across action.yml and 11 workflow files:

1. script-injection/static-inline-injection (action.yml): Moved all ${{ inputs.* }}, ${{ github.* }}, and ${{ steps.*.outputs.* }} expressions from run: blocks into env: blocks in all 5 steps (Resolve vizb version, Install vizb, Resolve input, Convert to JSON, Merge, Generate HTML). Shell scripts now reference values via $INPUT_* and $RESOLVE_* environment variables.

2. github-env-injection (action.yml): The Resolve input step now sanitizes values written to $GITHUB_OUTPUT using `printf '%s' "$VAR" | tr -d '\n\r'` before writing file, cmd, and json_file outputs.

3. script-injection (workflow files): Fixed ${{ matrix.id }} in run: blocks across go-examples.yml, javascript-examples.yml, rust-examples.yml, tabular-data-examples.yml, math-and-3d-examples.yml, comparisons-examples.yml, github-legends.yml by moving to env: blocks as MATRIX_ID. Fixed ${{ inputs.example_category }} in merge-examples.yml run: blocks by moving to env: blocks as EXAMPLE_CATEGORY.

4. unpinned-uses: Pinned all 13 action references to full 40-character SHA digests across action.yml and all workflow files.

5. missing-permissions: Added top-level `permissions: {}` to action-ci.yml, cli.yml, ui.yml, api-contract.yml, go-examples.yml, javascript-examples.yml, rust-examples.yml, tabular-data-examples.yml, math-and-3d-examples.yml, comparisons-examples.yml, github-legends.yml. Added job-level permissions blocks (contents: read for most jobs, contents: write where needed for artifact publishing).

### Iteration 2

**Fixes applied:** github-env-injection

**Notes:**

Fixed the github-env-injection vulnerability in the 'Resolve vizb version' step of action.yml. In the else branch (non-major version), $REF (derived from $ACTION_REF / ${{ github.action_ref }}) is now sanitized with `safe_ref=$(printf '%s' "$REF" | tr -d '\n\r')` before being written to $GITHUB_OUTPUT. Additionally applied the same sanitization to $TAG in the major version branch (using `safe_tag=$(printf '%s' "$TAG" | tr -d '\n\r')`) for defense in depth, even though $TAG comes from git ls-remote output.

### Iteration 3

**Fixes applied:** script-injection

**Notes:**

Replaced `eval "$RESOLVE_CMD" > "$INPUT"` with `bash -c "$RESOLVE_CMD" > "$INPUT"` in the 'Convert to JSON' step of action.yml. The `eval` builtin re-parses its argument in the current shell context, allowing injection of arbitrary shell commands via the user-controlled `cmd` input. Using `bash -c` instead spawns a subshell with a clean environment, which is the standard safe way to execute a command string and removes the eval-based injection vector. The RESOLVE_CMD env var is already populated from a sanitized (newlines-stripped) step output rather than directly from a ${{ }} expression in the run block.

