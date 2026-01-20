# R26 Worklist

**Concept-Tag:** RH-R26-WORKLIST

## Implementation Checklist

- [x] Create `scripts/build_arxiv_source_bundle.sh`
- [x] Deterministic zip (find | sort | zip -X)
- [x] Generate SOURCE_BUNDLE_MANIFEST.txt
- [x] Generate arxiv_source_bundle.sha256
- [x] Update paper/main.tex author: David Ingle, VertRule Inc.
- [x] Verify abstract contains non-claims
- [x] Create R26 proof artifacts documentation
- [x] Create SUBMISSION_CHECKLIST.md

## Outputs

| File | Purpose |
|------|---------|
| /tmp/arxiv_source.zip | arXiv source bundle (user-specified path) |
| arxiv/SOURCE_BUNDLE_MANIFEST.txt | List of files in bundle |
| arxiv/arxiv_source_bundle.sha256 | SHA-256 of last built bundle |
