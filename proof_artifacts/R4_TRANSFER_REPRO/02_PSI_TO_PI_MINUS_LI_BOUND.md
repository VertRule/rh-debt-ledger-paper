# Transfer: ψ-Bound to π−Li Bound

**Concept-Tag:** RH-R4-PSI-TO-PI-LI

## Setup

**Input assumption**: There exists an error function E(t) such that:

```math
|\psi(t) - t| \leq E(t) \quad \text{for } t \geq t_0
```

**Goal**: Derive a bound form for |π(x) − Li(x)|.

## Step 1: Relation Between π and ψ

Using partial summation (01_PARTIAL_SUMMATION.md), we have:

```math
\pi(x) = \frac{\psi(x)}{\log x} + \int_2^x \frac{\psi(t)}{t (\log t)^2} \, dt + \Delta_{pp}(x)
```

where Δ_pp(x) is the prime-power correction arising from ψ(x) − θ(x).

### Prime-Power Correction (Explicit Definition)

The prime-power correction term is defined explicitly in [04_DELTA_PP_DEFINITION.md](04_DELTA_PP_DEFINITION.md):

```math
R_{pp}(x) := \psi(x) - \theta(x) = \sum_{k \geq 2} \sum_{p^k \leq x} \log p
```

```math
\Delta_{pp}(x) := \frac{R_{pp}(x)}{\log x}
```

**Note:** Δ_pp(x) is now explicit but remains unbounded in this packet. Bounding it requires estimating contributions from prime powers p², p³, ... (debt item below).

## Step 2: Comparison with Li(x)

The logarithmic integral satisfies:

```math
\text{Li}(x) = \frac{x}{\log x} + \int_2^x \frac{t}{t (\log t)^2} \, dt + O(1)
```

### Boundary Terms (t=2)

The boundary terms at t=2 are made explicit in [05_BOUNDARY_TERMS_RECEIPT.md](05_BOUNDARY_TERMS_RECEIPT.md):

```math
C_{\text{boundary}} := -\frac{\psi(2)}{\log 2} + \frac{2}{\log 2} = -1 + \frac{2}{\log 2}
```

This replaces the "O(1)" with an explicit constant (kept symbolic).

## Step 3: Difference Bound

Subtracting:

```math
\pi(x) - \text{Li}(x) = \frac{\psi(x) - x}{\log x} + \int_2^x \frac{\psi(t) - t}{t (\log t)^2} \, dt + \Delta_{pp}(x) + O(1)
```

## Step 4: Apply Input Bound

Using |ψ(t) − t| ≤ E(t):

```math
|\pi(x) - \text{Li}(x)| \leq \frac{E(x)}{\log x} + \int_2^x \frac{E(t)}{t (\log t)^2} \, dt + |\Delta_{pp}(x)| + O(1)
```

## Bound Form (No Constants)

> **Transfer Result**: If |ψ(t) − t| ≤ E(t), then:
>
> |π(x) − Li(x)| ≤ (boundary term in E) + (integral of E against kernel) + (prime-power correction) + (lower-order terms)

The specific form of the kernel is 1/(t (log t)²), inherited from partial summation with f(t) = 1/log(t).

## Debt

| Item | Status |
|------|--------|
| Definition of Δ_pp(x) | **PAID** — see [04_DELTA_PP_DEFINITION.md](04_DELTA_PP_DEFINITION.md) |
| Bound on Δ_pp(x) | **UNPAID** — magnitude depends on θ(x^{1/2}) + θ(x^{1/3}) + ... |
| O(1) constant (C_boundary) | **PAID** — see [05_BOUNDARY_TERMS_RECEIPT.md](05_BOUNDARY_TERMS_RECEIPT.md) |
| Threshold t_0 | **UNPAID** — input bound E(t) may only hold for t ≥ t_0 |

## Non-Claims

This derivation establishes a transfer mechanism only. It does not:
- Assert any specific E(t)
- Claim RH or any zero-free region
- Provide numeric constants
