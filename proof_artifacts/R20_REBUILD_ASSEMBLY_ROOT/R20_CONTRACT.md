# R20 Rebuild Assembly Root Contract

**Concept-Tag:** RH-R20-CONTRACT

## Preconditions

1. R9 input manifest and digests exist and are valid
2. All verifier scripts (R7-R10) exist
3. All R7 output files exist

## Invariants

1. Rebuild produces identical output on repeated runs (deterministic)
2. No timestamps or environment-dependent values in output
3. File ordering is LC_ALL=C sorted
4. Hash computation uses sha256

## Postconditions

1. outputs/R20_R10_ASSEMBLY_ROOT.rebuilt.txt contains regenerated assembly root
2. outputs/R20_R10_ASSEMBLY_ROOT.rebuilt.sha256 contains digest of rebuilt file
3. outputs/R20_compare_report.txt contains comparison result
4. If rebuilt root matches committed root: verification PASSES
5. If mismatch: verification FAILS with diff report

## Non-Claims

- No proof reproduction
- No RH claim
- This is an auditability mechanism only
