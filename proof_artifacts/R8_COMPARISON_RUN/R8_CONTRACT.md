# R8 Comparison Run Contract

**Concept-Tag:** RH-R8-COMPARISON-CONTRACT

## Claim

The R7 bound statement can be mechanically regenerated from its declared inputs (R4 template + R6 instantiation) producing byte-identical equation inventory.

## Policy

1. **Generator script** (`R8_GENERATOR.sh`) extracts equations from:
   - R4: `02_PSI_TO_PI_MINUS_LI_BOUND.md` (transfer template)
   - R6: `R6_INSTANTIATION_RECORD.md` (source binding)
   - R4 term receipts: `04_DELTA_PP_DEFINITION.md`, `05_BOUNDARY_TERMS_RECEIPT.md`, `06_THRESHOLD_REQUIREMENTS_RECEIPT.md`

2. **Comparison receipt** records:
   - Hash of R7 equation inventory (original)
   - Hash of regenerated equation inventory
   - PASS if identical, FAIL otherwise

3. **Verification** checks the receipt shows PASS.

## Result

If the comparison passes, R7 is confirmed to be a faithful assembly of its declared inputs, not a hallucinated extension.

## What This Does Not Do

- Does not prove correctness of the mathematics
- Does not validate the cited sources
- Does not pay any debt items
