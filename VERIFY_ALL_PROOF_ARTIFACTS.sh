#!/bin/sh
# VERIFY_ALL_PROOF_ARTIFACTS.sh - Mechanical integrity checks for proof artifact packets
# No mathematical validation; only structural/link checks.
set -eu

ERRORS=0

fail() {
    echo "ERROR: $1" >&2
    ERRORS=$((ERRORS + 1))
}

echo "=== Verify Proof Artifacts ==="
echo ""

# A) Check required packet files exist
REQUIRED_FILES="
proof_artifacts/R3_ZERO_FREE_REGION/00_INDEX.md
proof_artifacts/R3_ZERO_FREE_REGION/01_ZERO_FREE_REGION_LEMMA.md
proof_artifacts/R3_ZERO_FREE_REGION/02_EXPLICIT_FORMULA_PSI.md
proof_artifacts/R3_ZERO_FREE_REGION/03_ZERO_SUM_BOUND.md
proof_artifacts/R3_ZERO_FREE_REGION/04_PSI_BOUND.md
proof_artifacts/R3_ZERO_FREE_REGION/05_TRANSFER_TO_PI_MINUS_LI.md
proof_artifacts/R3_ZERO_FREE_REGION/R3_WORKLIST.md
proof_artifacts/R3_ZERO_FREE_REGION_CONTRACT.md
"

echo "[1/5] Checking required packet files..."
for f in $REQUIRED_FILES; do
    if [ ! -f "$f" ]; then
        fail "Required file missing: $f"
    fi
done
if [ "$ERRORS" -eq 0 ]; then
    echo "  OK: All required files present"
fi

# B) Check links in 00_INDEX.md
echo "[2/5] Checking links in 00_INDEX.md..."
INDEX_FILE="proof_artifacts/R3_ZERO_FREE_REGION/00_INDEX.md"
if [ -f "$INDEX_FILE" ]; then
    INDEX_LINKS=$(grep -oE '\([0-9A-Za-z_]+\.md\)' "$INDEX_FILE" | tr -d '()' || true)
    for link in $INDEX_LINKS; do
        target="proof_artifacts/R3_ZERO_FREE_REGION/$link"
        if [ ! -f "$target" ]; then
            fail "Broken link in 00_INDEX.md: $link -> $target"
        fi
    done
    if [ "$ERRORS" -eq 0 ]; then
        echo "  OK: All index links valid"
    fi
fi

# C) Check links in R3_ZERO_FREE_REGION_CONTRACT.md
echo "[3/5] Checking links in contract..."
CONTRACT_FILE="proof_artifacts/R3_ZERO_FREE_REGION_CONTRACT.md"
if [ -f "$CONTRACT_FILE" ]; then
    CONTRACT_LINKS=$(grep -oE '\(R3_ZERO_FREE_REGION/[0-9A-Za-z_]+\.md\)' "$CONTRACT_FILE" | tr -d '()' || true)
    for link in $CONTRACT_LINKS; do
        target="proof_artifacts/$link"
        if [ ! -f "$target" ]; then
            fail "Broken link in contract: $link -> $target"
        fi
    done
    if [ "$ERRORS" -eq 0 ]; then
        echo "  OK: All contract links valid"
    fi
fi

# D) Check required headings in lemma files 01..05
echo "[4/5] Checking lemma file structure..."
LEMMA_FILES="
proof_artifacts/R3_ZERO_FREE_REGION/01_ZERO_FREE_REGION_LEMMA.md
proof_artifacts/R3_ZERO_FREE_REGION/02_EXPLICIT_FORMULA_PSI.md
proof_artifacts/R3_ZERO_FREE_REGION/03_ZERO_SUM_BOUND.md
proof_artifacts/R3_ZERO_FREE_REGION/04_PSI_BOUND.md
proof_artifacts/R3_ZERO_FREE_REGION/05_TRANSFER_TO_PI_MINUS_LI.md
"

REQUIRED_HEADINGS="Concept-Tag:
Debt Ledger
Non-Claims"

for f in $LEMMA_FILES; do
    if [ -f "$f" ]; then
        for heading in $REQUIRED_HEADINGS; do
            if ! grep -q "$heading" "$f"; then
                fail "Missing '$heading' in $f"
            fi
        done
    fi
done
if [ "$ERRORS" -eq 0 ]; then
    echo "  OK: All lemma files have required structure"
fi

# E) Check worklist structure
echo "[5/5] Checking worklist structure..."
WORKLIST_FILE="proof_artifacts/R3_ZERO_FREE_REGION/R3_WORKLIST.md"
WORKLIST_ERRORS=0
if [ -f "$WORKLIST_FILE" ]; then
    if ! grep -q "Concept-Tag:" "$WORKLIST_FILE"; then
        fail "Worklist missing 'Concept-Tag:'"
        WORKLIST_ERRORS=1
    fi
    if ! grep -q "| ID | Lemma | Task | Status |" "$WORKLIST_FILE"; then
        fail "Worklist missing table header"
        WORKLIST_ERRORS=1
    fi
fi
if [ "$WORKLIST_ERRORS" -eq 0 ]; then
    echo "  OK: Worklist structure valid"
fi

echo ""
if [ "$ERRORS" -gt 0 ]; then
    echo "=== PROOF ARTIFACT VERIFICATION FAILED: $ERRORS error(s) ==="
    exit 1
fi

echo "=== OK: Proof artifact integrity verified ==="
exit 0
