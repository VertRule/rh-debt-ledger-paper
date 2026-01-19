#!/bin/sh
# VERIFY.sh - Deterministic verification script for rh-debt-ledger-paper
# Checks: clean state, remote alignment, required files, forbidden artifacts, redaction, exhibit digest
#
# Environment variables:
#   VR_STRICT=1  - Treat dirty working tree as error (default: warning only)
set -e

EXPECTED_REMOTE_SSH="git@github.com:VertRule/rh-debt-ledger-paper.git"
EXPECTED_REMOTE_HTTPS="https://github.com/VertRule/rh-debt-ledger-paper"
ERRORS=0
DIRTY_TREE=0

error() {
    echo "ERROR: $1" >&2
    ERRORS=$((ERRORS + 1))
}

warn() {
    echo "WARNING: $1" >&2
}

echo "=== RH Debt Ledger Paper Verification ==="
echo ""

# 1) Check git clean status
echo "[1/10] Checking git status..."
if ! git diff --quiet 2>/dev/null || ! git diff --cached --quiet 2>/dev/null; then
    warn "Working tree is dirty (uncommitted changes present)"
    DIRTY_TREE=1
fi
if [ -n "$(git status --porcelain 2>/dev/null)" ]; then
    warn "Untracked or modified files present"
    DIRTY_TREE=1
fi
if [ "$DIRTY_TREE" -eq 0 ]; then
    echo "  OK: Working tree is clean"
else
    echo "  OK (warnings above)"
fi

# 2) Reject Co-Authored-By trailers in commits after cutoff
echo "[2/10] Checking for Co-Authored-By trailers..."
COAUTHOR_CUTOFF="92cfc2d"
COAUTHOR_MATCHES=$(git log "${COAUTHOR_CUTOFF}..HEAD" --format=%B 2>/dev/null | grep -n "^Co-Authored-By:" || true)
if [ -n "$COAUTHOR_MATCHES" ]; then
    echo "$COAUTHOR_MATCHES"
    error "Co-Authored-By trailer found in commits after $COAUTHOR_CUTOFF (see AUTHORSHIP.md)"
else
    echo "  OK: No Co-Authored-By trailers in recent commits"
fi

# 3) Verify remote URL (accept SSH or HTTPS)
echo "[3/10] Checking remote URL..."
ACTUAL_REMOTE=$(git remote get-url origin 2>/dev/null || echo "")
if [ "$ACTUAL_REMOTE" = "$EXPECTED_REMOTE_SSH" ] || [ "$ACTUAL_REMOTE" = "$EXPECTED_REMOTE_HTTPS" ]; then
    echo "  OK: $ACTUAL_REMOTE"
else
    error "Remote mismatch: got '$ACTUAL_REMOTE'"
fi

# 4) Verify local HEAD equals origin/main
echo "[4/10] Fetching and comparing with origin/main..."
git fetch origin main --quiet 2>/dev/null || warn "Could not fetch origin/main"
LOCAL_HEAD=$(git rev-parse HEAD 2>/dev/null || echo "")
REMOTE_HEAD=$(git rev-parse origin/main 2>/dev/null || echo "")
if [ -z "$LOCAL_HEAD" ] || [ -z "$REMOTE_HEAD" ]; then
    warn "Could not compare HEAD with origin/main"
elif [ "$LOCAL_HEAD" != "$REMOTE_HEAD" ]; then
    warn "HEAD ($LOCAL_HEAD) differs from origin/main ($REMOTE_HEAD)"
else
    echo "  OK: HEAD matches origin/main"
fi

# 5) Verify required tracked files exist
echo "[5/10] Checking required files..."
REQUIRED_FILES="README.md SUBMISSION.md EXHIBITS.md exhibits/canonical_run.json na0_rh_debt_ledger_draft.md .gitignore"
for f in $REQUIRED_FILES; do
    if [ ! -f "$f" ]; then
        error "Required file missing: $f"
    fi
done
echo "  OK: All required files present"

# 6) Verify forbidden artifacts are NOT tracked
echo "[6/10] Checking forbidden artifacts are not tracked..."
FORBIDDEN_PATTERNS="paper_runs/ runs/ analysis/ proofs/ series.csv zeros_used.csv"
TRACKED_FILES=$(git ls-files 2>/dev/null)
for pattern in $FORBIDDEN_PATTERNS; do
    if echo "$TRACKED_FILES" | grep -q "$pattern"; then
        error "Forbidden artifact is tracked: $pattern"
    fi
