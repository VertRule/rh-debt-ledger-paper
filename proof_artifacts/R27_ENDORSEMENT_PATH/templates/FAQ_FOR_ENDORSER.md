# FAQ for Potential Endorsers

## What am I endorsing?

You are endorsing the **author's appropriateness** to submit to the arXiv category (e.g., math.NT), not the correctness of any mathematical claims.

arXiv endorsement attests that:
- The submission appears topically appropriate
- The author appears to be a serious researcher
- The content is not spam or crankery

You are NOT attesting that:
- The mathematics is correct
- The results are novel or significant
- You agree with the approach

## Is this a proof of the Riemann Hypothesis?

**No.** The paper explicitly makes no proof claims.

This is a verification/reproducibility framework — a "debt ledger" that documents what computations have been performed and what remains unproven. The title and abstract state this clearly.

## Is this a claim to have verified RH to some new bound?

**No.** The paper does not claim to extend zero-verification bounds. It documents a framework for auditable, reproducible RH-related computations. Any numerical work is clearly scoped and does not claim to advance the state of the art.

## How do I verify this is serious work?

Three ways:

1. **Run the verification script:**
   ```bash
   git clone https://github.com/VertRule/rh-debt-ledger-paper
   cd rh-debt-ledger-paper
   VR_STRICT=1 ./VERIFY.sh
   ```
   This runs 24 verification checks and should report `24/24 PASS`.

2. **Inspect the verification ladder:**
   Browse `proof_artifacts/R01_*` through `R26_*`. Each rung documents a step with cryptographic receipts chaining to the next.

3. **Read the non-claims:**
   The paper's introduction explicitly lists what is NOT claimed. This is the opposite of crank behavior.

## What if I don't have time to review the paper?

You don't need to review the paper mathematically. Endorsement is about topical appropriateness and author seriousness, not peer review.

A quick check:
- Skim the abstract and introduction
- Run `VR_STRICT=1 ./VERIFY.sh` (takes ~1 minute)
- Note the explicit non-claims

## What if I'm not sure it fits the category?

The paper addresses:
- Riemann zeta function computations
- Verification frameworks for number-theoretic claims
- Deterministic reproducibility for mathematical software

This fits `math.NT` (Number Theory) or `math.NA` (Numerical Analysis). If you're an endorser for either, the paper is topically appropriate.

## What happens after I endorse?

1. The author completes the arXiv submission
2. arXiv staff perform a brief moderation check
3. The paper appears on arXiv (typically within 1–2 days)
4. Your name is NOT publicly associated with the endorsement

## Can I decline?

Absolutely. No explanation needed. The author has been instructed to accept silence or decline gracefully and not to follow up repeatedly.

## I have more questions

Contact the author directly via the email thread or repository contact information.
