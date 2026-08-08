# Brief — Recurring Publishing in Webflow: Daily, Weekly, and Monthly Schedules

**Funnel:** BOFU — shipped feature, no competitor content
**Task:** cb-20260802-recurring-publishing-webflow-daily-weekly-monthly
**Position:** Post 8 in publish order.

## Trigger status: CLEARED
The original list marked this "publish when the feature ships". It has shipped — recurrence is
live on `main` (`schedule-manager` validates it, `computeNextScheduledAt` drives it). Safe to
write. Verify against `knowledge/publishpilot/prd.md`, not against the original outline.

## Primary query
- "webflow recurring publishing"
- "webflow schedule weekly publish"

## Direct answer (first 2 sentences — this is what AI engines quote)
You can set a Webflow publish to repeat daily, weekly, or monthly with Publish Pilot, instead of creating a new schedule every time. Webflow has no native recurring publishing of any kind.

## Outline
- Use cases: a weekly newsletter archive, daily deal pages, monthly report drops
- Setting one up: pick the cadence, pick the content, done
- The four cadences: daily, weekly, monthly, custom
- How executions count against your plan — the maths readers actually want
- What happens when a run fails

## Verified facts (from knowledge/publishpilot/prd.md, reconciled 2026-08-02)
- Cadences are exactly **DAILY, WEEKLY, MONTHLY, CUSTOM**.
- **Recurring requires Pro or above.** Free trials also get it (all three trial variants).
  Starter does not. Say this plainly — it's a paid-tier feature and hiding it wastes the
  reader's time.
- **Recurring is NOT supported for HTML element content.** The API rejects it outright. This
  must appear in the post; a reader who tries it will hit an error.
- Every run counts as one execution. Plan limits: Starter 100, Pro 500, Business 1,200 per
  month. A daily schedule is ~30 executions/month — work a real example.

## Correction to the original outline
The outline said failures produce "retry + email notification". **Execution-result emails do
not exist.** Email is wired up for workspace invites only. On failure you get exponential
backoff retry, plus a record in the audit log and run history. Write it that way.

## Guardrails
- No timezone claims. A recurring schedule is the most tempting place to slip one in ("runs at
  9 AM your time"). Don't.
- Don't describe recurrence options beyond the four above.

## Internal links
- Post 1 (native options + limits)
- Post 10 (editorial calendar) — recurring is how a calendar runs itself

## House pattern reminders
Answer first → cadences → the plan-limit maths with real numbers → honest gating → soft CTA.
