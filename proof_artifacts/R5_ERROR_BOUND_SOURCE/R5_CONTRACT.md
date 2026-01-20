# R5 Error-Bound Source Contract

**Concept-Tag:** RH-R5-ERROR-BOUND-CONTRACT

## Claim

To instantiate the R4 transfer derivation, we require an admissible bound E(t) such that:

```math
|\psi(t) - t| \leq E(t) \quad \text{for all } t \in [t_0, x]
```

## Admissibility Predicates

An E(t) source is admissible if and only if it satisfies all of:

| Predicate | Requirement |
|-----------|-------------|
| **A1** | **Domain:** E(t) is defined for all t ≥ t₀ where t₀ is explicit in the source |
| **A2** | **Regularity:** E(t) is monotone non-decreasing and continuous, sufficient to support the integral ∫ E(t)/(t(log t)²) dt appearing in R4 |
| **A3** | **Explicit dependence:** All constants and thresholds in E(t) are stated explicitly in the source (no hidden O(1) terms) |
| **A4** | **Conditionality flag:** Whether E(t) is conditional (assumes RH or other unproved hypothesis) or unconditional is explicitly stated |

## Policy

No tail bound enters R4 unless it passes A1–A4 and is cited in [R5_MENU.md](R5_MENU.md); otherwise it stays UNPAID.

## Debt Ledger

| Obligation | Status |
|------------|--------|
| Dragon: E_RH(t) = O(√t log²t) | **EXTERNAL** — requires RH proof |
| Unconditional: E_ZFR(t) from classical zero-free region | **EXTERNAL-CITED** — until reproduced in-repo |

## Result

R4 becomes instantiated only via a chosen E(t) source recorded in [R5_MENU.md](R5_MENU.md) with an instantiation record documenting which menu item was selected and how A1–A4 are satisfied.
