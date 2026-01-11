#!/bin/bash
# Remote tmux Keep-Alive mit Session-Auswahl
#
# Nutzung: ./remote-keepalive.sh [IP] [Intervall]
#
# Beispiele:
#   ./remote-keepalive.sh                    # Interaktive IP-Auswahl
#   ./remote-keepalive.sh 192.168.42.246     # Direkt zu edo
#   ./remote-keepalive.sh 192.168.42.246 30  # Mit 30s Intervall

# Bekannte Server
declare -A SERVERS=(
    ["edo"]="192.168.42.246"
    ["thea"]="192.168.42.252"
    ["devoraxx"]="192.168.42.214"
    ["mira"]="192.168.42.15"
    ["proxy"]="192.168.42.254"
    ["office"]="192.168.42.253"
)

INTERVAL="${2:-15}"

# Funktion: Server auswählen
select_server() {
    echo "Verfügbare Server:"
    echo ""
    local i=1
    local keys=()
    for name in "${!SERVERS[@]}"; do
        echo "  $i) $name (${SERVERS[$name]})"
        keys+=("$name")
        ((i++))
    done
    echo "  $i) Andere IP eingeben"
    echo ""
    read -p "Auswahl [1-$i]: " choice

    if [[ "$choice" -eq "$i" ]]; then
        read -p "IP-Adresse: " TARGET_IP
    elif [[ "$choice" -ge 1 && "$choice" -lt "$i" ]]; then
        local idx=$((choice - 1))
        TARGET_IP="${SERVERS[${keys[$idx]}]}"
        TARGET_NAME="${keys[$idx]}"
    else
        echo "Ungültige Auswahl"
        exit 1
    fi
}

# Funktion: tmux-Session auswählen
select_session() {
    echo ""
    echo "Lade Sessions von $TARGET_IP..."

    SESSIONS=$(ssh -p 2222 -o ConnectTimeout=5 dieterhorst@"$TARGET_IP" "tmux list-sessions -F '#{session_name}'" 2>/dev/null)

    if [[ -z "$SESSIONS" ]]; then
        echo "Keine tmux-Sessions gefunden oder Verbindung fehlgeschlagen!"
        exit 1
    fi

    echo ""
    echo "Verfügbare Sessions:"
    echo ""
    local i=1
    local sess_array=()
    while IFS= read -r sess; do
        echo "  $i) $sess"
        sess_array+=("$sess")
        ((i++))
    done <<< "$SESSIONS"

    echo ""
    read -p "Auswahl [1-$((i-1))]: " choice

    if [[ "$choice" -ge 1 && "$choice" -lt "$i" ]]; then
        TARGET_SESSION="${sess_array[$((choice - 1))]}"
    else
        echo "Ungültige Auswahl"
        exit 1
    fi
}

# Funktion: Intervall wählen
select_interval() {
    echo ""
    echo "Intervall:"
    echo "  1) 15 Sekunden"
    echo "  2) 30 Sekunden"
    echo "  3) 60 Sekunden"
    echo "  4) Andere"
    echo ""
    read -p "Auswahl [1-4] (Enter=15s): " choice

    case "$choice" in
        1|"") INTERVAL=15 ;;
        2) INTERVAL=30 ;;
        3) INTERVAL=60 ;;
        4) read -p "Sekunden: " INTERVAL ;;
    esac
}

# Hauptprogramm
echo "=== Remote tmux Keep-Alive ==="
echo ""

# IP bestimmen
if [[ -n "$1" ]]; then
    TARGET_IP="$1"
    # Name finden falls bekannt
    for name in "${!SERVERS[@]}"; do
        if [[ "${SERVERS[$name]}" == "$TARGET_IP" ]]; then
            TARGET_NAME="$name"
            break
        fi
    done
else
    select_server
fi

# Session auswählen
select_session

# Intervall (nur wenn nicht als Parameter)
if [[ -z "$2" ]]; then
    select_interval
fi

# Bestätigung
echo ""
echo "=== Konfiguration ==="
echo "Server:   $TARGET_IP ${TARGET_NAME:+($TARGET_NAME)}"
echo "Session:  $TARGET_SESSION"
echo "Intervall: ${INTERVAL}s"
echo ""
read -p "Starten? [J/n]: " confirm

if [[ "$confirm" =~ ^[Nn] ]]; then
    echo "Abgebrochen."
    exit 0
fi

# Alten Prozess für diese IP stoppen falls vorhanden
PIDFILE="/tmp/keepalive-${TARGET_IP}.pid"
if [[ -f "$PIDFILE" ]]; then
    OLD_PID=$(cat "$PIDFILE")
    if kill -0 "$OLD_PID" 2>/dev/null; then
        echo "Stoppe alten Prozess (PID: $OLD_PID)..."
        kill "$OLD_PID" 2>/dev/null
        sleep 1
    fi
fi

# Keep-Alive starten
LOGFILE="/tmp/keepalive-${TARGET_IP}.log"

nohup bash -c "
while true; do
    sleep $INTERVAL
    ssh -p 2222 -o ConnectTimeout=5 dieterhorst@$TARGET_IP \"tmux send-keys -t '$TARGET_SESSION' C-u Enter\" 2>/dev/null
    if [[ \$? -eq 0 ]]; then
        echo \"\$(date '+%H:%M:%S') - Enter an $TARGET_SESSION gesendet\"
    else
        echo \"\$(date '+%H:%M:%S') - FEHLER: Verbindung fehlgeschlagen\"
    fi
done
" > "$LOGFILE" 2>&1 &

NEW_PID=$!
echo "$NEW_PID" > "$PIDFILE"

echo ""
echo "=== Gestartet ==="
echo "PID:  $NEW_PID"
echo "Log:  $LOGFILE"
echo ""
echo "Befehle:"
echo "  tail -f $LOGFILE     # Log verfolgen"
echo "  kill $NEW_PID              # Stoppen"
echo ""
