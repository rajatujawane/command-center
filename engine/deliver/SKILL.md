# deliver — publish the blog (merge the PR)

Only used by content-blog. Never sends mail, never posts to social. Runs only on a run
AFTER the commit step finished in an earlier run (the worker enforces this), so there is
always at least one cycle between "draft ready" and publish.

Repo, branches and budget key all come from the task's project config,
`agents/content-blog/projects/<task.project>/config.json`. Never hardcode a repo.

1. go-live gate: if the task has `meta.go_live` and now < go_live -> do NOT merge. Hold the
   step, flag "waiting for go-live <date>" in the brief. Stop.
   (No go_live set -> no date gate; the one-cycle gap from the commit pause is the window.)

2. veto check: if this task's `deliver` step is `blocked_on: "vetoed by me"` (set by the
   replies routine when I sent `kill <id>`) -> do NOT merge. Leave it blocked, flag in the
   brief. Stop.

3. budget check: read `state/budget.json`. Reset `spent` if `date` != today. Budgets are
   per project: compare `spent.blog_publish.<project>` against `caps.blog_publish.<project>`
   (missing project key -> use `caps.blog_publish.default`). If the project is at or over its
   cap -> park (leave the step), flag in the brief. Stop. One project hitting its cap never
   blocks another.

4. merge (rebase, resolve conflicts): cd `config.repo`.
     git fetch origin
     git checkout blog/<id>                        # the branch from the branch step's out
     git rebase origin/<config.default_branch>
   If the rebase hits conflicts, RESOLVE them: the post file + hero image are new files this
   branch added -> keep ours for those; for any unrelated file -> take the incoming change.
   After resolving each: git add -A && git rebase --continue.
   Only if a conflict genuinely can't be resolved safely -> git rebase --abort, set
   `blocked_on: "unresolvable rebase conflict on PR #<pr>"`, flag in the brief, do NOT merge.
   On a clean or resolved rebase:
     git push --force-with-lease
     gh pr merge <pr> --merge --delete-branch

5. increment `state/budget.json` `spent.blog_publish.<project>`. Record "merged PR #.." in
   out. Mark the step done.