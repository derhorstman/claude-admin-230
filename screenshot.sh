#!/bin/bash
# Screenshot-Script fuer DevoraXx
# Holt den neuesten Screenshot vom Mac (192.168.42.17) und speichert ihn unter /opt/Claude/screenshots/

SCREENSHOT_DIR="/opt/Claude/screenshots"
MAC_HOST="dieterhorst@192.168.42.17"
MAC_DESKTOP="/Users/dieterhorst/Desktop"
MAC_PASS="Fantasy+"

# Verzeichnis erstellen falls nicht vorhanden
mkdir -p "$SCREENSHOT_DIR"

# Neuesten Screenshot auf dem Mac finden
echo "Suche neuesten Screenshot auf Mac..."
LATEST=$(sshpass -p "$MAC_PASS" ssh -o StrictHostKeyChecking=no "$MAC_HOST" \
    "ls -t '$MAC_DESKTOP'/Bildschirmfoto*.png 2>/dev/null | head -1")

if [ -z "$LATEST" ]; then
    echo "Kein Screenshot auf dem Mac Desktop gefunden."
    exit 1
fi

# Dateiname extrahieren und Zeitstempel erstellen
BASENAME=$(basename "$LATEST")
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
FILENAME="screenshot_${TIMESTAMP}.png"
FILEPATH="${SCREENSHOT_DIR}/${FILENAME}"

# Screenshot kopieren
echo "Kopiere: $BASENAME"
sshpass -p "$MAC_PASS" scp -o StrictHostKeyChecking=no "$MAC_HOST:$LATEST" "$FILEPATH"

if [ $? -eq 0 ]; then
    echo "Screenshot gespeichert: $FILEPATH"

    # Auch als latest.png speichern für einfachen Zugriff
    cp "$FILEPATH" "${SCREENSHOT_DIR}/latest.png"
    echo "Kopie: ${SCREENSHOT_DIR}/latest.png"

    # Optional: Screenshot auf Mac loeschen
    # sshpass -p "$MAC_PASS" ssh -o StrictHostKeyChecking=no "$MAC_HOST" "rm '$LATEST'"
    # echo "Original auf Mac geloescht."

    exit 0
else
    echo "Fehler beim Kopieren des Screenshots."
    exit 1
fi
