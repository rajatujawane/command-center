#!/usr/bin/env bash
# Exercise runner persistence in a temporary database only.

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
SCHEMA="$ROOT/engine/runner/schema.sql"
REFERENCE_LOADER="$ROOT/engine/runner/load-protected-references.sh"
tmp_dir="$(mktemp -d "${TMPDIR:-/tmp}/command-center-runner.XXXXXX")"
db="$tmp_dir/runner.sqlite"

cleanup() {
  rm -f "$db" "$tmp_dir/duplicate-claim.err"
  rmdir "$tmp_dir"
}
trap cleanup EXIT

die() {
  echo "runner-state-test: $*" >&2
  exit 1
}

[ -f "$SCHEMA" ] || die "schema not found: $SCHEMA"

# Applying the schema twice must be safe.
sqlite3 "$db" < "$SCHEMA"
sqlite3 "$db" < "$SCHEMA"

[ "$(sqlite3 "$db" 'SELECT count(*) FROM schema_migrations WHERE version = 1;')" = "1" ] \
  || die "schema migration was not idempotent"

"$REFERENCE_LOADER" "$db" "$ROOT/projects/protected-references.json" >/dev/null
"$REFERENCE_LOADER" "$db" "$ROOT/projects/protected-references.json" >/dev/null
[ "$(sqlite3 "$db" 'SELECT count(*) FROM protected_references;')" = "12" ] \
  || die "protected reference registry was not loaded idempotently"

# A caller claims work by creating its run and ownership row in one transaction.
sqlite3 "$db" <<'SQL'
PRAGMA foreign_keys = ON;
BEGIN IMMEDIATE;
INSERT INTO runs (
  run_id, task_id, task_version, project_id, worker_session_id, workspace,
  code_revision, phase, status, started_at, heartbeat_at, budget_json
) VALUES (
  'run-1', 'VAR-PILOT', 'v1', 'termstack', 'session-1',
  '/tmp/termstack-worktree', 'abc123', 'prepare', 'claimed',
  '2026-09-08T10:00:00Z', '2026-09-08T10:00:00Z', '{}'
);
INSERT INTO task_claims (
  claim_id, task_id, task_version, run_id, owner_session_id, claimed_at, heartbeat_at
) VALUES (
  'claim-1', 'VAR-PILOT', 'v1', 'run-1', 'session-1',
  '2026-09-08T10:00:00Z', '2026-09-08T10:00:00Z'
);
COMMIT;
SQL

# A second active owner for the same task version must be rejected.
if sqlite3 "$db" <<'SQL' 2>"$tmp_dir/duplicate-claim.err"
.bail on
PRAGMA foreign_keys = ON;
BEGIN IMMEDIATE;
INSERT INTO runs (
  run_id, task_id, task_version, project_id, worker_session_id, workspace,
  phase, status, started_at, heartbeat_at
) VALUES (
  'run-2', 'VAR-PILOT', 'v1', 'termstack', 'session-2',
  '/tmp/other-worktree', 'prepare', 'claimed',
  '2026-09-08T10:01:00Z', '2026-09-08T10:01:00Z'
);
INSERT INTO task_claims (
  claim_id, task_id, task_version, run_id, owner_session_id, claimed_at, heartbeat_at
) VALUES (
  'claim-2', 'VAR-PILOT', 'v1', 'run-2', 'session-2',
  '2026-09-08T10:01:00Z', '2026-09-08T10:01:00Z'
);
COMMIT;
SQL
then
  die "duplicate active ownership was accepted"
fi

# The failed transaction must not leave its run behind.
[ "$(sqlite3 "$db" "SELECT count(*) FROM runs WHERE run_id = 'run-2';")" = "0" ] \
  || die "failed claim left a partial run"

# Persist a question, answer, handoff and an undelivered board update.
sqlite3 "$db" <<'SQL'
PRAGMA foreign_keys = ON;
BEGIN IMMEDIATE;
UPDATE runs
SET phase = 'awaiting_answer', status = 'waiting_for_input', heartbeat_at = '2026-09-08T10:02:00Z'
WHERE run_id = 'run-1';
INSERT INTO pending_questions (
  question_id, task_id, run_id, question, recommendation, blockage, created_at
) VALUES (
  'question-1', 'VAR-PILOT', 'run-1', 'Which test command is authoritative?',
  'Record the repository command before execution.', 'Tests cannot run safely.',
  '2026-09-08T10:02:00Z'
);
COMMIT;
SQL

# A fresh connection can resume from the durable phase.
[ "$(sqlite3 "$db" "SELECT phase || '|' || status FROM runs WHERE run_id = 'run-1';")" = \
  "awaiting_answer|waiting_for_input" ] || die "stored run phase could not be resumed"

sqlite3 "$db" <<'SQL'
PRAGMA foreign_keys = ON;
BEGIN IMMEDIATE;
INSERT INTO answers (
  answer_id, question_id, authorized_responder, source_event_id, answered_at, answer_text
) VALUES (
  'answer-1', 'question-1', 'owner', 'linear-comment-1',
  '2026-09-08T10:05:00Z', 'Use the repository test command after it is verified.'
);
UPDATE pending_questions
SET status = 'resolved', resolved_at = '2026-09-08T10:05:00Z'
WHERE question_id = 'question-1';
INSERT INTO handoffs (
  handoff_id, run_id, controller, session_workspace, completed_work,
  changed_files_json, tests_json, uncertainty, next_action, created_at
) VALUES (
  'handoff-1', 'run-1', 'agent', '/tmp/termstack-worktree',
  'Recorded a fixture run only.', '[]', '[]',
  'Live test command remains unknown.', 'Wait for verified configuration.',
  '2026-09-08T10:06:00Z'
);
INSERT INTO outbox_events (
  event_id, idempotency_key, run_id, task_id, event_type, intended_update,
  created_at, updated_at
) VALUES (
  'event-1', 'run-1:completion:v1', 'run-1', 'VAR-PILOT', 'task_update',
  '{"status":"Review"}', '2026-09-08T10:06:00Z', '2026-09-08T10:06:00Z'
);
UPDATE runs
SET phase = 'finished', status = 'completed', ended_at = '2026-09-08T10:06:00Z',
    heartbeat_at = '2026-09-08T10:06:00Z', outcome_json = '{"result":"fixture-only"}'
WHERE run_id = 'run-1';
COMMIT;
SQL

[ "$(sqlite3 "$db" "SELECT r.status || '|' || o.delivery_state || '|' || o.retry_count FROM runs r JOIN outbox_events o ON o.run_id = r.run_id WHERE r.run_id = 'run-1';")" = \
  "completed|pending|0" ] || die "completion and pending outbox state did not persist independently"

[ "$(sqlite3 "$db" 'PRAGMA integrity_check;')" = "ok" ] || die "database integrity check failed"
[ "$(sqlite3 "$db" 'PRAGMA foreign_key_check;')" = "" ] || die "foreign-key check failed"

echo "runner-state-test: passed"
