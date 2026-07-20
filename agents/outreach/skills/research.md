# research — verify contact + Plus before any T1 (read-only web)

Only runs for prospects picked as NEW T1 targets that are missing a verified
contact or Plus confirmation. Budget ~2 minutes per prospect; this is a filter,
not an investigation.

## Persona priority (from playbook, in order)
1. Ecommerce Manager / Head of Ecommerce
2. Director / VP Ecommerce
3. Founder / CEO if the company is < $5M
4. Head of Operations
NEVER VP Marketing / CMO.

## The 60-second guard (all three or no T1)
a. Domain resolves to the correct Shopify store (watch name collisions — e.g.
   american-hospitalsupply.com WITH hyphen; the no-hyphen domain is unrelated).
b. The named person verifiably maps to THAT company (LinkedIn or site).
c. Shopify Plus confirmed: BuiltWith-type evidence, custom checkout domain,
   native B2B portal signals. Notes saying "VERIFY PLUS FIRST" mean exactly that.

## Outcomes
- All three pass -> fill `contact.named_person` / `contact.email` (mark
  `email_verified: false` unless a verified source), keep in today's queue.
- Any fail -> remove from today's queue, set `flags: ["contact_needed"]` (or
  `["plus_unverified"]`), keep `status: "not_contacted"`, list in the summary
  under "need contact research" with the row's Hunter and LinkedIn links.
  Pick does NOT backfill the slot with a weaker target mid-pass; short days are
  reported, not padded.
- Evidence of NOT Plus / D2C-only / dead business -> `status: "disqualified"`
  with the reason in notes.
