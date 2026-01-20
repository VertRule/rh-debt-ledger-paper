#!/bin/sh
# verify_pq_sig.sh - Adapter for local PQ signature verification
# Usage: scripts/verify_pq_sig.sh <scheme> <sig_file> <payload_file> <pubkey_file>
# Exit codes:
#   0 - verification succeeded
#   1 - verification failed
#   2 - no PQ verifier found
set -e

if [ $# -lt 4 ]; then
    echo "Usage: $0 <scheme> <sig_file> <payload_file> <pubkey_file>" >&2
    exit 1
fi

SCHEME="$1"
SIG_FILE="$2"
PAYLOAD_FILE="$3"
PUBKEY_FILE="$4"

# Check files exist
if [ ! -f "$SIG_FILE" ]; then
    echo "ERROR: Signature file not found: $SIG_FILE" >&2
    exit 1
fi
if [ ! -f "$PAYLOAD_FILE" ]; then
    echo "ERROR: Payload file not found: $PAYLOAD_FILE" >&2
    exit 1
fi
if [ ! -f "$PUBKEY_FILE" ]; then
    echo "ERROR: Public key file not found: $PUBKEY_FILE" >&2
    exit 1
fi

# Map scheme to algorithm names
case "$SCHEME" in
    mldsa)
        OQS_ALG="ML-DSA-65"
        OPENSSL_ALG="mldsa65"
        ;;
    slhdsa)
        OQS_ALG="SLH-DSA-SHA2-128f"
        OPENSSL_ALG="slhdsa128f"
        ;;
    *)
        echo "ERROR: Unknown scheme: $SCHEME" >&2
        exit 1
        ;;
esac

# Try liboqs oqs-verify if available
if command -v oqs-verify >/dev/null 2>&1; then
    echo "Using: oqs-verify"
    if oqs-verify -a "$OQS_ALG" -k "$PUBKEY_FILE" -s "$SIG_FILE" -m "$PAYLOAD_FILE" 2>/dev/null; then
        exit 0
    else
        exit 1
    fi
fi

# Try openssl with oqsprovider
if command -v openssl >/dev/null 2>&1; then
    # Check for oqsprovider module in known locations
    OQS_MODULE_PATHS="${OPENSSL_MODULES:-} $HOME/.local/lib/ossl-modules /opt/homebrew/lib/ossl-modules /usr/local/lib/ossl-modules"
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
        echo "Using: openssl+oqsprovider"
        if OPENSSL_MODULES="$OQS_FOUND" openssl pkeyutl -verify -pubin -inkey "$PUBKEY_FILE" \
            -sigfile "$SIG_FILE" -in "$PAYLOAD_FILE" \
            -provider oqsprovider 2>/dev/null; then
            exit 0
        else
            exit 1
        fi
    fi
fi

# No verifier found
echo "no PQ verifier found"
exit 2
