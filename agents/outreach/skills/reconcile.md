# reconcile — sync prospect state from Gmail (read Gmail, write prospect files)

Runs first, every pass. Gmail is ground truth for what actually happened; prospect
files are ground truth for everything else. Never send, never delete, never modify
any email. Reads only, plus applying/removing OUR labels is allowed.

## 1. Detect sends
For every prospect with `gmail.pending_draft_id` set (a draft we created earlier):
- Search Sent for a matching message (same recipient + subject, or the thread id).
- Found in Sent -> the touch went out. In the prospect file: set
  `touches.<tN>.sent = <actual sent date from Gmail>`, store `gmail.thread_id`,
  clear `pending_draft_id`, set `status: "in_sequence"`.
  Follow-up clocks anchor to THIS date — a late send shifts T2/T3 automatically.
- Still sitting in drafts -> compute its age. Older than `draft_stale_days` ->
  add to the "waiting on you" list for the summary. Do not delete or refresh
  without being asked.
- Draft gone AND not in Sent (Rajat deleted it) -> clear `pending_draft_id`, note
  `"draft discarded <date>"` in the prospect, do NOT recreate it automatically;
  list under "discarded" in the summary.

## 2. Detect replies
For every prospect with a `gmail.thread_id`: check the thread for any message FROM
the prospect newer than our last touch.
- Reply found -> `status: "replied"`, record `replied_at` and a one-line gist in
  the prospect file. All future touches for this prospect stop permanently.
  Flag ⚡ in today's summary. Do NOT draft a reply (on-demand only).
- Bounce/auto-reply (mailer-daemon, out-of-office): bounce -> `flags: ["bounced"]`,
  status back to `not_contacted`, contact email marked bad; out-of-office -> ignore,
  cadence continues.

## 3. Control labels (Rajat's steering channel)
Search threads carrying each control label from `config.labels`:
- `reject` -> `status: "do_not_contact"`. Permanent. Never appears in any queue again.
- `hold`   -> add `"hold"` to flags. Cadence clock freezes (pick skips it). When the
  label is removed, drop the flag and resume where it left off.
- `later`  -> `status: "dropped"` with `dropped_at = today`, note "parked by label".
  Re-enters the eligible pool after `reapproach_after_days`, new thread, new angle.
Leave the labels in place (they are Rajat's record); just mirror them into the files.

## 4. Auto-drop
Final touch (t3) sent, no reply, and today > t3.sent + `drop_after_final_touch_days`
-> `status: "dropped"`, `dropped_at = today`. Count these for the summary ("closed N").
Never any 4th email.
