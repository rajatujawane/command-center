# enrich — refill the T1 lane (ON DEMAND ONLY)

Runs ONLY when the operator types `enrich outreach`. It is NOT in routines.md and the
03:00 daily pass must never invoke it. It spends real money.

It drafts nothing and sends nothing. It fills `contact.email` on prospect files so the
NEXT daily pass can pick them as T1 targets. All Hunter access goes through
`engine/hunter/SKILL.md` — read that first, never curl Hunter directly.

## Step 1 — ceilings (blocking, ask the operator)
Show the free `account` call first: plan, credits remaining, reset date, and this
project's remaining `hunter_credits` from state/budget.json.

Then ask for BOTH:
- **credit ceiling** for this run (default `default_credit_ceiling` = 10)
- **verification ceiling** — max `verify` calls

**At least one must be a number. If the operator gives neither, STOP — do not run.**
Reject a credit ceiling above the smaller of (account balance, project remaining).
Then `run-begin termstack <credit_ceiling> <verify_ceiling>`.

## Step 2 — select candidates (free)
From `projects/termstack/prospects/*.json`:
- `qualified == true` (run skills/qualify.md first — NEVER spend a search on a
  prospect that has not passed the intake gate), and
- `status == "not_contacted"`, and
- `contact.email` empty or `email_verified == false`, and
- `fit >= 6`, and
- not flagged `do_not_contact` / `disqualified` / `catch_all_unverifiable`

**Never spend on `plus_verified: false`** — TermStack is Plus-only.

Rank: `plus_verified: true` first, then `plus_confidence: high`, then the rest. Sort by
`fit` descending within each band — if the ceiling bites mid-run it must bite on the weakest.

**Then ASK, before spending anything.** List every candidate with `plus_confidence: high`
and `plus_verified: null`, with its evidence, and ask the operator to confirm Plus:

```
2 candidates have high Plus evidence but are unverified:
  - konner-sohnen  checkout.konner-sohnen.com + b2b.konner-sohnen.com
  - fsaproshop     separate B2B storefront (wholesale.fsaproshop.com)
Confirm Plus on these before I spend searches?  (y / skip / mark false)
```

The answer persists to `plus_verified`, so each prospect is asked about ONCE, ever. This
puts the manual check on the 2-3 prospects that earned it instead of all 15, and stops
searches going to stores that turn out to be Basic.
Skip any domain the cache already marks `accept_all: true`; park it (Step 5) for free.

## Step 3 — research each candidate (free, no Hunter)
This is where most candidates die, at zero cost. Per prospect, ~2 min, same bar as
skills/research.md:
- a. domain resolves to the correct Shopify store (watch name collisions)
- b. Shopify Plus / native B2B confirmed — custom checkout domain, B2B portal, `/b2b` login
- c. a NAMED person maps verifiably to THAT company, against the playbook persona
     priority: Ecommerce Manager → Director/VP Ecommerce → Founder if <$5M →
     Head of Operations. **NEVER VP Marketing / CMO.**

Any of a/b failing → no Hunter call. Set `flags: ["contact_needed"]` or
`["plus_unverified"]`, or `status: "disqualified"` with the reason in notes.
Only prospects clearing a+b reach Step 4.

## Step 4 — one Hunter path per prospect, cheapest first
**Domain check first (free):** use `contact.email_domain` if set. The store domain is
not always the company's mail domain — konner-sohnen.com's people are on dimaxgroup.com,
and searching the wrong one returns nothing AND still consumes a search.

**Path A — name found in Step 3:**
`email-finder <domain> <first> <last>` — 1 credit, free on a miss.

**Path B — a+b passed but no name found:** `domain-search` with the tightest filter
first (free if it misses, and a miss still caches `pattern` + `accept_all`):
```
type=personal&decision_maker=true&required_field=full_name&verification_status=valid&department=executive,management,sales
```
On a miss, loosen ONCE — drop `verification_status` and `decision_maker`. Then stop.

**Path C — generic fallback, last resort only, after A/B fail:**
Do NOT use `domain-search?type=generic` — it bills 1 credit per generic email found.
Construct `wholesale@<domain>` locally (free) and `verify` it (0.5). If not `valid`,
try `sales@<domain>` (0.5). Stop after `max_generic_guesses` (2), so the fallback can
never cost more than the finder path it replaced.

## Step 5 — accept, or park
Acceptance is status-only, per engine/hunter/SKILL.md. Score only decides whether
0.5 is worth spending; it never grants acceptance.

- Final status **`valid`** → write `contact.email`, `email_verified: true`,
  `email_source: "hunter:<endpoint>"`, and a `hunter` block
  `{status, score, checked: <date>}`. Clear `contact_needed`. This prospect is now T1-eligible.
- `accept_all` domain → `flags: ["catch_all_unverifiable"]`, no verify spend, listed
  in the summary for your manual judgment. Never queued.
- `risky` / `unknown` / `invalid` / not found → keep `status: "not_contacted"`,
  `flags: ["contact_needed"]`, note what was tried so the next run does not repeat it.

**Nothing that is not `valid` ever enters the T1 queue.** `email_verified: true` means
exactly one thing: Hunter returned `valid`.

One prospect per write — temp file + atomic rename, per CLAUDE.md.

## Step 6 — close out
`run-end`, then update `hunter_credits.spent.termstack` in state/budget.json by the run
total. Write `outputs/enrich-<YYYYMMDD>/summary.md`:
- credits spent vs ceiling, verifies used vs ceiling, account balance left this month
- accepted (now T1-eligible), with email + status
- parked catch-all, needing your judgment
- researched-and-died, with the reason (free, but tells you the list is thinning)
- per-prospect credit cost

Then iMessage the condensed version to "Command Center" via `engine/imessage/send.sh`
(plain text, ~38 chars wide, no markdown).

## Hard rules
- Never send, never draft, never post. This skill only writes prospect files.
- Never call Hunter outside an open run.
- Never spend on a prospect that failed Step 3.
- If the run dies mid-way, `run-status` shows what was spent; prospect files already
  written are correct and the next run skips them.
