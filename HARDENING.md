<!-- markdownlint-disable -->

# Hardening Report: goptics--vizb/v0.20.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **goptics--vizb/v0.20.0** was hardened automatically. 3 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### unpinned-uses (severity: high)

The action uses mutable tag references instead of pinned SHA digests, making it vulnerable to supply-chain attacks if the referenced tag is moved or overwritten. Failing references: `uses: actions/cache@v6` (tag, not a 40-char SHA).

Locations:

- `action.yml:130`

### unpinned-uses (severity: high)

The composite action uses mutable tag references instead of pinned SHA digests. Failing references: `uses: actions/cache@v6` (tag, not a 40-char SHA).

Locations:

- `.github/actions/setup-embed-ui/action.yml:8`

### unpinned-uses (severity: high)

The composite action uses mutable tag references instead of pinned SHA digests. Failing references: `uses: pnpm/action-setup@v6` (line 13) and `uses: actions/setup-node@v6` (line 16).

Locations:

- `.github/actions/setup-js/action.yml:13`
- `.github/actions/setup-js/action.yml:16`

## Iteration Notes

### Iteration 1

**Fixes applied:** unpinned-uses

**Notes:**

Pinned all mutable tag references to full commit SHAs: (1) actions/cache@v6 → @55cc8345863c7cc4c66a329aec7e433d2d1c52a9 in both action.yml and .github/actions/setup-embed-ui/action.yml; (2) pnpm/action-setup@v6 → @0977fd99725f1db4007ccb2928dbb4e90d06cc86 in .github/actions/setup-js/action.yml; (3) actions/setup-node@v6 → @249970729cb0ef3589644e2896645e5dc5ba9c38 in .github/actions/setup-js/action.yml. All original tags preserved as inline comments.

