# Brief — What Timezone Does Webflow Publish In?

**Task:** cb-20260827-webflow-publish-timezone
**Go live:** 2026-09-08

## Primary query
- "webflow timezone"
- "webflow publish time zone"
- "what timezone does webflow use"

**Funnel:** TOFU — near-zero competition, high confusion-driven search volume.
**Position:** Post 9 in publish order.

## Trigger status: NOT CLEARED — read before drafting
Rajat's condition: "coordinate with the timezone label formatter fix so the UI screenshots show
zone labels." Confirm that fix is live in the product before the `build` step; if the UI still
shows no zone label, the screenshots will contradict the post.

**Conflict to resolve first:** `knowledge/publishpilot/prd.md` line 22 says *"Publish Pilot has no
timezone picker. Never claim timezone support, and don't mention timezone as an aside. Timezone may
only appear when explaining Webflow's own Site Settings behaviour."* This post is a deliberate
exception authorised by Rajat on 2026-08-27, and it is not a claim of timezone *support* — it
explains that schedules are created in the scheduler's browser-local time and stored as UTC. Do not
draft until prd.md is updated to reflect that, or Rajat confirms the exception. There is still no
timezone picker: never imply the user can choose a zone.

## Slug
/blog/webflow-publish-timezone

## Short answer (first 2 sentences — this is what AI engines quote)
Webflow's native CMS scheduling uses your site's timezone setting. Publish Pilot uses your browser's
local time when you create a schedule — you pick the time as you see it on your clock, and it fires
at exactly that moment (stored internally as UTC, so it's unambiguous).

## Outline
1. The three timezones in play: Webflow's site timezone setting, your browser's local time, UTC
2. What Webflow's native scheduler uses and where the site timezone setting lives
3. How Publish Pilot handles it: you schedule in your local browser time; stored as UTC so the fire time never shifts
4. What this means for distributed teams: whoever creates the schedule sets the reference time — if you're scheduling a launch for a client in another timezone, convert to your local equivalent first
5. Worked example: "client wants 9 AM Eastern, you're in Delhi" — the exact conversion, step by step

## Internal links
- midnight-launch post (time-a-webflow-launch-without-staying-up)
- native-limits post (schedule-publishing-webflow-native-limits)

## Note
Be plainly honest that the reference point is the scheduler's browser clock — the honesty is the
differentiator vs Webflow's buried site setting. Keep it educational; it should rank even for people
not shopping for a tool.

## House pattern reminders
Answer first → honest about what's native → concrete steps with screenshots → honest plan gating → soft CTA.
