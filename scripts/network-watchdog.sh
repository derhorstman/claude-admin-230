#!/bin/bash
# Network Watchdog - prüft Netzwerk und startet bei Bedarf neu
# Läuft als Cronjob alle 2 Minuten

GATEWAY="192.168.42.1"
LOGFILE="/var/log/network-watchdog.log"
MAX_FAILS=2

# Ping-Test
ping -c 1 -W 3 $GATEWAY > /dev/null 2>&1
RESULT=$?

if [ $RESULT -eq 0 ]; then
    # Alles OK - nichts tun
    exit 0
fi

# Fehlgeschlagen - zweiter Versuch
sleep 2
ping -c 1 -W 3 $GATEWAY > /dev/null 2>&1
RESULT=$?

if [ $RESULT -eq 0 ]; then
    exit 0
fi

# Netzwerk ist wirklich down - neu starten
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
echo "[$TIMESTAMP] Gateway nicht erreichbar - starte Netzwerk neu" >> $LOGFILE

# Netzwerk neu starten
systemctl restart networking 2>> $LOGFILE

sleep 5

# Prüfen ob es funktioniert hat
ping -c 1 -W 3 $GATEWAY > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "[$TIMESTAMP] Netzwerk erfolgreich neugestartet" >> $LOGFILE
else
    echo "[$TIMESTAMP] WARNUNG: Netzwerk-Neustart hat nicht geholfen!" >> $LOGFILE
fi
