#!/usr/bin/env bash
# engine/imessage/send.sh  <group-name>  <message>
# Sends an iMessage to a NAMED group chat from the Mac's signed-in iMessage account.
# The message may be multi-line. The group must have a name set in Messages.
#
# Find your group's name (or guid, if name-matching fails on your macOS version):
#   sqlite3 ~/Library/Messages/chat.db \
#     "SELECT guid, display_name FROM chat WHERE display_name != '' ORDER BY ROWID DESC LIMIT 20;"
# If "first chat whose name" errors, replace it with: text chat id "<guid>"
#
# Requires the Messages app to be running and signed in.

set -euo pipefail
group="$1"
msg="$2"

osascript - "$group" "$msg" <<'APPLESCRIPT'
on run argv
  set chatName to item 1 of argv
  set msgText to item 2 of argv
  tell application "Messages"
    set theChat to first chat whose name is chatName
    send msgText to theChat
  end tell
end run
APPLESCRIPT