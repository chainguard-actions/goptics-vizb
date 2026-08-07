<!-- markdownlint-disable -->

# Hardening Report: goptics--vizb/v0.13.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **goptics--vizb/v0.13.0** was hardened automatically. 58 finding(s) were identified and resolved across 2 iteration(s).

## Findings Fixed

### script-injection (severity: high)

action.yml has pervasive direct interpolation of ${{ ... }} expressions inside run: blocks, violating rule (a). This includes:
- 'Resolve vizb version' step: REF="${{ github.action_ref }}" interpolated directly in shell
- 'Install vizb' step: VIZB_BINARY="${{ inputs.vizb-binary }}", OS=$(echo "${{ runner.os }}" ...), ARCH=$(echo "${{ runner.arch }}" ...), TAG="${{ steps.version.outputs.tag }}"
- 'Resolve input' step: FILE="${{ inputs.file }}", FILE="${{ inputs.bench-file }}", CMD="${{ inputs.cmd }}", CMD="${{ inputs.bench-cmd }}", ${{ inputs.merge-files }}, ${{ inputs.merge-dir }}, ${{ inputs.data-url }}, ${{ inputs.output-json }}
- 'Convert to JSON' step: All inputs interpolated directly, and most critically ${{ steps.resolve.outputs.cmd }} is executed directly as a shell command (arbitrary command injection)
- 'Merge' step: ${{ inputs.merge-files }} is unquoted in shell expansion (rule b violation), plus ${{ inputs.merge-dir }}, ${{ inputs.tag-axis }}
- 'Generate HTML' step: ${{ inputs.charts }}, ${{ inputs.chart }}, ${{ inputs.stat }}, ${{ inputs.enable-3d }}, ${{ inputs.data-url }}, ${{ inputs.output-html }}, ${{ steps.resolve.outputs.json_file }}

Locations:

- `action.yml:100`
- `action.yml:120`
- `action.yml:148`
- `action.yml:175`
- `action.yml:210`
- `action.yml:240`

### github-env-injection (severity: high)

action.yml writes unsanitized values derived from untrusted inputs and github context to $GITHUB_OUTPUT and $GITHUB_PATH without the required sanitization step (printf '%s' ... | tr -d '\n\r'):
- 'Resolve vizb version' step: echo "tag=$REF" >> "$GITHUB_OUTPUT" and echo "tag=$TAG" >> "$GITHUB_OUTPUT" where REF comes from ${{ github.action_ref }}
- 'Resolve input' step: writes $FILE (from ${{ inputs.file }}/${{ inputs.bench-file }}), $CMD (from ${{ inputs.cmd }}/${{ inputs.bench-cmd }}), and $OUT_JSON (from ${{ inputs.output-json }}) to $GITHUB_OUTPUT using heredoc multiline syntax without sanitization

Locations:

- `action.yml:100`
- `action.yml:148`

### unpinned-uses (severity: high)

Multiple uses: references use mutable version tags instead of full 40-character SHA commit hashes, making the action vulnerable to supply-chain attacks if a tag is moved or a dependency is compromised.

action.yml: actions/cache@v6

.github/workflows/action-ci.yml: actions/checkout@v7, actions/setup-go@v6
.github/workflows/cli.yml: actions/checkout@v7, actions/setup-go@v6, golangci/golangci-lint-action@v9, codecov/codecov-action@v7
.github/workflows/deploy-docs.yml: actions/checkout@v7, pnpm/action-setup@v6, actions/setup-node@v6, peaceiris/actions-gh-pages@v4
.github/workflows/deploy-examples-csv.yml: actions/checkout@v7, actions/upload-artifact@v7
.github/workflows/deploy-examples-go.yml: actions/checkout@v7, actions/upload-artifact@v7
.github/workflows/deploy-examples-javascript.yml: actions/checkout@v7, actions/upload-artifact@v7
.github/workflows/deploy-examples-json.yml: actions/checkout@v7, actions/upload-artifact@v7
.github/workflows/deploy-examples-rust.yml: actions/checkout@v7, actions/upload-artifact@v7
.github/workflows/merge-deploy-examples.yml: actions/checkout@v7, actions/download-artifact@v8, peaceiris/actions-gh-pages@v4
.github/workflows/release.yml: actions/checkout@v7, trstringer/manual-approval@v1, actions/setup-go@v6, goreleaser/goreleaser-action@v7, vedantmgoyal2009/winget-releaser@v2
.github/workflows/ui.yml: actions/checkout@v7, pnpm/action-setup@v6, actions/setup-node@v6, actions/setup-go@v6
.github/workflows/winget.yml: vedantmgoyal2009/winget-releaser@v2

Locations:

- `action.yml:113`
- `.github/workflows/action-ci.yml:13`
- `.github/workflows/cli.yml:27`
- `.github/workflows/deploy-docs.yml:16`
- `.github/workflows/deploy-examples-csv.yml:57`
- `.github/workflows/deploy-examples-go.yml:54`
- `.github/workflows/deploy-examples-javascript.yml:37`
- `.github/workflows/deploy-examples-json.yml:33`
- `.github/workflows/deploy-examples-rust.yml:34`
- `.github/workflows/merge-deploy-examples.yml:20`
- `.github/workflows/release.yml:18`
- `.github/workflows/ui.yml:22`
- `.github/workflows/winget.yml:10`

### missing-permissions (severity: medium)

