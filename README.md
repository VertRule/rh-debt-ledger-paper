# RH Debt Ledger Paper

![verify](https://github.com/VertRule/rh-debt-ledger-paper/actions/workflows/verify.yml/badge.svg)

**Latest release:** `r3-cited-complete` — view with `gh release view r3-cited-complete`

**Start here: [SUBMISSION.md](SUBMISSION.md)**

## How to Verify

Download the [R3 CITED Complete release](https://github.com/VertRule/rh-debt-ledger-paper/releases/tag/r3-cited-complete), extract, and run:

```
cd repo
VR_STRICT=1 ./VERIFY.sh
```

Expected output: `=== VERIFICATION PASSED ===`

**What this verifies:** R3 packet structure and integrity (17/17 tasks CITED with citation-only evidence). Does not verify mathematical claims — only governance compliance.

---

# Front Door: Submission & Verification

This repository contains the manuscript and **receipted exhibits** for the RH NA0 debt-ledger work.
It **does not** claim a proof of the Riemann Hypothesis.

## What this repo is

- A paper draft: `na0_rh_debt_ledger_draft.md`
- A small "exhibits" layer: `EXHIBITS.md` + `exhibits/canonical_run.json`
- A reproducibility contract: how to verify the canonical exhibit by digest

This repo intentionally excludes large run bundles and raw series data unless explicitly published elsewhere.

## Claim tiers

- **Definitions**: always allowed.
- **PROMOTED_FINITE**: certified on a finite domain/grid (mechanical verification).
- **PROMOTED_GLOBAL**: requires paying THEOREM-class obligations with an external proof artifact under policy.
  Default posture: **global promotion disabled**.

## Canonical exhibit

See `EXHIBITS.md` for the table, and `exhibits/canonical_run.json` for a compact pointer.

**Canonical run name:** (see `EXHIBITS.md`)
**Manifest digest:** (see `EXHIBITS.md`)
**Promotion tier:** PROMOTED_FINITE
**Dragon obligation status:** UNPAID (THEOREM)

## The Dragon Obligation (what remains unpaid)

No computational verification can pay this obligation.

The remaining blocker to global promotion is a THEOREM-class obligation asserting an unconditional tail bound sufficient to certify the RH-style envelope globally. Discharging this obligation requires an **external proof artifact** and is considered **equivalent in difficulty to proving RH itself**.

(For the precise object identity and current status, see `exhibits/canonical_run.json`.)

## How to verify integrity (digest-based)

This repo carries **pointers** rather than full run bundles. Verification is done by comparing the canonical exhibit's recorded digests to the corresponding artifacts in the source experiment repository that produced them.

Minimum expected verification items:
- A run directory containing `sha256_manifest.txt`
- A recorded digest of that manifest (as cited in `EXHIBITS.md` / `exhibits/canonical_run.json`)
- The run's `run_metrics.json` for key metrics (max_r_total, min_slack, a_max_allowed)
- The proof obligation object for the dragon obligation (PO-tail / ladder PO)

If you have access to the source experiment repo, verification is:
1) Locate the canonical run directory by name.
2) Compute `sha256` of `sha256_manifest.txt`.
3) Confirm it matches the manifest digest recorded in this paper repo.
4) Confirm `run_metrics.json` values match the exhibit pointer values.

## Where to start reading

1) `README.md` (short orientation)
2) `na0_rh_debt_ledger_draft.md` (the manuscript)
3) `EXHIBITS.md` (the evidence table)
4) `exhibits/canonical_run.json` (machine-readable exhibit pointer)
