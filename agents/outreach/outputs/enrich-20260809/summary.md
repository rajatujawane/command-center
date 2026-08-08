# TermStack — free research sweep, 2026-08-09

## Cost
ZERO Hunter quota. 18 searches / 36 verifications still available, reset 2026-08-15.
Method: HTTP fetch of each storefront + trade page, checking domain resolution, TLS,
cdn.shopify.com density, installed app extensions, wholesale/trade/dealer links, and
customer_authentication signals.

## Scope
17 candidates (fit >= 6, not_contacted, no verified email), excluding the 4 already
resolved in yesterday's enrich run.

## Result: 21 of 25 top-fit prospects were mis-scored
Only 4 of the original fit-7/8 pool survive as genuinely strong. Combined with
yesterday's run, 21 of 25 carried wrong or unverifiable evidence.

### Disqualified — 4 (hard evidence)
- **airtek** (7 -> 0) — HTTPS fails TLS handshake (curl 35). Not a live Shopify storefront.
- **kitchensupply** (6 -> 0) — HTTPS cert does not match hostname (curl 60). Same.
- **biom** (6 -> 0) — Next.js site, noindex/nofollow, off-grid homes. Not Shopify, not wholesale.
- **neuro** (6 -> 0) — store is password-protected (in.getneuro.com/password). Not trading.

### Downgraded to 3 — 6 (no wholesale channel at all)
hyperlite-mountain-gear (8), hormbles-chormbles (8), ocb-usa-republic-brands (7),
happ-e-rides (7), sanzo (7), bruvi (6). No wholesale/trade/dealer/stockist link anywhere
on the homepage and no B2B app installed. Nothing to sell terms into.

### Downgraded — 1
- **laird-superfood** (8 -> 4) — wholesale runs on ExpertVoice, off Shopify checkout.

### Survivors, ranked
1. **jonathan-adler** (7 -> 8) — STRONGEST. Live Shopify, customer_authentication +
   /account/login, multi-segment trade: /pages/trade-services, /pages/wholesale,
   Contract & Hospitality, Corporate Gifting, B2B Services, hosted B2B_Catalog.pdf.
   Terms nowhere published = settled by hand. Exactly the pitch.
2. **fsaproshop** (8) — native B2B confirmed yesterday, but Hunter has no data on the
   domain. Manual LinkedIn only. Do not spend another search here.
3. **konner-sohnen** (7) — German (DIMAX Group, EUR), /pages/for-dealers, application-only,
   advertises "verschiedene Zahlungsbedingungen" settled off-platform. Real pain.
   **Corporate email domain is dimaxgroup.com, NOT konner-sohnen.com** — a Hunter search
   against the store domain would return nothing and waste a search.
4. **quad-lock, immi, elavi, bequet-confections** (6) — live stores with some wholesale
   surface, but application forms rather than portals. Second tier.

## Where the 18 remaining searches should go
Only 3 prospects justify a search, and only after a named person is found on LinkedIn:
jonathan-adler, konner-sohnen (**dimaxgroup.com**), and the second tier if they clear.
That is ~3-6 searches, not 18. The constraint is no longer quota — it is that most of
the pool has no B2B channel to sell into.

## The real finding
The bottleneck was never contact data. It is that the not_contacted pool was built on
unverified evidence: dead stores, password-protected stores, non-Shopify sites, and
"wholesale" that turns out to be a JotForm or an ExpertVoice account. Sourcing needs to
change upstream — qualify on a live B2B channel BEFORE a prospect enters the pool.

## System
0 quota spent · 17 prospect files updated (atomic) · 0 drafts · 0 sends.
