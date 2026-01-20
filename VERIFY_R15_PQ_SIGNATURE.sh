#!/bin/sh
# VERIFY_R15_PQ_SIGNATURE.sh - Verify optional post-quantum signatures
# Hybrid alongside GPG: PQ sigs are additive, verification skips if no tooling
set -e

SIGS_DIR="proof_artifacts/R15_PQ_SIGNATURE/sigs_pq"
PAYLOAD="proof_artifacts/R11_SIGNATURE/R10_ASSEMBLY_ROOT.txt"
SIGNERS_FILE="proof_artifacts/R11_SIGNATURE/SIGNERS.md"
PUBKEYS_DIR="proof_artifacts/R15_PQ_SIGNATURE/pubkeys"
VERIFY_SCRIPT="scripts/verify_pq_sig.sh"
ERRORS=0
VERIFIED=0
SKIPPED=0

error() {
    echo "ERROR: $1" >&2
    ERRORS=$((ERRORS + 1))
}

# Check required files exist
if [ ! -f "$PAYLOAD" ]; then
    echo "SKIP: Payload file not found: $PAYLOAD"
    exit 0
fi

if [ ! -d "$SIGS_DIR" ]; then
    echo "SKIP: PQ signatures directory not found"
    exit 0
fi

# Count PQ signature files
SIG_COUNT=0
for sig in "$SIGS_DIR"/*.sig; do
    if [ -f "$sig" ]; then
        SIG_COUNT=$((SIG_COUNT + 1))
    fi
done

# If no sig files, pass
if [ "$SIG_COUNT" -eq 0 ]; then
    echo "no PQ sigs present (ok)"
    exit 0
fi

# Check verify script exists
if [ ! -x "$VERIFY_SCRIPT" ]; then
    echo "PQ verify skipped (verify script missing)"
    exit 0
fi

# Process each signature file
for sig in "$SIGS_DIR"/*.sig; do
    if [ ! -f "$sig" ]; then
        continue
    fi

    # Parse filename: <signer_id>.<scheme>.sig
    basename=$(basename "$sig" .sig)
    signer_id=$(echo "$basename" | sed 's/\.[^.]*$//')
    scheme=$(echo "$basename" | sed 's/.*\.//')

    # Check signer exists in ledger (reuse R13 rule)
    if [ -f "$SIGNERS_FILE" ]; then
        if ! grep -q "^| *$signer_id *|" "$SIGNERS_FILE"; then
            error "PQ signature from unknown signer: $signer_id (not in SIGNERS.md)"
            continue
        fi
    fi

    # Look for public key file (required for each sig)
    PUBKEY="$PUBKEYS_DIR/$signer_id.$scheme.pub"
    if [ ! -f "$PUBKEY" ]; then
        error "Missing public key for PQ signature: $PUBKEY"
        continue
    fi

    # Run verification
    set +e
    OUTPUT=$("$VERIFY_SCRIPT" "$scheme" "$sig" "$PAYLOAD" "$PUBKEY" 2>&1)
    RESULT=$?
    set -e

    case $RESULT in
        0)
            echo "  $signer_id ($scheme): verified"
            VERIFIED=$((VERIFIED + 1))
            ;;
        2)
            echo "  $signer_id ($scheme): PQ verify skipped (tool missing)"
            SKIPPED=$((SKIPPED + 1))
            ;;
        *)
            error "PQ signature verification failed: $sig"
            echo "    $OUTPUT"
            ;;
    esac
done

if [ "$ERRORS" -gt 0 ]; then
    echo "R15 PQ signature verification failed: $ERRORS error(s)"
    exit 1
fi

if [ "$VERIFIED" -gt 0 ]; then
    echo "R15 PQ signature verification passed: $VERIFIED verified, $SKIPPED skipped"
elif [ "$SKIPPED" -gt 0 ]; then
    echo "R15 PQ signature verification passed: $SKIPPED skipped (no tooling)"
else
    echo "R15 PQ signature verification passed"
fi
exit 0
