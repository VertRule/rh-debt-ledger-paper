# Boundary Terms Receipt

**Concept-Tag:** RH-R4-BOUNDARY-TERMS

## Claim

Identify and explicitly account for the boundary terms arising from partial summation at the lower limit t=2 in the ψ→π−Li transfer.

## Context

Partial summation (Abel summation) applied to a sum Σf(n) produces an integral plus boundary contributions at the limits. In the ψ→π−Li transfer, the lower limit t=2 contributes terms that were previously absorbed into "O(1)".

## Construction

### Partial Summation Form

For a step function A(t) and smooth function f(t), partial summation gives:

```math
\sum_{2 < n \leq x} f(n) \cdot a_n = A(x)f(x) - A(2)f(2) - \int_2^x A(t) f'(t) \, dt
```

where a_n is the jump of A at n.

### Boundary Term at t=2

In the ψ→π−Li transfer with A(t) = ψ(t) and f(t) = 1/log(t), the lower boundary term is:

```math
B_{\text{lower}} := -\frac{\psi(2)}{\log 2}
```

Since ψ(2) = log 2 (the only prime power ≤ 2 is 2 itself):

```math
B_{\text{lower}} = -\frac{\log 2}{\log 2} = -1
```

### Li(x) Boundary

For Li(x) = ∫₂ˣ dt/log(t), the comparison at t=2 contributes:

```math
C_{\text{Li,lower}} := -\frac{2}{\log 2}
```

### Combined Boundary Constant

The net boundary contribution in the difference π(x) − Li(x) is:

```math
C_{\text{boundary}} := B_{\text{lower}} - C_{\text{Li,lower}} = -1 + \frac{2}{\log 2}
```

This is a fixed constant (approximately 1.885) but we keep it in symbolic form.

## Evidence

Citation anchor for partial summation: see [evidence/EVIDENCE.md#id-r43](evidence/EVIDENCE.md#id-r43).

No new citations added by this receipt.

## NA0 Debt Ledger

| Item | Status |
|------|--------|
| Boundary terms at t=2 | **PAID** (this receipt) |
| Numeric evaluation of C_boundary | **UNPAID** — left symbolic |
| Threshold t₀ requirements | **UNPAID** — separate item (R4.5) |

## Result

Replace "O(1) constant UNPAID" with an explicit boundary term reference. The O(1) is now C_boundary as defined above.
