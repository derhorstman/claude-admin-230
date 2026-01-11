#!/bin/bash
# Schreibt Text in das Terminal eines Kollegen-Servers
# Usage: kollege-schreiben.sh <IP> <Text>
# Beispiel: kollege-schreiben.sh 166 "Hallo Kollege!"

IP="$1"
TEXT="$2"

if [ -z "$IP" ] || [ -z "$TEXT" ]; then
    echo "Usage: $0 <IP> <Text>"
    echo "Beispiel: $0 166 'Hallo vom Admin-Server!'"
    echo ""
    echo "Verfügbare Kollegen:"
    echo "  166 - cant (Chor-Software)"
    echo "  246 - edo"
    echo "  214 - devoraxx"
    echo "  252 - thea"
    echo "  253 - office"
    echo "  254 - proxy"
    echo "  15  - mira"
    echo "  150 - opsref"
    exit 1
fi

# Kurze IP zu voller IP
if [[ ! "$IP" =~ \. ]]; then
    IP="192.168.42.$IP"
fi

echo "Verbinde zu $IP..."

# Aktive tmux-Session finden
SESSION=$(ssh -p 2222 -o ConnectTimeout=5 dieterhorst@$IP "tmux list-sessions -F '#{session_name}' 2>/dev/null | grep web-terminal | head -1")

if [ -z "$SESSION" ]; then
    echo "Keine aktive web-terminal Session auf $IP gefunden."
    echo "Prüfe ob Claude dort läuft..."
    ssh -p 2222 dieterhorst@$IP "ps aux | grep -E 'claude|tmux' | grep -v grep"
    exit 1
fi

echo "Session gefunden: $SESSION"
echo "Sende: $TEXT"

# Text in Session schreiben
ssh -p 2222 dieterhorst@$IP "tmux send-keys -t '$SESSION' '$TEXT' Enter"

if [ $? -eq 0 ]; then
    echo "Erfolgreich gesendet!"
else
    echo "Fehler beim Senden."
    exit 1
fi
