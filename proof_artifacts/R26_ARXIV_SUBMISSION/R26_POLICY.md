# R26 Submission Policy

**Concept-Tag:** RH-R26-POLICY

## arXiv Submission Strategy

### Category Selection

Primary: **math.NT** (Number Theory)

The paper discusses bounds on the prime counting function and the debt ledger
model for tracking proof obligations. This is squarely number theory.

Do NOT submit to:
- cs.AI (no AI content beyond tooling mentions)
- math.GM (General Mathematics is often a red flag for crankery)

### Moderator Risk Mitigation

The Riemann Hypothesis is a famous open problem. arXiv moderators are
understandably sensitive to submissions that:
- Claim to prove RH
- Claim "strong evidence" for RH
- Use vague or grandiose language

**Our mitigation:**

1. **Explicit non-claims** in abstract and introduction
2. **"Debt ledger" framing** emphasizes what is NOT proven
3. **"Tail bound unpaid"** statement is prominent
4. **No forward projection** about what results "suggest"

### What We ARE Publishing

- A verification infrastructure / governance model
- A reproducible artifact ladder (R4–R25)
- An honest accounting of paid vs. unpaid obligations
- A methodological paper, not a proof paper

### License

Recommend: **arXiv license** (perpetual, non-exclusive)
- Allows arXiv to distribute
- Author retains copyright
- Standard for math papers

## Source Bundle Contents

The arXiv source bundle contains ONLY:

```
main.tex
sections/01_introduction.tex
sections/02_problem_statement.tex
sections/03_ledger_model.tex
sections/04_verification_ladder.tex
sections/05_results_so_far.tex
sections/06_limits_and_obligations.tex
sections/07_reproducibility.tex
sections/08_conclusion.tex
bib.bib
```

No PDF, no proof_artifacts, no scripts. arXiv compiles its own PDF.

## Package Compatibility

Packages used that arXiv supports:
- amsmath, amssymb, amsthm (standard)
- hyperref (standard)
- graphicx, xcolor (standard)
- geometry (standard)
- tcolorbox (available on arXiv TeX Live)

If tcolorbox causes issues, the Non-Claims box can be reformatted using
a simple framed environment instead.
