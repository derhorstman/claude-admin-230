#!/bin/bash
# Sendet periodisch Enter an ein tmux-Pane um es aktiv zu halten
#
# Nutzung: ./tmux-keepalive.sh [session:window.pane] [intervall_sekunden]
#
# Beispiele:
#   ./tmux-keepalive.sh              # Standard: Session "0", Pane "0", alle 60s
#   ./tmux-keepalive.sh claude       # Session "claude", alle 60s
#   ./tmux-keepalive.sh claude:0.1   # Session "claude", Window 0, Pane 1
#   ./tmux-keepalive.sh claude 30    # Session "claude", alle 30s

TARGET="${1:-0}"
INTERVAL="${2:-60}"

echo "Keep-Alive für tmux '$TARGET'"
echo "Intervall: ${INTERVAL}s"
echo "Stoppen mit Ctrl+C"
echo ""

# Prüfen ob Target existiert
if ! tmux has-session -t "$TARGET" 2>/dev/null; then
    echo "Fehler: tmux Session '$TARGET' nicht gefunden!"
    echo ""
    echo "Verfügbare Sessions:"
    tmux list-sessions 2>/dev/null || echo "  (keine)"
    exit 1
fi

while true; do
    sleep "$INTERVAL"
    tmux send-keys -t "$TARGET" C-u Enter
    echo "$(date '+%H:%M:%S') - Enter gesendet an '$TARGET'"
done
