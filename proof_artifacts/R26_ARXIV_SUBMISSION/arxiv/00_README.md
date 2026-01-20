# arXiv Submission Instructions

**Concept-Tag:** RH-R26-ARXIV-README

## Build Source Bundle

```bash
./scripts/build_arxiv_source_bundle.sh /tmp/arxiv_source.zip
```

This produces a deterministic zip containing only the LaTeX sources.

## Upload to arXiv

1. Go to https://arxiv.org/submit
2. Select category: **math.NT** (Number Theory)
3. Upload the source zip (NOT the PDF)
4. arXiv will compile the PDF from sources
5. Review the compiled PDF carefully
6. Select license: arXiv license (recommended)
7. Submit

## Pre-Submission Checklist

See `SUBMISSION_CHECKLIST.md` for the full checklist.

## If Compilation Fails

1. Check arXiv's TeX Live version compatibility
2. If tcolorbox is unavailable, replace Non-Claims box with:
   ```latex
   \begin{center}
   \fbox{\parbox{0.9\textwidth}{
     \textbf{Non-Claims} \\
     This paper is NOT a proof of RH...
   }}
   \end{center}
   ```
3. Re-run the build script and re-upload

## Contact

For questions about the verification ladder:
- Repository: https://github.com/VertRule/rh-debt-ledger-paper
- Releases: Check GitHub releases for verify-surface zips
