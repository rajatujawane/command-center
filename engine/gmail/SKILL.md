# gmail — drafts only, plus read-for-status
NEVER send. NEVER delete. Only create drafts and read.

## create drafts (gmail_draft step)
For each email in the previous step's artifact, create a Gmail DRAFT addressed to the
prospect, subject + body from the artifact. Record {prospect, draft_id} to
outputs/<id>/drafts.json. Do not send.

## read for status (check_inbox step)
Read the latest inbox + Sent (last ~7 days). For each tracked draft:
- if the matching message now appears in Sent -> mark that prospect "sent" in the task,
  and create a follow-up task in incoming/ with advance_at = sent_date + 4d.
- if there is a reply from the prospect -> mark "replied", capture a one-line gist for the brief.
Update the task file. Never send or reply automatically.