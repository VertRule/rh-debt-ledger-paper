# R7 Equation Inventory

**Concept-Tag:** RH-R7-EQUATION-INVENTORY

## Scope

This inventory lists the canonical equations in the R7 instantiated bound statement, for change detection only. It does not validate correctness.

## Inventory

### EQ-R7-1: Main Bound

```math
|\pi(x) - \text{Li}(x)| \leq \frac{E(x)}{\log x} + \int_{t_0}^x \frac{E(t)}{t (\log t)^2} \, dt + |\Delta_{pp}(x)| + |C_{\text{boundary}}| + R_{t_0}(x)
```

### EQ-R7-2: Error Bound E(t)

```math
E(t) = O\left(t \cdot \exp\left(-c(\log t)^{3/5}(\log \log t)^{-1/5}\right)\right)
```

### EQ-R7-3: Prime-Power Correction

```math
\Delta_{pp}(x) := \frac{R_{pp}(x)}{\log x} = \frac{\psi(x) - \theta(x)}{\log x}
```

### EQ-R7-4: Prime-Power Remainder

```math
R_{pp}(x) = \sum_{k \geq 2} \sum_{p^k \leq x} \log p
```

### EQ-R7-5: Boundary Constant

```math
C_{\text{boundary}} := -1 + \frac{2}{\log 2}
```

### EQ-R7-6: Threshold Remainder

```math
R_{t_0}(x) := \int_2^{t_0} \frac{|\psi(t) - t|}{t (\log t)^2} \, dt + \frac{|\psi(t_0) - t_0|}{\log t_0}
```
