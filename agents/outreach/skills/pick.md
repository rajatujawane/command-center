# pick — build today's queue (follow-ups first, then new T1s)

Runs after reconcile, so all dates are real. Output: `outputs/or-<date>/queue.json`,
an ordered list of `{prospect_id, touch, reason}`.

## 1. Due follow-ups (always first, any day of week)
A prospect is due for its next touch when ALL of:
- `status == "in_sequence"`, no reply, no `hold` flag, no pending unsent draft
  for this touch already in Gmail (idempotency — never draft the same touch twice).
- The clock expired:
  - t2 due: today >= t1.sent + `cadence_days.t2_after_t1`
  - t3 due: today >= t1.sent + `cadence_days.t3_after_t1`
    AND today >= t2.sent + `cadence_days.min_gap_between_touches`
    (a late T2 pushes T3 — never two touches closer than min_gap)
Follow-up capacity depends on the day:
- On a T1 day (`t1_send_days`): `min_new_t1_per_day` slots are RESERVED for new
  T1s. Follow-ups get at most `hard_ceiling_per_day - min_new_t1_per_day` slots
  (8 - 3 = 5), oldest-due first; the rest carry to tomorrow (flag in summary).
- On a non-T1 day: follow-ups get up to `hard_ceiling_per_day`, oldest-due first.

## 2. New T1s (only if today is in `t1_send_days`)
Queue guard first: count our unsent drafts sitting in Gmail (tracked via
`pending_draft_id`). If >= `max_pending_drafts` -> ZERO new T1s today, say so in
the summary ("N drafts awaiting review, holding new outreach"). Follow-ups above
still go through.

If the guard passes, pick new T1 targets:
- Eligible: `status == "not_contacted"` (or "drafted"/"queued" imports with a usable
  draft), no exclusion below.
- HARD EXCLUSIONS — never pick: replied, call_booked, customer, do_not_contact,
  disqualified, warm_install, hold flag, bounced without a new email, dropped less
  than `reapproach_after_days` ago, notes containing a do-not-contact-before date
  that has not passed, notes saying RAJAT TO CONFIRM, Plus unverified (that goes to
  research first), D2C-only stores.
- Order: SAM tier A first, then highest `fit`. Read the prospect's `notes` before
  queuing — ambiguous history means skip and flag, not queue.

How many: AT LEAST `min_new_t1_per_day` (the reserved slots — follow-up volume
never eats them; only the queue guard or an empty eligible pool can). If
follow-ups used fewer than their share, fill spare capacity with more T1s up to
`max_emails_per_day` total for the day, never past `hard_ceiling_per_day`.
Fewer eligible targets than the minimum -> queue what is real, never pad; add a
"pool low" warning to the summary when untouched eligible prospects < 15
(suggest a mining session per playbook).

## 3. Order inside the queue
1. Due follow-ups, oldest due first.
2. New T1s, tier A then fit.
Each entry gets a send-window hint from the prospect's HQ (see playbook) — purely
informational text for the summary; nothing is scheduled.
