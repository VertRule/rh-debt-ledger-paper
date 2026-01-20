# arXiv Submission Checklist

**Concept-Tag:** RH-R26-SUBMISSION-CHECKLIST

## Pre-Submission Verification

- [ ] Run `VR_STRICT=1 ./VERIFY.sh` — must be 24/24 PASS
- [ ] Run `./scripts/build_arxiv_source_bundle.sh /tmp/arxiv_source.zip`
- [ ] Verify determinism: run twice, compare SHA-256
- [ ] Check SOURCE_BUNDLE_MANIFEST.txt matches expected files

## Paper Content Review

- [ ] Title is accurate: "A Debt Ledger Model for Tracking Proof Obligations..."
- [ ] Author is correct: David Ingle, VertRule Inc.
- [ ] Date is fixed: January 2026
- [ ] Abstract contains explicit non-claims statement
- [ ] Introduction contains Non-Claims box
- [ ] "Tail bound unpaid" statement is present
- [ ] No "evidence suggests RH" or similar language
- [ ] References compile correctly

## arXiv Submission Fields

| Field | Value |
|-------|-------|
| Primary category | math.NT (Number Theory) |
| Cross-list | None (do not cross-list to cs.AI or math.GM) |
| License | arXiv license (perpetual, non-exclusive) |
| Comments | "Verification ladder and artifact chain; no RH claim" |

## Moderator Risk Awareness

arXiv moderators are sensitive to RH-related submissions. Our paper is
designed to pass moderation by:

1. **Explicit non-claims**: Abstract and introduction state clearly this
   is NOT a proof of RH.

2. **Debt framing**: The "unpaid obligation" language makes clear that
   the hard part is not done.

3. **Methodological focus**: We are publishing a verification infrastructure,
   not a proof.

4. **No grandiose claims**: No "this suggests RH is true" or "strong evidence".

5. **Reproducibility**: The artifact ladder is verifiable by anyone.

## Post-Submission

- [ ] arXiv compiles PDF successfully
- [ ] Review compiled PDF for formatting issues
- [ ] Confirm Non-Claims box renders correctly
- [ ] Confirm bibliography appears
- [ ] Note arXiv identifier for future reference

## If Held for Moderation

If the paper is held:
1. Do NOT argue that RH is proven (it isn't claimed)
2. Emphasize the methodological/infrastructure nature
3. Point to the explicit non-claims in abstract
4. Offer to clarify any specific concerns
