# R9 Worklist

**Concept-Tag:** RH-R9-WORKLIST

## Tasks

| ID | Description | Status |
|----|-------------|--------|
| R9.1 | Add manifest + digests | DONE |
| R9.2 | Add verifier and wire into VERIFY.sh | DONE |
| R9.3 | Make R8 generator consume manifest paths | N/A |

## Notes

- R9.1 creates R9_INPUT_MANIFEST.txt and R9_INPUT_DIGESTS.sha256
- R9.2 adds VERIFY_R9_NO_SURPRISE.sh as step 17 in VERIFY.sh
- R9.3 is N/A because R8 generator already uses explicit paths
