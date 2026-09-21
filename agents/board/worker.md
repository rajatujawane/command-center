# board — worker (one task)
You were launched with a single task id (a Linear identifier, e.g. `VAR-37`). Process ONLY
that task. Read CLAUDE.md first.

0. Load the project config FIRST. Read `tasks/active/<id>.json`, take its `project`, read
   `projects/<project>/config.json`. Everything project-specific comes from there. A value you
   need that isn't in the config -> set `blocked_on: "missing config key <key> for <project>"`
   and stop. No `project` -> `blocked_on: "task has no project"`, stop.

   ATTEMPT LIMIT: `config.budget.max_attempts` if the project sets one, otherwise
   `meta.max_attempts` from agent.json. Project beats agent default — the same precedence as
   repo, delivery and test_cmd. It is defined in two places on purpose; read them in that
   order and never assume the agent default applies when a project has said otherwise.

   Then check, in this order, and stop immediately on any of them:
   - `state/pause` exists                 -> stop. No step runs.
   - task `controller` != `"agent"`       -> stop. I have taken this over.
   - current step has `paused: true`      -> stop.

1. Start at the first step whose status != "done". Run it, write status + out after it
   (temp file + atomic rename), and CONTINUE to the next step in the SAME run — until one of
   these stops you:
     - `work` returned `needs_input`      -> STOP. The question is on the card; I answer it.
     - `work` returned `blocked`/`failed` -> STOP.
     - you just completed `report`        -> STOP. `review` is a gate; it is mine.
     - any step sets `blocked_on`         -> STOP.

   Steps:
   - brief   -> skills/brief.md. Assemble the prompt from the card text, the project config
                and the knowledge root -> `outputs/<id>/brief.md`. Missing required inputs is
                NOT a reason to guess: it is a question, and it belongs to `work`, not here.
   - work    -> skills/work.md. One `claude -p` invocation in an isolated worktree. Parse the
                result contract. This is the ONLY resumable step: it may stay `pending` across
                runs while `attempts` increments, up to the attempt limit (see below).
   - report  -> skills/report.md. Push the outcome and evidence to the card, move it to
                Review (or Waiting for input / Blocked). Write the handoff.
   - review  -> GATE. Do not close the card. Do not merge anything. Stop and let me look.

2. Every stop, without exception, writes `outputs/<id>/handoff.md` first — see
   skills/handoff.md. The handoff is the contract, not the session id. If a session cannot be
   resumed later, the next run rebuilds from the handoff and says so. A run that stops without
   a handoff is a bug.

3. All steps done -> move the task file to `tasks/done/`, append a line to `tasks/log.md`.
   Do NOT move the Linear card to Done. I close my own cards.

## What this worker may never do
- Send an email, post to a platform, or merge to a production branch. Those are gates.
- Touch a repo outside `config.repo`, or any path outside its own worktree.
- Commit changes it did not make. `git add -A` is only ever run inside the task's worktree.
- Spend past `config.budget.max_minutes` or the attempt limit. Hitting either is a stop,
  not a retry.
- Write `state/heartbeat.json`. That is the dispatcher's.
