#!/usr/bin/env bash
# Load the permanent Linear reference registry into an initialized runner database.

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
db="${1:-$ROOT/state/runner.sqlite}"
registry="${2:-$ROOT/projects/protected-references.json}"

die() {
  echo "protected-references: $*" >&2
  exit 1
}

[ $# -le 2 ] || die "usage: load-protected-references.sh [database] [registry.json]"
[ -f "$db" ] || die "database not found: $db"
[ -f "$registry" ] || die "registry not found: $registry"
jq empty "$registry" >/dev/null 2>&1 || die "invalid JSON: $registry"

jq -e '
  .schema_version == 1 and
  (.source | type == "string" and test("^[a-z0-9:-]+$")) and
  (.references | type == "array" and length > 0) and
  all(.references[];
    (.identifier | type == "string" and test("^VAR-[0-9]+$")) and
    (.linear_issue_id | type == "string" and test("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$")) and
    (.seed_marker | type == "string" and test("^[a-z0-9:-]+$"))
  ) and
  (([.references[].linear_issue_id] | unique | length) == (.references | length)) and
  (([.references[].seed_marker] | unique | length) == (.references | length))
' "$registry" >/dev/null || die "invalid or duplicate protected-reference entry"

sqlite3 "$db" "SELECT 1 FROM protected_references LIMIT 1;" >/dev/null 2>&1 \
  || die "database schema is not initialized: $db"

source_name="$(jq -r '.source' "$registry")"

# Existing membership is append-only. An ID may be reloaded only with the same marker and source.
while IFS=$'\t' read -r issue_id marker; do
  existing="$(sqlite3 -separator '|' "$db" \
    "SELECT seed_marker || '|' || source FROM protected_references WHERE linear_issue_id = '$issue_id';")"
  if [ -n "$existing" ] && [ "$existing" != "$marker|$source_name" ]; then
    die "append-only conflict for protected issue: $issue_id"
  fi
done < <(jq -r '.references[] | [.linear_issue_id, .seed_marker] | @tsv' "$registry")

{
  echo "PRAGMA foreign_keys = ON;"
  echo "BEGIN IMMEDIATE;"
  jq -r --arg source "$source_name" '
    .references[] |
    "INSERT OR IGNORE INTO protected_references (linear_issue_id, seed_marker, source, loaded_at) VALUES (\u0027" +
    .linear_issue_id + "\u0027, \u0027" + .seed_marker + "\u0027, \u0027" + $source +
    "\u0027, strftime(\u0027%Y-%m-%dT%H:%M:%fZ\u0027, \u0027now\u0027));"
  ' "$registry"
  echo "COMMIT;"
} | sqlite3 "$db"

expected="$(jq '.references | length' "$registry")"
loaded="$(sqlite3 "$db" "SELECT count(*) FROM protected_references WHERE source = '$source_name';")"
[ "$loaded" = "$expected" ] || die "registry load incomplete: expected $expected, found $loaded"

echo "protected-references: loaded $loaded"