The following workflow files have no top-level permissions: block and contain at least one job without a job-level permissions: block, meaning they run with the default (potentially broad) token permissions:
- action-ci.yml: no top-level permissions, neither 'stateless' nor 'stateful' jobs have permissions
- cli.yml: no top-level permissions, none of the lint/format/test/action jobs have permissions
- ui.yml: no top-level permissions, none of the lint/format/test/build jobs have permissions
- deploy-examples-csv.yml: no top-level permissions; the 'convert' job has no permissions block
- deploy-examples-go.yml: no top-level permissions; the 'convert' job has no permissions block
- deploy-examples-javascript.yml: no top-level permissions; the 'convert' job has no permissions block
- deploy-examples-json.yml: no top-level permissions; the 'convert' job has no permissions block
- deploy-examples-rust.yml: no top-level permissions; the 'convert' job has no permissions block

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

shell injection: expression "${{ inputs.vizb-binary }}" appears directly in run: block of step "Install vizb"; move to env: map

Locations:

- `action.yml:145`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.file }}" appears directly in run: block of step "Resolve input"; move to env: map

Locations:

- `action.yml:206`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.bench-file }}" appears directly in run: block of step "Resolve input"; move to env: map

Locations:

- `action.yml:207`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.cmd }}" appears directly in run: block of step "Resolve input"; move to env: map

Locations:

- `action.yml:208`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.bench-cmd }}" appears directly in run: block of step "Resolve input"; move to env: map

Locations:

- `action.yml:209`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.merge-files }}" appears directly in run: block of step "Resolve input"; move to env: map

Locations:

- `action.yml:213`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.merge-dir }}" appears directly in run: block of step "Resolve input"; move to env: map

Locations:

- `action.yml:213`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.data-url }}" appears directly in run: block of step "Resolve input"; move to env: map

Locations:

- `action.yml:213`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.output-json }}" appears directly in run: block of step "Resolve input"; move to env: map

Locations:

- `action.yml:229`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.tag }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:243`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.tag }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:243`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.name }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:244`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.name }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:244`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.description }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:245`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.description }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:245`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.group }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:246`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.group }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:246`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.group-pattern }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:247`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.group-pattern }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:247`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.group-regex }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:248`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.group-regex }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:248`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.sort }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:249`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.sort }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:249`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.filter }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:250`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.filter }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:250`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mem-unit }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:251`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.mem-unit }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:251`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.time-unit }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:252`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.time-unit }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:252`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.number-unit }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:253`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.number-unit }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:253`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.select }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:254`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.select }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:254`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.json-path }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:255`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.json-path }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:255`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.show-labels }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:256`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.parser }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:257`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.parser }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:257`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.charts }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:258`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.chart }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:258`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.stat }}" appears directly in run: block of step "Convert to JSON"; move to env: map

Locations:

- `action.yml:258`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.merge-files }}" appears directly in run: block of step "Merge"; move to env: map

Locations:

- `action.yml:277`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.merge-files }}" appears directly in run: block of step "Merge"; move to env: map

Locations:

- `action.yml:277`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.merge-dir }}" appears directly in run: block of step "Merge"; move to env: map

Locations:

- `action.yml:278`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.merge-dir }}" appears directly in run: block of step "Merge"; move to env: map

Locations:

- `action.yml:278`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.tag-axis }}" appears directly in run: block of step "Merge"; move to env: map

Locations:

- `action.yml:279`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.charts }}" appears directly in run: block of step "Generate HTML"; move to env: map

Locations:

- `action.yml:287`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.chart }}" appears directly in run: block of step "Generate HTML"; move to env: map

Locations:

- `action.yml:287`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.stat }}" appears directly in run: block of step "Generate HTML"; move to env: map

Locations:

- `action.yml:287`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.enable-3d }}" appears directly in run: block of step "Generate HTML"; move to env: map

Locations:

- `action.yml:288`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.data-url }}" appears directly in run: block of step "Generate HTML"; move to env: map

Locations:

- `action.yml:290`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.data-url }}" appears directly in run: block of step "Generate HTML"; move to env: map

Locations:

- `action.yml:291`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.output-html }}" appears directly in run: block of step "Generate HTML"; move to env: map

Locations:

- `action.yml:291`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.output-html }}" appears directly in run: block of step "Generate HTML"; move to env: map

Locations:

- `action.yml:293`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, github-env-injection, unpinned-uses, missing-permissions, static-inline-injection

**Notes:**

Fixed all findings in action.yml and all .github/workflows/*.yml files:

1. script-injection/static-inline-injection: Moved all ${{ }} expressions from run: blocks into env: blocks across all 5 steps in action.yml (Resolve vizb version, Install vizb, Resolve input, Convert to JSON, Merge, Generate HTML). The dangerous direct execution of ${{ steps.resolve.outputs.cmd }} was replaced with bash -c "$RESOLVE_CMD" where RESOLVE_CMD is set via env:.

2. github-env-injection: Added printf '%s' "$VAR" | tr -d '\n\r' sanitization for all values written to $GITHUB_OUTPUT that derive from github.action_ref, inputs.file, inputs.bench-file, inputs.cmd, inputs.bench-cmd, and inputs.output-json.

3. unpinned-uses: Pinned all 13 action references across action.yml and all 12 workflow files to full 40-character SHA commit hashes with version tag comments.

4. missing-permissions: Added top-level permissions: {} and job-level permissions: contents: read blocks to action-ci.yml, cli.yml, ui.yml, deploy-examples-csv.yml, deploy-examples-go.yml, deploy-examples-javascript.yml, deploy-examples-json.yml, and deploy-examples-rust.yml.

### Iteration 2

**Fixes applied:** script-injection

**Notes:**

Fixed script injection in `.github/workflows/merge-deploy-examples.yml` at the 'Prepare output directory' step. Moved `${{ inputs.language }}` out of the `run:` shell command into an `env:` block as `LANGUAGE`, and updated the shell command to use `"dist/examples/$LANGUAGE"` (double-quoted) instead of the direct expression interpolation.

