# R24 Worklist

**Concept-Tag:** RH-R24-WORKLIST

## Implementation Checklist

- [x] Create `scripts/build_paper_deterministic_local.sh`
- [x] Set deterministic environment (SOURCE_DATE_EPOCH, TZ, LC_ALL)
- [x] Run build twice and compare SHA-256
- [x] Capture toolchain versions in build.log
- [x] Create `VERIFY_R24_PAPER_BUILD.sh` (optional verifier)
- [x] Do NOT wire into VERIFY.sh
- [x] Create R24 proof artifacts documentation
- [x] Update paper/00_README.md with build instructions

## Outputs

| File | Purpose |
|------|---------|
| outputs/main.pdf | Built paper PDF |
| outputs/main.pdf.sha256 | SHA-256 digest of PDF |
| outputs/build.log | Toolchain versions + build output |
