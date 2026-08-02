# TermStack outreach — Tue 21 Jul 2026

## Gate status
Drafts only. Nothing was sent. 5 Gmail drafts created, all awaiting review.

## Phase 1 — reconcile (Gmail is ground truth)
Read Sent, Inbox, Spam, and all control labels. **No prospect state changed** —
every recorded send date already matched Gmail exactly.

- **0 replies.** Nothing inbound from any of the 14 prospect threads. Inbox holds
  only Google system mail.
- 0 bounces, 0 spam-folder hits, 0 auto-replies.
- Control labels (reject / hold / later): all empty, nothing to mirror.
- 0 tracked pending drafts, so the queue guard passed (0 < 6).

## Phase 2 — pick
Tue is a T1 day: 3 slots reserved for new T1s, leaving 5 of the 8 hard-ceiling
slots for follow-ups. **13 follow-ups were due**, so 8 carry to tomorrow.

Selected oldest-due first. The four T3s were unambiguous. The 5th slot was a
four-way tie at due date 2026-07-19; broken first on fit (cocofloss drops at 8),
then among the three fit-9 peers on earliest actual send timestamp, which gives
Filtrous (17:00:59Z vs CarBahn 17:11, memobottle 17:19).

## Phase 3 — research (the blocking finding)
**Not one prospect in the 63-row untouched pool has a usable contact.** 62 have a
completely empty email field; the 1 exception (Sweet Water Decor) is an unverified
generic `wholesale@` inbox on a row whose own notes say "VERIFY PLUS FIRST".

So all 3 T1 slots were gated on research. Results:

- **ULE Group — all three guards PASS, blocked only on an address.** Domain
  confirmed `ulegroup.com` (Plus, custom `account.ulegroup.com`, `buyer_flags`
  JWT = native B2B). Wholesale electrical distributor, ~$18.6M. Named person
  Denise M. Foley, EVP of eCommerce, verified via Shopify's own case study and
  LinkedIn. Correct persona tier, not marketing. Only `contact@ulegroup.com`
  (general inbox) is published. **Held rather than cold-emailing a generic inbox
  while domain reputation is still recovering.** Get her direct address and this
  is the strongest T1 in the pool.
- **Death Wish Coffee — Plus and wholesale PASS, persona FAIL.** The DTC ecommerce
  seat has been vacant since Sep 2023; the only verifiable ecom title owns Amazon,
  not Shopify. Marketing roles excluded per playbook. No published email. Flagged
  `contact_needed`. Useful wedge if a contact appears: their wholesale still runs
  on the old separate-storefront pattern, not native B2B.
- **Merz b. Schwanen — DISQUALIFIED on product fit.** (Report landed after the pass
  closed and after the iMessage went out; folded in here, prospect file updated, a
  correction was sent.) Their wholesale does not run on Shopify at all:
  `b2b.merzbschwanen.com` and the US equivalent are nginx + Odoo with NuOrder. Only
  the D2C storefront is Shopify, and Plus is contradicted rather than merely
  unproven (no custom checkout domain, no `shopify_plus` markers, no Plus-only B2B
  objects, case study never says Plus). TermStack has nothing to attach to.
  Secondary fail: the correct persona is published as a first name only
  ("Matthias", Senior eCommerce Manager), and the CEO fails the &lt;$5M gate.
  Do not re-approach unless they migrate wholesale onto Shopify.

No T1 was padded with a weaker target, per the skill's "short days are reported,
not padded" rule. **3 T1 slots went unused.**

## Phase 4 — draft (5 created, 0 sent)
All are replies inside the existing thread, zero links, playbook voice.
Each T3 carries one angle not used in that thread's T1 or T2.

| Prospect | Touch | New angle | Window |
|---|---|---|---|
| American Hospital Supply | T3 final | credit exposure on new reseller accounts | US 6:30-9:30pm IST |
| Elite Truck | T3 final | dealer tiers policed per order | US 6:30-9:30pm IST |
| Montana West | T3 final | preseason buy volume spike | US 6:30-9:30pm IST |
| WBC | T3 final | first order risk, new trade accounts (GBP) | UK 1:30-3pm IST |
| Filtrous | T2 | three rules + university purchase orders | US 6:30-9:30pm IST |

Four of these are FINAL touches. No reply within 7 days of sending auto-drops
American Hospital Supply, Elite Truck, Montana West and WBC.

## Deliverability — read before sending any of these
SPF and DMARC verified live today via dig:
`v=spf1 include:_spf.google.com ~all` and `v=DMARC1; p=none;`.

But **the seed test has still not been run**, and the hold from 2026-07-20 was
conditioned on it passing. The 0-replies-across-14-threads result is exactly what
a spam-placement problem looks like, and every one of those 14 went out while SPF
and DMARC were still missing. Worth noting the four T3s above are last-chance
emails: spending them on a domain that may still be filtered burns the prospect.

Recommendation: run the seed test to rajatserver29@gmail.com first, confirm
inbox placement with SPF/DKIM/DMARC all PASS in "Show original", then send.

## System
- Untracked stale draft in Gmail: "TermStack Cold Outreach – Email #1 (Template)"
  from Jul 16, Russell Hendrix content, 5 days old. Not created by this system and
  not tracked by any prospect file. Left untouched.
- Pool depth is fine at 63 rows (no pool-low warning); contact coverage is the
  bottleneck, not list size.
