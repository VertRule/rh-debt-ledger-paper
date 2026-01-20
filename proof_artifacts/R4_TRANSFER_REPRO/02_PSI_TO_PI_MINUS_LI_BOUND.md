# Transfer: ψ-Bound to π−Li Bound

**Concept-Tag:** RH-R4-PSI-TO-PI-LI

## Setup

**Input assumption**: There exists an error function E(t) such that:

```math
|\psi(t) - t| \leq E(t) \quad \text{for } t \geq t_0
```

**Goal**: Derive a bound form for |π(x) − Li(x)|.

---

## Derivation Steps

<!-- STEP-R4-01 -->
### STEP-R4-01: Relation Between π and ψ

Using partial summation (01_PARTIAL_SUMMATION.md), we have:

```math
\pi(x) = \frac{\psi(x)}{\log x} + \int_2^x \frac{\psi(t)}{t (\log t)^2} \, dt + \Delta_{pp}(x)
```

where Δ_pp(x) is the prime-power correction arising from ψ(x) − θ(x).

**Dependencies:** 01_PARTIAL_SUMMATION.md, DEF-R4-01

---

<!-- DEF-R4-01 -->
### DEF-R4-01: Prime-Power Correction

The prime-power correction term is defined explicitly in [04_DELTA_PP_DEFINITION.md](04_DELTA_PP_DEFINITION.md):

```math
R_{pp}(x) := \psi(x) - \theta(x) = \sum_{k \geq 2} \sum_{p^k \leq x} \log p
```

```math
\Delta_{pp}(x) := \frac{R_{pp}(x)}{\log x}
```

**Note:** Δ_pp(x) is now explicit but remains unbounded in this packet.

---

<!-- STEP-R4-02 -->
### STEP-R4-02: Expansion of Li(x)

The logarithmic integral satisfies:

```math
\text{Li}(x) = \frac{x}{\log x} + \int_2^x \frac{1}{(\log t)^2} \, dt + C_{\text{boundary}}
```

**Dependencies:** DEF-R4-02

---

<!-- DEF-R4-02 -->
### DEF-R4-02: Boundary Constant

The boundary terms at t=2 are made explicit in [05_BOUNDARY_TERMS_RECEIPT.md](05_BOUNDARY_TERMS_RECEIPT.md):

```math
C_{\text{boundary}} := -\frac{\psi(2)}{\log 2} + \frac{2}{\log 2} = -1 + \frac{2}{\log 2}
```

---

<!-- DEF-R4-03 -->
### DEF-R4-03: Threshold Remainder

The input bound E(t) may only hold for t ≥ t₀. The threshold requirements are made explicit in [06_THRESHOLD_REQUIREMENTS_RECEIPT.md](06_THRESHOLD_REQUIREMENTS_RECEIPT.md):

```math
R_{t_0}(x) := \int_2^{t_0} \frac{|\psi(t) - t|}{t (\log t)^2} \, dt + \frac{|\psi(t_0) - t_0|}{\log t_0}
```

This remainder absorbs below-threshold contributions.

---

<!-- STEP-R4-03 -->
### STEP-R4-03: Difference Bound (Symbolic)

Subtracting STEP-R4-02 from STEP-R4-01:

```math
\pi(x) - \text{Li}(x) = \frac{\psi(x) - x}{\log x} + \int_2^x \frac{\psi(t) - t}{t (\log t)^2} \, dt + \Delta_{pp}(x) + C_{\text{boundary}}
```

**Dependencies:** STEP-R4-01, STEP-R4-02, DEF-R4-01, DEF-R4-02

---

<!-- STEP-R4-04 -->
### STEP-R4-04: Apply Input Bound

Using |ψ(t) − t| ≤ E(t) for t ≥ t₀, and splitting the integral at t₀:

```math
|\pi(x) - \text{Li}(x)| \leq \frac{E(x)}{\log x} + \int_{t_0}^x \frac{E(t)}{t (\log t)^2} \, dt + |\Delta_{pp}(x)| + |C_{\text{boundary}}| + R_{t_0}(x)
```

**Dependencies:** STEP-R4-03, DEF-R4-01, DEF-R4-02, DEF-R4-03

---

## Final Bound

<!-- FINAL-BOUND -->
> **Transfer Result (STEP-R4-04)**: If |ψ(t) − t| ≤ E(t) for t ≥ t₀, then:
>
> ```math
> |\pi(x) - \text{Li}(x)| \leq \frac{E(x)}{\log x} + \int_{t_0}^x \frac{E(t)}{t (\log t)^2} \, dt + |\Delta_{pp}(x)| + |C_{\text{boundary}}| + R_{t_0}(x)
> ```

**Step Chain:** STEP-R4-01 → STEP-R4-02 → STEP-R4-03 → STEP-R4-04

**Definitions Used:** DEF-R4-01, DEF-R4-02, DEF-R4-03

---

## Debt

| Item | Status |
|------|--------|
| Definition of Δ_pp(x) | **PAID** — DEF-R4-01, see [04_DELTA_PP_DEFINITION.md](04_DELTA_PP_DEFINITION.md) |
| Bound on Δ_pp(x) | **UNPAID** — magnitude depends on θ(x^{1/2}) + θ(x^{1/3}) + ... |
| O(1) constant (C_boundary) | **PAID** — DEF-R4-02, see [05_BOUNDARY_TERMS_RECEIPT.md](05_BOUNDARY_TERMS_RECEIPT.md) |
| Threshold contract (structure) | **PAID** — DEF-R4-03, see [06_THRESHOLD_REQUIREMENTS_RECEIPT.md](06_THRESHOLD_REQUIREMENTS_RECEIPT.md) |
| Value of t₀ | **UNPAID** — depends on source of E(t) |
| Evaluation of R_{t₀}(x) | **UNPAID** — requires fixing t₀ |

## Non-Claims

This derivation establishes a transfer mechanism only. It does not:
- Assert any specific E(t)
- Claim RH or any zero-free region
- Provide numeric constants
