# hunter — metered contact lookup (shared infrastructure)

Hunter.io is NOT owned by any project. Any agent may use it; every credit is
tagged to the project that spent it. All calls go through `engine/hunter/hunter.sh`.
NEVER curl api.hunter.io directly, and never put the API key in a prompt, a file
under version control, an output artifact, or the ledger.

## The four calls (nothing else is wired up)
The free plan has TWO SEPARATE QUOTAS, not one credit pool:
**50 searches** and **100 verifications** per month, reset on `reset_date`.

| call | draws from | notes |
|---|---|---|
| `account` | nothing | free, and the authority on what anything cost |
| `domain-search <domain> [extra]` | searches | 1 per UNIQUE DOMAIN per billing period |
| `email-finder <domain> <first> <last>` | searches | 1 |
| `verify <email>` | verifications | 1 |

**Observed 2026-08-08, contradicting hunter.io's own docs:** a domain-search returning
ZERO results still consumed a search. The docs claim "a new query is counted for calls
returning at least one result" — do not trust it. Repeats on the SAME domain within a
billing period ARE free, which is why tight-then-loosen on one domain costs 1, not 2.

Because the docs are unreliable, **cost is never inferred from the response body** — it
is MEASURED as the account-counter delta around every call. Ledger rows carry the real
`searches` and `verifications` consumed.

Enrichment, companies, combined, leads, discover: deliberately not implemented.
They do not answer "who do I email and is it deliverable."

Two rules that drive every decision below:
- A miss is NOT free — budget for the search whether or not it returns anything.
- But a SECOND query on a domain already queried this period IS free. So once you have
  paid for a domain, loosening the filter and retrying costs nothing. Query tight first,
  loosen on a miss, and take the free `pattern` / `accept_all` intel either way.
- `domain_search_limit` still caps results (paid plans bill per email returned); on the
  free plan the search counter moves by 1 per domain regardless.

## Every run is ceilinged
No metered call runs outside an open run.

```
engine/hunter/hunter.sh run-begin <project> <credit_ceiling> <verify_ceiling>
```

Pass `null` for a ceiling you are not setting; **at least one must be a number** —
`run-begin` refuses if both are null. The caller must ask the operator for these
and must not invent them.

`guard` runs BEFORE each call and refuses if the call's WORST case would breach —
so the ceiling is never crossed, only approached. domain-search worst case is
`domain_search_limit` credits, finder is 1, verify is 0.5.

Close with `run-end`, which prints the run total and deletes the run file. An open
run file blocks the next `run-begin`; if a run died mid-way, `run-status` shows what
it spent before you clear it.

## Acceptance — status only, never score
An address is usable if and only if its final status is **`valid`**. Score decides
whether spending 0.5 to find out is worthwhile; it NEVER grants acceptance.

- `verification.status == "valid"` already on the finder/search response → accept, spend nothing.
- score >= `verify_score_floor` (50) and status not yet valid → `verify` (0.5), accept only on `valid`.
- score < 50 → discard, do not verify.
- `accept_all` domain → the verifier can only ever answer `accept_all`, never `valid`.
  Do NOT spend 0.5 to learn that. Return unverifiable and let the caller park it.
- `risky` / `unknown` / `accept_all` / `invalid` → not usable. No exceptions.

## State
- `state/hunter-ledger.jsonl` — append-only, one row per metered call:
  `{ts, project, endpoint, target, result, credits}`. This is the spend audit.
- `state/hunter-cache.json` — per-domain `pattern`, `accept_all`, `disposable`,
  `webmail`, `last_seen`. Persists across billing periods. Hunter's "same search is
  free within the period" expires monthly; this cache does not. Check it before
  spending — a domain already known to be catch-all needs no call at all.
- `state/hunter-run.json` — exists only while a run is open.

## Budget
`state/budget.json` carries `hunter_credits` caps and spend per project. CLAUDE.md's
hard rule applies: a project never spends another project's credits. Before
`run-begin`, check the requested ceiling against that project's remaining monthly
allocation, not just the account balance.

## Plan
Free plan, 50 credits/month. At ~1.5 credits per resolved contact that is ~30 a
month — Hunter is a last-mile verifier, not a sourcing engine. Free web research
must do the qualifying first. Upgrading = edit `plan`, `monthly_credits`,
`default_credit_ceiling`, and raise `domain_search_limit` to 3. Nothing else changes.
