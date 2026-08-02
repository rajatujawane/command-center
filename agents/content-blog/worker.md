# content-blog — worker (one task)
You were launched with a single task id. Process ONLY that task. Read CLAUDE.md first.

0. Load the project config FIRST. Read tasks/active/<id>.json, take its `project` field, and
   read `projects/<project>/config.json`. Everything project-specific comes from there:
   `repo`, `repo_slug`, `site_root`, `default_branch`, `prod_branch`, `preview_base_url`,
   `build_skills`, `voice`, `notify`. Never hardcode a repo path, repo slug, or URL — if a
   value you need isn't in the config, set blocked_on "missing config key <key> for
   <project>" and stop. No `project` field on the task -> blocked_on "task has no project",
   stop.

1. Start at the first step whose status != "done". Run it, write status + out after it
   (temp file + atomic rename), and CONTINUE to the next step in the SAME run — until one of
   these stops you:
     - you just completed `commit`              -> STOP this run. The draft is ready and I've
                                                    been notified; publishing waits for a later run.
     - the current step is `deliver` and it HOLDS (before go_live) or is vetoed/blocked -> STOP.
     - any step sets blocked_on (fact_check / qa_image fail) -> STOP.
   So a fresh task runs branch..commit in ONE run and stops. A later run resumes at `deliver`.

   Steps:
   - branch     -> cd config.repo. uncommitted changes? commit them on the current branch first.
                   confirm config.default_branch exists (it is the source of truth; fall back to
                   detecting main/master only if it doesn't), checkout it, git pull --ff-only,
                   git checkout -b blog/<id>. record branch + default in out.
   - draft      -> skills/blog-writing: it resolves config.voice, reads the task's inputs, and
                   writes the post (title H1, one-line meta desc, body) -> outputs/<id>/draft.md.
   - fact_check -> skills/fact-check: verify against inputs, fix inline. unverifiable core
                   claim -> blocked_on + stop.
   - build      -> cd config.repo; git checkout blog/<id>. hand it title + body; run the repo's
                   own skills named in config.build_skills, in that order, from the repo root
                   (they resolve their own paths under config.site_root). record slug in out.
                   do NOT commit.
   - qa_image   -> VIEW the hero image; fix any formatting/legibility issue via the repo's
                   image skill, up to twice, else gate with the image.
   - commit     -> cd config.repo; git checkout blog/<id>. git add -A; git commit -m "blog: <title>";
                   git push -u origin blog/<id>; open a DRAFT PR vs config.default_branch.
                   record PR url in out.
                   then engine/imessage/send.sh "<config.notify.group>" "<config.product> draft
                   ready to read: <config.preview_base_url>/<slug>. Publishes <go_live or 'next
                   run'>. Reply 'kill <id>' to stop."  THEN STOP (see rule above).
   - deliver    -> run engine/deliver (go-live gate, veto check, budget, then rebase/resolve/
                   push/merge). holds or merges per that skill.
   - promote    -> run engine/promote: open + merge a "<DDth MMMM YYYY> dev to prod" PR from
                   config.default_branch into config.prod_branch on config.repo_slug,
                   remote-only via gh. record promo PR url.
                   nothing to promote -> skip. merge fails -> blocked_on + stop.
   - notify     -> on a successful promote (now live on prod), engine/imessage/send.sh
                   "<config.notify.group>" "Published: <config.live_base_url>/<slug>".
2. All steps done -> move task file to tasks/done/, append a line to tasks/log.md.
3. Do NOT write heartbeat. Return to the dispatcher.
