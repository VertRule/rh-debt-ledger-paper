# One-Page Pitch: RH Debt-Ledger Framework

## What It Is

A **deterministic debt-ledger** and **verification ladder** for Riemann Hypothesis computations.

The framework provides:
- Auditable proof artifacts with cryptographic receipts
- Reproducible builds (bit-for-bit identical outputs)
- A structured "debt" accounting of what remains unproven
- Step-by-step verification rungs, each building on the last

## What It Is NOT

- **Not a proof of RH** — we make no such claim
- **Not a new zero-verification bound** — we do not extend Platt or others
- **Not an RH verification claim** — the paper documents a framework, not a result
- **Not speculative mathematics** — no unproven conjectures are assumed

## Why This Matters

RH-related computations have a reproducibility problem:
- Results depend on specific software versions and environments
- Verification steps are often implicit or undocumented
- Claims are difficult to audit independently

This framework addresses these issues by making every step:
- Deterministic (same inputs → same outputs)
- Auditable (cryptographic receipts chain together)
- Reproducible (verification script runs anywhere)

## How to Verify

```bash
git clone https://github.com/VertRule/rh-debt-ledger-paper
cd rh-debt-ledger-paper
VR_STRICT=1 ./VERIFY.sh
```

Expected output: `24/24 PASS`

## Repository Structure

- `paper/` — LaTeX source and compiled PDF
- `proof_artifacts/` — Verification ladder (R1–R26+)
- `scripts/` — Deterministic build and verification tools
- `VERIFY.sh` — Single-command verification

## Why Endorse

Endorsement criteria:
- **Topicality**: Squarely in number theory / numerical analysis
- **Seriousness**: 24-rung verification ladder, deterministic builds
- **Auditability**: Every claim is machine-verifiable
- **Non-crankery**: Explicit non-claims, no proof assertions

Endorsement does NOT mean you agree with the approach or vouch for correctness — only that the submission is appropriate for the category.

## Contact

- Repository: https://github.com/VertRule/rh-debt-ledger-paper
- Release: r26-arxiv-submission-kit
