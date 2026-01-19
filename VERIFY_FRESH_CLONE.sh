#!/usr/bin/env bash
set -euo pipefail

# VERIFY_FRESH_CLONE.sh - Fresh clone verification for rh-debt-ledger-paper
# Clones the repo to a temp directory and runs all verifiers.

TEMP_DIR="/tmp/vr_paper_fresh_clone_verify"
REPO_URL="git@github.com:VertRule/rh-debt-ledger-paper.git"

echo "=== Fresh Clone Verification ==="
echo ""

# Clean up any previous run
if [[ -d "$TEMP_DIR" ]]; then
    echo "Removing previous temp directory..."
    rm -rf "$TEMP_DIR"
fi

mkdir -p "$TEMP_DIR"
cd "$TEMP_DIR"

echo "Cloning $REPO_URL..."
git clone --quiet "$REPO_URL" repo
cd repo

echo "HEAD: $(git rev-parse --short HEAD)"
echo ""

# Run verifiers and capture outputs (run VERIFY.sh first while tree is clean)
echo "Running VERIFY.sh..."
VERIFY_OUT=$(./VERIFY.sh 2>&1) || { echo "$VERIFY_OUT"; echo "VERIFY.sh FAILED"; exit 1; }

echo "Running VERIFY_EXHIBIT.sh..."
VERIFY_EXHIBIT_OUT=$(./VERIFY_EXHIBIT.sh 2>&1) || { echo "$VERIFY_EXHIBIT_OUT"; echo "VERIFY_EXHIBIT.sh FAILED"; exit 1; }

echo "Running VERIFY_ALL_EXHIBITS.sh..."
VERIFY_ALL_OUT=$(./VERIFY_ALL_EXHIBITS.sh 2>&1) || { echo "$VERIFY_ALL_OUT"; echo "VERIFY_ALL_EXHIBITS.sh FAILED"; exit 1; }

# Write outputs to files (after all verifiers pass)
echo "$VERIFY_ALL_OUT" > verify_all_exhibits.out
echo "$VERIFY_EXHIBIT_OUT" > verify_exhibit.out
echo "$VERIFY_OUT" > verify.out

# Compute sha256 (cross-platform)
if command -v shasum &> /dev/null; then
    shasum -a 256 verify_all_exhibits.out verify_exhibit.out verify.out > verify_outputs.sha256
elif command -v sha256sum &> /dev/null; then
    sha256sum verify_all_exhibits.out verify_exhibit.out verify.out > verify_outputs.sha256
else
    echo "ERROR: No sha256 tool available"
    exit 1
fi

echo ""
echo "=== Verification Outputs ==="
cat verify_outputs.sha256
echo ""
echo "=== Summary ==="
grep -A4 "^=== Summary ===" verify_all_exhibits.out || true
echo ""
echo "=== FRESH CLONE VERIFICATION PASSED ==="
echo "Outputs saved to: $TEMP_DIR/repo/"
