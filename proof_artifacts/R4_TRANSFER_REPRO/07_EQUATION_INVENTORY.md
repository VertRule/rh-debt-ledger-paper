# Equation Inventory

**Concept-Tag:** RH-R4-EQUATION-INVENTORY

## Scope

This inventory lists the canonical equations the packet asserts, for change detection only. It does not validate correctness.

## Inventory

### EQ1: Second Chebyshev Function

```math
\psi(x) := \sum_{n \leq x} \Lambda(n) = \sum_{p^k \leq x} \log p
```

### EQ2: First Chebyshev Function

```math
\theta(x) := \sum_{p \leq x} \log p
```

### EQ3: Prime-Power Remainder

```math
R_{pp}(x) := \psi(x) - \theta(x) = \sum_{k \geq 2} \sum_{p^k \leq x} \log p
```

### EQ4: Prime-Power Correction Term

```math
\Delta_{pp}(x) := \frac{R_{pp}(x)}{\log x}
```

### EQ5: Boundary Constant

```math
C_{\text{boundary}} := -1 + \frac{2}{\log 2}
```

### EQ6: Threshold Remainder Term

```math
R_{t_0}(x) := \int_2^{t_0} \frac{|\psi(t) - t|}{t (\log t)^2} \, dt + \frac{|\psi(t_0) - t_0|}{\log t_0}
```

### EQ7: Complete Transfer Bound Template

```math
|\pi(x) - \text{Li}(x)| \leq \frac{E(x)}{\log x} + \int_{t_0}^x \frac{E(t)}{t (\log t)^2} \, dt + |\Delta_{pp}(x)| + C_{\text{boundary}} + R_{t_0}(x)
```
