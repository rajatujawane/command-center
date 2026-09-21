# board — dispatcher (one routine run)
"start board" runs THIS. It does intake from Linear, hands each active task to its own worker
instance, then stamps one heartbeat. It never advances a task itself.

Read CLAUDE.md first. Everything project-specific lives in
`projects/<project>/config.json`. The dispatcher never touches a repo.

Every Linear call in this file is `engine/linear/linear.sh`. If `mcp__linear__*` tools are
available in your session, they are not for you — see CLAUDE.md. Using them breaks comment
dedupe and may silently return nothing in a routine session.

## 0. Brakes — check these before anything else
- `state/pause` exists -> claim nothing, advance nothing. Note it for the brief. Stop here.
  (Tasks already mid-flight are NOT force-stopped; they simply get no new run.)
- `engine/linear/linear.sh whoami` fails -> the board is unreachable. Do NOT claim new work
  from stale state. Advance already-active tasks only, then stop.

## 1. Drain answers FIRST, before intake

A task already claimed and waiting on me outranks a new card: it has a worktree, a session
and half a deliverable, and a new claim would sit behind it anyway at `max_active: 1`.

For every task in `tasks/active/` whose current step carries `blocked_on: "question: ..."`:

    engine/linear/linear.sh comments <id> <task.last_comment_check or .claimed_at>

Apply section 3a of `engine/replies/SKILL.md` exactly — same grammar, same
status-as-disambiguator rule, same duplicate handling, same ack that quotes the answer back.
Record `last_comment_check` on the task so the next tick reads from there.

This used to live only in `replies` at 30m. Doing it here means one wake covers answer +
resume: with the routine at 15m an answer is picked up in 15 minutes rather than 30, and
acted on in the same run rather than the next. `replies` still does it too — that is
harmless, because every action is keyed and idempotent, and it keeps answers flowing if this
dispatcher is ever paused.

## 2. Intake
    engine/linear/linear.sh ready

For each identifier returned, in order:
- `tasks/active/<IDENT>.json` or `tasks/done/<IDENT>.json` already exists -> ALREADY CLAIMED.
  Skip silently. This file check is the claim lock; there is no other one and none is needed
  while max_active is 1.
- CAPACITY. Count two different things, because they mean different things:

      agent-busy = tasks in tasks/active/ whose current step is NOT a gate and has NO
                   blocked_on. These are tasks the AGENT can act on right now.
      open       = every file in tasks/active/, whatever state it is in.

  `agent-busy >= meta.max_active` -> stop intake. Something is genuinely being worked on.
  `open >= meta.max_open`         -> stop intake, and flag it in the brief: too much is
                                     sitting on my desk, and claiming more would bury it.
  claims already made today >= `meta.max_claims_per_day` -> stop intake, flag it.

  A task parked at a gate, or waiting on an answer, is on MY desk — it is not consuming agent
  capacity and must NOT count toward `max_active`. Counting it means one unreviewed task halts
  every other project indefinitely, which is the opposite of what a queue is for.

  `max_open` is what stops the other failure: work piling up faster than I clear it. Hitting
  it is a signal to go and review, not a reason to raise the number.
- Otherwise claim it:
  1. `linear.sh get <IDENT>` -> read title, description, project, labels.
  2. RESOLVE THE PROJECT. The card carries Linear's DISPLAY name ("Preorder & Back in Stock");
     the config folder is a short key (`preorder`). They are not the same string and one is
     never derived from the other by lowercasing — resolve it by lookup:

         jq -r --arg p "<card project name>" 'select(.linear_project==$p) | .project' \
            agents/board/projects/*/config.json

     Exactly one key returned -> that is `<project>`, and `projects/<project>/config.json`
     is its config.
     Nothing returned (no project on the card, or no config claims that Linear project) ->
     do NOT claim. Comment `unroutable-<IDENT>`: "no project config on the mini for
     '<card project name>'". Flag in the brief. Leave the card Ready. Move on.
     More than one key returned -> two configs claim the same Linear project. Do NOT guess and
     do NOT claim; flag it. That is a config error and it must be fixed, not worked around.
  3. Write `tasks/incoming/<IDENT>.json` (temp file + atomic rename) carrying:
     `id`, `title`, `project` (the resolved KEY, not the display name),
     `linear_project` (the display name, for reading), `linear_url`,
     `controller: "agent"`, `claimed_at`, `brief_source` (the card description verbatim),
     and the steps from `agent.json` each with `status: "pending"`.
     Storing the key is what lets the worker do `projects/<task.project>/config.json`
     unchanged, exactly as content-blog does. The display name is never used as a path.
  4. Atomic-rename it into `tasks/active/`.
  5. `linear.sh status <IDENT> doing`
  6. `linear.sh comment <IDENT> claim-<IDENT> "Claimed by command-center. Run record: state/runs/<IDENT>.json"`

Write the file BEFORE moving the card. If the run dies between the two, the next run sees the
file, skips intake, and the card is corrected on the next report. The reverse order would lose
the claim.

## 3. Advance
List `tasks/active/`. Process ONE AT A TIME: launch a worker instance for the first task, let
it return, then the next. Each worker gets only CLAUDE.md, `agents/board/worker.md` and its
task id, and advances ONLY that task.

Skip any task whose `controller` is not `"agent"` — I have taken it over. Skip any task whose
current step carries `paused: true`.

## 4. Heartbeat
Append ONE row to the FLAT ARRAY in `state/heartbeat.json` (see CLAUDE.md — it is a plain
array of rows, not `{"runs":[...]}`):
    {agent:"board", ts, tasks_touched:<N>, claimed:[<idents>], ok:true, note:"<one line>"}
Workers NEVER write heartbeat — only the dispatcher does.

The heartbeat is the ONLY evidence a run happened. `replies` has zero rows despite being a
scheduled routine, and that is how nobody noticed it was not running. If you skip this line,
your run did not happen as far as anyone can tell.

Then `ops/heartbeat.sh` to ping the external watchdog. A run that got this far is a healthy
run, even if individual tasks blocked.
