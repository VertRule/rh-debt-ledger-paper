# Partial Summation Identity

**Concept-Tag:** RH-R4-PARTIAL-SUMMATION

## Statement

Let A(t) be a step function with jumps at points t_n, and let f(t) be continuously differentiable on [a,b]. Then:

```math
\sum_{a < t_n \leq b} f(t_n) \cdot (\text{jump at } t_n) = A(b)f(b) - A(a)f(a) - \int_a^b A(t) f'(t) \, dt
```

## Stieltjes Form

Equivalently, in Stieltjes notation:

```math
\int_a^b f(t) \, dA(t) = f(b)A(b) - f(a)A(a) - \int_a^b A(t) \, df(t)
```

where the left side is the Stieltjes integral and the right side uses integration by parts.

## Application to Prime Counting

Setting A(t) = π(t) (prime counting function) and f(t) = 1/log(t):

```math
\sum_{p \leq x} \frac{1}{\log p} = \frac{\pi(x)}{\log x} - \frac{\pi(2)}{\log 2} + \int_2^x \frac{\pi(t)}{t (\log t)^2} \, dt
```

Similarly, with A(t) = ψ(t) or A(t) = θ(t), one obtains transfer identities between ψ, θ, π, and their integral representations.

## Transfer Template

> **Template**: To transfer a bound on A(t) to a bound on Σf(t_n), apply partial summation. The error in the sum is controlled by:
> - The boundary terms A(b)f(b) and A(a)f(a)
> - The integral ∫|A(t)−(comparison)| · |f'(t)| dt

This template is used in 02_PSI_TO_PI_MINUS_LI_BOUND.md to convert a ψ-bound into a π−Li bound.
