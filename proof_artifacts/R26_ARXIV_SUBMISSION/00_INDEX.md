# R26 arXiv Submission

**Concept-Tag:** RH-R26-ARXIV-SUBMISSION

## Purpose

Deterministic arXiv source bundle and submission checklist.

## Contents

| File | Description |
|------|-------------|
| R26_CONTRACT.md | What this rung establishes and does NOT claim |
| R26_POLICY.md | Submission policy and moderator notes |
| R26_WORKLIST.md | Implementation checklist |
| arxiv/00_README.md | arXiv submission instructions |
| arxiv/SUBMISSION_CHECKLIST.md | Pre-submission checklist |
| arxiv/SOURCE_BUNDLE_MANIFEST.txt | Generated: list of files in source bundle |
| arxiv/arxiv_source_bundle.sha256 | Generated: SHA-256 of source bundle |

## Build Source Bundle

```bash
./scripts/build_arxiv_source_bundle.sh /tmp/arxiv_source.zip
```

This produces a deterministic zip suitable for arXiv upload.
