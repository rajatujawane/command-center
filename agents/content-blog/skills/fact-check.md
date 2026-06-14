---
name: fact-check
description: Verify the factual claims in a blog draft and fix what's wrong before the build step.
---

# Fact Check

Runs on the draft before it goes to the repo. The job is to make sure nothing in the post
is wrong, unsupported, or overstated. This replaces a generic text QA pass — the point
isn't style (the blog-writing skill handles that), it's truth.

## What to check

1. Read `outputs/<task-id>/draft.md` and the task's research + knowledge inputs.
2. For every factual claim, verify it:
   - Numbers, dates, percentages, prices.
   - Product capabilities — does the product actually do this?
   - Technical claims — API behavior, platform limits, how a feature works.
   - Named tools, companies, standards.
3. Cross-check each claim against the research notes and knowledge files. If a claim isn't
   supported there and you can't confirm it, treat it as unverified.

## What to do with problems

- **Wrong fact** -> fix it inline with the correct value.
- **Overstated claim** -> soften it to what's actually true.
- **Unverifiable claim** -> remove it, or rewrite so it no longer asserts something you
  can't back.
- **A core claim of the post is unverifiable** -> set `blocked_on` with the reason and
  stop. Don't ship a post whose main point can't stand.

## Hard rule

Never invent a source or a number to make a claim check out. If it can't be verified, it
comes out.

Make the changes directly in `draft.md`. Mark the step done once the draft is clean.