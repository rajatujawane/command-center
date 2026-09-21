# takeover — pick a task up yourself, and give it back

Two writers on one workspace lose edits. The point of this file is that there is only ever
one, and that the changeover is explicit at both ends.

Controller lives on the task as `controller`: `"agent"` or `"human"`. Intake and the worker
both skip anything that is not `"agent"`.

## Taking over

1. Set `controller: "human"` on the task (temp file + atomic rename).
   From this moment nothing claims it and no worker advances it.
2. Confirm no run is live: check `state/runs/<id>.json` has an end time, or that no `claude`
   process holds that session. **A lease that expired is not a process that stopped.** If a
   run may still be live, stop it and confirm before writing anything.
3. `linear.sh status <id> human`
4. Work in the task's own worktree. The path and session id are on the LINEAR CARD, in the
   resume block of the latest result comment — that is the point of putting them there. The
   local `state/runs/<id>.json` holds the same values if you are already on the mini:

       cd <worktree>
       claude --resume <session-id>

   Then `/remote-control` in that interactive session to carry on from a phone.
   `claude -p` is not a Remote Control session. Verify this path by hand before building any
   one-click version of it; if it doesn't work on this machine's version, the fallback is the
   handoff plus a normal terminal, and that is fine.

## Giving it back

1. Commit or stash your changes in the worktree. Nothing uncommitted survives a handover.
2. Update `outputs/<id>/handoff.md` yourself — what you changed, what you did not finish,
   what the agent should do next. The agent reads this, not your session.
3. `controller: "agent"`, `linear.sh status <id> ready`.

**Disconnecting is not handing back.** A closed laptop, a dropped phone, a dead battery: the
task stays `human`, and stays untouched, until you say otherwise. That is the correct
behaviour — the alternative is automation resuming into your half-finished edits.
