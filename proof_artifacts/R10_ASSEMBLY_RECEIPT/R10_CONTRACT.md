# R10 Assembly Receipt Contract

**Concept-Tag:** RH-R10-ASSEMBLY-RECEIPT-CONTRACT

## Claim

The assembly state is receipt-bound: a canonical JSON receipt captures the assembly root digest, R9 manifest digest, per-file input digests, and output artifact digests.

## Construction

The receipt (`R10_RECEIPT.json`) contains:

- **assembly_root_sha256**: sha256 of canonical text (see below)
- **r9_manifest_sha256**: digest of R9_INPUT_MANIFEST.txt
- **r9_inputs**: ordered list of input paths with their sha256 digests
- **outputs**: list of output artifact paths with their sha256 digests
- **notes**: epistemic boundary statement

Assembly root canonical text (one hex digest per line, in order):
1. r9_manifest_sha256
2. Each input sha256 (manifest order)
3. Each output sha256 (fixed order: R7_BOUND_STATEMENT.md, R7_EQUATION_INVENTORY.md, R7_EQUATION_INVENTORY.sha256)
4. Each verifier sha256 (fixed order: VERIFY_R7, VERIFY_R8, VERIFY_R9, VERIFY_R10)

The receipt file itself is excluded from the assembly root to avoid circularity.

Rules:

- Input order follows R9_INPUT_MANIFEST.txt exactly
- No timestamps (deterministic)
- JSON formatting: 2-space indent, stable key order

## Policy

Verification fails if:

- Recomputed assembly_root_sha256 differs from receipt
- Receipt file digest differs from R10_RECEIPT.sha256
- Any input or output digest mismatches

## What This Does Not Do

- Does not prove correctness of the mathematics
- Does not validate the cited sources
- Does not pay any debt items
