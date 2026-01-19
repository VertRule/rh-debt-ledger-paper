# Transfer to π(x) − Li(x)

**Concept-Tag:** RH-R3-TRANSFER-PI-LI

## Claim

TBD (debt): Given |ψ(x) − x| ≤ E(x), derive |π(x) − Li(x)| ≤ E′(x) via partial summation and standard ψ-to-π relations.

## Inputs / Outputs

- **Input:** ψ(x) bound E(x) (from Step 4)
- **Output:** π(x) − Li(x) bound E′(x)

## Dependencies

- ψ(x) bound (Step 4)
- Partial summation formula
- Relation: π(x) = ψ(x)/log x + ∫₂ˣ ψ(t)/(t log²t) dt + O(1)

## Debt Ledger

- [ ] Transfer formula not written explicitly
- [ ] Error propagation not quantified
- [ ] Li(x) approximation details not specified

## Non-Claims

- Transfer is standard; no novel contribution
- Final bound inherits all debts from earlier steps
