<!-- markdownlint-disable -->

# Hardening Report: goptics--vizb/v0.23.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **goptics--vizb/v0.23.0** was hardened automatically. 1 finding(s) were identified and resolved across 2 iteration(s).

## Findings Fixed

### unpinned-uses (severity: high)

The composite action step 'Cache vizb binary' uses `actions/cache@v6`, which is a mutable tag reference rather than a pinned full 40-character SHA commit hash. This means the action could silently change if the tag is moved, enabling supply-chain attacks. It should be pinned to a specific commit SHA (e.g., `actions/cache@<40-char-sha> # v6`).

Locations:

- `action.yml:163`

## Iteration Notes

### Iteration 1

**Fixes applied:** unpinned-uses

**Notes:**

Pinned `actions/cache@v6` to full commit SHA `55cc8345863c7cc4c66a329aec7e433d2d1c52a9` in hardened/action/action.yml (line 163). The original tag is preserved as a comment: `actions/cache@55cc8345863c7cc4c66a329aec7e433d2d1c52a9 # v6`.

### Iteration 2

**Fixes applied:** unpinned-uses

**Notes:**

Pinned all three mutable tag references to full commit SHAs:
- `.github/actions/setup-embed-ui/action.yml` line 9: `actions/cache@v6` → `actions/cache@55cc8345863c7cc4c66a329aec7e433d2d1c52a9 # v6`
- `.github/actions/setup-js/action.yml` line 14: `pnpm/action-setup@v6` → `pnpm/action-setup@0977fd99725f1db4007ccb2928dbb4e90d06cc86 # v6`
- `.github/actions/setup-js/action.yml` line 17: `actions/setup-node@v6` → `actions/setup-node@249970729cb0ef3589644e2896645e5dc5ba9c38 # v6`

