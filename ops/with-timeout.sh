#!/usr/bin/env bash
# ops/with-timeout.sh <seconds> <command> [args...]
#
# Run a command with a wall-clock limit. Exits 124 if the limit was hit, otherwise the
# command's own exit code.
#
# macOS ships no `timeout` and no `gtimeout` (those come from GNU coreutils, which is not
# installed here). Rather than depend on a brew package the mini may not have after a
# rebuild, this does it with job control only.
#
# TERM first, then KILL five seconds later — a claude run that is mid-write gets a chance
# to finish the file before it is destroyed.
#
# The watcher records that it fired by creating a marker file. Do NOT infer "timed out"
# from the exit code alone: 143 is also what a command gets when a human kills it, and the
# watcher is still alive during its own grace period, so neither signal nor liveness tells
# you who did it.
set -uo pipefail

secs="${1:?usage: with-timeout.sh <seconds> <command> [args...]}"; shift
[ $# -gt 0 ] || { echo "with-timeout.sh: no command given" >&2; exit 2; }

marker="$(mktemp -t cc-timeout)"; rm -f "$marker"

"$@" &
pid=$!

( sleep "$secs"
  kill -0 "$pid" 2>/dev/null || exit 0     # finished on its own; do nothing
  : > "$marker"
  kill -TERM "$pid" 2>/dev/null
  sleep 5
  kill -KILL "$pid" 2>/dev/null ) &
watcher=$!

wait "$pid" 2>/dev/null; rc=$?

kill "$watcher" 2>/dev/null; wait "$watcher" 2>/dev/null

if [ -f "$marker" ]; then
  rm -f "$marker"
  echo "with-timeout.sh: killed after ${secs}s" >&2
  exit 124
fi
rm -f "$marker"
exit "$rc"
