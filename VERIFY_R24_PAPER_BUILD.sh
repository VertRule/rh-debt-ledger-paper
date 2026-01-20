#!/bin/sh
# VERIFY_R24_PAPER_BUILD.sh - Verify deterministic paper build
# Concept-Tag: RH-R24-PAPER-BUILD-VERIFIER
#
# This verifier is OPTIONAL and NOT wired into VERIFY.sh.
# It requires a TeX toolchain (latexmk or pdflatex).
#
# Usage: ./VERIFY_R24_PAPER_BUILD.sh
#
# Exit codes:
#   0 - PASS (deterministic) or SKIP (no toolchain)
#   1 - FAIL (non-deterministic or build error)
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "=== R24 Paper Build Verification ==="

# Check for TeX toolchain
if ! command -v latexmk >/dev/null 2>&1 && ! command -v pdflatex >/dev/null 2>&1; then
    echo "SKIP: No TeX toolchain (latexmk or pdflatex) available"
    echo "Install TeX Live to enable paper build verification."
    exit 0
fi

# Run the deterministic build script
echo "Running deterministic build..."
if "$SCRIPT_DIR/scripts/build_paper_deterministic_local.sh"; then
    echo ""
    echo "=== R24 VERIFICATION PASSED ==="
    exit 0
else
    echo ""
    echo "=== R24 VERIFICATION FAILED ==="
    exit 1
fi
