#!/bin/bash
# Fragt Office (.253) nach Wissen aus dem Kollektiv-Hippocampus

OFFICE_IP="192.168.42.253"
OFFICE_PORT="2222"
KOLLEKTIV_FILE="/opt/Claude/Kollektiv/Hippocampus.md"

FRAGE="$1"

if [ -z "$FRAGE" ]; then
  echo "Verwendung: frag-office.sh \"suchbegriff oder frage\""
  echo "Beispiele:"
  echo "  frag-office.sh tmux"
  echo "  frag-office.sh \"wer kennt Docker\""
  exit 1
fi

echo "=== Frage an Office: $FRAGE ==="
echo ""

# Durchsuche Kollektiv-Hippocampus
ssh -p ${OFFICE_PORT} dieterhorst@${OFFICE_IP} "grep -i '${FRAGE}' ${KOLLEKTIV_FILE}" 2>/dev/null

if [ $? -ne 0 ]; then
  echo "(Keine Treffer im Kollektiv-Hippocampus)"
fi
