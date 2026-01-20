#!/bin/sh
# VERIFY_R16_PQ_TOOLING.sh - Verify optional PQ tooling receipt
# If receipt exists, verify it matches current environment
set -e

RECEIPT_FILE="proof_artifacts/R16_PQ_TOOLING/R16_TOOLING_RECEIPT.json"
DIGEST_FILE="proof_artifacts/R16_PQ_TOOLING/R16_TOOLING_RECEIPT.sha256"
ERRORS=0

error() {
    echo "ERROR: $1" >&2
    ERRORS=$((ERRORS + 1))
}

# If receipt does not exist, pass
if [ ! -f "$RECEIPT_FILE" ]; then
    echo "R16 receipt absent (ok)"
    exit 0
fi

# Receipt exists, verify it

# 1) Verify sha256 matches
if [ ! -f "$DIGEST_FILE" ]; then
    error "Receipt exists but digest file missing: $DIGEST_FILE"
else
    EXPECTED_DIGEST=$(cat "$DIGEST_FILE" | tr -d ' \n')
    ACTUAL_DIGEST=$(shasum -a 256 "$RECEIPT_FILE" | awk '{print $1}')
    if [ "$EXPECTED_DIGEST" != "$ACTUAL_DIGEST" ]; then
        error "Receipt digest mismatch: expected $EXPECTED_DIGEST, got $ACTUAL_DIGEST"
    fi
fi

# 2) Recompute current detection
OPENSSL_STATUS="absent"
OQS_TOOLBOX_STATUS="absent"

if command -v openssl >/dev/null 2>&1; then
    OPENSSL_STATUS="present"
fi

if command -v oqs-verify >/dev/null 2>&1; then
    OQS_TOOLBOX_STATUS="present"
fi

CURRENT_BACKEND="none"
CURRENT_VERSION="TBD"

# Check for oqsprovider module in known locations
OQS_MODULE_PATHS="${OPENSSL_MODULES:-} $HOME/.local/lib/ossl-modules /opt/homebrew/lib/ossl-modules /usr/local/lib/ossl-modules"

if [ "$OPENSSL_STATUS" = "present" ]; then
    OQS_FOUND=""
    for modpath in $OQS_MODULE_PATHS; do
        if [ -d "$modpath" ] && { [ -f "$modpath/oqsprovider.dylib" ] || [ -f "$modpath/oqsprovider.so" ]; }; then
            if OPENSSL_MODULES="$modpath" openssl list -providers -provider oqsprovider 2>/dev/null | grep -q oqsprovider; then
                OQS_FOUND="$modpath"
                break
            fi
        fi
    done
    if [ -n "$OQS_FOUND" ]; then
        CURRENT_BACKEND="openssl-oqsprovider"
        OPENSSL_VER=$(openssl version 2>/dev/null | head -1 || echo "unknown")
        PROVIDER_VER=$(OPENSSL_MODULES="$OQS_FOUND" openssl list -providers -provider oqsprovider 2>/dev/null | grep -A2 oqsprovider | grep version | sed 's/.*version: //' | tr -d ' ' || echo "unknown")
        if [ -n "$PROVIDER_VER" ] && [ "$PROVIDER_VER" != "unknown" ]; then
            CURRENT_VERSION="openssl:${OPENSSL_VER};oqsprovider:${PROVIDER_VER}"
        else
            CURRENT_VERSION="openssl:${OPENSSL_VER}"
        fi
    fi
fi

if [ "$CURRENT_BACKEND" = "none" ] && [ "$OQS_TOOLBOX_STATUS" = "present" ]; then
    CURRENT_BACKEND="oqs-toolbox"
    OQS_VER=$(oqs-verify --version 2>/dev/null | head -1 || echo "unknown")
    CURRENT_VERSION="$OQS_VER"
fi

# 3) Extract receipt fields and compare
# Use grep/sed for portable JSON parsing (no jq dependency)
RECEIPT_BACKEND=$(grep '"backend"' "$RECEIPT_FILE" | sed 's/.*: *"\([^"]*\)".*/\1/')
RECEIPT_VERSION=$(grep '"backend_version"' "$RECEIPT_FILE" | sed 's/.*: *"\([^"]*\)".*/\1/')
RECEIPT_OPENSSL=$(grep '"openssl"' "$RECEIPT_FILE" | sed 's/.*: *"\([^"]*\)".*/\1/')
RECEIPT_OQS=$(grep '"oqs-toolbox"' "$RECEIPT_FILE" | sed 's/.*: *"\([^"]*\)".*/\1/')

# Compare backend
if [ "$RECEIPT_BACKEND" != "$CURRENT_BACKEND" ]; then
    error "Backend mismatch: receipt=$RECEIPT_BACKEND, current=$CURRENT_BACKEND"
fi

# Compare version
if [ "$RECEIPT_VERSION" != "$CURRENT_VERSION" ]; then
    error "Backend version mismatch: receipt=$RECEIPT_VERSION, current=$CURRENT_VERSION"
fi

# Compare command availability
if [ "$RECEIPT_OPENSSL" != "$OPENSSL_STATUS" ]; then
    error "openssl status mismatch: receipt=$RECEIPT_OPENSSL, current=$OPENSSL_STATUS"
fi

if [ "$RECEIPT_OQS" != "$OQS_TOOLBOX_STATUS" ]; then
    error "oqs-toolbox status mismatch: receipt=$RECEIPT_OQS, current=$OQS_TOOLBOX_STATUS"
fi

if [ "$ERRORS" -gt 0 ]; then
    echo "R16 PQ tooling verification failed: $ERRORS error(s)"
    exit 1
fi

echo "R16 PQ tooling receipt verified (backend=$CURRENT_BACKEND)"
exit 0
