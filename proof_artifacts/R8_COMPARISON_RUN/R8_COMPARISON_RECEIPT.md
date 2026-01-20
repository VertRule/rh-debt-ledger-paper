# R8 Comparison Receipt

**Concept-Tag:** RH-R8-COMPARISON-RECEIPT

## Comparison Run Results

| Item | Value |
|------|-------|
| **Date** | 2026-01-19 |
| **Original file** | `proof_artifacts/R7_BOUND_STATEMENT/R7_EQUATION_INVENTORY.md` |
| **Regenerated file** | `proof_artifacts/R8_COMPARISON_RUN/R8_REGENERATED_INVENTORY.md` |
| **Generator** | `proof_artifacts/R8_COMPARISON_RUN/R8_GENERATOR.sh` |

## Hash Comparison

| Source | SHA-256 |
|--------|---------|
| **Original (R7)** | `9290d401bd2ad25f452e05808c5d939db1366f4a98fd7462fd77771c015fd9f0` |
| **Regenerated (R8)** | `9290d401bd2ad25f452e05808c5d939db1366f4a98fd7462fd77771c015fd9f0` |

## Result

**PASS** — Byte-identical output from two independent construction paths.

## Interpretation

The R7 equation inventory can be mechanically regenerated from its declared inputs:
- R4 transfer template (STEP-R4-04)
- R6 instantiation record (E(t) from U1/R5.1)
- R4 term receipts (Δ_pp, C_boundary, R_{t₀})

This confirms R7 is a faithful assembly, not a hallucinated extension.

## Non-Claims

- This comparison does not validate mathematical correctness
- This comparison does not verify the cited sources
- This comparison only confirms structural consistency
