# Operator Steps: arXiv Endorsement Request

## Overview

Independent authors submitting to math categories typically need manual endorsement. arXiv's auto-endorsement requires an academic email and prior arXiv math authorship.

## Step 1: Start arXiv Submission

1. Go to https://arxiv.org/submit
2. Log in or create an arXiv account
3. Select "New Submission"
4. Choose primary category: `math.NT` (Number Theory) or `math.NA` (Numerical Analysis)
5. Upload the source bundle from R26: `arxiv_source_bundle.zip`
6. Complete metadata fields
7. When you reach the submission step, arXiv will detect you need endorsement
8. arXiv sends an **endorsement request email** to your registered address

## Step 2: Endorsement Request Email (Token Handling)

arXiv sends an email containing:
- A one-time endorsement URL: `https://arxiv.org/auth/endorse?x=<CODE>`
- A fallback page: `http://arxiv.org/auth/endorse.php`
- An endorsement code (5–8 characters)

### Safety Rules

| Rule | Rationale |
|------|-----------|
| Treat the code as sensitive | One-time token; if leaked, must request new one |
| Never post publicly | GitHub, Twitter, forums, etc. |
| Store only in private notes | Local file, password manager, encrypted note |
| Verify domain is `arxiv.org` | Phishing protection |
| Prefer HTTPS link | Use `https://arxiv.org/...` not `http://` |

### Preferred Action: Forward the Original Email

Rather than copying the code manually:
1. Forward the original arXiv endorsement email to the potential endorser
2. Add a cover note above (see templates)
3. This preserves the authentic arXiv formatting and headers

## Step 3: Find Qualified Endorsers

Endorsers must have:
- Prior arXiv submissions in the target category
- Active endorser status (not all authors are endorsers)

### Finding Candidates

1. Open papers you cite in your bibliography
2. Go to each paper's arXiv abstract page
3. Use arXiv's endorser check:
   - Visit: https://arxiv.org/auth/endorse-lookup
   - Enter author names to check endorser status
4. Prioritize authors whose work is closest to your topic

### Endorser Selection Criteria

- Has published in `math.NT` or `math.NA`
- Work relates to RH, zeta functions, or numerical analysis
- Appears active (recent submissions)

## Step 4: Send Outreach

### Checklist Before Sending

- [ ] Confirm the endorsement URL domain is `arxiv.org`
- [ ] Use HTTPS link when possible
- [ ] Include cover note (use template)
- [ ] Attach or link: paper PDF, repository release
- [ ] Non-claims bullets are present

### Outreach Methods (Choose One)

**Option A: Email (Preferred)**
- Forward the arXiv endorsement email
- Add cover note from `ARXIV_ENDORSEMENT_REQUEST_EMAIL.md`

**Option B: Short Forward**
- Use `ARXIV_ENDORSEMENT_REQUEST_FORWARDING_NOTE.md`
- For endorsers you have prior contact with

**Option C: DM/Message**
- Use `ARXIV_ENDORSEMENT_REQUEST_DM.txt`
- Follow up with email containing the endorsement link

### What to Include

1. Cover note explaining request
2. Forwarded arXiv endorsement email (contains the link)
3. Link to GitHub release: `r26-arxiv-submission-kit`
4. Paper PDF location: `paper/main.pdf`
5. Verification command: `VR_STRICT=1 ./VERIFY.sh`
6. Non-claims bullets

## Step 5: Follow-Up Protocol

| Day | Action |
|-----|--------|
| 0 | Send initial request |
| 5–7 | If no response, send ONE polite follow-up |
| 14+ | Stop. Do not contact again. |

### Follow-Up Template

> Hi [Name],
>
> Just a brief follow-up on my arXiv endorsement request from [date].
> No pressure at all — I understand you're busy. The forwarded email
> below contains the endorsement link if you're able to help.
>
> Thanks either way.

## Step 6: After Endorsement

Once endorsed:
1. Complete the arXiv submission
2. Record the arXiv ID in the repository
3. Create a new rung documenting the submission

## arXiv Policy Notes

- math categories require endorsement for new authors without academic affiliation
- Endorsement is category-specific (math.NT endorser may not endorse cs.CR)
- Endorsement expires if not used within the submission window
- If token is compromised, request a new endorsement email via arXiv support
