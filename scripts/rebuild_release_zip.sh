#!/bin/sh
# rebuild_release_zip.sh - Deterministic rebuild of verify-surface zip from git tag
# Usage: scripts/rebuild_release_zip.sh <tag> <out_zip_path>
#
# Guarantees:
# - Same tag produces byte-identical zip on repeated runs
# - No timestamps (zip -X)
# - Stable file ordering (LC_ALL=C sort)
# - No network access required
set -e

if [ $# -lt 2 ]; then
    echo "Usage: $0 <tag> <out_zip_path>" >&2
    exit 1
fi

TAG="$1"
OUT_ZIP="$(cd "$(dirname "$2")" && pwd)/$(basename "$2")"

# Verify tag exists
if ! git rev-parse "$TAG" >/dev/null 2>&1; then
    echo "ERROR: Tag not found: $TAG" >&2
    exit 1
fi

# Create temp work directory
WORKDIR="$(mktemp -d /tmp/r21_zip_XXXXXX)"
trap 'git worktree remove --force "$WORKDIR/worktree" 2>/dev/null || true; rm -rf "$WORKDIR"' EXIT

# Create worktree at tag (detached, no branch pollution)
git worktree add --detach "$WORKDIR/worktree" "$TAG" >/dev/null 2>&1

# Derive zip root name from tag
ZIPROOT="$TAG"

# Create staging directory
STAGE="$WORKDIR/$ZIPROOT"
mkdir -p "$STAGE/repo"

# Verify surface allowlist (ordered)
# This list defines what goes into the release zip
ALLOWLIST="
VERIFY.sh
VERIFY_R4_TRANSFER.sh
VERIFY_R5_ERROR_BOUND.sh
VERIFY_R6_INSTANTIATION.sh
VERIFY_R7_BOUND_STATEMENT.sh
VERIFY_R8_COMPARISON.sh
VERIFY_R9_NO_SURPRISE.sh
VERIFY_R10_ASSEMBLY_RECEIPT.sh
VERIFY_R11_SIGNATURE.sh
VERIFY_R14_KEY_CAPTURE.sh
VERIFY_R15_PQ_SIGNATURE.sh
VERIFY_R16_PQ_TOOLING.sh
VERIFY_R20_REBUILD_ASSEMBLY_ROOT.sh
VERIFY_QUICKSTART.md
checkpoints
proof_artifacts/R4_TRANSFER_REPRO
proof_artifacts/R5_ERROR_BOUND_SOURCE
proof_artifacts/R6_INSTANTIATION
proof_artifacts/R7_BOUND_STATEMENT
proof_artifacts/R8_COMPARISON_RUN
proof_artifacts/R9_NO_SURPRISE_ASSEMBLY
proof_artifacts/R10_ASSEMBLY_RECEIPT
proof_artifacts/R11_SIGNATURE
proof_artifacts/R14_KEY_CAPTURE
proof_artifacts/R15_PQ_SIGNATURE
proof_artifacts/R16_PQ_TOOLING
proof_artifacts/R20_REBUILD_ASSEMBLY_ROOT
scripts/verify_pq_sig.sh
scripts/capture_pq_tooling.sh
scripts/capture_gpg_fingerprint.sh
scripts/rebuild_r10_assembly_root.sh
"

# Copy each item from worktree to staging
for item in $ALLOWLIST; do
    SRC="$WORKDIR/worktree/$item"
    if [ -e "$SRC" ]; then
        # Create parent directory in destination
        PARENT=$(dirname "$item")
        if [ "$PARENT" != "." ]; then
            mkdir -p "$STAGE/repo/$PARENT"
        fi

        if [ -d "$SRC" ]; then
            # Copy directory recursively
            cp -R "$SRC" "$STAGE/repo/$item"
            # Remove excluded directories
            rm -rf "$STAGE/repo/$item/.git" "$STAGE/repo/$item/target" "$STAGE/repo/$item/dist" 2>/dev/null || true

            # Remove outputs/* except .gitkeep and .gitignore
            if [ -d "$STAGE/repo/$item" ]; then
                find "$STAGE/repo/$item" -type d -name 'outputs' | while read -r outdir; do
                    find "$outdir" -type f ! -name '.gitkeep' ! -name '.gitignore' -delete 2>/dev/null || true
                done
            fi
        else
            cp "$SRC" "$STAGE/repo/$item"
        fi
    fi
done

# Generate README_VERIFY.md
cat > "$STAGE/README_VERIFY.md" <<EOF
Concept-Tag: RH-R21-REBUILD-RELEASE-ZIP

Tag: $TAG

What this is
- Verify-surface release zip rebuilt from git tag.
- No proof reproduction. No RH claim.

Verify
cd repo
VR_STRICT=1 ./VERIFY.sh

Expected
=== VERIFICATION PASSED ===
EOF

# Strip extended attributes (macOS)
if command -v xattr >/dev/null 2>&1; then
    xattr -cr "$STAGE" 2>/dev/null || true
fi

# Set all file timestamps to a fixed epoch for determinism
# Using 2024-01-01 00:00:00 UTC as the canonical timestamp
find "$STAGE" -exec touch -t 202401010000.00 {} \; 2>/dev/null || true

# Build file list with stable ordering
FILELIST="$WORKDIR/filelist.txt"
(cd "$WORKDIR" && find "$ZIPROOT" -type f | LC_ALL=C sort) > "$FILELIST"

# Create zip deterministically
rm -f "$OUT_ZIP"
(cd "$WORKDIR" && zip -X "$OUT_ZIP" -@ < "$FILELIST")

# Compute and report sha256
if command -v sha256sum >/dev/null 2>&1; then
    SHA256=$(sha256sum "$OUT_ZIP" | awk '{print $1}')
elif command -v shasum >/dev/null 2>&1; then
    SHA256=$(shasum -a 256 "$OUT_ZIP" | awk '{print $1}')
else
    echo "WARNING: No sha256 tool found" >&2
    SHA256="unknown"
fi

echo "Created: $OUT_ZIP"
echo "SHA256:  $SHA256"

# Write sha256 file
echo "$SHA256" > "$WORKDIR/$ZIPROOT.sha256"
