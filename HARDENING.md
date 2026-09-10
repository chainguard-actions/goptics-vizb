<!-- markdownlint-disable -->

# Hardening Report: goptics--vizb/v0.21.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **goptics--vizb/v0.21.0** was hardened automatically. 1 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### unpinned-uses (severity: high)

Multiple `uses:` references are pinned to mutable version tags instead of immutable 40-character commit SHAs, making the action vulnerable to supply-chain attacks if the tag is moved or the upstream action is compromised. Failing references: `actions/cache@v6` (action.yml), `actions/cache@v6` (.github/actions/setup-embed-ui/action.yml), `pnpm/action-setup@v6` (.github/actions/setup-js/action.yml), `actions/setup-node@v6` (.github/actions/setup-js/action.yml).

Locations:

- `action.yml:138`
- `.github/actions/setup-embed-ui/action.yml:8`
- `.github/actions/setup-js/action.yml:13`
- `.github/actions/setup-js/action.yml:16`

## Iteration Notes

### Iteration 1

**Fixes applied:** unpinned-uses

**Notes:**

Pinned all four unpinned `uses:` references to immutable commit SHAs:
- `actions/cache@v6` → `actions/cache@55cc8345863c7cc4c66a329aec7e433d2d1c52a9 # v6` in both `action.yml` and `.github/actions/setup-embed-ui/action.yml`
- `pnpm/action-setup@v6` → `pnpm/action-setup@0977fd99725f1db4007ccb2928dbb4e90d06cc86 # v6` in `.github/actions/setup-js/action.yml`
- `actions/setup-node@v6` → `actions/setup-node@249970729cb0ef3589644e2896645e5dc5ba9c38 # v6` in `.github/actions/setup-js/action.yml`

