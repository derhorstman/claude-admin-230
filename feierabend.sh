#!/bin/bash
# Feierabend Git-Backup Script
# Nutzung: ./feierabend.sh "Session Zusammenfassung"

cd /opt/Claude || exit 1

# Git-Config falls nicht gesetzt
git config user.email 2>/dev/null || git config user.email "dieterhorst@systemhaus-horst.de"
git config user.name 2>/dev/null || git config user.name "Dieter Horst"

# Zusammenfassung aus Parameter oder Standard
SUMMARY="${1:-Feierabend-Backup}"
DATE=$(date +%Y-%m-%d)
HOSTNAME=$(hostname)

# Alle Änderungen stagen
git add -A

# Prüfen ob es Änderungen gibt
if git diff --cached --quiet; then
    echo "Keine Änderungen zum Committen auf $HOSTNAME"
    exit 0
fi

# Commit erstellen
git commit -m "Session $DATE ($HOSTNAME): $SUMMARY"

if [ $? -eq 0 ]; then
    echo "Git-Backup erfolgreich auf $HOSTNAME"
    git log --oneline -1
else
    echo "Git-Backup fehlgeschlagen auf $HOSTNAME"
    exit 1
fi
