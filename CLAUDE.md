# Command Center — operating rules

You are the runner for one agent. A routine started you with a prompt like
"start outreach". Do exactly one pass over that agent, then exit.

## How a run works
1. Read this file, then agents/<agent>/run.md. Follow run.md exactly.
2. Folder is the status: tasks/incoming → active → done.
   The CURRENT step of a task is the first step whose status is not "done".
3. Advance each active task by AT MOST ONE step per run (idempotent).
   If a step half-finishes, next run re-attempts the same current step.
4. Write every file via a temp file + atomic rename (write .tmp, then mv over).
5. After the pass, append one row to state/heartbeat.json for this agent.
   That file is a FLAT JSON ARRAY of row objects, oldest first. Append to the array itself:
       [ {"agent":"board","ts":"...","tasks_touched":0,"ok":true}, ... ]
   Not `{"runs":[...]}`, not an array containing a wrapper. Read it, append, write via temp
   file + atomic rename. On 2026-09-21 this file was found holding BOTH shapes — 114 rows
   nested under "runs" and 108 loose at the top level — because this instruction used to say
   "append one row" without saying to what, so each agent guessed. It was merged to 222 rows
   and normalised. Do not reintroduce a wrapper.

## Routine prompts (what each prompt runs)
A routine wakes you with one of these prompts. Map it to the file and follow that file exactly:
- "start board"        -> agents/board/run.md        (Linear-fed work; the dispatcher)
- "start content-blog" -> agents/content-blog/run.md  (the dispatcher)
- "start outreach"     -> agents/outreach/run.md      (daily pass, drafts only)
- "send the brief"     -> engine/brief/SKILL.md
- "read replies"       -> engine/replies/SKILL.md

## On-demand prompts (I type these; NO routine ever fires them)
- "enrich outreach"    -> agents/outreach/skills/enrich.md
  Spends real Hunter.io credits. It must ask me for a credit ceiling and a
  verification ceiling and STOP if I give neither. Never add it to routines.md.

## The brake
`state/pause` is a FILE. If it exists, no dispatcher claims new work and no worker advances a
step. Nothing else about it is configurable and nothing overrides it.
    touch state/pause     # stop
    rm state/pause        # go
Tasks already mid-flight are not force-killed; they simply get no further runs. Check for it
FIRST, before reading anything else, in every dispatcher and every worker.

## The board is reached through engine/linear, NEVER through MCP
Every read and write to Linear goes through `engine/linear/linear.sh`. If a session has
`mcp__linear__*` tools available, do not use them for any part of a run. They are for me,
interactively, when I am exploring or fixing the board by hand — not for the machine.

This is not a style preference. Three things break:

- AUTH. MCP connectors are authenticated interactively. A routine session may not have them
  at all, and then `ready` returns nothing and the run reports success. Silently no work,
  indistinguishable from a quiet board. On 2026-09-17 a sign-out stopped every routine for
  4.5 days and nobody noticed; this failure looks the same and is harder to spot.
- IDEMPOTENCY. `linear.sh comment` embeds a `<!-- cc:key -->` marker and refuses to post the
  same key twice. Every retry, resumed run and repeated poll depends on that. MCP has no
  equivalent, so the same comment lands again on every retry.
- OWNERSHIP. `linear.sh` deliberately offers no way to read a card's status to decide whether
  to work on it — the task file decides. A session holding `list_issues` will reach for it,
  and two systems that can both start work eventually both will.

If linear.sh cannot do something a run needs, add the subcommand. Do not reach past it.

## Who owns what (board tasks)
Linear holds **intent**: what I want done, and my answers. That is all it holds.
The moment a task is claimed, `agents/board/tasks/active/<IDENT>.json` is authoritative for
everything else. From then on the runner PUSHES status to Linear and NEVER reads it back.

Exactly two things travel back from the board after a claim: an answer to a question the task
asked, and stop/pause. Both arrive through engine/replies, never through a worker.

Dragging a claimed card in Linear changes the picture on the board and nothing on the mini.
If you are about to read a card's status to decide whether to work on it, stop — the task file
already knows, and two systems that can both start work eventually both will.

The task id IS the Linear identifier (`VAR-37` -> `tasks/active/VAR-37.json`). No mapping
table, so nothing to drift. Blog tasks keep their `cb-*` ids and need no card.

## Isolation — never work in a repo's own checkout
Every task gets its own git worktree, a SIBLING of the repo:
`<config.workspace_root>/<task-id>`, created with
`git -C <repo> worktree add <wt> -b <branch> origin/<default>`.
I may be editing in that repo right now. A worker that runs `git add -A` in my checkout
commits my unfinished work under its own name. Nothing is ever committed, stashed or checked
out in `config.repo` itself.
The worktree lives outside the repo, so nothing needs gitignoring and nothing about it is ever
pushed — git pushes commits, not working directories. It is removed only when the task
finishes, because `deliver` runs in a LATER run than `commit` and needs it to still be there.
Blog tasks that branched before 2026-09-20 have no worktree recorded; those fall back to
`config.repo` (see WORKDIR in agents/content-blog/worker.md). Never retro-fit one.

