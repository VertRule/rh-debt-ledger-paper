# R24 Paper Build

**Concept-Tag:** RH-R24-PAPER-BUILD

## Purpose

Deterministic local build of the paper PDF with SHA-256 receipt.

## Contents

| File | Description |
|------|-------------|
| R24_CONTRACT.md | What this rung establishes and does NOT claim |
| R24_POLICY.md | Build determinism policy and toolchain notes |
| R24_WORKLIST.md | Implementation checklist |
| outputs/ | Build artifacts (main.pdf, main.pdf.sha256, build.log) |

## Verifier

```bash
./VERIFY_R24_PAPER_BUILD.sh
```

Note: Optional, not wired into VERIFY.sh. Requires TeX toolchain.
