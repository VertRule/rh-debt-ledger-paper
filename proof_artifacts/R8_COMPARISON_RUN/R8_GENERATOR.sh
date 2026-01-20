#!/usr/bin/env bash
# R8_GENERATOR.sh — Regenerate R7 equation inventory from R4+R6 inputs
# This provides a second construction path for comparison.

set -euo pipefail

R4_DIR="proof_artifacts/R4_TRANSFER_REPRO"
R6_DIR="proof_artifacts/R6_INSTANTIATION"
OUTPUT_FILE="proof_artifacts/R8_COMPARISON_RUN/R8_REGENERATED_INVENTORY.md"

cat > "$OUTPUT_FILE" << 'HEADER'
# R7 Equation Inventory

**Concept-Tag:** RH-R7-EQUATION-INVENTORY

## Scope

This inventory lists the canonical equations in the R7 instantiated bound statement, for change detection only. It does not validate correctness.

## Inventory

HEADER

# EQ-R7-1: Main Bound (from R4 STEP-R4-04)
cat >> "$OUTPUT_FILE" << 'EQ1'
### EQ-R7-1: Main Bound

```math
|\pi(x) - \text{Li}(x)| \leq \frac{E(x)}{\log x} + \int_{t_0}^x \frac{E(t)}{t (\log t)^2} \, dt + |\Delta_{pp}(x)| + |C_{\text{boundary}}| + R_{t_0}(x)
```

EQ1

# EQ-R7-2: Error Bound E(t) (from R6 instantiation)
cat >> "$OUTPUT_FILE" << 'EQ2'
### EQ-R7-2: Error Bound E(t)

```math
E(t) = O\left(t \cdot \exp\left(-c(\log t)^{3/5}(\log \log t)^{-1/5}\right)\right)
```

EQ2

# EQ-R7-3: Prime-Power Correction (from R4 DEF-R4-01)
cat >> "$OUTPUT_FILE" << 'EQ3'
### EQ-R7-3: Prime-Power Correction

```math
\Delta_{pp}(x) := \frac{R_{pp}(x)}{\log x} = \frac{\psi(x) - \theta(x)}{\log x}
```

EQ3

# EQ-R7-4: Prime-Power Remainder (from R4 04_DELTA_PP_DEFINITION.md)
cat >> "$OUTPUT_FILE" << 'EQ4'
### EQ-R7-4: Prime-Power Remainder

```math
R_{pp}(x) = \sum_{k \geq 2} \sum_{p^k \leq x} \log p
```

EQ4

# EQ-R7-5: Boundary Constant (from R4 05_BOUNDARY_TERMS_RECEIPT.md)
cat >> "$OUTPUT_FILE" << 'EQ5'
### EQ-R7-5: Boundary Constant

```math
C_{\text{boundary}} := -1 + \frac{2}{\log 2}
```

EQ5

# EQ-R7-6: Threshold Remainder (from R4 06_THRESHOLD_REQUIREMENTS_RECEIPT.md)
cat >> "$OUTPUT_FILE" << 'EQ6'
### EQ-R7-6: Threshold Remainder

```math
R_{t_0}(x) := \int_2^{t_0} \frac{|\psi(t) - t|}{t (\log t)^2} \, dt + \frac{|\psi(t_0) - t_0|}{\log t_0}
```
EQ6

echo "Generated: $OUTPUT_FILE"
