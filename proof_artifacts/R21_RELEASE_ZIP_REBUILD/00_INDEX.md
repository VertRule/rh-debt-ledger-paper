# R21 Release Zip Rebuild

**Concept-Tag:** RH-R21-RELEASE-ZIP-REBUILD

## Purpose

Provides a deterministic script to rebuild the verify-surface release zip from any git tag. Establishes release reproducibility: the same tag always produces a byte-identical zip.

## Contents

| File | Description |
|------|-------------|
| R21_CONTRACT.md | Contract specifying rebuild behavior |
| R21_WORKLIST.md | Implementation tasks |
| R21_POLICY.md | Policy governing release zip reproducibility |

## Usage

```bash
scripts/rebuild_release_zip.sh <tag> <out_zip_path>
```

## Verification

Local only (not wired into CI):
```bash
./VERIFY_R21_RELEASE_ZIP_REBUILD.sh <tag>
```
