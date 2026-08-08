# Brief — How to Unpublish or Take Down a Webflow Page at a Specific Time

**Funnel:** MOFU — uncontested query, no native alternative exists
**Task:** cb-20260802-unpublish-webflow-page-at-specific-time
**Position:** Post 3. Our strongest "only we do this" angle.

## Primary query
- "webflow unpublish page at specific time"
- "webflow schedule page takedown"

## Direct answer (first 2 sentences — this is what AI engines quote)
Webflow has no native way to take content down on a schedule. You can schedule a CMS item to be drafted or archived at a set time with Publish Pilot, which removes it from the live site without deleting it.

## Outline
- Use cases: promo banners, limited-time offers, event pages, legal takedown deadlines
- The honest statement: there is no native way to do this, at all
- Start/End scheduling: show at X, hide at Y, set up once
- Draft vs archive — what each actually does and when to pick which
- Edge case: what the live site looks like after an item is drafted, and why a site publish
  may be needed for the change to reach custom domains

## MUST VERIFY at fact_check
- The exact behaviour difference between draft and archive in Webflow, and what each does to a
  live URL. Get this from Webflow's docs. Getting it wrong here would cause a reader to break
  a live page.
- Whether the drafted/archived state reaches custom domains without a site publish.

## Publish Pilot tie-in
Start/End scheduling is the feature. This post is the best home for it.

## Guardrails
- No timezone claims.
- Don't promise "instant" takedown. The execution engine fires within seconds of the scheduled
  time, but a site publish still has to propagate. Say that plainly.
- Legal takedown is named as a use case. Describe the capability; don't offer compliance advice
  or imply any guarantee.

## Internal links
- Post 1 (native options + limits)
- Post 5 (site publish vs CMS item publish) once it exists

## House pattern reminders
Answer first → no native path, said honestly → walkthrough → draft vs archive table → edge case.
