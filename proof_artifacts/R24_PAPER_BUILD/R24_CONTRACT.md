# R24 Contract

**Concept-Tag:** RH-R24-CONTRACT

## Establishes

1. A deterministic local build process for the paper PDF.
2. SHA-256 receipt for the built PDF.
3. Toolchain version capture for audit.
4. Two-pass build verification (same source → same PDF bytes).

## Does NOT Claim

1. Cross-machine reproducibility (toolchain not pinned).
2. Proof correctness or mathematical validity.
3. RH or any statement about prime distribution.

## Verification

```bash
./VERIFY_R24_PAPER_BUILD.sh
```

SKIP if no TeX toolchain available.
PASS if two builds produce identical SHA-256.
FAIL if builds differ or error occurs.

## Dependencies

- R23 (paper skeleton)
- Local TeX toolchain (latexmk or pdflatex)
