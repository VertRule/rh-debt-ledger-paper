# R5: Error-Bound Source Contract

**Concept-Tag:** RH-R5-INDEX

## Purpose

R5 is where the tail-bound source becomes an explicit external obligation.

To instantiate the R4 transfer derivation, we require an admissible bound E(t) such that |ψ(t)−t| ≤ E(t). This packet defines what "admissible" means and catalogs available sources.

## Contents

| File | Description |
|------|-------------|
| [R5_CONTRACT.md](R5_CONTRACT.md) | Admissibility predicates A1–A4 |
| [R5_MENU.md](R5_MENU.md) | Catalog of E(t) sources (unconditional vs conditional) |
| [R5_WORKLIST.md](R5_WORKLIST.md) | Task tracking |
| [evidence/EVIDENCE.md](evidence/EVIDENCE.md) | Citation ledger |

## Verification

```
./VERIFY_R5_ERROR_BOUND.sh
```

## Non-Claims

- No RH claim
- No zero-free region reproduction
- Sources are cited, not derived
- Dragon obligation (RH-level bound) remains EXTERNAL
