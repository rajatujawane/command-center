#!/usr/bin/env bash
# engine/imessage/read.sh  <group-name>  [hours]
# Prints inbound messages (not from me) in a NAMED group chat from the last N hours
# (default 1), newest first, as:  <ISO ts>\t<text>
#
# Requires Full Disk Access for whatever process runs this (Claude Code), because it
# reads ~/Library/Messages/chat.db directly.
#
# Find your group's display_name:
#   sqlite3 ~/Library/Messages/chat.db \
#     "SELECT ROWID, guid, chat_identifier, display_name FROM chat WHERE display_name != '' ORDER BY ROWID DESC LIMIT 20;"

set -euo pipefail
group="$1"
hours="${2:-1}"
db="$HOME/Library/Messages/chat.db"

sqlite3 -separator $'\t' "$db" "
  SELECT datetime(m.date/1000000000 + 978307200, 'unixepoch', 'localtime') AS ts,
         m.text
  FROM message m
  JOIN chat_message_join cmj ON cmj.message_id = m.ROWID
  JOIN chat c ON c.ROWID = cmj.chat_id
  WHERE c.display_name = '$group'
    AND m.is_from_me = 0
    AND m.text IS NOT NULL
    AND (m.date/1000000000 + 978307200) > strftime('%s','now','-$hours hours')
  ORDER BY m.date DESC;
"