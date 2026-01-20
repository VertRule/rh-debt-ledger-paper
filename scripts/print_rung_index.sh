#!/bin/sh
# print_rung_index.sh - Print current rung and discovered verifier steps
# Pure convenience script, no policy changes
set -e

echo "=== RH Debt Ledger — Rung Index ==="
echo ""

# Current rung from STATUS.md if available
if [ -f STATUS.md ]; then
    CURRENT=$(grep "^\*\*R" STATUS.md | head -1 | sed 's/\*\*//g' | sed 's/ *—.*//')
    echo "Current rung: $CURRENT"
else
    echo "Current rung: (STATUS.md not found)"
fi

echo ""
echo "Discovered verifier steps:"

# Find all VERIFY_R*.sh scripts
for v in VERIFY_R*.sh; do
    if [ -f "$v" ] && [ -x "$v" ]; then
        # Extract rung number from filename
        RUNG=$(echo "$v" | sed 's/VERIFY_R//' | sed 's/_.*//' | sed 's/\.sh//')
        NAME=$(echo "$v" | sed 's/VERIFY_//' | sed 's/\.sh//' | tr '_' ' ')
        echo "  - R$RUNG: $v"
    fi
done

echo ""
echo "Run 'VR_STRICT=1 ./VERIFY.sh' for full verification."
