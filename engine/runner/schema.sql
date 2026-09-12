PRAGMA foreign_keys = ON;
BEGIN IMMEDIATE;

CREATE TABLE IF NOT EXISTS schema_migrations (
  version INTEGER PRIMARY KEY,
  applied_at TEXT NOT NULL
);

INSERT OR IGNORE INTO schema_migrations (version, applied_at)
VALUES (1, strftime('%Y-%m-%dT%H:%M:%fZ', 'now'));

CREATE TABLE IF NOT EXISTS runs (
  run_id TEXT PRIMARY KEY,
  task_id TEXT NOT NULL,
  task_version TEXT NOT NULL,
  project_id TEXT NOT NULL,
  worker_session_id TEXT,
  workspace TEXT NOT NULL,
  code_revision TEXT,
  phase TEXT NOT NULL,
  status TEXT NOT NULL CHECK (status IN (
    'claimed', 'running', 'waiting_for_input', 'human_control',
    'completed', 'failed', 'canceled'
  )),
  started_at TEXT NOT NULL,
  heartbeat_at TEXT NOT NULL,
  ended_at TEXT,
  attempts INTEGER NOT NULL DEFAULT 1 CHECK (attempts >= 1),
  budget_json TEXT,
  outcome_json TEXT
);

CREATE INDEX IF NOT EXISTS runs_task_idx
  ON runs (task_id, task_version, started_at);

CREATE INDEX IF NOT EXISTS runs_status_heartbeat_idx
  ON runs (status, heartbeat_at);

CREATE TABLE IF NOT EXISTS task_claims (
  claim_id TEXT PRIMARY KEY,
  task_id TEXT NOT NULL,
  task_version TEXT NOT NULL,
  run_id TEXT NOT NULL UNIQUE,
  owner_session_id TEXT NOT NULL,
  claimed_at TEXT NOT NULL,
  heartbeat_at TEXT NOT NULL,
  released_at TEXT,
  release_reason TEXT,
  FOREIGN KEY (run_id) REFERENCES runs (run_id) ON DELETE RESTRICT
);

CREATE UNIQUE INDEX IF NOT EXISTS task_claims_one_active_idx
  ON task_claims (task_id, task_version)
  WHERE released_at IS NULL;

CREATE TABLE IF NOT EXISTS pending_questions (
  question_id TEXT PRIMARY KEY,
  task_id TEXT NOT NULL,
  run_id TEXT NOT NULL,
  question TEXT NOT NULL,
  recommendation TEXT,
  blockage TEXT NOT NULL,
  reply_link TEXT,
  status TEXT NOT NULL DEFAULT 'pending'
    CHECK (status IN ('pending', 'resolved', 'canceled')),
  created_at TEXT NOT NULL,
  resolved_at TEXT,
  FOREIGN KEY (run_id) REFERENCES runs (run_id) ON DELETE RESTRICT
);

CREATE INDEX IF NOT EXISTS pending_questions_task_status_idx
  ON pending_questions (task_id, status, created_at);

CREATE TABLE IF NOT EXISTS answers (
  answer_id TEXT PRIMARY KEY,
  question_id TEXT NOT NULL UNIQUE,
  authorized_responder TEXT NOT NULL,
  source_event_id TEXT NOT NULL UNIQUE,
  answered_at TEXT NOT NULL,
  answer_text TEXT NOT NULL,
  FOREIGN KEY (question_id) REFERENCES pending_questions (question_id) ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS handoffs (
  handoff_id TEXT PRIMARY KEY,
  run_id TEXT NOT NULL,
  controller TEXT NOT NULL,
  session_workspace TEXT NOT NULL,
  completed_work TEXT NOT NULL,
  changed_files_json TEXT NOT NULL,
  tests_json TEXT NOT NULL,
  uncertainty TEXT,
  next_action TEXT NOT NULL,
  created_at TEXT NOT NULL,
  FOREIGN KEY (run_id) REFERENCES runs (run_id) ON DELETE RESTRICT
);

CREATE INDEX IF NOT EXISTS handoffs_run_idx
  ON handoffs (run_id, created_at);

CREATE TABLE IF NOT EXISTS outbox_events (
  event_id TEXT PRIMARY KEY,
  idempotency_key TEXT NOT NULL UNIQUE,
  run_id TEXT,
  task_id TEXT NOT NULL,
  event_type TEXT NOT NULL,
  intended_update TEXT NOT NULL,
  delivery_state TEXT NOT NULL DEFAULT 'pending'
    CHECK (delivery_state IN ('pending', 'delivering', 'delivered', 'failed')),
  retry_count INTEGER NOT NULL DEFAULT 0 CHECK (retry_count >= 0),
  next_attempt_at TEXT,
  last_error TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  delivered_at TEXT,
  FOREIGN KEY (run_id) REFERENCES runs (run_id) ON DELETE RESTRICT
);

CREATE INDEX IF NOT EXISTS outbox_delivery_idx
  ON outbox_events (delivery_state, next_attempt_at, created_at);

CREATE TABLE IF NOT EXISTS protected_references (
  linear_issue_id TEXT PRIMARY KEY,
  seed_marker TEXT NOT NULL UNIQUE,
  source TEXT NOT NULL,
  loaded_at TEXT NOT NULL
);

COMMIT;
