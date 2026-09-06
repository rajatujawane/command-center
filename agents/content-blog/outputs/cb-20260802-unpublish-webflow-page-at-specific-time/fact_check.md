# Fact check — cb-20260802-unpublish-webflow-page-at-specific-time

Verified the draft against the brief's MUST VERIFY items, the PRD, and Webflow's own docs.

## Core claims verified

1. **No native scheduled takedown.** Webflow's only native scheduling publishes a brand-new
   CMS item at a future time; there is no native scheduled draft/archive/unpublish/site-takedown.
   Consistent with Post 1 (native-limits) and Webflow docs. PASS.

2. **Draft vs archive behaviour (MUST VERIFY).** Confirmed against Webflow developer docs
   (developers.webflow.com/data/docs/working-with-the-cms/publishing) and Help Center summary:
   - Draft: keeps the item as a normal editable Collection item, marked to come off the live
     site. Not deleted.
   - Archive: "unpublishes items from your live site at the next full-site publish" and keeps
     them accessible in the CMS (separate archived list). Not deleted.
   - Both only take effect at the next full-site publish, not immediately. PASS.

3. **Drafted/archived state reaching custom domains (MUST VERIFY).** Confirmed: drafting or
   archiving does NOT reach the live site on its own. Webflow removes drafted/archived items at
   the next full-site publish, so the item stays visible on the live custom domain until a site
   publish runs. Draft asserts this plainly per the guardrail. PASS.

4. **Manual Unpublish is immediate and resets to draft**, and is not schedulable natively.
   Confirmed from Webflow docs. Draft notes this as distinct from draft/archive. PASS.

5. **Publish Pilot capabilities.** CMS item draft/archive scheduling, site-wide publish
   scheduling, and Start/End scheduling all present in PRD sections 3 and 7. OAuth + cloud
   execution confirmed. "Fires within seconds of the scheduled time" traces to PRD NFR
   (EventBridge fires Lambda within seconds). PASS.

## Guardrails honoured

- No timezone claim anywhere in connection with Publish Pilot (none mentioned at all).
- No "instant" takedown promise; propagation via site publish stated plainly.
- Legal takedown named only as a use case; capability described, no compliance advice or
  guarantee (added an explicit line that PP cannot advise on the requirement).
- Did not claim the draft/archive action auto-publishes the site; the walkthrough pairs it
  with a scheduled site publish, which matches PP's separate Site-Wide Scheduling action.
- Closing CTA uses generic "free trial" (PRD confirms trials exist) without quoting a
  specific trial length or card policy.

## Result

No unverifiable core claim. No blocker. Draft is factually clean; proceeding to build.
