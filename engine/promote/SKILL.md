# promote — ship the default branch to prod (remote-only, no local checkout)

Runs right after a successful `deliver` (the blog PR was merged into the default branch).
It opens a PR from the default branch into the prod branch and merges it, entirely through
the GitHub API via `gh` — no `git checkout`, no rebase, no working tree. Assumes the prod
branch already exists on the remote.

Inputs come from the task's project config,
`agents/content-blog/projects/<task.project>/config.json`:

    REPO = config.repo_slug        e.g. rajatujawane/varr-labs-website
    BASE = config.prod_branch      e.g. prod
    HEAD = config.default_branch   e.g. main

Never hardcode a repo. If REPO is missing, set blocked_on "missing repo_slug for <project>"
and stop.

1. Nothing-to-promote guard: check whether HEAD is ahead of BASE.
     gh api repos/$REPO/compare/$BASE...$HEAD --jq '.ahead_by'
   If it returns 0 -> nothing to ship. Mark the step done, record "nothing to promote", stop.

2. Already-open guard: if a PR from HEAD into BASE is already open, reuse it (skip to
   step 4 with that PR number) instead of opening a duplicate.
     gh pr list -R $REPO --base $BASE --head $HEAD --state open --json number

3. Build the title from today's date as "DDth MMMM YYYY dev to prod":
   ordinal suffix -> 1/21/31 = st, 2/22 = nd, 3/23 = rd, everything else = th.
   e.g. "15th June 2026 dev to prod".
   Create the PR (remote, no checkout):
     gh pr create -R $REPO --base $BASE --head $HEAD \
       --title "<title>" --body "Automated dev -> prod promotion."
   Capture the PR number/url.

4. Merge it (remote):
     gh pr merge -R $REPO <pr> --merge
   Do NOT delete the default branch.

5. Record the promotion PR url in out. Mark the step done.

If the merge fails (e.g. branch protection requires checks that haven't passed), do NOT
force anything: set blocked_on "promotion merge failed: <reason>" and flag in the brief.

## Shared-repo guard

On a repo that is also under active feature development (publish-pilot is; varr-labs-website
mostly isn't), HEAD can carry commits that have nothing to do with this blog post, and
promoting would ship them to prod as a side effect.

Before step 3, list what would ship:
     gh api repos/$REPO/compare/$BASE...$HEAD --jq '.files[].filename'
If any file falls outside the site content the blog step touched (config.site_root plus its
blog content and public/blog assets), do NOT merge. Set blocked_on
"promotion would ship unrelated changes: <first few paths>" and flag it in the brief so I
decide. A blog post must never be the thing that pushes someone else's feature to prod.
