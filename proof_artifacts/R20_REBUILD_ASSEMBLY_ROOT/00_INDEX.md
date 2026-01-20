# R20 Rebuild Assembly Root

**Concept-Tag:** RH-R20-REBUILD-ASSEMBLY-ROOT

## Purpose

Provides a deterministic rebuild surface that regenerates R10_ASSEMBLY_ROOT.txt from the declared verify surface (R4-R9 artifacts + verifier scripts) and compares against the committed assembly root.

## Contents

| File | Description |
|------|-------------|
| R20_CONTRACT.md | Contract specifying rebuild behavior |
| R20_WORKLIST.md | Implementation tasks |
| R20_REBUILD_POLICY.md | Policy governing rebuild process |
| outputs/ | Generated rebuild outputs |

## Verification

```bash
./VERIFY_R20_REBUILD_ASSEMBLY_ROOT.sh
```
