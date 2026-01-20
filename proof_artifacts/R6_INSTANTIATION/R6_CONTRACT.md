# R6 Instantiation Contract

**Concept-Tag:** RH-R6-INSTANTIATION-CONTRACT

## Claim

Bind a specific admissible E(t) source from R5_MENU.md to instantiate the R4 transfer template.

## Policy

No instantiation without:
- Source ID from R5_MENU.md
- Conditionality status (UNCONDITIONAL or CONDITIONAL)
- t₀ handling (explicit threshold or UNPAID)
- Constants handling (explicit values or UNPAID)
- Remainder terms explicit (Δ_pp, C_boundary, R_{t₀})

## Result

R4 is instantiated only through [R6_INSTANTIATION_RECORD.md](R6_INSTANTIATION_RECORD.md); otherwise R4 remains schematic.

## What This Does Not Do

- Does not prove RH
- Does not derive new bounds
- Does not pay THEOREM-class obligations
- Does not assert specific numeric values unless cited
