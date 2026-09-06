# Brief — Get Slack Notifications When Your Webflow Site Publishes

**Task:** cb-20260827-slack-notifications-webflow-publish
**Go live:** 2026-09-11

## Primary query
- "webflow slack notification"
- "webflow publish notification"
- "know when webflow publishes"

**Funnel:** BOFU — launch announcement for outbound webhooks / Slack.
**Position:** Post 10 in publish order.

## Trigger status: CLEARED
Rajat's condition was "publish same day webhooks ship (with the Business repricing)".
`knowledge/publishpilot/prd.md` records outbound webhooks and the named Slack / Zapier / custom
webhook integrations as **shipped**, with the Business pricing table in place. Verify against
prd.md, not against this line, before drafting.

## Slug
/blog/slack-notifications-webflow-publish

## Short answer (first 2 sentences — this is what AI engines quote)
Webflow doesn't notify you when a publish succeeds or fails. Publish Pilot's Slack integration posts
to a channel of your choice on every scheduled execution — success or failure — so you're not
refreshing the live site to check.

## Outline
1. The trust problem: scheduled publishing only works if you know it worked (especially overnight/off-hours)
2. Agency angle: a #client-sitename channel per client; proof-of-work without logging in
3. Setup: connecting Slack, choosing events, using the "Send test event" button
4. Failure notifications: what the error payload tells you and what to do
5. Brief mention of Zapier/generic webhook option for non-Slack teams

## Verified facts (from prd.md — re-check at draft time)
- Webhooks are **paid Business tier only**. Trials are deliberately excluded — they are the feature
  that justifies the Business price. Say the gating plainly, don't bury it.
- Named integrations on the marketing site are Slack, Zapier, and custom webhook.
- Failure handling is exponential-backoff retry plus a record in the audit log and run history.
  There are no execution-result emails — email is wired for workspace invites only.

## Guardrails
- No timezone claims.
- Don't promise notification channels that don't exist (no SMS, no email on execution results).

## Internal links
- midnight-launch post (time-a-webflow-launch-without-staying-up)
- agencies post (agencies-multiple-client-webflow-sites)
- recurring post (recurring-publishing-webflow-daily-weekly-monthly)

## House pattern reminders
Answer first → honest about what's native → concrete steps with screenshots → honest plan gating → soft CTA.
