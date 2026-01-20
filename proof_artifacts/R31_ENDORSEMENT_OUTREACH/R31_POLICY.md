# R31 Policy: Token Handling and Outreach

## Token Safety Rules

| Rule | Rationale |
|------|-----------|
| NEVER commit endorsement codes | One-time tokens; leaks require new codes |
| NEVER post tokens in issues/PRs | Public visibility |
| Store tokens only in `operator_private/` | Gitignored directory |
| Forward original arXiv email | Preserves authentic headers |
| Verify domain is `arxiv.org` | Phishing protection |

## Outreach Protocol

1. **Initial contact**: Send cover note + forward arXiv email
2. **Wait 5–7 days**: Do not contact before this window
3. **One follow-up**: Maximum one polite follow-up
4. **Stop**: After follow-up, do not contact again regardless of response

## Template Usage

All templates use placeholders:
- `<ARXIV_CATEGORY>` — e.g., math.NT
- `<PAPER_TITLE>` — full title
- `<REPO_RELEASE>` — e.g., r30-readme-front-door
- `<VERIFY_COMMAND>` — `VR_STRICT=1 ./VERIFY.sh`

**Critical line in all templates:**
> "Official arXiv endorsement email will be forwarded separately."

This ensures tokens travel only via email, not in templates.

## Mechanical Enforcement

`VERIFY_R31_NO_TOKEN_LEAK.sh` scans the entire repository for arXiv endorsement URLs and token query parameters. If any are found in tracked files, verification fails.

This check runs as VERIFY.sh step 25/25.

**WARNING:** Do not copy endorsement links or codes into any tracked file; handle in `operator_private/` only.

## What Endorsement Is NOT

Endorsement does NOT mean:
- The endorser reviewed the paper
- The endorser agrees with the approach
- The mathematics is correct
- arXiv has accepted the paper

Endorsement means only:
- The submission is topically appropriate
- The author appears serious
- The content is not spam
