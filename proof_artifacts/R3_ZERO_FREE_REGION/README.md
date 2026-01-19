# R3 Zero-Free Region Packet

**Concept-Tag:** RH-R3-PACKET-README

## Purpose

This packet decomposes the R3 rung (unconditional PNT error bound via zero-free region) into payable lemma obligations.

**What this packet is:**
- A structured debt ledger with explicit tasks
- A governance framework for tracking progress

**What this packet is not:**
- A proof of RH
- A claim of completion

## What counts as paying a task (DONE criteria)

A task moves from TODO to DONE when:
1. The debt item is resolved with explicit evidence
2. Evidence is recorded in the "Evidence/Receipt" column
3. No unstated assumptions are introduced

## Evidence/Receipt format

The Evidence/Receipt column must contain one of:
- A citation reference (e.g., "[Korobov 1958, Thm 2.1]")
- A file path to a derived computation (e.g., "derivations/c_value.md")
- A proof sketch reference (e.g., "sketches/convergence.md")

## Allowed evidence types

| Type | Description | Example |
|------|-------------|---------|
| Citation | Published result with theorem/page reference | [Davenport 2000, Ch. 17] |
| Derived constant | Explicit computation with all steps | derivations/t0_bound.md |
| Reproduced sketch | Self-contained proof outline | sketches/explicit_formula.md |

## Forbidden moves

- No "standard result" without a specific citation
- No constant without derivation or citation
- No unstated assumptions
- No appeals to "well-known" without reference
- No merging of debt items to hide unresolved work

## Example DONE row

```
| 01.1 | 01_ZERO_FREE_REGION_LEMMA | Effective value of c not specified | DONE | [Korobov 1958], c = 0.05 derived in derivations/c_korobov.md |
```
