# R15 Worklist

**Concept-Tag:** RH-R15-WORKLIST

## Tasks

| ID | Description | Status |
|----|-------------|--------|
| R15.1 | Add PQ signature policy and directory structure | DONE |
| R15.2 | Add PQ verification adapter script | DONE |
| R15.3 | Add verifier and wire into VERIFY.sh as step 21 | DONE |

## Notes

- R15.1 creates sigs_pq/ directory for PQ signature files
- R15.2 adds scripts/verify_pq_sig.sh for local PQ tool detection
- R15.3 adds VERIFY_R15_PQ_SIGNATURE.sh as step 21 in VERIFY.sh
- PQ signatures are optional; verification passes with none present
