# Fact check — cb-20260802-schedule-blog-posts-webflow-step-by-step

Checked draft.md against knowledge inputs (prd.md, brief) and, for the Webflow-behaviour
claims, against current Webflow documentation (Aug 2026).

## Spine claim (per brief) — VERIFIED

**Claim:** You can natively schedule a Webflow blog post (CMS Collection item) to publish at a
set time, but only if it has never been published before; there is no native way to schedule a
republish of a live item or a full-site publish.

**Verification:** Confirmed against current Webflow sources and consistent with the already-
vetted sibling post `schedule-publishing-webflow-native-limits.mdx` (same pipeline, passed
fact_check on 2026-08-03):
- Webflow Help Center "Scheduled publishing" — only never-published Collection items can be
  scheduled; the Schedule option is absent once an item has gone live.
- Webflow forum + updates — republish-on-a-schedule and scheduled full-site publish are not
  natively supported.
Claim stands.

## This post's differentiating claims

- **Scheduled item publish moves only that one item, not other staged site changes.** Verified
  via Webflow docs (a scheduled CMS item publish pushes just that item; unrelated staged design
  changes stay on staging). This is the basis for the "site publish people miss" section. Kept.
- **Destination domains are chosen in the schedule dialog; select the production custom domain
  to reach real visitors.** Verified — the native schedule/publish modal lets you pick which
  domains (staging subdomain and/or custom production domain) to publish to. Kept.
- **A full-site publish cannot be scheduled natively.** Same spine source. This is what makes
  the "two schedules, one outcome" pairing a Publish Pilot capability, not a native one. Kept.
- **Scheduling not available on Starter or Basic Site plans; a paid Site plan is required to
  publish to a custom domain.** Consistent with the vetted sibling post and Webflow plan docs
  (custom domain requires a paid Site plan). Reworded during fact_check to match the vetted
  wording ("Starter or Basic Site plans") rather than "free Starter plan only". Kept.
- **Native scheduled time follows the site's configured timezone in Site Settings, not a
  per-post timezone.** Verified. This is the only timezone mention and is about Webflow's own
  behaviour — compliant with the no-Publish-Pilot-timezone rule.

## Publish Pilot capability claims — trace to prd.md section 7

- Republish / draft / archive CMS item on a schedule, schedule a full-site publish, start/end
  scheduling, connect once via Webflow OAuth, runs in the cloud. All in prd.md section 7. Kept.
- **Calendar view of all scheduled publishes.** prd.md section 7 lists "Calendar view of all
  upcoming schedules". Kept.
- No timezone capability claimed for Publish Pilot anywhere. ✓
- No invented product screenshots or unconfirmed UI. Walkthrough is numbered prose; the one
  body image will be a diagram produced by blog-image (per brief guardrail). ✓

## CTA
- "Free 7-day trial, no card required" — matches the brief CTA convention and the vetted
  sibling post; standard 7-day trial exists per prd.md section 8. Kept.

## Guardrail compliance
- No timezone claim for Publish Pilot. ✓
- No fabricated screenshots. ✓
- No em dashes, no exclamation marks, "we"/"you" voice. ✓ (only markdown table separators and
  the closing horizontal rule use hyphens)

## Result
No unverifiable core claim. One wording alignment applied inline (plan requirement). Draft is
factually clean. Proceed to build.
