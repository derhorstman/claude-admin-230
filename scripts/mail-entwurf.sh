#!/bin/bash
# Mail-Entwurf auf Mac erstellen
# Usage: mail-entwurf.sh "empfaenger@email.de" "Betreff" "Inhalt"

TO="$1"
SUBJECT="$2"
BODY="$3"

ssh dieterhorst@192.168.42.17 "osascript -e 'tell application \"Mail\"
    set newMessage to make new outgoing message with properties {subject:\"$SUBJECT\", content:\"$BODY\", visible:true}
    tell newMessage
        make new to recipient at end of to recipients with properties {address:\"$TO\"}
    end tell
end tell'"

echo "Mail-Entwurf erstellt: $SUBJECT"
