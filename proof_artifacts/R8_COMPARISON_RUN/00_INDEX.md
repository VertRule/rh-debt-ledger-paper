# R8: Comparison Run

**Concept-Tag:** RH-R8-INDEX

## Purpose

R8 provides a second construction path for the R7 bound statement and verifies byte-identical output. This guards against hallucinated extensions by ensuring the bound can be mechanically regenerated from its declared inputs.

## Principle

> "Two independent constructions producing identical output is stronger evidence than one construction alone."

## Contents

| File | Description |
|------|-------------|
| [R8_CONTRACT.md](R8_CONTRACT.md) | Comparison run policy |
| [R8_GENERATOR.sh](R8_GENERATOR.sh) | Script that regenerates bound from R4+R6 |
| [R8_COMPARISON_RECEIPT.md](R8_COMPARISON_RECEIPT.md) | Proof of byte-identical output |
| [R8_WORKLIST.md](R8_WORKLIST.md) | Task tracking |

## Verification

```
./VERIFY_R8_COMPARISON.sh
```

## Non-Claims

- No RH claim
- No new analytic bounds
- This is a mechanical consistency check, not a proof
