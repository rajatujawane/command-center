# VAR-38 — [THROWAWAY] Add a two-button section to the admin home page

You are a command-center worker. You have ONE task. Do it, then report.

## The card, verbatim

## Goal

Add a section containing two buttons to the TermStack admin home page.

Throwaway task. It exists only to exercise the runner — the change will be deleted, not merged. Nothing here is product work.

## Scope

In `packages/admin/src/app/page.tsx`, add one new `<s-section>` containing an inline `<s-stack>` with **two** `<s-button>` elements side by side. Place it inside `HomePage`, immediately before the `<s-box paddingBlockStart="large" />` that precedes the page-level banners.

Match the component style already in that file — it is a Next.js app-router client component using Shopify Polaris web components. Do not introduce a new UI library or pattern.

The first button is labelled `Hello`. The second button carries the label specified for this task.

Out of scope: every other file.

## Completion criteria

* `packages/admin/src/app/page.tsx` contains a new `<s-section>` with exactly two buttons, inline, in the position described above.
* The first button reads `Hello`.
* The second button's label is the one specified for this task.
* Exactly one commit on the task branch, containing exactly that change.

## Evidence

The commit sha and the diff.

## Overrides

Three deliberate departures from this project's defaults:

* `delivery: none`**.** Do not `git push` and do not open a PR. Commit locally in the worktree only. This change must leave no trace on GitHub. The project default is `draft_pr`; it does not apply here.
* **Do not build, install or run tests.** A fresh worktree has no `node_modules` and installing is out of scope. Do not report a build as passing, and do not attempt one.
* **Do not update** `docs/kb/`**.** The repo's CLAUDE.md asks for a KB sync when a change touches a path in a page's `sources:`. It does not apply to a branch that will be deleted.

## Cleanup

After review the worktree and branch are deleted. Nothing from this issue reaches `main`, a PR, or production.

## Where you are working

Product:        TermStack
Repository:     /Users/rajatserver/Developer/term-stack
Your worktree:  /Users/rajatserver/Developer/.worktrees/VAR-38      <-- work ONLY here
Your branch:    board/VAR-38   (branched from origin/main)

The repository's own checkout is on an unrelated branch and may have uncommitted work in it.
Never cd into /Users/rajatserver/Developer/term-stack itself, never `git checkout` there, never `git add` there.

## Limits binding this run

Time: 30 minutes. Attempts: 1.
Project delivery default: draft_pr — but the card overrides it to `none` for this task.

Allowed: read, search, edit and write inside your worktree; `git add` and `git commit` there.
The card forbids: building, installing, running tests, `git push`, opening a PR, updating
docs/kb, and any network call. Those override the project defaults.

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
When you ask, give the question, your recommendation, and what it blocks.


## Answers to your questions

**Q-VAR-38-1** — answered by Rajat at 2026-09-20T06:35:53.047Z:

    World

That is the authorised answer. Use it exactly. Do not re-ask.
