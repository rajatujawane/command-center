# Acceptance tests

Seven tests. Each catches a failure that has actually happened to systems like this one.
Run them in order — each assumes the previous passed.

Tests 1 and 2 need nothing. Tests 3–7 need `LINEAR_API_KEY` in `.env`.

Status 2026-09-20: **all seven pass.** 1 and 2 by hand; 3–7 driven through VAR-37 (happy
path) and VAR-38 (question and answer path).

---

## 1. The worker cannot touch my uncommitted work
**Status: PASSED 2026-09-20.** Re-run after any change to `branch`, `build` or `commit`.

    repo=~/Developer/varr-labs-website
    echo scratch >> $repo/.proof.txt                       # my half-finished edit
    git -C $repo worktree add ~/Developer/.worktrees/T -b blog/T origin/main
    echo post > ~/Developer/.worktrees/T/test.md
    git -C ~/Developer/.worktrees/T add -A
    git -C ~/Developer/.worktrees/T commit -m "blog: test"

**Assert:** `git -C $repo status --porcelain` still shows `?? .proof.txt`, and the repo is
still on `main`. Under the old rule `git add -A` in the repo swept it into the blog commit.

    git -C $repo worktree remove --force ~/Developer/.worktrees/T
    git -C $repo branch -D blog/T && rm $repo/.proof.txt

## 2. The brake works

    touch state/pause      # then: start board

**Assert:** claims nothing, advances nothing, says why. `rm state/pause` and it resumes.
A brake you have never pulled is not a brake.

---

## 3. Credentials reach the right places

    engine/linear/linear.sh whoami        -> your name
    engine/slack/slack.sh  whoami         -> bot name in workspace
    ops/heartbeat.sh                      -> heartbeat: ok
    engine/linear/linear.sh ready         -> empty (nothing is Ready + agent yet)

**Assert on the last one:** it returns nothing, and in particular returns none of the 12
example cards. If an example appears, its labels are wrong — fix that before going further.

## 4. Saying the same thing twice says it once

    engine/linear/linear.sh comment VAR-17 test-1 "hello"     -> posted
    engine/linear/linear.sh comment VAR-17 test-1 "hello"     -> already posted: test-1

**Assert:** one comment on the card, not two. Delete it afterwards.
Every retry, every repeated routine, every resumed run depends on this holding.

## 5. Two polls, one job

Put ONE real card in Ready + label `agent`. Then:

    start board
    start board        # immediately, before the first finishes anything

**Assert:** exactly one file in `agents/board/tasks/active/`, one `claim-` comment, one run
record. The file is the lock; if this fails, nothing downstream is safe.

## 6. A missing input becomes a question, not a guess

Make a card deliberately incomplete — name a repo but no acceptance criteria, or reference
"the test store" without saying which.

**Assert:** the task stops with `RESULT: needs_input`, the card moves to **Waiting for input**,
and the question names what is missing. **Assert it did NOT pick a plausible answer.**

This is the test that matters most. A system that guesses here is worse than no system,
because its output looks like work.

## 7. One answer, one resume

Answer the question from test 6 **on the Linear card**. Then:

    read replies       -> records it, acks with the answer quoted, card back to Doing
    start board        -> resumes the SAME session once

Then run `read replies` again with nothing changed:

    read replies       -> nothing happens

**Assert:** `answers` holds ONE entry for that key, and ONE ack comment exists. Two defences
have to hold independently — the task is no longer waiting, AND the key is already answered.
Check both; a pass that only exercises one of them is a pass for the wrong reason.

The card goes back to **Doing**, not Ready: it is already claimed, and showing it as Ready
would tell the board a busy task is free.

---

## Then, and only then

Two clean end-to-end runs before `board` gets a schedule in routines.md. Not one.
The first success can be luck; the second is evidence.

## What is deliberately not tested
Nothing verifies that example cards cannot run, because examples live in `templates/` as
files and are not on the board. There is nothing to exclude, so there is nothing to test —
which is the point. If examples ever go back on the board, this section becomes six tests.

## 8. The poller wakes only when there is work

    DRY_RUN=1 ops/board-tick.sh

**Assert**, in order:
- empty board                     -> `IDLE`
- one card in Ready + `agent`     -> `WOULD WAKE: new card VAR-nn`
- `touch state/pause`             -> silent, exit 0, and NO network call is made
- bad/absent LINEAR_API_KEY       -> logs "board unreachable", does not wake

**Status 2026-09-21: passes.** Idle tick measured at ~2s and zero tokens.

The third case matters most: the brake is checked before anything else, so a paused system
cannot be woken by anything happening on the board.

## 9. launchd actually runs it (do this after installing the plist)

    launchctl list | grep varrlabs        # registered?
    tail -f logs/board-tick.log           # a line every 15 min?

**Assert:** ticks appear on schedule, and `logs/board-tick.err.log` stays empty.

**The one that needs real verification:** put a card in Ready and confirm the launchd-run
tick can actually start a Claude session. launchd jobs do not inherit your login shell's
environment or, on some macOS versions, its keychain access — so `claude -p` may work by hand
and fail from launchd. If it does fail, the log will show it; that is a solvable auth problem,
but assume nothing until a card has been claimed by a tick you did not start yourself.
