#!/bin/bash
# Meldet Session-Ergebnis an Office (.253) Kollektiv-Hippocampus

OFFICE_IP="192.168.42.253"
OFFICE_PORT="2222"
KOLLEKTIV_FILE="/opt/Claude/Kollektiv/Hippocampus.md"

# Eigene IP ermitteln
MY_IP=$(hostname -I | awk '{print $1}' | grep -oE '192\.168\.42\.[0-9]+')
MY_HOSTNAME=$(hostname)
DATUM=$(date +%Y-%m-%d)
ZEIT=$(date +%H:%M)

# Parameter
SESSION_NR="${1:-?}"
ERGEBNIS="${2:-Keine Beschreibung}"
GELERNT="${3:-}"
TAGS="${4:-}"

# Meldung formatieren
MELDUNG="| ${DATUM} ${ZEIT} | ${MY_HOSTNAME} (${MY_IP}) | Session ${SESSION_NR} | ${ERGEBNIS} | ${TAGS} |"

# An Office senden (in Tabelle einfügen)
ssh -p ${OFFICE_PORT} dieterhorst@${OFFICE_IP} "
  # Backup
  cp ${KOLLEKTIV_FILE} ${KOLLEKTIV_FILE}.bak
  
  # Meldung nach 'Aktive Erkenntnisse' Tabelle einfügen
  sed -i '/^| Datum | VM | Session | Erkenntnis | Tags |/a ${MELDUNG}' ${KOLLEKTIV_FILE}
  
  echo 'Gemeldet an Office: ${ERGEBNIS}'
"

# Falls GELERNT angegeben, auch das speichern
if [ -n "$GELERNT" ]; then
  ssh -p ${OFFICE_PORT} dieterhorst@${OFFICE_IP} "
    echo '' >> ${KOLLEKTIV_FILE}
    echo '**${MY_HOSTNAME} (Session ${SESSION_NR}):** ${GELERNT}' >> ${KOLLEKTIV_FILE}
  "
fi

echo "✓ Session ${SESSION_NR} an Office gemeldet"
