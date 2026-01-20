#!/bin/sh
# VERIFY_R11_SIGNATURE.sh - Verify R11 optional signature layer
# Checks all signatures present; passes without any
set -e

R11_DIR="proof_artifacts/R11_SIGNATURE"
R10_RECEIPT="proof_artifacts/R10_ASSEMBLY_RECEIPT/R10_RECEIPT.json"
ASSEMBLY_ROOT_TXT="$R11_DIR/R10_ASSEMBLY_ROOT.txt"
ASSEMBLY_ROOT_SIG="$R11_DIR/R10_ASSEMBLY_ROOT.sig"
SIGS_DIR="$R11_DIR/sigs"
ERRORS=0
SIG_COUNT=0

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

# 3) Check multi-signer envelope (sigs/*.asc)
if [ -d "$SIGS_DIR" ]; then
    for sig in "$SIGS_DIR"/*.asc; do
        # Check if glob matched any files
        [ -e "$sig" ] || continue

        if command -v gpg >/dev/null 2>&1; then
            if gpg --verify "$sig" "$ASSEMBLY_ROOT_TXT" 2>/dev/null; then
                SIG_COUNT=$((SIG_COUNT + 1))
            else
                error "Signature verification failed: $sig"
            fi
        else
            error "GPG not available but signature file exists: $sig"
        fi
    done
fi

# 4) Check legacy single signature file (backward compatibility)
if [ -f "$ASSEMBLY_ROOT_SIG" ]; then
    if command -v gpg >/dev/null 2>&1; then
        if gpg --verify "$ASSEMBLY_ROOT_SIG" "$ASSEMBLY_ROOT_TXT" 2>/dev/null; then
            SIG_COUNT=$((SIG_COUNT + 1))
        else
            error "Legacy signature verification failed: $ASSEMBLY_ROOT_SIG"
        fi
    else
        error "GPG not available but legacy signature file exists"
    fi
fi

# 5) Report signature status
if [ "$SIG_COUNT" -gt 0 ]; then
    echo "R11: $SIG_COUNT signature(s) verified"
else
    echo "R11: no signatures present (ok)"
fi

# 6) Report result
if [ "$ERRORS" -gt 0 ]; then
    echo "R11 signature verification failed: $ERRORS error(s)"
    exit 1
fi

echo "R11 signature layer verified"
exit 0
