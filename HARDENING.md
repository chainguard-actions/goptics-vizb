<!-- markdownlint-disable -->

# Hardening Report: goptics--vizb/v0.22.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **goptics--vizb/v0.22.0** was hardened automatically. 3 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### unpinned-uses (severity: high)

action.yml references actions/cache@v6 using a mutable version tag instead of a pinned 40-character commit SHA. This exposes the action to supply-chain attacks if the tag is moved or the upstream repository is compromised.

Locations:

- `action.yml:161`

### unpinned-uses (severity: high)

.github/actions/setup-embed-ui/action.yml references actions/cache@v6 using a mutable version tag instead of a pinned 40-character commit SHA.

Locations:

- `.github/actions/setup-embed-ui/action.yml:8`

### unpinned-uses (severity: high)

.github/actions/setup-js/action.yml references pnpm/action-setup@v6 and actions/setup-node@v6 using mutable version tags instead of pinned 40-character commit SHAs. Both are supply-chain risks.

Locations:

- `.github/actions/setup-js/action.yml:13`
- `.github/actions/setup-js/action.yml:16`

## Iteration Notes

### Iteration 1

**Fixes applied:** unpinned-uses

**Notes:**

Pinned all four unpinned action references to full 40-character commit SHAs: (1) actions/cache@v6 → @55cc8345863c7cc4c66a329aec7e433d2d1c52a9 in action.yml; (2) actions/cache@v6 → @55cc8345863c7cc4c66a329aec7e433d2d1c52a9 in .github/actions/setup-embed-ui/action.yml; (3) pnpm/action-setup@v6 → @0977fd99725f1db4007ccb2928dbb4e90d06cc86 in .github/actions/setup-js/action.yml; (4) actions/setup-node@v6 → @249970729cb0ef3589644e2896645e5dc5ba9c38 in .github/actions/setup-js/action.yml. Original version tags preserved as inline comments.

