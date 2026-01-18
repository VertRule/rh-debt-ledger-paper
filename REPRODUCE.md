# Reproduction Guide

This document describes how to verify the canonical exhibit against the source experiment repository.

## Prerequisites

1. Local clone of the experiment repository at:
   ```
   ../experiments/rh_debt_ledger
   ```
   (Relative to the VertRule root, i.e., sibling to `papers/`)

2. The canonical run must exist in:
   ```
   experiments/rh_debt_ledger/paper_runs/<RUN_NAME>/run/
   ```

## Canonical Run Details

- **Run name:** `2026-01-17_dragon_boop_v1_x1000_step100_T50`
- **Expected manifest digest:** `8b53653351f1625d3d2a59fae00b9c9b41a37ab9df3e9ad7a27de974945ef729`
- **Promotion tier:** `PROMOTED_FINITE`
- **Dragon status:** `UNPAID`

See `exhibits/canonical_run.json` for the machine-readable pointer.

## Re-run Canonical (from experiment repo)

To reproduce the canonical run from scratch:

```sh
cd experiments/rh_debt_ledger

cargo build --release

./target/release/vr-rh-debt-ledger run \
  --x-max 1000 \
  --x-step 100 \
  --t-max 50.0 \
  --zeros fixtures/zeros_small.csv \
  --tail-bound-policy user-constants \
  --tail-constants fixtures/tail_constants_pass.json \
  --global-claim envelope-rh-style \
  --out /tmp/repro_run
```

Then freeze the run:

```sh
./target/release/vr-freeze-paper-run \
  --src /tmp/repro_run \
  --name "2026-01-17_dragon_boop_v1_x1000_step100_T50" \
  --dest paper_runs
```

## Verify Digest

Compute the SHA-256 of the manifest file:

```sh
shasum -a 256 experiments/rh_debt_ledger/paper_runs/2026-01-17_dragon_boop_v1_x1000_step100_T50/run/sha256_manifest.txt
```

**Expected output:**
```
8b53653351f1625d3d2a59fae00b9c9b41a37ab9df3e9ad7a27de974945ef729  .../sha256_manifest.txt
```

## Automated Verification

From the paper repo root:

```sh
./VERIFY_EXHIBIT.sh
```

This script reads `exhibits/canonical_run.json`, locates the run in the experiment repo, and compares digests automatically.

## Expected Result

- Digest matches: `PASS`
- Run not found (experiment repo missing): `SKIP`
- Digest mismatch: `FAIL`
