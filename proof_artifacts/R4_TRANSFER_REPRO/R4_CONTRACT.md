# R4 Transfer Contract

**Concept-Tag:** RH-R4-TRANSFER-CONTRACT

## Claim

Given an explicit bound on |ψ(x)−x|, derive a bound form for |π(x)−Li(x)|.

## Assumptions

The following are assumed without proof in this packet:

1. **Stieltjes integral existence**: For functions of bounded variation on compact intervals, the Stieltjes integral ∫f dg exists and standard integration-by-parts applies.

2. **Standard prime-counting relations**: The functions π(x), θ(x), ψ(x) satisfy:
   - θ(x) = Σ_{p≤x} log p
   - ψ(x) = Σ_{p^k≤x} log p = θ(x) + θ(x^{1/2}) + θ(x^{1/3}) + ...
   - π(x) counts primes p ≤ x

3. **Prime-power correction**: The difference ψ(x) − θ(x) is denoted Δ_pp(x) and treated as an explicit correction term. Its magnitude is NOT assumed bounded here; this is recorded as debt.

4. **Li(x) definition**: Li(x) = ∫_2^x dt/log(t), the logarithmic integral.

## Construction Outline

1. **Partial summation** (01_PARTIAL_SUMMATION.md): Establish the Stieltjes form relating sums over primes to integrals against step functions.

2. **Transfer** (02_PSI_TO_PI_MINUS_LI_BOUND.md): Starting from a bound |ψ(t)−t| ≤ E(t), derive via partial summation an integral expression for π(x)−Li(x), plus the correction Δ_pp(x)/log(x).

## Debt Ledger

| Item | Status | Notes |
|------|--------|-------|
| Bound on Δ_pp(x) | UNPAID | Prime-power correction magnitude not bounded here |
| Smoothing remainder | UNPAID | If smoothing is introduced, remainder terms need explicit treatment |
| Constants in transfer | UNPAID | No numeric constants are asserted; transfer is in bound-form only |

## Non-Claims

- This packet does NOT claim RH.
- This packet does NOT assert any zero-free region.
- This packet does NOT provide numeric values for constants.
- This packet reproduces a transfer mechanism; it does not prove the input bound.
