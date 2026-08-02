# content-blog — dispatcher (one routine run)
"start content-blog" runs THIS. It does intake, hands each active task to its own worker
instance, then stamps one heartbeat. It never advances a task itself.

Tasks are project-scoped. Every task carries a `project` field, and everything repo-specific
(repo path, repo slug, branches, preview url, voice) lives in
`projects/<project>/config.json`. The dispatcher never touches a repo itself.

1. Intake:
   - Pull inbound handoffs into tasks/incoming/.
   - For each task in incoming/: check its `project` is present and has a
     `projects/<project>/config.json`. If not, leave it in incoming/ and flag it in the
     brief as "unroutable task <id>: unknown project". Do not stamp or move it.
   - Then stamp the steps from agent.json (each status "pending"), move to tasks/active/
     (write via temp file + atomic rename).
   - go_live tasks only: intake when now >= go_live - the project config's `lead`
     (fall back to meta.lead if the config doesn't set one).
2. List tasks/active/. Process them ONE AT A TIME: launch a worker instance for the first
   task, let it finish and return, then the next. Each worker is given only CLAUDE.md,
   worker.md, and its task id, and advances ONLY its own task. One at a time regardless of
   project — two workers in two different repos still share one budget file and one
   iMessage thread.
3. Wait for all workers to return.
4. Append ONE row to state/heartbeat.json {agent:"content-blog", ts, tasks_touched:<N>, ok:true}.
   Workers NEVER write heartbeat — only the dispatcher does.