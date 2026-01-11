#!/bin/bash
# Pre-Session Backup Script
# Erstellt ein Backup von /opt/Claude vor jeder neuen Session

BACKUP_DIR="/opt/Claude/backups"
DATE=$(date +%Y-%m-%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/pre-session-$DATE.tar.gz"

# Backup-Verzeichnis erstellen falls nicht vorhanden
mkdir -p "$BACKUP_DIR"

# Backup erstellen (ohne das backups-Verzeichnis selbst)
tar -czf "$BACKUP_FILE" --exclude='backups' -C /opt Claude 2>/dev/null

# Nur die letzten 5 Backups behalten
cd "$BACKUP_DIR"
ls -t pre-session-*.tar.gz 2>/dev/null | tail -n +6 | xargs -r rm -f

echo "Backup erstellt: $BACKUP_FILE"