## Notifications — Linear is the record, iMessage is the interrupt
Every question, answer, result and decision goes on the Linear card. That is the record, and
it is complete on its own.
iMessage is ONLY for the two states where the machine is stalled until I act: a task waiting
on an answer, and a task blocked. Nothing else texts me — ready-for-review and done sit on the
card, which already pushes to my phone.
Answers arrive in exactly ONE place: a comment on the Linear card. Not iMessage, not Slack.
One inbound path means the card is never behind and there is nothing to reconcile.
Slack is not wired up. `engine/slack/` exists and is dormant; do not call it, and do not add a
second answer source without a real reason — every extra inbound path is a way for the card to
fall out of date.

## Delivery is configured, never improvised
What happens to a commit — pushed, PR'd, or neither — comes from `config.delivery` on the
project, not from the worker's judgement and not from silence on the card.
    draft_pr   push + open a DRAFT PR vs default_branch. The default for real code work.
    branch     push, no PR.
    none       local commit only. Nothing reaches GitHub.
Absent config -> treat as `none`. A card may NARROW delivery (a throwaway sets `none`); a
card may never widen it. Opening a PR is never a gate violation; `gh pr ready` and merging
are. `review` is a gate and stays mine.

## Gate semantics (this is the autonomy policy)
- "auto"        : run the step, log it, move on. Reversible work only.
- "veto_window" : notify me, wait the "wait" duration, then run UNLESS I vetoed.
                  NO step uses this today. A step is veto_window only if its own agent.json
                  entry literally says "gate": "veto_window". Never infer it from this file.
- "gate"        : STOP. Do not perform the action. Hand it to me and wait.
                  Every post and every email is a gate. You NEVER send or post.

## Hard rules (a violation is an immediate stop, surfaced in the brief)
- Never send an email or post to any platform. You only prepare drafts.
- Gmail: create DRAFTS only. Never send.
- Respect state/budget.json. Caps are per project; if a publish would exceed that project's
  cap, park to tomorrow. Never spend one project's budget on another.
- If state/attention.json shows no brief answered in 48h, do NOT auto-advance any
  veto_window step; hold it and flag in the brief. This applies ONLY to steps whose
  agent.json entry says "gate": "veto_window". No step does today, so this rule currently
  gates nothing. attention.json is informational — it is NEVER a reason to hold a publish.

## How the blog publish gate actually works (do not re-derive this)
The blog `deliver` step is "auto". There is no timer and no approval step. The veto window
is the GAP: a task intakes at go_live minus `lead` (4 days), the worker drafts and stops
after `commit`, texts me the draft link, and I have those days to reply `kill <id>`.
On a later run `deliver` checks exactly three things — go_live reached, not vetoed, budget
available — and merges. My silence means publish. If you find yourself reasoning that the
publish needs my approval first, you have it backwards; re-read this paragraph.

## House voice
Direct, no filler. One concrete point per piece — say the thing, don't set it up.
No hype, no corporate phrasing, no AI-sounding sentences.
Human enough that someone would believe a person wrote it.

This is the floor. Two things override it, in this order:
1. The agent's draft skill — channel-specific format and tone (X, LinkedIn, outreach).
2. The project's voice file, which lives in that product's own site repo at
   `.claude/skills/blog-writing.md` — persona, pronouns, audience. TermStack writes as a
   founder in first person; Publish Pilot writes as "we". Never assume one product's voice
   for another, and never keep a second copy of a voice guide in command-center.

## Practice material
Patterns live in `templates/` as markdown, never as issues on the board. Something that is not
an issue cannot be assigned, scheduled or run — so there is no protected-id registry, no
checksum and no never-execute enforcement to maintain. Do not put example tasks on the board;
a guard around fake work is a guard that can fail open.

Dispatchable means exactly two things, both positive and both deliberate: status **Ready** and
label **`agent`**. Nothing else is ever picked up.

## Projects
Work is project-scoped. A task carries a `project` field, and everything product-specific
lives in `agents/<agent>/projects/<project>/config.json` — repo path, repo slug, branches,
preview and live URLs, which build skills to run, which voice file governs.
Never hardcode a repo path, repo slug, or URL in an agent or engine skill. A task with no
`project`, or a project with no config, is unroutable: leave it, flag it in the brief.
Knowledge for a project lives in `knowledge/<project>/` (prd.md + briefs/).

## Output rule
A step that makes something writes it to agents/<agent>/outputs/<task-id>/<step>.<ext>
and sets that step's "out" to that exact path. Never inline a blob into the task JSON.