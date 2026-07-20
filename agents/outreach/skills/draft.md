# draft — create Gmail drafts for today's queue (GATE: drafts only, never send)

For each queue entry, build the email from the touch template
(`projects/<project>/templates/<touch>.md`) + the playbook voice rules + the
prospect file (evidence, angle, vertical, HQ currency). Then create a Gmail DRAFT.

## Mechanics
- T1: new draft, new thread, to the verified contact. Subject per template.
- T2 / T3: draft created as a REPLY in the prospect's `gmail.thread_id` (same
  thread, subject stays Re:). If the thread can't be found, do not draft a fresh
  thread — flag "thread missing" in the summary and skip.
- Apply the tracking label (`config.labels.track`) to the thread/draft.
- After creating: write `gmail.pending_draft_id` (+ thread id if new) into the
  prospect file, set `status: "drafted"` for T1s, and append
  `{prospect_id, touch, draft_id, subject}` to `outputs/or-<date>/drafts.json`.
- Idempotency: if the prospect already has a `pending_draft_id` for this touch,
  skip — never create a duplicate draft.
- One prospect fails (bad email, Gmail error) -> record it, continue the rest,
  list under SYSTEM in the summary.

## Content rules (the floor is CLAUDE.md house voice; playbook overrides)
- ZERO links in every touch. Links only inside threads where they replied.
- If the prospect file has a usable `sheet_draft` for this touch (imported from
  the old sheet), prefer it — human-reviewed material beats regenerating. Update
  names/dates if stale, keep the voice.
- Every T1 hook must be SPECIFIC to the prospect: their wholesale page, a B2B tool
  they use, a case study or app review they appear in (`evidence` field). Never a
  generic opener.
- UK/EU prospects: GBP/EUR amounts. US: USD. AU: AUD.
- Word budgets: T1 ~80, T2 ~55, T3 2-3 sentences. Hard tone rules in playbook.
