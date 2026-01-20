# R20 Rebuild Policy

**Concept-Tag:** RH-R20-REBUILD-POLICY

## Assembly Root Definition

The assembly root is computed as the sha256 of a canonical text containing:

1. R9 manifest sha256 (from R9_INPUT_MANIFEST.sha256)
2. Each input file sha256 (from R9_INPUT_DIGESTS.sha256, hash only)
3. Output file sha256s (fixed order):
   - R7_BOUND_STATEMENT.md
   - R7_EQUATION_INVENTORY.md
   - R7_EQUATION_INVENTORY.sha256
4. Verifier script sha256s (fixed order):
   - VERIFY_R7_BOUND_STATEMENT.sh
   - VERIFY_R8_COMPARISON.sh
   - VERIFY_R9_NO_SURPRISE.sh
   - VERIFY_R10_ASSEMBLY_RECEIPT.sh

## Determinism Requirements

- No timestamps in output
- No environment-dependent values
- Stable file ordering (LC_ALL=C sort)
- Consistent newline handling (Unix LF)
- Same bytes on repeated runs

## Output Format

R10_ASSEMBLY_ROOT.txt format:
```
assembly_root_sha256=<64-hex-chars>
```

Single line with newline at EOF.

## Comparison

- Byte-exact comparison with committed R10_ASSEMBLY_ROOT.txt
- Any difference = FAIL
- Exact match = PASS
