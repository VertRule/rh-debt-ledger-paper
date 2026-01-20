#!/bin/sh
# rebuild_r10_assembly_root.sh - Deterministic rebuild of R10 assembly root
# Regenerates R10_ASSEMBLY_ROOT.txt from the declared verify surface
set -e

R9_DIR="proof_artifacts/R9_NO_SURPRISE_ASSEMBLY"
R20_OUT="proof_artifacts/R20_REBUILD_ASSEMBLY_ROOT/outputs"
COMMITTED_ROOT="proof_artifacts/R11_SIGNATURE/R10_ASSEMBLY_ROOT.txt"

# Ensure output directory exists
mkdir -p "$R20_OUT"

# Select sha256 tool
if command -v sha256sum >/dev/null 2>&1; then
    SHA256="sha256sum"
    SHA256_EXTRACT='{ print $1 }'
elif command -v shasum >/dev/null 2>&1; then
    SHA256="shasum -a 256"
    SHA256_EXTRACT='{ print $1 }'
else
    echo "ERROR: No sha256 tool found" >&2
    exit 1
fi

sha256_file() {
    $SHA256 "$1" | awk "$SHA256_EXTRACT"
}

# Build canonical text for assembly root computation
# Must match VERIFY_R10_ASSEMBLY_RECEIPT.sh exactly
CANONICAL_TEXT=$(mktemp)
trap 'rm -f "$CANONICAL_TEXT"' EXIT

# 1) r9_manifest_sha256
cat "$R9_DIR/R9_INPUT_MANIFEST.sha256" >> "$CANONICAL_TEXT"

# 2) input digests (manifest order, hash only)
while IFS= read -r line; do
    echo "$line" | awk '{ print $1 }' >> "$CANONICAL_TEXT"
done < "$R9_DIR/R9_INPUT_DIGESTS.sha256"

# 3) output digests (fixed order)
sha256_file "proof_artifacts/R7_BOUND_STATEMENT/R7_BOUND_STATEMENT.md" >> "$CANONICAL_TEXT"
sha256_file "proof_artifacts/R7_BOUND_STATEMENT/R7_EQUATION_INVENTORY.md" >> "$CANONICAL_TEXT"
sha256_file "proof_artifacts/R7_BOUND_STATEMENT/R7_EQUATION_INVENTORY.sha256" >> "$CANONICAL_TEXT"

# 4) verifier digests (fixed order)
sha256_file "VERIFY_R7_BOUND_STATEMENT.sh" >> "$CANONICAL_TEXT"
sha256_file "VERIFY_R8_COMPARISON.sh" >> "$CANONICAL_TEXT"
sha256_file "VERIFY_R9_NO_SURPRISE.sh" >> "$CANONICAL_TEXT"
sha256_file "VERIFY_R10_ASSEMBLY_RECEIPT.sh" >> "$CANONICAL_TEXT"

# Compute assembly root
COMPUTED_ROOT=$(sha256_file "$CANONICAL_TEXT")

# Write rebuilt assembly root file
REBUILT_FILE="$R20_OUT/R20_R10_ASSEMBLY_ROOT.rebuilt.txt"
echo "assembly_root_sha256=$COMPUTED_ROOT" > "$REBUILT_FILE"

# Write sha256 of rebuilt file
REBUILT_SHA="$R20_OUT/R20_R10_ASSEMBLY_ROOT.rebuilt.sha256"
sha256_file "$REBUILT_FILE" > "$REBUILT_SHA"

# Compare with committed root
COMPARE_REPORT="$R20_OUT/R20_compare_report.txt"

if [ ! -f "$COMMITTED_ROOT" ]; then
    echo "ERROR: Committed root not found: $COMMITTED_ROOT" > "$COMPARE_REPORT"
    echo "RESULT: FAIL (committed root missing)" >> "$COMPARE_REPORT"
    cat "$COMPARE_REPORT"
    exit 1
fi

COMMITTED_HASH=$(grep '^assembly_root_sha256=' "$COMMITTED_ROOT" | sed 's/assembly_root_sha256=//')

if [ "$COMPUTED_ROOT" = "$COMMITTED_HASH" ]; then
    {
        echo "R20 Assembly Root Rebuild Report"
        echo "================================"
        echo "Rebuilt:   $COMPUTED_ROOT"
        echo "Committed: $COMMITTED_HASH"
        echo "RESULT: MATCH"
    } > "$COMPARE_REPORT"
    cat "$COMPARE_REPORT"
    exit 0
else
    {
        echo "R20 Assembly Root Rebuild Report"
        echo "================================"
        echo "Rebuilt:   $COMPUTED_ROOT"
        echo "Committed: $COMMITTED_HASH"
        echo "RESULT: MISMATCH"
        echo ""
        echo "Diff:"
        diff "$COMMITTED_ROOT" "$REBUILT_FILE" || true
    } > "$COMPARE_REPORT"
    cat "$COMPARE_REPORT"
    exit 1
fi
