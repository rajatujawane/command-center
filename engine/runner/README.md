# Durable runner state

`schema.sql` defines coordination records for future development runs. It does not schedule or execute work.

To initialize a local database when Step 4 is approved for use:

```sh
sqlite3 state/runner.sqlite < engine/runner/schema.sql
```

Every connection must enable foreign-key enforcement with `PRAGMA foreign_keys = ON`. A claimant must create its run and claim inside one `BEGIN IMMEDIATE` transaction. The partial unique index on `(task_id, task_version)` rejects a second active owner. Releasing a claim requires an explicit `released_at` and reason; do not infer release from a stale heartbeat without a recovery policy.

Load the permanent protected-reference registry before any future dispatch check:

```sh
engine/runner/load-protected-references.sh state/runner.sqlite
```

The loader is idempotent and rejects changed membership for an existing UUID. Missing, invalid or partially loaded reference state must deny dispatch.

Outbox events have unique idempotency keys. A completed run and an undelivered board update are separate states: retry the pending outbox event without rerunning completed work.

Run the offline acceptance check:

```sh
engine/runner/test-state.sh
```

The test creates and removes a temporary database. It never writes `state/runner.sqlite`, contacts Linear, launches Claude, opens the TermStack checkout, sends a message or changes existing workflow state.
