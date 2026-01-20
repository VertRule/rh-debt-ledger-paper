# Threshold Requirements Receipt

**Concept-Tag:** RH-R4-THRESHOLD-REQUIREMENTS

## Claim

The transfer derivation is conditional on an input bound |ψ(t)−t| ≤ E(t) holding for all t in [t₀, x]; we record this threshold requirement explicitly.

## Context

Many analytic bounds in number theory are stated "for sufficiently large t" or "for t ≥ t₀". The transfer step must not silently extend such bounds below their valid range. This receipt makes the threshold requirement explicit.

## Construction

### Assumption Contract

**Assumption A(x):** For a given x ≥ t₀, the input bound |ψ(t) − t| ≤ E(t) holds for all t ∈ [t₀, x].

### Below-Threshold Treatment

The interval [2, t₀) is not covered by Assumption A(x). We introduce an explicit remainder term:

```math
R_{t_0}(x) := \int_2^{t_0} \frac{|\psi(t) - t|}{t (\log t)^2} \, dt + \frac{|\psi(t_0) - t_0|}{\log t_0}
```

This remainder absorbs all contributions from below the threshold and is carried symbolically until t₀ is fixed.

### Complete Bound Template

The full transfer bound becomes:

```math
|\pi(x) - \text{Li}(x)| \leq \frac{E(x)}{\log x} + \int_{t_0}^x \frac{E(t)}{t (\log t)^2} \, dt + |\Delta_{pp}(x)| + C_{\text{boundary}} + R_{t_0}(x)
```

where:
- First two terms: contribution from the assumed bound over [t₀, x]
- Δ_pp(x): prime-power correction (see 04_DELTA_PP_DEFINITION.md)
- C_boundary: boundary terms at t=2 (see 05_BOUNDARY_TERMS_RECEIPT.md)
- R_{t₀}(x): below-threshold remainder (this receipt)

## Evidence

No new citations required. The threshold contract follows standard practice in analytic number theory.

## NA0 Debt Ledger

| Item | Status |
|------|--------|
| Threshold contract (structure) | **PAID** (this receipt) |
| Value of t₀ | **UNPAID** — depends on source of E(t) |
| Evaluation of R_{t₀}(x) | **UNPAID** — requires fixing t₀ |

## Result

All R4 bounds are explicitly conditional on A(x); below-threshold contributions are carried as R_{t₀}(x).
