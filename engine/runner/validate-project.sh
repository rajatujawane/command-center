#!/usr/bin/env bash
# Validate a development project-register entry without touching its workspace.

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
mode="config"

if [ "${1:-}" = "--for-dispatch" ]; then
  mode="dispatch"
  shift
fi

config="${1:-$ROOT/projects/termstack.json}"

die() {
  echo "project-register: $*" >&2
  exit 1
}

[ $# -le 1 ] || die "usage: validate-project.sh [--for-dispatch] [config.json]"
[ -f "$config" ] || die "config not found: $config"
jq empty "$config" >/dev/null 2>&1 || die "invalid JSON: $config"

jq -e '
  .schema_version == 1 and
  (.project | type == "string" and length > 0) and
  (.product | type == "string" and length > 0) and
  (.linear | type == "object") and
  (.linear.workspace_id | type == "string" and length > 0) and
  (.linear.team_id | type == "string" and length > 0) and
  (.workspace | type == "object") and
  (.workspace.repository_url | type == "string" and startswith("https://github.com/")) and
  (.workspace.path | type == "string" and startswith("/")) and
  (.workspace.default_branch | type == "string" and length > 0) and
  (.workspace.isolation == "worktree") and
  (.verification.test_commands | type == "array") and
  (.policy.dispatch_enabled | type == "boolean") and
  (.policy.allowed_actions | type == "array") and
  (.policy.send_policy == "forbidden")
' "$config" >/dev/null || die "invalid project-register shape or unsafe fixed policy: $config"

if [ "$mode" = "dispatch" ]; then
  jq -e '
    def text: type == "string" and length > 0;
    .policy.dispatch_enabled == true and
    (.linear.workspace_id | text) and
    (.linear.team_id | text) and
    (.linear.project_id | text) and
    (.linear.working_instructions_document_id | text) and
    (.linear.working_instructions_url | text) and
    (.workspace.release_branch | text) and
    (.verification.test_commands | length > 0) and
    (all(.verification.test_commands[]; text)) and
    (.verification.test_environment | text) and
    (.verification.artifact_path | text) and
    (.notification.route | text) and
    (.policy.allowed_actions | length > 0) and
    (all(.policy.allowed_actions[]; text)) and
    (.policy.release_policy | text)
  ' "$config" >/dev/null || die "not ready for dispatch: disabled or required values are unknown"
fi

echo "project-register: valid ($mode): $(jq -r '.project' "$config")"
