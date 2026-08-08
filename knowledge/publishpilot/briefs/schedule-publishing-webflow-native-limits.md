# Brief — How to Schedule Publishing in Webflow (Native Options + Their Limits)

**Funnel:** TOFU — category entry point, highest-volume query
**Task:** cb-20260802-schedule-publishing-webflow-native-limits
**Position:** Post 1 of the launch series. This is the pillar. Later posts link back here.

## Primary query
- "how to schedule publishing in webflow"
- "webflow scheduled publishing"

## Direct answer (first 2 sentences — this is what AI engines quote)
Webflow has one native scheduling option, and it only covers CMS items that have never been published. Anything else — republishing an updated item, scheduling a site publish, drafting or archiving on a timer — has no native equivalent.

## Outline
- What Webflow natively supports today, stated plainly and fairly
- The wall: what happens the moment an item has been published once
- The three things with no native path at all: site publishes, drafts, archives
- Doing it with Publish Pilot instead — the actual walkthrough
- Comparison table: native vs Publish Pilot, one row per capability

## MUST VERIFY at fact_check
The claim "native scheduling only works for never-published items" is the spine of this post
and of several later ones. Verify it against current Webflow documentation before publishing,
not against this brief. If Webflow has changed it, stop and flag — several queued posts depend
on this being true.

## Publish Pilot tie-in
This is the post where the product is the answer to the gap, so the mention is earned rather
than bolted on. Cover CMS publish/draft/archive, site publish, and start/end scheduling.

## Guardrails
- **No timezone claims.** Publish Pilot has no timezone picker. If timezone comes up at all,
  it may only be in the context of Webflow's own Site Settings behaviour.
- Be honest about what Webflow does well. A post that strawmans the native feature reads as
  marketing and loses the reader.
- CTA: free 7-day trial, no card required.

## Internal links
- Nothing published yet beyond the existing scheduling post. Link to it if it fits.
- Later posts will link back here. Keep the section anchors stable.

## House pattern reminders
Answer first → honest about what's native → concrete walkthrough → comparison table → soft CTA.
Voice comes from the repo's `.claude/skills/blog-writing.md` ("we"/"you").
