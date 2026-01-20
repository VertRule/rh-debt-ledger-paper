# Operator Steps: Alternate Preprint Dissemination

## Overview

While awaiting arXiv endorsement, establish a publicly citable preprint via Zenodo or OSF. This provides a DOI and permanent archival independent of arXiv.

## Option A: Zenodo Deposit (Recommended)

Zenodo provides DOI minting, versioning, and permanent archival via CERN.

### Step 1: Prepare Materials

Gather from the repository:
- `paper/main.pdf` — the compiled paper
- `arxiv_source_bundle.zip` — from R26 build script
- SHA256 digest from R25

### Step 2: Create Zenodo Account

1. Go to https://zenodo.org
2. Sign up (GitHub OAuth available)
3. Verify email

### Step 3: Create New Upload

1. Click "New Upload"
2. Select upload type: **Preprint**

### Step 4: Upload Files

Upload these files:
- `main.pdf` — primary paper
- `arxiv_source_bundle.zip` — reproducible source
- `SHA256SUMS.txt` — containing the paper digest

### Step 5: Fill Metadata

| Field | Value |
|-------|-------|
| Title | A Deterministic Debt-Ledger Framework for RH Verification |
| Authors | David Ingle |
| Description | (Copy abstract from paper) |
| Keywords | Riemann Hypothesis, verification, reproducibility, debt ledger |
| License | Select appropriate (e.g., CC-BY-4.0 for text) |
| Related identifiers | GitHub repo URL |

### Step 6: Publish

1. Review all fields
2. Click "Publish"
3. Zenodo assigns a DOI immediately

### Step 7: Record DOI

1. Note the DOI (format: `10.5281/zenodo.XXXXXXX`)
2. This will be recorded in a future rung
3. Do NOT commit the DOI to R27 — create a new rung for it

## Option B: OSF Preprints (Mirror)

OSF provides additional visibility and preprint server indexing.

### Step 1: Create OSF Account

1. Go to https://osf.io
2. Sign up and verify email

### Step 2: Create New Preprint

1. Go to https://osf.io/preprints/
2. Click "Add a preprint"
3. Select a preprint service (OSF Preprints or domain-specific)

### Step 3: Upload and Configure

1. Upload `main.pdf`
2. Fill metadata (similar to Zenodo)
3. Add GitHub repo as supplementary link
4. OSF can mint a DOI or you can link to Zenodo DOI

### Step 4: Submit

1. Review preprint
2. Submit for posting
3. OSF preprints are typically posted within 24–48 hours

## Parallel Strategy

| Platform | Purpose | DOI |
|----------|---------|-----|
| Zenodo | Primary archive, DOI minting | Yes (primary) |
| OSF Preprints | Visibility, preprint indexing | Optional (can link) |
| arXiv | Academic visibility (when endorsed) | Via arXiv ID |

## After DOI is Minted

1. Do NOT modify R27 — it documents the process, not the outcome
2. Create a new rung (R28 or later) to record:
   - Zenodo DOI
   - OSF link (if used)
   - arXiv ID (when available)
3. Update paper metadata if needed for future versions

## Notes

- Zenodo allows versioning — you can update the deposit later
- DOIs are permanent; content at that DOI should not change
- For updates, create a new version (new DOI, linked to original)
- Both platforms support embargo if needed (not recommended for this project)
