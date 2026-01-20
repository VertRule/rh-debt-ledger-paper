#!/bin/sh
# VERIFY_R20_REBUILD_ASSEMBLY_ROOT.sh - Verify R20 assembly root rebuild
# Runs deterministic rebuild and checks for exact match with committed root
set -e

R20_DIR="proof_artifacts/R20_REBUILD_ASSEMBLY_ROOT"
REBUILD_SCRIPT="scripts/rebuild_r10_assembly_root.sh"
COMPARE_REPORT="$R20_DIR/outputs/R20_compare_report.txt"

# Check rebuild script exists
if [ ! -x "$REBUILD_SCRIPT" ]; then
    echo "ERROR: Rebuild script not found or not executable: $REBUILD_SCRIPT" >&2
    exit 1
fi

# Run rebuild
if ! "$REBUILD_SCRIPT"; then
    echo "R20 assembly root rebuild FAILED"
    if [ -f "$COMPARE_REPORT" ]; then
        echo "See: $COMPARE_REPORT"
    fi
    exit 1
fi

# Verify determinism: run again and check output is identical
FIRST_SHA=$(cat "$R20_DIR/outputs/R20_R10_ASSEMBLY_ROOT.rebuilt.sha256")
"$REBUILD_SCRIPT" >/dev/null 2>&1
SECOND_SHA=$(cat "$R20_DIR/outputs/R20_R10_ASSEMBLY_ROOT.rebuilt.sha256")

if [ "$FIRST_SHA" != "$SECOND_SHA" ]; then
    echo "ERROR: Rebuild is not deterministic" >&2
    echo "First run:  $FIRST_SHA"
    echo "Second run: $SECOND_SHA"
    exit 1
fi

echo "R20 assembly root rebuild verified (deterministic, matches committed)"
exit 0
