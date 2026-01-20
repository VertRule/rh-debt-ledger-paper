# R5 Error-Bound Source Menu

**Concept-Tag:** RH-R5-ERROR-BOUND-MENU

## Purpose

This menu catalogs admissible E(t) sources for the R4 transfer derivation. Each entry documents what the source provides and what debt remains.

---

## UNCONDITIONAL SOURCES

Sources that do not assume RH or other unproved hypotheses.

### U1: Classical Zero-Free Region

| Field | Value |
|-------|-------|
| **Status** | UNCONDITIONAL |
| **Strength** | Weaker (subpolynomial improvement over trivial) |
| **Inputs** | None (follows from analytic continuation + zero-free region) |
| **Outputs** | E(t) of the form t·exp(−c(log t)^α) for some α < 1 and c > 0 |
| **Citation** | de la Vallée Poussin (1896); Korobov (1958); Vinogradov (1958) |
| **Debt** | Constants c, α not reproduced; t₀ threshold not fixed; full derivation EXTERNAL-CITED |

---

## CONDITIONAL SOURCES

Sources that assume RH or other unproved hypotheses.

### C1: Riemann Hypothesis

| Field | Value |
|-------|-------|
| **Status** | CONDITIONAL |
| **Strength** | Stronger (square-root barrier) |
| **Inputs** | Assume RH: all non-trivial zeros of ζ(s) have Re(s) = 1/2 |
| **Outputs** | E_RH(t) = O(√t log²t) |
| **Citation** | von Koch (1901); Schoenfeld (1976) for explicit constants |
| **Debt** | RH unproved; this source is the Dragon obligation |

---

## Instantiation Record Format

To instantiate R4 with a chosen source, create an instantiation record containing:

1. **Source ID**: Which menu item (e.g., U1, C1)
2. **A1 check**: Domain and t₀ value
3. **A2 check**: Regularity confirmation
4. **A3 check**: Constants listed explicitly
5. **A4 check**: Conditionality stated
6. **Resulting E(t)**: The specific form used

No instantiation record exists yet. R4 remains in scaffold state.
