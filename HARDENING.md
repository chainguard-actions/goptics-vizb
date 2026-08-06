<!-- markdownlint-disable -->

# Hardening Report: goptics--vizb/v0.17.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **goptics--vizb/v0.17.0** was hardened automatically. 64 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Multiple ${{ ... }} expressions are interpolated directly inside run: shell blocks in action.yml, violating rule (a). This includes attacker-controllable inputs: ${{ inputs.vizb-binary }}, ${{ inputs.file }}, ${{ inputs.cmd }}, ${{ inputs.bench-file }}, ${{ inputs.bench-cmd }}, ${{ inputs.merge-files }}, ${{ inputs.merge-dir }}, ${{ inputs.data-url }}, ${{ inputs.output-json }}, ${{ inputs.tag }}, ${{ inputs.id }}, ${{ inputs.name }}, ${{ inputs.title }}, ${{ inputs.description }}, ${{ inputs.group }}, ${{ inputs.group-pattern }}, ${{ inputs.group-regex }}, ${{ inputs.sort }}, ${{ inputs.filter }}, ${{ inputs.mem-unit }}, ${{ inputs.time-unit }}, ${{ inputs.number-unit }}, ${{ inputs.col-axis }}, ${{ inputs.json-path }}, ${{ inputs.parser }}, ${{ inputs.charts }}, ${{ inputs.chart }}, ${{ inputs.stat }}, ${{ inputs.show-labels }}, ${{ inputs.enable-3d }}, ${{ inputs.output-html }}, ${{ inputs.tag-axis }}, ${{ github.action_ref }}, ${{ runner.os }}, ${{ runner.arch }}, and ${{ steps.resolve.outputs.* }} (including ${{ steps.resolve.outputs.cmd }} which is executed directly as a shell command). Additionally, ${{ inputs.merge-files }} is expanded unquoted in an array (rule b): `FILES+=(${{ inputs.merge-files }})`, allowing shell metacharacter injection.

Locations:

- `action.yml:110`
- `action.yml:116`
- `action.yml:132`
- `action.yml:139`
- `action.yml:141`
- `action.yml:143`
- `action.yml:175`
- `action.yml:177`
- `action.yml:205`
- `action.yml:242`
- `action.yml:255`

### script-injection (severity: high)

Multiple workflow files interpolate ${{ matrix.id }} and ${{ inputs.example_category }} directly inside run: shell commands (rule a). For example: `run: mkdir -p .act/jsons && cp ${{ matrix.id }}.json .act/jsons/` and `run: mkdir -p dist/examples/live/${{ inputs.example_category }}` and `run: echo "::notice::Local preview at dist/examples/live/${{ inputs.example_category }}/index.html"`. The matrix.* and inputs.* contexts are workflow-controllable and must not be interpolated directly into shell commands.

Locations:

- `.github/workflows/comparisons-examples.yml:68`
- `.github/workflows/github-legends.yml:72`
- `.github/workflows/go-examples.yml:100`
- `.github/workflows/javascript-examples.yml:65`
- `.github/workflows/math-and-3d-examples.yml:76`
- `.github/workflows/rust-examples.yml:60`
- `.github/workflows/tabular-data-examples.yml:82`
- `.github/workflows/merge-examples.yml:30`
- `.github/workflows/merge-examples.yml:37`

### github-env-injection (severity: high)

In action.yml's 'Resolve vizb version' step, ${{ github.action_ref }} is assigned to REF and then written unsanitized to $GITHUB_OUTPUT via `echo "tag=$REF" >> "$GITHUB_OUTPUT"` and `echo "tag=$TAG" >> "$GITHUB_OUTPUT"` without the required `printf '%s' ... | tr -d '\n\r'` sanitization. In the 'Resolve input' step, ${{ inputs.file }}, ${{ inputs.bench-file }}, ${{ inputs.cmd }}, ${{ inputs.bench-cmd }} are assigned to FILE/CMD and written to $GITHUB_OUTPUT via heredoc (`echo "$FILE"` / `echo "$CMD"`) without sanitization, and ${{ inputs.output-json }} is written as `echo "json_file=$OUT_JSON" >> "$GITHUB_OUTPUT"` without sanitization. An attacker-controlled newline in any of these values can inject arbitrary key=value pairs into the GitHub environment files.

Locations:

