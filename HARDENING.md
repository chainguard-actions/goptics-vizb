<!-- markdownlint-disable -->

# Hardening Report: goptics--vizb/v0.19.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **goptics--vizb/v0.19.0** was hardened automatically. 5 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (a): The 'Resolve vizb version' run: block directly interpolates ${{ inputs.vizb-binary }} (line ~126) and ${{ github.action_ref }} (line ~132) into shell command strings. Any ${{ ... }} expression inside a run: block is a script-injection risk because the value is substituted by the YAML template engine before the shell ever sees it, allowing an attacker-controlled value to inject shell metacharacters. The 'Install vizb' run: block similarly interpolates ${{ runner.os }} (line ~167), ${{ inputs.vizb-binary }} (line ~173), ${{ runner.arch }}, and ${{ steps.version.outputs.tag }} directly into shell code. All of these should be moved to env: variables and then referenced as quoted shell variables (e.g., "$RUNNER_OS").

Locations:

- `action.yml:126`
- `action.yml:132`
- `action.yml:167`
- `action.yml:173`

### github-env-injection (severity: high)

The 'Resolve vizb version' run: block sets REF from ${{ github.action_ref }} (an untrusted github.* context value) and then writes it to $GITHUB_OUTPUT without sanitization: `echo "tag=$REF" >> "$GITHUB_OUTPUT"` and `echo "tag=$TAG" >> "$GITHUB_OUTPUT"` (where TAG is derived from REF). A newline embedded in github.action_ref could inject arbitrary key=value pairs into GITHUB_OUTPUT. The required sanitization step — `safe=$(printf '%s' "$REF" | tr -d '\n\r')` — must be applied before every write to a special environment file when the source is an untrusted context.

Locations:

- `action.yml:132`
- `action.yml:145`

### unpinned-uses (severity: high)

Multiple uses: references are pinned to mutable tags rather than immutable 40-character commit SHAs, making the action vulnerable to supply-chain attacks if the upstream tag is moved or the repository is compromised. Failing references: action.yml: `uses: actions/cache@v6`; .github/actions/setup-js/action.yml: `uses: pnpm/action-setup@v6` and `uses: actions/setup-node@v6`. Each should be pinned to a full SHA, e.g. `actions/cache@<40-hex-sha> # v6`.

Locations:

- `action.yml:152`
- `.github/actions/setup-js/action.yml:14`
- `.github/actions/setup-js/action.yml:17`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.vizb-binary }}" appears directly in run: block of step "Resolve vizb version"; move to env: map

Locations:

- `action.yml:126`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.vizb-binary }}" appears directly in run: block of step "Install vizb"; move to env: map

Locations:

- `action.yml:173`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, static-inline-injection, github-env-injection, unpinned-uses

**Notes:**

Fixed all findings in action.yml and .github/actions/setup-js/action.yml:

1. script-injection / static-inline-injection: Moved all ${{ }} expressions out of run: blocks into env: maps. 'Resolve vizb version' step now uses VIZB_BINARY and ACTION_REF env vars. 'Install vizb' step now uses RUNNER_OS_INPUT, RUNNER_ARCH_INPUT, VIZB_BINARY_INPUT, and VERSION_TAG env vars.

2. github-env-injection: Both GITHUB_OUTPUT writes in 'Resolve vizb version' now sanitize values with `printf '%s' "$VAR" | tr -d '\n\r'` before writing (safe_tag and safe_ref variables).

3. unpinned-uses: Pinned all three mutable tag references to full 40-character commit SHAs:
   - actions/cache@v6 → @55cc8345863c7cc4c66a329aec7e433d2d1c52a9 # v6
   - pnpm/action-setup@v6 → @0977fd99725f1db4007ccb2928dbb4e90d06cc86 # v6
   - actions/setup-node@v6 → @249970729cb0ef3589644e2896645e5dc5ba9c38 # v6

