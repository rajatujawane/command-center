# promote — ship the default branch to prod (remote-only, no local checkout)

Runs right after a successful `deliver` (the blog PR was merged into the default branch).
It opens a PR from the default branch into `prod` and merges it, entirely through the
GitHub API via `gh` — no `git checkout`, no rebase, no working tree. Assumes a `prod`
branch already exists on the remote.

Repo: `rajatujawane/varr-labs-website`. Base: `prod`. Head: the default branch (main/master).

1. Nothing-to-promote guard: check whether the default branch is ahead of prod.
     gh api repos/rajatujawane/varr-labs-website/compare/prod...<default> --jq '.ahead_by'
   If it returns 0 -> nothing to ship. Mark the step done, record "nothing to promote", stop.

2. Already-open guard: if a PR from <default> into prod is already open, reuse it (skip to
   step 4 with that PR number) instead of opening a duplicate.
     gh pr list -R rajatujawane/varr-labs-website --base prod --head <default> --state open --json number

3. Build the title from today's date as "DDth MMMM YYYY dev to prod":
   ordinal suffix -> 1/21/31 = st, 2/22 = nd, 3/23 = rd, everything else = th.
   e.g. "15th June 2026 dev to prod".
   Create the PR (remote, no checkout):
     gh pr create -R rajatujawane/varr-labs-website --base prod --head <default> \
       --title "<title>" --body "Automated dev -> prod promotion."
   Capture the PR number/url.

4. Merge it (remote):
     gh pr merge -R rajatujawane/varr-labs-website <pr> --merge
   Do NOT delete the default branch.

5. Record the promotion PR url in out. Mark the step done.

If the merge fails (e.g. branch protection requires checks that haven't passed), do NOT
force anything: set blocked_on "promotion merge failed: <reason>" and flag in the brief.