- `action.yml:120`
- `action.yml:122`
- `action.yml:183`
- `action.yml:185`
- `action.yml:196`

### unpinned-uses (severity: high)

All uses: references in action.yml and workflow files use mutable version tags instead of pinned 40-character SHA commit hashes, making them vulnerable to supply-chain attacks if the referenced tag is moved or the upstream repository is compromised. Failing references include: action.yml: actions/cache@v6; action-ci.yml: actions/checkout@v7, actions/setup-go@v6, actions/upload-artifact@v7, actions/download-artifact@v8; cli.yml: actions/checkout@v7, actions/setup-go@v6, actions/upload-artifact@v7, actions/download-artifact@v8, golangci/golangci-lint-action@v9, codecov/codecov-action@v7; release.yml: trstringer/manual-approval@v1, actions/checkout@v7, docker/setup-qemu-action@v4, docker/setup-buildx-action@v4, docker/login-action@v4, actions/setup-go@v6, actions/download-artifact@v8, goreleaser/goreleaser-action@v7, vedantmgoyal2009/winget-releaser@v2, peaceiris/actions-gh-pages@v4; api-contract.yml: actions/checkout@v7, pnpm/action-setup@v6, actions/setup-node@v6; deploy-docs.yml: actions/checkout@v7, pnpm/action-setup@v6, actions/setup-node@v6, actions/upload-artifact@v7; ui.yml: actions/checkout@v7, pnpm/action-setup@v6, actions/setup-node@v6, codecov/codecov-action@v7, actions/setup-go@v6; winget.yml: vedantmgoyal2009/winget-releaser@v2; and all example workflow files using actions/checkout@v7, actions/upload-artifact@v7, actions/download-artifact@v8.

Locations:

- `action.yml:127`
- `.github/workflows/action-ci.yml:10`
- `.github/workflows/cli.yml:27`
- `.github/workflows/release.yml:16`
- `.github/workflows/api-contract.yml:27`
- `.github/workflows/deploy-docs.yml:27`
- `.github/workflows/ui.yml:20`
- `.github/workflows/winget.yml:9`
- `.github/workflows/comparisons-examples.yml:36`
- `.github/workflows/github-legends.yml:47`
- `.github/workflows/go-examples.yml:84`
- `.github/workflows/javascript-examples.yml:43`
- `.github/workflows/math-and-3d-examples.yml:58`
- `.github/workflows/rust-examples.yml:43`
- `.github/workflows/tabular-data-examples.yml:58`
- `.github/workflows/merge-examples.yml:21`
- `.github/workflows/publish-site.yml:20`
- `.github/workflows/installers.yml:28`

### missing-permissions (severity: medium)

Three workflow files have no top-level permissions: key and no job-level permissions: keys on any of their jobs, meaning they run with the default (potentially broad) GITHUB_TOKEN permissions: action-ci.yml, cli.yml, and api-contract.yml. Each of these files has multiple jobs with no permissions defined at any level.

Locations:

- `.github/workflows/action-ci.yml:1`
- `.github/workflows/cli.yml:1`
- `.github/workflows/api-contract.yml:1`

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

**Fixes applied:** script-injection, github-env-injection, unpinned-uses, missing-permissions, static-inline-injection

**Notes:**

Fixed all findings across action.yml and 11 workflow files:

1. action.yml: Moved all ${{ inputs.* }}, ${{ github.action_ref }}, ${{ runner.* }}, and ${{ steps.resolve.outputs.* }} expressions from run: blocks to env: blocks. Sanitized all GITHUB_OUTPUT writes with printf '%s' | tr -d '\n\r'. Fixed merge-files unquoted array expansion using xargs-based tokenization. Pinned actions/cache@v6 to SHA.

2. Workflow files (comparisons-examples.yml, github-legends.yml, go-examples.yml, javascript-examples.yml, math-and-3d-examples.yml, rust-examples.yml, tabular-data-examples.yml, merge-examples.yml): Moved ${{ matrix.id }} and ${{ inputs.example_category }} from run: blocks to env: blocks.

3. All workflow files: Pinned all 16 action references to full 40-character SHA hashes.

4. action-ci.yml, cli.yml, api-contract.yml: Added top-level permissions: {} and job-level permissions: {contents: read} blocks.

5. release.yml, deploy-docs.yml, ui.yml, winget.yml, publish-site.yml, installers.yml: Pinned all action references to SHA hashes.

