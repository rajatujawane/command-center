# report — push the outcome back to the board

Takes what `work` produced and puts it where I will see it. Changes no code, runs no tests,
makes no decisions.

## Write the handoff first

Always. Before any network call. See `handoff.md`. If the push fails, the handoff is what
survives, and it is what the next run reads.

## Then push, by result

**ready_for_review**
    linear.sh comment <id> result-<id>-<attempt> "<summary + evidence links + tested revision>"
    linear.sh status  <id> review
    (no text — see "What is worth interrupting me for" below)

The comment MUST say what delivery actually happened, in these words, so the card never
implies more than exists:
    delivery=draft_pr -> "Draft PR: <url>"
    delivery=branch   -> "Pushed branch `board/<id>`. No PR."
    delivery=none     -> "Committed locally only. Not pushed, no PR."
A card that says "ready for review" with no PR, when the project expects one, is a failed
delivery step, not a finished task.

**needs_input**
    linear.sh comment <id> Q-<id>-<n> "<question>\n\nRecommendation: <...>\nThis blocks: <...>"
    linear.sh status  <id> waiting
    engine/imessage/send.sh "<config.notify.group>" \
      "<id> is waiting on you: <the question, one line>. Answer on the Linear card: <url>" 

**blocked / failed at the attempt limit**
    linear.sh comment <id> blocked-<id>-<attempt> "<what stopped it, what it needs>"
    linear.sh status  <id> blocked
    engine/imessage/send.sh "<config.notify.group>" \
      "<id> blocked: <one line>. <url>"

**completed** — comment the result, move to `review` anyway. I close my own cards.

## What is worth interrupting me for

Two things, and nothing else:

    needs_input   a task cannot continue without an answer from me
    blocked       it stopped, at the attempt limit or on something external

Those get an iMessage, because they are the only states where the machine is stalled until I
act. Everything else — claimed, working, ready for review, done — goes on the Linear card and
waits for me to look. Linear pushes to my phone for cards I am on, so a review is already
one notification; a text as well would be two notifications for one event.

A channel that reports everything gets muted, and then it reports nothing. Resist adding
"just this one more" notification.

## Always put the resume handle on the card

Every result comment ends with this block. Without it the card cannot be acted on from a
phone — the session id would live only on the mini, and "take this over" would mean SSHing in
to grep for it, which defeats the point of the board being the interface.

    ---
    Resume: `cd <worktree> && claude --resume <session-id>`
    Branch: `board/<id>` @ `<commit>`  ·  Handoff: `outputs/<id>/handoff.md`

Post it even when the task finished cleanly — the commonest reason to reopen something is
wanting a change after review, and that is exactly when the handle has to already be there.

If the worktree has been removed, say so on the line and point at the handoff instead:
the note is the contract, the session is the shortcut.

## Evidence

A link, never a blob. The card gets a pointer to `outputs/<id>/...`, the PR, the test output.
Never paste a diff, a log or a screenshot into a comment.

Evidence names the exact revision it came from. `tested at <sha>` is evidence; "tests pass" is
a claim. A test that never ran is not a test that passed — if a check was skipped, say which
and why, in the comment. A later commit invalidates the evidence above it.

## If the push fails

Do not retry in a loop and do not redo the work. Write the intended call to
`state/outbox/<iso>-<id>.json`:

    {"cmd":"comment","args":["VAR-37","result-VAR-37-1","..."],"attempts":1}

Mark the step done anyway — the work IS done; only the telling failed. The next dispatcher run
drains the outbox before intake. Delivery is retried; work never is.

## Hard limits
- Never move a card to Done.
- Never post the same key twice (linear.sh already refuses, do not work around it).
- Never notify about anything in `templates/`.
