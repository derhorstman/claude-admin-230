#!/bin/bash
# Deploy Selbsterhaltung + Claude Code auf neue VM
# Usage: ./deploy-selbsterhaltung.sh <IP>

set -e

if [ -z "$1" ]; then
    echo "Usage: $0 <IP>"
    echo "Beispiel: $0 192.168.42.253"
    exit 1
fi

IP="$1"
USER="dieterhorst"
PASS="Fantasy+"
TEMPLATE_DIR="/opt/Claude/templates"

echo "=== Selbsterhaltung + Claude Deploy auf $IP ==="

# 1. SSH-Key kopieren (versuche beide Ports)
echo "[1/9] SSH-Key kopieren..."
sshpass -p "$PASS" ssh-copy-id -o StrictHostKeyChecking=no -p 2222 $USER@$IP 2>/dev/null || \
sshpass -p "$PASS" ssh-copy-id -o StrictHostKeyChecking=no $USER@$IP 2>/dev/null || \
echo "Key bereits vorhanden"

# 2. SSH-Port erkennen
echo "[2/9] SSH-Port erkennen..."
if ssh -o StrictHostKeyChecking=no -o ConnectTimeout=3 -p 2222 $USER@$IP "true" 2>/dev/null; then
    PORT=2222
    echo "    Port 2222 erkannt"
elif ssh -o StrictHostKeyChecking=no -o ConnectTimeout=3 $USER@$IP "true" 2>/dev/null; then
    PORT=22
    echo "    Port 22 erkannt"
else
    echo "FEHLER: Keine SSH-Verbindung möglich"
    exit 1
fi

# SSH-Befehl helper
SSH_CMD="ssh -o StrictHostKeyChecking=no -p $PORT $USER@$IP"

# 3. Hostname und OS holen
echo "[3/9] System-Info holen..."
HOSTNAME=$($SSH_CMD "hostname" 2>/dev/null)
OS=$($SSH_CMD "grep PRETTY_NAME /etc/os-release | cut -d'\"' -f2" 2>/dev/null || echo "Unknown")
DATUM=$(date +%Y-%m-%d)

echo "    Hostname: $HOSTNAME"
echo "    OS: $OS"

# 4. Node.js 22 + tmux installieren
echo "[4/9] Node.js 22 + tmux installieren..."
$SSH_CMD "sudo apt-get install -y tmux"
$SSH_CMD "command -v node >/dev/null 2>&1 && echo 'Node.js bereits installiert:' && node -v || (
    curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash - &&
    sudo apt-get install -y nodejs
)"

# 5. Claude Code 2.0.65 installieren (stabile Version!)
echo "[5/9] Claude Code 2.0.65 installieren..."
$SSH_CMD "command -v claude >/dev/null 2>&1 && echo 'Claude Code bereits installiert:' && claude --version || (
    sudo npm install -g @anthropic-ai/claude-code@2.0.65
)"
# Auto-Updates deaktivieren
$SSH_CMD "mkdir -p ~/.claude && echo '{\"autoUpdates\": false}' > ~/.claude.json"

# 6. Verzeichnisse erstellen
echo "[6/9] Verzeichnisse erstellen..."
$SSH_CMD "sudo mkdir -p /opt/Claude/01_START /opt/Claude/archiv /opt/Claude/screenshots /opt/Claude/scripts /opt/Claude/hooks /opt/Claude/prompts && sudo chown -R $USER:$USER /opt/Claude"

# 7. Templates kopieren und Platzhalter ersetzen (# als Delimiter wegen Slashes in OS)
echo "[7/9] Templates deployen..."
for file in aktuell.md Praefrontaler_Cortex.md Hippocampus.md feierabend.md startprompt.txt; do
    cat "$TEMPLATE_DIR/01_START/$file" | \
        sed "s#{{IP}}#$IP#g" | \
        sed "s#{{HOSTNAME}}#$HOSTNAME#g" | \
        sed "s#{{OS}}#$OS#g" | \
        sed "s#{{DATUM}}#$DATUM#g" | \
    $SSH_CMD "cat > /opt/Claude/01_START/$file"
    echo "    $file"
done

# Screenshot-Script kopieren
scp -P $PORT /opt/Claude/screenshot.sh $USER@$IP:/opt/Claude/
$SSH_CMD "chmod +x /opt/Claude/screenshot.sh"
echo "    screenshot.sh"

# Network-Watchdog kopieren und Cronjob einrichten
scp -P $PORT /opt/Claude/scripts/network-watchdog.sh $USER@$IP:/opt/Claude/ 2>/dev/null || true
$SSH_CMD "chmod +x /opt/Claude/network-watchdog.sh 2>/dev/null || true"
$SSH_CMD "(crontab -l 2>/dev/null | grep -v network-watchdog; echo '*/2 * * * * /opt/Claude/network-watchdog.sh') | crontab -" 2>/dev/null || true
echo "    network-watchdog.sh + cronjob (alle 2 min)"

# Pre-Session-Backup Script kopieren
scp -P $PORT /opt/Claude/scripts/pre-session-backup.sh $USER@$IP:/opt/Claude/scripts/
$SSH_CMD "chmod +x /opt/Claude/scripts/pre-session-backup.sh"
echo "    pre-session-backup.sh"

# Credentials kopieren (falls vorhanden)
if [ -f ~/.claude/.credentials.json ]; then
    $SSH_CMD "mkdir -p ~/.claude"
    scp -P $PORT ~/.claude/.credentials.json $USER@$IP:~/.claude/
    echo "    credentials kopiert"
fi

# 8. SSH-Port auf 2222 umstellen (falls noch auf 22)
if [ "$PORT" = "22" ]; then
    echo "[8/9] SSH-Port auf 2222 umstellen..."
    $SSH_CMD "sudo sed -i 's/^#Port 22/Port 2222/' /etc/ssh/sshd_config && sudo sed -i 's/^Port 22$/Port 2222/' /etc/ssh/sshd_config && sudo systemctl restart sshd"
    sleep 2
    # Verbindung testen
    if ssh -o StrictHostKeyChecking=no -o ConnectTimeout=3 -p 2222 $USER@$IP "true" 2>/dev/null; then
        PORT=2222
        echo "    Port 2222 aktiv"
    else
        echo "    WARNUNG: Port-Umstellung fehlgeschlagen"
    fi
else
    echo "[8/9] SSH-Port bereits 2222"
fi

# 9. Verbindung testen
echo "[9/9] Verbindung testen..."
SSH_CMD="ssh -o StrictHostKeyChecking=no -p $PORT $USER@$IP"
if $SSH_CMD "claude --version" >/dev/null 2>&1; then
    echo "    Claude Code funktioniert"
else
    echo "    WARNUNG: Claude Code nicht erreichbar"
fi

# Update SSH-Port in Praefrontaler_Cortex.md
SSH_CMD="ssh -o StrictHostKeyChecking=no -p $PORT $USER@$IP"
$SSH_CMD "sed -i 's#| SSH | Port 22 |#| SSH | Port 2222 |#' /opt/Claude/01_START/Praefrontaler_Cortex.md"

# Version checken
CLAUDE_VERSION=$($SSH_CMD "claude --version 2>/dev/null" || echo "nicht installiert")
NODE_VERSION=$($SSH_CMD "node -v 2>/dev/null" || echo "nicht installiert")

echo ""
echo "=== Fertig! ==="
echo "Server: $IP ($HOSTNAME)"
echo "OS: $OS"
echo "Node.js: $NODE_VERSION"
echo "Claude Code: $CLAUDE_VERSION"
echo "SSH: ssh -p $PORT $USER@$IP"
echo "Startwort: start"
