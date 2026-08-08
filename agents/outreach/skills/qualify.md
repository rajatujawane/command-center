# qualify — the intake gate (free, runs before anything else)

No prospect enters the pool unqualified. This is the fix for the 2026-08-08/09 finding:
**21 of 25 top-fit prospects carried wrong evidence** — dead stores, password-protected
stores, non-Shopify sites, and "wholesale" that was a JotForm or an ExpertVoice account.
Every one of those was catchable for free, before a single search was spent.

Costs nothing. No Hunter, no API. Run it liberally.

## The mechanical pass
```
agents/outreach/qualify.sh <domain>
```
Emits one JSON verdict. Write `qualified` (bool) and `qualify_verdict` (string) onto the
prospect file. Re-run when a prospect has not been checked in 60 days — stores close.

| verdict | meaning | action |
|---|---|---|
| `DEAD` | domain does not resolve, or HTTPS is broken | `status: disqualified`, `qualified: false` |
| `CLOSED` | store password-protected / unavailable / root 404 | `status: disqualified`, `qualified: false` |
| `NOT_SHOPIFY` | zero cdn.shopify.com references | `status: disqualified`, `qualified: false` |
| `OFF_PLATFORM_B2B` | third-party wholesale app detected | `qualified: false`, fit <= 4 |
| `NO_B2B_CHANNEL` | live Shopify, no wholesale surface anywhere | `qualified: false`, fit <= 3 |
| `REVIEW` | passed every mechanical check | `qualified: true`, then judge fit by hand |

**`REVIEW` is not a pass.** It means "worth two minutes of a person's time".

## Why each check exists (every one caught a real prospect)
- **TLS** — Shopify always terminates valid TLS. A handshake failure or hostname
  mismatch means it is not a Shopify-hosted storefront. Caught airtek, kitchensupply.
- **password redirect / "store is unavailable"** — caught neuro (password-protected)
  and uncle-jack (store closed, domain redirecting to a dead one).
- **cdn.shopify.com count** — caught biom, a Next.js site that was never Shopify.
- **third-party wholesale apps** (Wholesale Gorilla, SparkLayer, ExpertVoice, BSS,
  Wholesale Club) — B2B is not native AND most of these run on non-Plus plans.
  TermStack is Plus-only. Caught le-toy-van and laird-superfood.
- **B2B subdomain probe** — `wholesale.` / `b2b.` / `trade.` / `dealers.` resolving to a
  Shopify store with `customer_authentication` is the strongest native-B2B tell in the
  whole set. It is how fsaproshop was confirmed.
- **wholesale path probe** — do NOT judge by homepage links alone. The manual sweep on
  2026-08-09 wrongly downgraded hormbles-chormbles to fit 3 because the nav link did not
  match a homepage href regex, while `/pages/wholesale` was live the whole time. The
  path probe exists specifically because the human pass got this wrong.

## Fit, after a REVIEW verdict
- **8** — B2B subdomain on Shopify with `customer_authentication`, or a multi-segment
  trade program (trade + contract/hospitality + corporate), terms nowhere published.
- **6-7** — real wholesale page with a login or account gate; native-vs-app unconfirmed.
- **5** — wholesale exists but is an application form with no portal.
- **<= 4** — off-platform or no channel. Does not get contacted.

Terms published openly on the wholesale page is a NEGATIVE, not a positive: it means
they are already solved. The pitch needs terms settled by hand.

## Contact-domain trap
The email domain is not always the store domain. konner-sohnen.com is operated by DIMAX
Group and its people are on **dimaxgroup.com** — a Hunter search against the store domain
would have returned nothing and consumed a search anyway (a miss is not free). Before any
Hunter call, confirm which domain the company's staff actually use, from the site footer,
imprint / Impressum, privacy policy, or a published contact address. Record it as
`contact.email_domain` when it differs.

## Hard rule
`pick` must never queue a prospect whose `qualified` is not `true`. Unqualified prospects
are not "not yet researched" — they are known-bad until a probe says otherwise.
