# R21 Release Zip Rebuild Policy

**Concept-Tag:** RH-R21-POLICY

## Definition

A **verify-surface zip** is a deterministically rebuildable artifact containing:
1. `README_VERIFY.md` — verification instructions
2. `repo/` — the verify surface files from a specific tag

## Reproducibility Requirement

All releases MUST be reproducible from their git tag:
- Given tag T, running `scripts/rebuild_release_zip.sh T out.zip` twice must produce byte-identical outputs
- The sha256 digest of the zip is deterministic for a given tag

## Determinism Guarantees

1. **No timestamps**: Uses `zip -X` to exclude extra file attributes
2. **Stable ordering**: Files are sorted with `LC_ALL=C sort` before zipping
3. **Fixed allowlist**: Only declared verify-surface files are included
4. **No local state**: Uses git worktree to isolate from working directory

## Exclusions

The following are excluded from verify-surface zips:
- `.git/` directory
- `target/` directory
- `dist/` directory
- `**/outputs/*` files (except `.gitkeep` and `.gitignore`)

## Verify Surface Allowlist

The verify surface includes:
- All VERIFY*.sh scripts
- VERIFY_QUICKSTART.md
- checkpoints/
- proof_artifacts/R4_TRANSFER_REPRO/ through R20_REBUILD_ASSEMBLY_ROOT/
- scripts/ (verification-related scripts only)

## Note on Release Comparison

GitHub may add metadata to release assets. Byte-exact match with downloaded releases is not guaranteed, but content equivalence should hold.
