# Paper Skeleton

**Concept-Tag:** RH-R23-PAPER-SKELETON

## Purpose

LaTeX skeleton for a paper documenting the RH debt ledger verification ladder.

## What This Paper Claims

1. We built a deterministic "debt ledger" pipeline for comparing $\pi(x)$ to approximations.
2. We built an auditable verification ladder (R4–R22) with reproducible releases.
3. The tail-bound obligation remains unpaid and is equivalent in difficulty to RH.

## What This Paper Does NOT Claim

- Not a proof of RH.
- Not a new bound on $\pi(x)$.
- Not verification of RH beyond known computational checks.
- Not evidence "suggesting" RH is true.

## Build

```bash
cd paper
pdflatex main.tex
bibtex main
pdflatex main.tex
pdflatex main.tex
```

## Structure

| File | Content |
|------|---------|
| main.tex | Master document |
| sections/01_introduction.tex | Motivation + Non-claims box |
| sections/02_problem_statement.tex | RH and counting primes |
| sections/03_ledger_model.tex | Debt ledger framing |
| sections/04_verification_ladder.tex | R4–R22 rungs |
| sections/05_results_so_far.tex | What we built |
| sections/06_limits_and_obligations.tex | Unpaid obligations |
| sections/07_reproducibility.tex | Deterministic builds |
| sections/08_conclusion.tex | Summary |
| bib.bib | References |
