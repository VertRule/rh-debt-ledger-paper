# R3 Zero-Free Region Contract

**Concept-Tag:** RH-R3-ZERO-FREE-REGION

## Claim

For sufficiently large x, the prime counting function satisfies:

```
|π(x) - li(x)| ≤ x · exp(-c · (log x)^α)
```

where α and c are effective constants derived from the zero-free region, not assumed.

This is an unconditional bound weaker than RH (which would give O(x^(1/2+ε))).

## Dependencies

1. **de la Vallée Poussin (1896)**: Classical zero-free region of form σ > 1 - c/log(|t|+2)
2. **Korobov-Vinogradov**: Improved zero-free region σ > 1 - c/(log |t|)^(2/3)(log log |t|)^(1/3)
3. **Explicit formula**: Connection between zeros of ζ(s) and π(x)
4. **Contour integration**: Standard analytic number theory machinery

## Proof Plan

| Step | Input | Output | Source |
|------|-------|--------|--------|
| 1 | Zero-free region statement | Region R where ζ(s) ≠ 0 | Korobov-Vinogradov |
| 2 | Explicit formula for ψ(x) | Sum over zeros + error | Standard ANT |
| 3 | Region R | Bound on real parts of zeros | Step 1 |
| 4 | Zero bounds + explicit formula | Bound on |ψ(x) - x| | Steps 2-3 |
| 5 | ψ(x) bound | π(x) bound via partial summation | Standard |

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
