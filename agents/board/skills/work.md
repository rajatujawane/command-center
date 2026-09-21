# work — run one task

One `claude -p` invocation, in its own worktree, against `outputs/<id>/brief.md`.
This is the only resumable step: it may run across several runs.

## 1. Worktree

Never work in the repo itself — I may be editing in it right now.

    repo=<config.repo>            # expanded
    wt=<config.workspace_root>/<id>

    git -C "$repo" fetch origin
    git -C "$repo" worktree add "$wt" -b board/<id> origin/<config.default_branch>

Already exists (resumed task) -> reuse it. Record `worktree=$wt branch=board/<id>` in `out`.

`config.workspace_root` is a SIBLING of the repo, never inside it. Nothing is added to the
product repo's .gitignore and nothing about the worktree is ever pushed — a worktree is a
working directory, and git pushes commits, not directories.

## 2. Session id — assign it, do not scrape it

    sid=$(uuidgen | tr 'A-Z' 'a-z')

Write `state/runs/<id>.json` BEFORE launching:

    {"task":"<id>","session":"<sid>","attempt":<n>,"worktree":"<wt>",
     "phase":"work","started":"<iso>","result":null}

Assigning the id up front means resume never depends on parsing output, and a run that dies
mid-flight is still resumable. Scraping the id from stdout loses it exactly when you need it.

## 3. Invoke

Always through `ops/with-timeout.sh`, never bare. `config.budget.max_minutes` is not a
limit unless something enforces it, and macOS has no `timeout` or `gtimeout` — that is what
`with-timeout.sh` is for. Run from inside the worktree.

    cd "$wt"
    ops/with-timeout.sh <max_minutes * 60> \
      claude -p "$(cat outputs/<id>/brief.md)" \
        --session-id "$sid" \
        --output-format json \
        --allowedTools <tools> \
        --permission-mode acceptEdits

Exit 124 means the limit was hit: that is `blocked`, NOT `failed`, and NOT a success with
missing output. Record "killed at the time limit" and whatever partial commit exists.

`<tools>` starts from `config.allowed_tools` and is NARROWED by the card's overrides. A card
that forbids builds means `Bash(yarn *)` and `Bash(npm *)` come out of the list — do not pass
a tool the card has just forbidden and rely on the model to decline it. Mechanical prevention
beats instruction wherever both are available.

Resuming (`state/runs/<id>.json` has a session and the task is not on attempt 1):

    claude --resume "$sid" -p "$(cat outputs/<id>/brief.md)" --output-format json ...

Resume fails or the transcript is gone -> say so in `out`, generate a NEW session id, and
start again from `outputs/<id>/handoff.md`. Never pretend the old history survived.

## 4. The result contract

The brief tells the worker to end with exactly one of these as its last line:

    RESULT: needs_input          a question, with a recommendation, and what it blocks
    RESULT: ready_for_review     a deliverable exists and is described
    RESULT: completed            finished, nothing to review
    RESULT: blocked              an external thing is in the way
    RESULT: failed               it did not work

**Exit code 0 is not success.** A clean exit with no contract line is `failed` — record the
last 40 lines of output and stop. A non-zero exit with a `blocked` line is `blocked`.

Keep these three apart; conflating them is how a broken setup looks like a broken product:
- a permission or tool denial        -> `blocked`, not `failed`
- infrastructure (network, auth)     -> `blocked`, not `failed`
- the product's own test failing     -> that is a real finding. `ready_for_review`.

## 5. Record

Write the result into `state/runs/<id>.json` and the step's `out`.

- `needs_input`     -> step stays `pending`, set `blocked_on: "question: <text>"`. STOP.
- `ready_for_review`/`completed` -> step `done`. Continue to `report`.
- `blocked`/`failed` -> increment `attempts`. Below the attempt limit -> leave `pending`,
  it retries next run. At the limit -> `blocked_on: "failed after N attempts: <reason>"`. STOP.

Never retry inside one run. One run, one attempt — so a bad loop costs one run, not a night.

## 6. Delivery — read `config.delivery`, do not decide it here

What happens to the commit is a PROJECT setting, not a judgement call:

    "delivery": "draft_pr"   push the branch, open a DRAFT PR vs default_branch. The default
                             for real code work — a draft PR is how it gets reviewed, and a
                             draft cannot be merged by accident.
    "delivery": "branch"     push the branch, no PR.
    "delivery": "none"       commit locally only. Nothing reaches GitHub.

A card may narrow this (a throwaway sets `none`); a card may NOT widen it. If `config.delivery`
is absent, treat it as `none` and say so in `out` — silence must never mean "push".

`draft_pr`:
    git -C "$wt" push -u origin board/<id>
    gh pr create --draft --base <config.default_branch> --head board/<id> \
       --title "<task title>" --body "<summary + link to the Linear card>"
Record the PR url in `out`. NEVER `gh pr ready` and NEVER merge — `review` is a gate.

## 7. Cleanup

Leave the worktree alone. `report` runs in a later phase and I may want to look at it. It is
removed only when the task leaves `tasks/active/`:

    git -C "$repo" worktree remove "$wt"
