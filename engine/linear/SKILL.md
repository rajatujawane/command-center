---
name: linear
description: Talk to the Linear board — list dispatchable work, post evidence and questions, move cards. Used by agents/board and by the replies routine. Never used to decide what to do.
---

# Linear

The board holds **intent**: what I want done, and my answers. That is all it holds.

The moment a task is claimed, `agents/board/tasks/active/<IDENT>.json` becomes authoritative
for everything else — which step, what happened, what it cost. From then on this engine
**pushes** to Linear and never reads status back.

Getting this backwards is how you get two runs on one task. If you find yourself about to
read a card's status to decide whether to work on it, stop: the task file already knows.

## The one-way rule

```
intent  ──────────────►  task file      (once, at intake)
status  ◄──────────────  task file      (every run, push only)
```

Exactly two things travel back from the board after intake:

- an **answer** to a question the task asked (handled by engine/replies)
- **stop** / **pause** (handled by engine/replies)

Nothing else on a card can change what the runner does. Dragging a claimed card in Linear
changes the picture on the board and nothing on the mini.

## Task ids

The task id **is** the Linear identifier: `VAR-37` -> `tasks/active/VAR-37.json`.
There is no mapping table, so there is nothing to drift. (Blog tasks keep their own `cb-*`
ids — different agent, different source, no Linear card required.)

## Commands

    engine/linear/linear.sh whoami                     sanity check the key
    engine/linear/linear.sh ready                      dispatchable issues (TSV)
    engine/linear/linear.sh get VAR-37                 one issue as JSON
    engine/linear/linear.sh comment VAR-37 <key> <body>
    engine/linear/linear.sh status VAR-37 <status-key>
    engine/linear/linear.sh comments VAR-37 [since-iso]

`config.json` holds **names only** — team key, status names, label names. The script resolves
names to ids at call time. Never paste a UUID into it; a manifest of UUIDs is a second copy
of the board that goes stale silently.

## Dispatchable means exactly this

`ready` returns issues that are **status Ready** and carry **label `agent`**. That is the
whole filter, and it is a positive one: a card has to be deliberately marked before anything
can pick it up.

This is why there is no reference registry, no checksum and no protected-id list. Practice
material lives in `templates/` as markdown — off the board, so unrunnable by construction
rather than by guard. Nothing to enforce, nothing to keep in sync, nothing to fail open.

## Idempotency

Every comment carries a key and a hidden marker (`<!-- cc:key -->`). Posting the same key
twice is a no-op. Use stable keys:

    claim-VAR-37        claimed, run started
    Q-VAR-37-1          first question this task asked
    result-VAR-37-3     result of run 3
    blocked-VAR-37-2    blockage on run 2

Re-running a step must never produce a second comment. Assume every run may be repeated —
because a killed run, a failed merge, or a retried routine will repeat it.

## When the board is unreachable

Do **not** claim new work from stale state. Finish what is already claimed, write the
intended update to `state/outbox/<n>.json`, and let the next run deliver it. A failed push
must never cause completed work to be redone.

## Hard limits
- Never use `mcp__linear__*` tools in a run — not for a read, not for a write, not "just this
  once because it is easier". They may be absent in a routine session, they cannot dedupe a
  comment, and they expose reads that this engine withholds on purpose. See CLAUDE.md.
  MCP is for Rajat and a human-driven session, by hand, outside a run.
- Never read a card's status to decide whether to run it. The task file decides.
- Never move a card to Done. `review` is a gate; I close my own cards.
- Never create issues. Work I have not asked for does not get a card.
- Never write a UUID into config.json.
