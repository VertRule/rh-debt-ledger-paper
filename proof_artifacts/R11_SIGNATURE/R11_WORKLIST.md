# R11 Worklist

**Concept-Tag:** RH-R11-WORKLIST

## Tasks

| ID | Description | Status |
|----|-------------|--------|
| R11.1 | Add signature policy and signable text | DONE |
| R11.2 | Add verifier and wire into VERIFY.sh | DONE |
| R12.1 | Add sigs/ envelope + policy | DONE |
| R12.2 | Verify-all-present behavior | DONE |

## Notes

- R11.1 creates R10_ASSEMBLY_ROOT.txt from R10_RECEIPT.json
- R11.2 adds VERIFY_R11_SIGNATURE.sh as step 19 in VERIFY.sh
- Signature file (.sig) is optional; absence is not failure
- R12.1 adds sigs/ directory for multi-signer envelope
- R12.2 updates verifier to check all *.asc signatures present
