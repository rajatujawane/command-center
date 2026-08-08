# Fact check — cb-20260802-schedule-publishing-webflow-native-limits

Checked draft.md against knowledge inputs (prd.md, brief) and, for the spine claim, against
current Webflow documentation as the brief required.

## Spine claim (MUST VERIFY per brief) — VERIFIED

**Claim:** Webflow's native scheduling only works for CMS Collection items that have never
been published; there is no native path to republish a live item, schedule a full-site
publish, or move an item to draft/archive on a timer.

**Verification:** Confirmed against current Webflow sources (Aug 2026):
- Webflow Help Center "Scheduled publishing" — only items that have never been published can
  be scheduled; if the Schedule option is missing, the item is or was previously published.
- Webflow Wishlist "Scheduled Publishing - Previously Published Items" (open idea) — confirms
  republish-on-a-schedule is NOT natively supported and is still a requested feature.
- Secondary guides (BRIX Templates, SAYU) corroborate.
The claim stands. No stop/flag needed. Several later posts depend on this; it is currently true.

## Other claims checked

- **Not available on Starter/Basic plans; runs in the cloud (no computer needed); item-level
  publish doesn't push other staged changes.** Consistent with Webflow docs and the existing
  vetted post `schedule-webflow-cms-item-to-publish-automatically.mdx`. Kept.
- **Native scheduled time follows the site's configured timezone in Site Settings, not a
  per-schedule timezone.** Verified by both web searches. Kept. (This is the only timezone
  mention, and it is about Webflow's own behaviour — compliant with the no-PP-timezone rule.)
- **A manual full-site publish doesn't cancel a scheduled item.** Corroborated by the existing
  published post that passed this same pipeline. Kept as a fairness point.
- **Publish Pilot capabilities** (publish/republish/draft/archive CMS items, full-site publish,
  start/end scheduling, connect once via Webflow OAuth, runs in cloud). All trace to prd.md
  section 7. Kept.
- **CTA: free 7-day trial, no card required.** Matches brief CTA instruction; trials (standard
  7 days) exist per prd.md section 8. Kept.

## Guardrail compliance
- No timezone claim made for Publish Pilot anywhere. ✓
- Native feature described fairly (three "does well" points), not strawmanned. ✓
- No em dashes, no exclamation marks, "we"/"you" voice. ✓

## Result
No inline corrections required. Draft is factually clean. Proceed to build.
