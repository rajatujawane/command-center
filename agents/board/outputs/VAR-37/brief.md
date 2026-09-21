# VAR-37 — [THROWAWAY] Add a Hello button to the admin home page

You are a command-center worker. You have ONE task. Do it, then report.

## The card, verbatim

## Goal

Add a button labelled "Hello" to the TermStack admin home page.

Throwaway task. It exists only to prove the runner works end to end — the change will be deleted, not merged. Nothing here is product work.

## Scope

Add one visible button reading `Hello` to `packages/admin/src/app/page.tsx`, matching the component style already in that file (Next.js app-router client component using Shopify Polaris web components — `<s-section>`, `<s-stack>`, `<s-button>`). Do not introduce a new UI library or pattern.

Out of scope: every other file.

## Completion criteria

* `packages/admin/src/app/page.tsx` contains a button labelled `Hello`, styled consistently with the components already there.
* Exactly one commit on the task branch, containing exactly that change.

## Evidence

The commit sha and the diff.

## Overrides

Two deliberate departures from the usual defaults for this project:

* **Do not build, install or run tests.** The project config names a test command; it does not apply here. A fresh worktree has no `node_modules` and installing them is out of scope. Do not report a build as passing, and do not attempt one — if you think the change needs verifying beyond the diff, record that as an uncertainty instead of running anything.
* **Do not** `git push` **and do not open a PR.** Commit locally in the worktree only. This change must leave no trace on GitHub.

## Cleanup

After review the worktree and branch are deleted. Nothing from this issue reaches `main`, a PR, or production.

## Where you are working

Product:        TermStack
Repository:     /Users/rajatserver/Developer/term-stack
Your worktree:  /Users/rajatserver/Developer/.worktrees/VAR-37      <-- work ONLY here
Your branch:    board/VAR-37   (branched from origin/main)

The repository's own checkout is on an unrelated branch and may have uncommitted work in it.
Never cd into /Users/rajatserver/Developer/term-stack itself, never `git checkout` there, never `git add` there.

## Limits binding this run

Time: 30 minutes (the card narrows this to 15). Attempts: 1.

Allowed: read, search, edit and write inside your worktree; `git add` and `git commit` there.
The card explicitly forbids: building, installing, running tests, `git push`, opening a PR,
and any network call. Those prohibitions override the project defaults — the project config
does name a test command, and it does not apply to this task.

## What may never be done, on any task

- Send an email, post to any platform, or merge to a production branch. Those are gates.
- Touch a repo outside the one named above, or any path outside your worktree.
- Commit changes you did not make. `git add -A` only ever runs inside your worktree.
- Claim something was verified when it was not.

## How to end

Your LAST line must be exactly one of these:

    RESULT: needs_input          you need an answer before you can continue
    RESULT: ready_for_review     a deliverable exists — describe it and where
    RESULT: completed            finished, nothing to review
    RESULT: blocked              something external is in the way
    RESULT: failed               it did not work

Before that line, state briefly: what you changed, the commit sha, and anything you are
uncertain about. If you believe the change needs verifying beyond reading the diff, say so
as an uncertainty — do NOT run a build to find out.

A missing input is `needs_input`, never a guess. Do not invent a file path, a component name
or an authorisation. If the card does not say it and the code does not show it, ask.
