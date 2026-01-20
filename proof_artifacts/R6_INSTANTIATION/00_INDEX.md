# R6: Instantiation Record

**Concept-Tag:** RH-R6-INDEX

## Purpose

R6 binds a specific admissible E(t) source from R5 into the R4 transfer template.

This creates a concrete instantiation of the schematic R4 derivation with explicit source selection, threshold handling, and debt tracking.

## Contents

| File | Description |
|------|-------------|
| [R6_CONTRACT.md](R6_CONTRACT.md) | Instantiation policy |
| [R6_INSTANTIATION_RECORD.md](R6_INSTANTIATION_RECORD.md) | The binding record |
| [R6_WORKLIST.md](R6_WORKLIST.md) | Task tracking |
| [evidence/EVIDENCE.md](evidence/EVIDENCE.md) | Evidence pointer |

## Verification

```
./VERIFY_R6_INSTANTIATION.sh
```

## Non-Claims

- No RH claim
- No new analytic bounds
- Binding is a ledger artifact, not a proof
- Debt terms (constants, thresholds) remain explicit
