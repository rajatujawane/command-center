# templates — patterns, not tasks

These are the shapes a good card takes. They live here, as files, **not** as issues on the
board.

That is the whole safety mechanism. A pattern that is not an issue cannot be assigned,
scheduled, picked up or accidentally run. There is no protected-id registry, no checksum, no
never-execute label and no scheduler exclusion — because there is nothing on the board to
exclude. Guards that protect fake work are guards that can fail open.

## Using one

Copy the body into a new Linear issue in **Inbox**. Fill in every field. Delete the
`<angle bracket>` prompts as you go — a card that still has them is not ready.

When it is genuinely ready, move it to **Ready** and add the label **`agent`**. Those two
together are the only thing that makes work dispatchable. Until both are set, the mini will
not see it. Assigning the issue does nothing; the assignee is who is accountable, which
stays you.

## Do not repeat what the machine already knows

Three layers carry the instructions, and each says something the others cannot:

| Layer | Holds | Examples |
|---|---|---|
| `agents/board/projects/<p>/config.json` | true for every task in this project | repo path and slug, default branch, allowed tools, time and attempt limits, test command |
| `CLAUDE.md` + `agents/board/worker.md` | true for every task everywhere | never send, never post, gates stop, worktree isolation |
| **The card** | true for THIS task only | goal, file, scope, completion criteria, evidence |

**If you would write the same sentence on the next card in this project, it belongs in the
config, not on the card.** Repo paths, branch names, tool lists and limits are already known
— repeating them on a card creates a second copy that drifts.

## State every override, and only overrides

An override must be written down, because silence lets the default win. A default you are
happy with needs no mention; a default you are suspending needs an explicit line.

    Config says `test_cmd: yarn ... test`, and this task must not run it
      -> say "do not build or run tests", and say why.

    worker.md bans sending, posting and merging to prod, but NOT `git push`
      -> a task that must not reach GitHub has to say "do not push".

If the Overrides section is empty, delete it. Most cards have none.

## The fields that actually fail

Most cards fail on the same three:

- **Completion criteria** — how a stranger would know it is finished. Not "improve X".
- **Evidence** — what proof gets attached, and which revision it came from.
- **Unknowns** — write UNKNOWN where you do not know. Do not leave it blank and do not guess.
  UNKNOWN becomes a question; blank becomes a wrong assumption.

A card missing any of these produces a question instead of work. That is the system behaving
correctly, but it costs a round trip, and the round trip is you.
