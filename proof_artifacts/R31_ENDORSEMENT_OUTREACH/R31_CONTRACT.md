# R31 Contract

## Commitments

1. **No token leaks** — Endorsement codes/links never appear in committed files
2. **Mechanical enforcement** — VERIFY_R31_NO_TOKEN_LEAK.sh scans for violations
3. **Non-claims preserved** — All templates explicitly disclaim proof/verification
4. **VERIFY.sh updated** — Verification becomes 25/25

## Deliverables

| Artifact | Purpose |
|----------|---------|
| `VERIFY_R31_NO_TOKEN_LEAK.sh` | Scans repo for endorsement token patterns |
| `templates/COVER_NOTE_EMAIL.md` | Email cover note (token-free) |
| `templates/COVER_NOTE_DM.txt` | DM template (token-free) |
| `templates/ONE_PAGE_PITCH.md` | Project summary for endorsers |
| `.gitignore` update | Excludes `operator_private/` |

## Private (Not Committed)

| Artifact | Purpose |
|----------|---------|
| `operator_private/ENDORSEMENT_TOKEN_STORAGE.md` | Actual tokens (gitignored) |
| `operator_private/ENDORSEMENT_OUTREACH_LOG.md` | Contact log (gitignored) |

## Verification

- `VR_STRICT=1 ./VERIFY.sh` must report 25/25 PASS
- Step 25 runs `VERIFY_R31_NO_TOKEN_LEAK.sh`
