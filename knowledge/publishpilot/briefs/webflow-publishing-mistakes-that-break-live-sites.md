# Brief — 5 Webflow Publishing Mistakes That Break Live Sites

**Funnel:** TOFU — listicle, wide reach, strong internal-link hub
**Task:** cb-20260802-webflow-publishing-mistakes-that-break-live-sites
**Position:** Post 7 in publish order. Links out to almost every other post in the series.

## Primary query
- "webflow publishing mistakes"
- "webflow accidentally published changes"

## Direct answer (first 2 sentences — this is what AI engines quote)
Most Webflow publishing accidents come from the same few places: a site publish that shipped unfinished designer work, an edit to a live CMS item that was never republished, or a publish that only reached the staging subdomain. None of them are obvious until the site is already wrong.

## Outline
Five mistakes. Each one: what happens, why it happens, how to avoid it, and how scheduling
helps if it does.

1. Site-publishing half-finished designer work
2. Publishing only to the `.webflow.io` subdomain and forgetting custom domains
3. Editing a live CMS item and not realising it needs a republish
4. Taking content down manually and forgetting, so an expired offer stays live
5. No record of who published what and when — the audit log angle

## Replacement for the original mistake #2
The original outline had "timezone confusion (scheduled 9 AM — whose 9 AM?)" as a mistake.
**Cut it.** Publish Pilot has no timezone picker, so raising the question invites the reader to
look for a feature that doesn't exist, and any answer we give reads as a claim. It has been
replaced above with the expired-offer mistake, which is real, uncontested, and links naturally
to post 3.

## Verified facts
- Audit log records `EXECUTION_STARTED`, `EXECUTION_COMPLETED`, `EXECUTION_FAILED` with
  timestamps and error detail. Run history is also kept per schedule.
- **Do not make retention length a selling point.** The marketing site says 14/60/90 days by
  plan, but the code writes a flat 90-day TTL regardless. This is unresolved (see the open
  items in `knowledge/publishpilot/prd.md`). Describe that a record exists; don't quote a
  retention number.

## Guardrails
- No timezone claims anywhere in this post, including in the intro.
- Mistakes 1-3 are claims about Webflow's behaviour and must be verified at fact_check.

## Internal links
Link each mistake to its deep-dive: 1 and 2 → post 5, 3 → post 2, 4 → post 3, 5 → post 4.

## House pattern reminders
Answer first → five sections, same shape each → how-to-avoid is the payoff, not the CTA.
