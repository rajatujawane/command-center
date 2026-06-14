# content-blog — dispatcher (one routine run)
"start content-blog" runs THIS. It does intake, hands each active task to its own worker
instance, then stamps one heartbeat. It never advances a task itself.

1. Intake:
   - Pull inbound handoffs into tasks/incoming/.
   - For each task in incoming/: stamp the steps from agent.json (each status "pending"),
     move to tasks/active/ (write via temp file + atomic rename).
   - go_live tasks only: intake when now >= go_live - meta.lead.
2. List tasks/active/. Process them ONE AT A TIME: launch a worker instance for the first
   task, let it finish and return, then the next. Each worker is given only CLAUDE.md,
   worker.md, and its task id, and advances ONLY its own task.
3. Wait for all workers to return.
4. Append ONE row to state/heartbeat.json {agent:"content-blog", ts, tasks_touched:<N>, ok:true}.
   Workers NEVER write heartbeat — only the dispatcher does.