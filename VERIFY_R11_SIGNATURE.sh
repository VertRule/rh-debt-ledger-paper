#!/bin/sh
# VERIFY_R11_SIGNATURE.sh - Verify R11 optional signature layer
# Checks signature if present; passes without it
set -e

R11_DIR="proof_artifacts/R11_SIGNATURE"
R10_RECEIPT="proof_artifacts/R10_ASSEMBLY_RECEIPT/R10_RECEIPT.json"
ASSEMBLY_ROOT_TXT="$R11_DIR/R10_ASSEMBLY_ROOT.txt"
ASSEMBLY_ROOT_SIG="$R11_DIR/R10_ASSEMBLY_ROOT.sig"
ERRORS=0

error() {
    echo "ERROR: $1" >&2
    ERRORS=$((ERRORS + 1))
}

# 1) Check R10_ASSEMBLY_ROOT.txt exists
if [ ! -f "$ASSEMBLY_ROOT_TXT" ]; then
    error "Assembly root text file missing: $ASSEMBLY_ROOT_TXT"
    exit 1
fi

# 2) Verify R10_ASSEMBLY_ROOT.txt matches R10_RECEIPT.json
RECEIPT_ROOT=$(grep '"assembly_root_sha256"' "$R10_RECEIPT" | sed 's/.*: *"\([^"]*\)".*/\1/')
TXT_ROOT=$(grep '^assembly_root_sha256=' "$ASSEMBLY_ROOT_TXT" | sed 's/assembly_root_sha256=//')

if [ "$RECEIPT_ROOT" != "$TXT_ROOT" ]; then
    error "Assembly root mismatch: receipt=$RECEIPT_ROOT, txt=$TXT_ROOT"
fi

# 3) Check signature if present
if [ -f "$ASSEMBLY_ROOT_SIG" ]; then
    # Signature exists - verify it
    if command -v gpg >/dev/null 2>&1; then
        if gpg --verify "$ASSEMBLY_ROOT_SIG" "$ASSEMBLY_ROOT_TXT" 2>/dev/null; then
            echo "R11: signature verified"
        else
            error "Signature verification failed"
        fi
    else
        error "GPG not available but signature file exists"
    fi
else
    # No signature - that's ok
    echo "R11: signature not present (ok)"
fi

# 4) Report result
if [ "$ERRORS" -gt 0 ]; then
    echo "R11 signature verification failed: $ERRORS error(s)"
    exit 1
fi

echo "R11 signature layer verified"
exit 0
