<!-- markdownlint-disable -->

# Hardening Report: goptics--vizb/v0.23.1

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **goptics--vizb/v0.23.1** was hardened automatically. 1 finding(s) were identified and resolved across 3 iteration(s).

## Findings Fixed

### unpinned-uses (severity: high)

action.yml has a composite step that uses a mutable tag instead of a full 40-character commit SHA: `uses: actions/cache@v6` (step 'Cache vizb binary'). Pin it to a commit SHA and keep the version as a comment.

Locations:

- `action.yml:147`

## Iteration Notes

### Iteration 1

**Fixes applied:** unpinned-uses

**Notes:**

Pinned `actions/cache@v6` in action.yml (the 'Cache vizb binary' step) to the commit `55cc8345863c7cc4c66a329aec7e433d2d1c52a9`, with a `# v6` comment to keep the version readable.

### Iteration 2

**Fixes applied:** github-env-injection

**Notes:**

action/resolve.sh now strips newline and carriage-return characters from TAG with printf '%s' "$TAG" | tr -d '\n\r' and then writes the cleaned value to $GITHUB_OUTPUT. TAG is captured on its own line, so set -euo pipefail behaves as before. action.yml was left unchanged.

### Iteration 3

**Fixes applied:** github-env-injection

**Notes:**

The 'Add vizb to PATH' step now strips newlines from "$HOME/.local/bin" with printf '%s' ... | tr -d '\n\r' and then appends the result to $GITHUB_PATH. Nothing else in the step changed.

