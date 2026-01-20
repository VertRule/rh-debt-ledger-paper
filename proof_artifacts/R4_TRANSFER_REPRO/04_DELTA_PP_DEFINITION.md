# Prime-Power Correction Definition

**Concept-Tag:** RH-R4-DELTA-PP-DEFINITION

## Claim

Define the prime-power correction term Δ_pp(x) explicitly for the ψ→π−Li transfer in R4.

## Context

The second Chebyshev function ψ(x) counts prime powers with log p weights, while the prime counting function π(x) counts primes only. The transfer from a ψ-bound to a π−Li bound must account for higher prime powers (p², p³, ...).

## Construction

### Base Definitions

The von Mangoldt function:
```math
\Lambda(n) = \begin{cases} \log p & \text{if } n = p^k \text{ for prime } p \text{ and } k \geq 1 \\ 0 & \text{otherwise} \end{cases}
```

The Chebyshev functions:
```math
\psi(x) := \sum_{n \leq x} \Lambda(n) = \sum_{p^k \leq x} \log p
```

```math
\theta(x) := \sum_{p \leq x} \log p
```

### Prime-Power Remainder

Define the prime-power remainder:
```math
R_{pp}(x) := \psi(x) - \theta(x) = \sum_{k \geq 2} \sum_{p^k \leq x} \log p
```

This counts contributions from prime powers p^k with k ≥ 2.

### Correction Term for Transfer

In the ψ→π−Li transfer (see 02_PSI_TO_PI_MINUS_LI_BOUND.md), the prime-power correction term is:
```math
\Delta_{pp}(x) := \frac{R_{pp}(x)}{\log x}
```

This arises from the boundary term when applying partial summation to relate π(x) to ψ(x).

## Evidence

Citation anchor for Chebyshev function relations and prime-power treatment: see [evidence/EVIDENCE.md#id-r41](evidence/EVIDENCE.md#id-r41).

No new citations added by this receipt.

## NA0 Debt Ledger

| Item | Status |
|------|--------|
| Definition of Δ_pp(x) | **PAID** (this receipt) |
| Bound on Δ_pp(x) | **UNPAID** — requires O(√x) or similar estimate |
| Explicit enumeration of R_pp(x) | **UNPAID** — left symbolic |

## Result

Δ_pp(x) is now explicit and must appear as an explicit term in R4 transfer bounds.
