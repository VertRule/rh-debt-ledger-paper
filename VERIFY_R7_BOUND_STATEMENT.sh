#!/usr/bin/env bash
# VERIFY_R7_BOUND_STATEMENT.sh — Mechanical integrity checks for R7 packet
# Does NOT validate math. Only validates packet structure and hash.

set -euo pipefail

R7_DIR="proof_artifacts/R7_BOUND_STATEMENT"
FAIL=0

echo "=== R7 Bound Statement Integrity Check ==="

# Check required files exist
REQUIRED_FILES=(
    "$R7_DIR/00_INDEX.md"
    "$R7_DIR/R7_BOUND_STATEMENT.md"
    "$R7_DIR/R7_EQUATION_INVENTORY.md"
    "$R7_DIR/R7_EQUATION_INVENTORY.sha256"
    "$R7_DIR/R7_WORKLIST.md"
)

echo "[1/5] Checking required files..."
for f in "${REQUIRED_FILES[@]}"; do
    if [[ ! -f "$f" ]]; then
        echo "  FAIL: Missing $f"
        FAIL=1
    fi
done
if [[ $FAIL -eq 0 ]]; then
    echo "  OK: All required files present"
fi

# Check each file contains Concept-Tag
echo "[2/5] Checking Concept-Tag markers..."
for f in "$R7_DIR/00_INDEX.md" "$R7_DIR/R7_BOUND_STATEMENT.md" "$R7_DIR/R7_EQUATION_INVENTORY.md" "$R7_DIR/R7_WORKLIST.md"; do
    if [[ -f "$f" ]]; then
        if ! grep -q "Concept-Tag:" "$f"; then
            echo "  FAIL: $f missing Concept-Tag"
            FAIL=1
        fi
    fi
done
if [[ $FAIL -eq 0 ]]; then
    echo "  OK: All files have Concept-Tag"
fi

# Check bound statement structure
echo "[3/5] Checking bound statement structure..."
STATEMENT="$R7_DIR/R7_BOUND_STATEMENT.md"
if [[ -f "$STATEMENT" ]]; then
    STMT_FAIL=0
    if ! grep -q "BOUND-R7-MAIN" "$STATEMENT"; then
        echo "  FAIL: $STATEMENT missing main bound anchor"
        STMT_FAIL=1
        FAIL=1
    fi
    if ! grep -q "TERM-R7-E" "$STATEMENT"; then
        echo "  FAIL: $STATEMENT missing E(t) term anchor"
        STMT_FAIL=1
        FAIL=1
    fi
    if ! grep -q "TERM-R7-DELTA-PP" "$STATEMENT"; then
        echo "  FAIL: $STATEMENT missing Δ_pp term anchor"
        STMT_FAIL=1
        FAIL=1
    fi
    if ! grep -q "TERM-R7-C-BOUNDARY" "$STATEMENT"; then
        echo "  FAIL: $STATEMENT missing C_boundary term anchor"
        STMT_FAIL=1
        FAIL=1
    fi
    if ! grep -q "TERM-R7-R-T0" "$STATEMENT"; then
        echo "  FAIL: $STATEMENT missing R_t0 term anchor"
        STMT_FAIL=1
        FAIL=1
    fi
    if [[ $STMT_FAIL -eq 0 ]]; then
        echo "  OK: Bound statement has required term anchors"
    fi
fi

# Check equation inventory structure
echo "[4/5] Checking equation inventory structure..."
INVENTORY="$R7_DIR/R7_EQUATION_INVENTORY.md"
if [[ -f "$INVENTORY" ]]; then
    INV_FAIL=0
    for eq in "EQ-R7-1" "EQ-R7-2" "EQ-R7-3" "EQ-R7-4" "EQ-R7-5" "EQ-R7-6"; do
        if ! grep -q "$eq" "$INVENTORY"; then
            echo "  FAIL: $INVENTORY missing $eq"
            INV_FAIL=1
            FAIL=1
        fi
    done
    if [[ $INV_FAIL -eq 0 ]]; then
        echo "  OK: Equation inventory has all 6 equations"
    fi
fi

# Check equation inventory hash
echo "[5/5] Checking equation inventory hash..."
EXPECTED_HASH="$R7_DIR/R7_EQUATION_INVENTORY.sha256"
if [[ -f "$INVENTORY" ]] && [[ -f "$EXPECTED_HASH" ]]; then
    EXPECTED=$(cat "$EXPECTED_HASH" | tr -d ' \n')
    ACTUAL=$(shasum -a 256 "$INVENTORY" | awk '{print $1}')
    if [[ "$EXPECTED" != "$ACTUAL" ]]; then
        echo "  FAIL: R7 equation inventory hash mismatch (equations changed without updating inventory)"
        echo "  Expected: $EXPECTED"
        echo "  Actual:   $ACTUAL"
        FAIL=1
    else
        echo "  OK: Equation inventory hash verified"
    fi
else
    echo "  SKIP: Equation inventory or hash file not found"
fi

echo ""
if [[ $FAIL -eq 0 ]]; then
    echo "=== R7 INTEGRITY CHECK PASSED ==="
    exit 0
else
    echo "=== R7 INTEGRITY CHECK FAILED ==="
    exit 1
fi
