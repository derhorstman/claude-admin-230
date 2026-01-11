#!/bin/bash
# Liest den Kontext (aktuell.md) von einem Kollegen-Server
# Usage: kollege-kontext.sh <IP>
# Beispiel: kollege-kontext.sh 166

IP="$1"

if [ -z "$IP" ]; then
    echo "Usage: $0 <IP>"
    echo "Beispiel: $0 166"
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

echo "=== Kontext von $IP ==="
echo ""

# aktuell.md lesen
ssh -p 2222 -o ConnectTimeout=5 dieterhorst@$IP "cat /opt/Claude/01_START/aktuell.md 2>/dev/null" || echo "(keine aktuell.md gefunden)"
