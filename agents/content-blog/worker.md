# content-blog — worker (one task)
You were launched with a single task id. Process ONLY that task. Read CLAUDE.md first.

1. Load tasks/active/<id>.json. Start at the first step whose status != "done". Run it,
   write status + out after it (temp file + atomic rename), and CONTINUE to the next step in
   the SAME run — until one of these stops you:
     - you just completed `commit`              -> STOP this run. The draft is ready and I've
                                                    been notified; publishing waits for a later run.
     - the current step is `deliver` and it HOLDS (before go_live) or is vetoed/blocked -> STOP.
     - any step sets blocked_on (fact_check / qa_image fail) -> STOP.
   So a fresh task runs branch..commit in ONE run and stops. A later run resumes at `deliver`.

   Steps:
   - branch     -> cd meta.repo. uncommitted changes? commit them on the current branch first.
                   detect default (main/master), checkout it, git pull --ff-only,
                   git checkout -b blog/<id>. record branch + default in out.
   - draft      -> skills/blog-writing: read the task's inputs, write the post (title H1,
                   one-line meta desc, body) -> outputs/<id>/draft.md.
   - fact_check -> skills/fact-check: verify against inputs, fix inline. unverifiable core
                   claim -> blocked_on + stop.
   - build      -> cd meta.repo; git checkout blog/<id>. hand it title + body; run the repo's
                   blog-ready + blog-image skills. record slug in out. do NOT commit.
   - qa_image   -> VIEW the hero image; fix any formatting/legibility issue via the repo's
                   blog-image skill, up to twice, else gate with the image.
   - commit     -> cd meta.repo; git checkout blog/<id>. git add -A; git commit -m "blog: <title>";
                   git push -u origin blog/<id>; open a DRAFT PR vs default. record PR url in out.
                   then engine/imessage/send.sh "<group>" "Draft ready to read:
                   http://localhost:3001/blog/<slug>. Publishes <go_live or 'next run'>.
                   Reply 'kill <id>' to stop."  THEN STOP (see rule above).
   - deliver    -> run engine/deliver (go-live gate, veto check, budget, then rebase/resolve/
                   push/merge). holds or merges per that skill.
   - notify     -> on a successful merge, engine/imessage/send.sh "<group>"
                   "Published: http://localhost:3001/blog/<slug>".
2. All steps done -> move task file to tasks/done/, append a line to tasks/log.md.
3. Do NOT write heartbeat. Return to the dispatcher.