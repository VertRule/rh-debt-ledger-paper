# R3 Zero-Free Region Contract

**Concept-Tag:** RH-R3-ZERO-FREE-REGION

## Claim

For sufficiently large x, the prime counting function satisfies:

```
|π(x) - Li(x)| ≤ x · exp(-c · (log x)^α)
```

where α and c are effective constants derived from the zero-free region, not assumed.

This is an unconditional bound weaker than RH (which would give O(x^(1/2+ε))).

Operationally we bound |ψ(x) − x| using the explicit formula under a zero-free region, then transfer to π(x) − Li(x) by partial summation / standard ψ-to-π relations.

## Dependencies

1. **de la Vallée Poussin (1896)**: Classical zero-free region of form σ > 1 - c/log(|t|+2)
2. **Korobov-Vinogradov**: Improved zero-free region σ > 1 - c/(log |t|)^(2/3)(log log |t|)^(1/3)
3. **Explicit formula**: Connection between zeros of ζ(s) and π(x)
4. **Contour integration**: Standard analytic number theory machinery

## Proof Plan

| Step | Input | Output | Source | Artifact |
|------|-------|--------|--------|----------|
| 1 | Zero-free region statement | Region R where ζ(s) ≠ 0 | Korobov-Vinogradov | [01_ZERO_FREE_REGION_LEMMA](R3_ZERO_FREE_REGION/01_ZERO_FREE_REGION_LEMMA.md) |
| 2 | Explicit formula for ψ(x) | Sum over zeros + error | Standard ANT | [02_EXPLICIT_FORMULA_PSI](R3_ZERO_FREE_REGION/02_EXPLICIT_FORMULA_PSI.md) |
| 3 | Region R | Bound on real parts of zeros | Step 1 | [03_ZERO_SUM_BOUND](R3_ZERO_FREE_REGION/03_ZERO_SUM_BOUND.md) |
| 4 | Zero bounds + explicit formula | Bound on |ψ(x) - x| | Steps 2-3 | [04_PSI_BOUND](R3_ZERO_FREE_REGION/04_PSI_BOUND.md) |
| 5 | ψ(x) bound | π(x) − Li(x) bound via partial summation | Standard | [05_TRANSFER_TO_PI_MINUS_LI](R3_ZERO_FREE_REGION/05_TRANSFER_TO_PI_MINUS_LI.md) |

## Debt Ledger

- [ ] Effective constants not yet computed
- [ ] Contour choice not specified
- [ ] Error term in explicit formula not bounded
- [ ] Transition from ψ(x) to π(x) not detailed
- [ ] Range of validity ("sufficiently large x") not quantified

## Non-Claims

- This is **not** RH
- This is **not** an RH-equivalent bound
- No hidden assumptions beyond standard analytic number theory
- No novel zero-free region claimed
- Constants are placeholders until derived
