# R31: Endorsement Outreach Kit

## Purpose

This rung provides:
1. Public, token-safe templates for endorsement outreach
2. A mechanical verifier that prevents token leaks in-repo
3. Policy for handling sensitive endorsement codes

## Non-Claims

This outreach kit does **not** imply:
- That endorsement validates mathematical claims
- That arXiv acceptance is imminent
- That the paper has been peer reviewed

## Directory Contents

```
R31_ENDORSEMENT_OUTREACH/
├── 00_INDEX.md           # This file
├── R31_CONTRACT.md       # Commitments for this rung
├── R31_POLICY.md         # Token handling and outreach policy
└── templates/
    ├── COVER_NOTE_EMAIL.md
    ├── COVER_NOTE_DM.txt
    └── ONE_PAGE_PITCH.md
```

## Private Storage (Gitignored)

Actual endorsement tokens are stored in `operator_private/` which is gitignored:
- `ENDORSEMENT_TOKEN_STORAGE.md` — codes and links
- `ENDORSEMENT_OUTREACH_LOG.md` — contact tracking

## Verification

`VERIFY_R31_NO_TOKEN_LEAK.sh` scans the entire repository for arXiv endorsement URLs and token patterns. If any are found in tracked files, verification fails.

This verifier is wired into `VERIFY.sh` as step 25/25.

**WARNING:** Do not copy endorsement links or codes into any tracked file; handle in `operator_private/` only.

## Related Rungs

- R27: Endorsement path documentation
- R28: Zenodo DOI (parallel dissemination lane)
