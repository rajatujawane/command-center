# handoff — the note that outlives the session

Every stop writes `outputs/<id>/handoff.md`. No exceptions, including crashes you can still
write from, including `failed`.

**The handoff is the contract. The session id is an optimisation.** Sessions expire, get
pruned, or vanish with a reinstall. The note does not. A system whose recovery depends on a
transcript surviving is a system that loses a night's work the first time one doesn't.

So: resume tries the session id, and falls back to this file. Both paths must work. Test the
fallback path deliberately, because it is the one you will need at the worst moment.

## Shape

```markdown
# <id> — <title>
Run <n> · <iso> · session <sid> · worktree <path>

## Where it stands
<two or three sentences. What is true now, not what was attempted.>

## Done
- <thing>  — proof: <path or sha or url>

## Changed
<files touched, and the branch. "nothing" is a valid and useful answer.>

## Proven
<what was actually run, and against which revision. Name what was NOT run.>

## Uncertain
<what I am not sure about. Guesses belong here and nowhere else.>

## Next
<the single next action, concrete enough to start from cold.>
```

## Rules

Write it so a stranger could pick the task up. Six weeks from now you are that stranger.

- "Uncertain" is not optional. An empty Uncertain on a non-trivial task means it wasn't
  examined. Certainty that was never tested belongs here, not in "Proven".
- "Proven" names the revision. Without a sha it is a claim, not proof.
- "Next" is one action, not a plan. If the next action is "ask Rajat", the result was
  `needs_input` and the question is already on the card.
- Overwrite the previous handoff; the history is in git. The current file is always the
  current truth.
