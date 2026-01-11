#!/bin/bash
#
# Backup VM-Daten nach QNAP NAS (NASHORST)
# Sichert /opt/ Projektdaten von allen VMs
# Streamt direkt aufs NAS (kein lokaler Speicherplatz nötig)
#
# QNAP: 192.168.42.126 (NASHORST)
# Share: //192.168.42.126/Public
# Mount: /mnt/nashorst
#

QNAP_IP="192.168.42.126"
QNAP_SHARE="Public"
QNAP_USER="dieterhorst"
QNAP_PASS="Mondstein2026"
MOUNT_POINT="/mnt/nashorst"
BACKUP_DIR="$MOUNT_POINT/Backups/VMs"
DATE=$(date +%Y-%m-%d_%H%M)
LOG="$MOUNT_POINT/Backups/backup-$DATE.log"
RETENTION_DAYS=14

# VMs mit SSH-Port
declare -A VMS=(
    ["MIRA_.15"]="192.168.42.15:2222"
    ["DevoraXx_.214"]="192.168.42.214:2222"
    ["Admin-Portal_.230"]="LOCAL"
    ["DNS-DHCP_.216"]="192.168.42.216:2222"
    ["Reverse-Proxy_.254"]="192.168.42.254:2222"
    ["Office_.253"]="192.168.42.253:2222"
    ["Thea_.252"]="192.168.42.252:2222"
    ["edo_.246"]="192.168.42.246:2222"
    ["PEDAGOGUS_.128"]="192.168.42.128:2222"
    ["OpsRef_.150"]="192.168.42.150:2222"
    ["cant_.166"]="192.168.42.166:2222"
    ["NEU_.174"]="192.168.42.174:2222"
)

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG"
}

echo "=== VM-Backup nach QNAP (NASHORST) ==="
echo "Start: $(date)"
echo ""

# Prüfe ob QNAP erreichbar ist
echo "Prüfe QNAP-Erreichbarkeit..."
if ! ping -c 1 -W 3 $QNAP_IP &>/dev/null; then
    echo "FEHLER: QNAP ($QNAP_IP) nicht erreichbar!"
    exit 1
fi

# Mount-Point erstellen falls nicht vorhanden
sudo mkdir -p $MOUNT_POINT

# Prüfe ob bereits gemountet
if ! mountpoint -q $MOUNT_POINT; then
    echo "Mounte QNAP-Share..."
    sudo mount -t cifs //$QNAP_IP/$QNAP_SHARE $MOUNT_POINT \
        -o credentials=/root/.qnap-credentials,vers=3.0,uid=$(id -u),gid=$(id -g)

    if [ $? -ne 0 ]; then
        echo "FEHLER: Mount fehlgeschlagen!"
        exit 1
    fi
fi

# Backup-Verzeichnis erstellen
mkdir -p $BACKUP_DIR

# Ab hier ins Log schreiben
log "=== VM-Backup nach QNAP (NASHORST) ==="
log "Start: $(date)"

# Freien Speicher prüfen
FREE_SPACE=$(df -h $MOUNT_POINT | tail -1 | awk '{print $4}')
log "Verfügbarer Speicher auf QNAP: $FREE_SPACE"
log ""

SUCCESS=0
FAILED=0

for VM in "${!VMS[@]}"; do
    NAME=$(echo $VM | cut -d'_' -f1)
    IP=$(echo $VM | cut -d'_' -f2)
    TARGET="${VMS[$VM]}"

    log "=== $NAME ($IP) ==="

    # Direkt aufs NAS schreiben (kein lokaler Zwischenspeicher)
    FINAL_ARCHIVE="$BACKUP_DIR/${NAME}_${DATE}.tar.gz"

    if [ "$TARGET" == "LOCAL" ]; then
        # Lokaler Server (.230) - direkt aufs NAS streamen
        log "Packe lokale Daten direkt aufs NAS..."
        tar -czf "$FINAL_ARCHIVE" \
            --exclude='node_modules' \
            --exclude='.git' \
            --exclude='*.log' \
            --exclude='__pycache__' \
            --exclude='.venv' \
            --exclude='*.pyc' \
            /opt/Claude \
            /opt/admin-portal 2>/dev/null

        if [ $? -eq 0 ] && [ -s "$FINAL_ARCHIVE" ]; then
            SIZE=$(du -h "$FINAL_ARCHIVE" | cut -f1)
            log "OK: $NAME gesichert ($SIZE)"
            ((SUCCESS++))
        else
            log "FEHLER: Archiv nicht erstellt!"
            ((FAILED++))
            rm -f "$FINAL_ARCHIVE"
        fi
    else
        # Remote VM via SSH - direkt aufs NAS streamen
        HOST=$(echo $TARGET | cut -d':' -f1)
        PORT=$(echo $TARGET | cut -d':' -f2)

        log "Verbinde zu $HOST:$PORT..."

        # Prüfe ob erreichbar
        if ! ssh -p $PORT -o ConnectTimeout=5 -o BatchMode=yes dieterhorst@$HOST "echo ok" &>/dev/null; then
            log "WARNUNG: $NAME nicht erreichbar - übersprungen"
            ((FAILED++))
            continue
        fi

        # Remote tar direkt aufs NAS streamen
        ssh -p $PORT dieterhorst@$HOST "tar -czf - \
            --exclude='node_modules' \
            --exclude='.git' \
            --exclude='*.log' \
            --exclude='__pycache__' \
            --exclude='.venv' \
            --exclude='*.pyc' \
            /opt/Claude /opt/*/ 2>/dev/null" > "$FINAL_ARCHIVE" 2>/dev/null

        if [ -s "$FINAL_ARCHIVE" ]; then
            SIZE=$(du -h "$FINAL_ARCHIVE" | cut -f1)
            log "OK: $NAME gesichert ($SIZE)"
            ((SUCCESS++))
        else
            log "FEHLER: Archiv leer oder nicht erstellt!"
            ((FAILED++))
            rm -f "$FINAL_ARCHIVE"
        fi
    fi

    log ""
done

# Alte Backups aufräumen
log "=== Aufräumen (Backups älter als $RETENTION_DAYS Tage) ==="
DELETED=$(find $BACKUP_DIR -name '*.tar.gz' -mtime +$RETENTION_DAYS -delete -print 2>/dev/null | wc -l)
log "Gelöscht: $DELETED alte Backups"

# Zusammenfassung
log ""
log "=== Zusammenfassung ==="
log "Erfolgreich: $SUCCESS"
log "Fehlgeschlagen: $FAILED"
log "Ende: $(date)"

# Aktuelle Backups anzeigen
log ""
log "Aktuelle Backups auf QNAP:"
ls -lh $BACKUP_DIR/*.tar.gz 2>/dev/null | tee -a "$LOG"

log ""
log "Backup abgeschlossen!"

# Gesamtgröße anzeigen
TOTAL=$(du -sh $BACKUP_DIR 2>/dev/null | cut -f1)
log "Gesamtgröße Backups: $TOTAL"