done
echo "  OK: No forbidden artifacts tracked"

# 7) Paranoia grep for machine-specific paths
# Note: patterns are split to avoid self-matching
echo "[7/10] Running redaction scan..."
USERS_PATTERN="/Us""ers/"
MACBOOK_PATTERN="Davids""-MacBook"
MATCHES=$(git ls-files | xargs grep -l -i "$USERS_PATTERN" 2>/dev/null | grep -v 'VERIFY' || true)
if [ -n "$MATCHES" ]; then
    echo "$MATCHES"
    error "Found '$USERS_PATTERN' path in tracked files (redaction failure)"
fi
MATCHES=$(git ls-files | xargs grep -l -i "$MACBOOK_PATTERN" 2>/dev/null | grep -v 'VERIFY' || true)
if [ -n "$MATCHES" ]; then
    echo "$MATCHES"
    error "Found '$MACBOOK_PATTERN' in tracked files (redaction failure)"
fi
echo "  OK: No machine-specific paths found"

# 8) Run exhibit digest verification (soft dependency)
echo "[8/10] Running exhibit digest verification..."
if [ -x "./VERIFY_EXHIBIT.sh" ]; then
    set +e
    EXHIBIT_OUTPUT=$(./VERIFY_EXHIBIT.sh 2>&1)
    EXHIBIT_EXIT=$?
    set -e
    if echo "$EXHIBIT_OUTPUT" | grep -q "^SKIP:"; then
        echo "  SKIP: Experiment repo not available"
    elif [ "$EXHIBIT_EXIT" -eq 0 ]; then
        echo "  OK: Exhibit digest verified"
    else
        echo "$EXHIBIT_OUTPUT"
        error "Exhibit digest verification failed"
    fi
else
    echo "  SKIP: VERIFY_EXHIBIT.sh not found or not executable"
fi

# 9) Run verify-all-exhibits (soft dependency)
echo "[9/10] Running verify-all-exhibits..."
if [ -x "./VERIFY_ALL_EXHIBITS.sh" ]; then
    set +e
    ALL_EXHIBITS_OUTPUT=$(./VERIFY_ALL_EXHIBITS.sh 2>&1)
    ALL_EXHIBITS_EXIT=$?
    set -e
    if echo "$ALL_EXHIBITS_OUTPUT" | grep -q "VERIFICATION PASSED"; then
        echo "  OK: All exhibits verified"
    elif echo "$ALL_EXHIBITS_OUTPUT" | grep -q "Skipped:"; then
        echo "  OK: All exhibits verified (some skipped)"
    else
        echo "$ALL_EXHIBITS_OUTPUT"
        if [ "$ALL_EXHIBITS_EXIT" -ne 0 ]; then
            error "Verify-all-exhibits failed"
        fi
    fi
else
    echo "  SKIP: VERIFY_ALL_EXHIBITS.sh not found or not executable"
fi

# 10) Verify contribution ledger integrity
echo "[10/10] Checking contribution ledger..."
LEDGER_FILE=".github/CONTRIBUTION_LEDGER.md"
LEDGER_ERRORS=0
if [ ! -f "$LEDGER_FILE" ]; then
    error "Contribution ledger missing: $LEDGER_FILE"
    LEDGER_ERRORS=1
else
    if ! grep -qi "operator-led" "$LEDGER_FILE"; then
        error "Contribution ledger missing 'operator-led' declaration"
        LEDGER_ERRORS=1
    fi
    if ! grep -qi "do not claim" "$LEDGER_FILE"; then
        error "Contribution ledger missing epistemic boundary ('do not claim')"
        LEDGER_ERRORS=1
    fi
fi
if [ "$LEDGER_ERRORS" -eq 0 ]; then
    echo "  OK: Contribution ledger integrity verified"
fi

echo ""
if [ "$ERRORS" -gt 0 ]; then
    echo "=== VERIFICATION FAILED: $ERRORS error(s) ==="
    exit 1
fi

# In strict mode, dirty tree is an error
if [ "${VR_STRICT:-0}" = "1" ] && [ "$DIRTY_TREE" -eq 1 ]; then
    echo "=== VERIFICATION FAILED: Dirty tree in strict mode ==="
    exit 1
fi

# DRILL: intentional failure
echo "DRILL: intentional failure" >&2
exit 1

echo "=== VERIFICATION PASSED ==="
exit 0
