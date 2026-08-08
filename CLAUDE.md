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

## Routine prompts (what each prompt runs)
A routine wakes you with one of these prompts. Map it to the file and follow that file exactly:
- "start content-blog" -> agents/content-blog/run.md  (the dispatcher)
- "start outreach"     -> agents/outreach/run.md      (daily pass, drafts only)
- "send the brief"     -> engine/brief/SKILL.md
- "read replies"       -> engine/replies/SKILL.md

## On-demand prompts (I type these; NO routine ever fires them)
- "enrich outreach"    -> agents/outreach/skills/enrich.md
  Spends real Hunter.io credits. It must ask me for a credit ceiling and a
  verification ceiling and STOP if I give neither. Never add it to routines.md.

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