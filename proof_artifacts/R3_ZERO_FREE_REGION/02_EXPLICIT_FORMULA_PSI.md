# Explicit Formula for ψ(x)

**Concept-Tag:** RH-R3-EXPLICIT-FORMULA-PSI

## Claim

For x not a prime power, ψ(x) = x − Σ_ρ (x^ρ / ρ) − log(2π) − ½log(1 − x⁻²), where the sum is over non-trivial zeros ρ of ζ(s).

## Inputs / Outputs

- **Input:** Chebyshev function ψ(x), zeros of ζ(s)
- **Output:** Explicit representation of ψ(x) in terms of zeros

## Dependencies

- Riemann's explicit formula
- Contour integration of −ζ′(s)/ζ(s)
- Residue calculus

## Debt Ledger

- [ ] Convergence conditions not detailed
- [ ] Truncation error not bounded
- [ ] Contour specification not given

## Non-Claims

- Does not bound the sum over zeros (that is Step 3)
- Formula is standard; no novel contribution claimed
