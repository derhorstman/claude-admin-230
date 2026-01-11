#!/bin/bash
# Hippocampus Auto-Archivierung
# Verschiebt alte Sessions wenn > 500 Zeilen

HIPPO="/opt/Claude/01_START/Hippocampus.md"
ARCHIV="/opt/Claude/01_START/Hippocampus_Archiv.md"
MAX_LINES=500
KEEP_LINES=300

LINES=$(wc -l < "$HIPPO")

if [ "$LINES" -gt "$MAX_LINES" ]; then
    echo "Hippocampus hat $LINES Zeilen (max $MAX_LINES)"

    # Berechne wie viele Zeilen archiviert werden
    ARCHIVE_LINES=$((LINES - KEEP_LINES))

    # Archiv-Header wenn neu
    if [ ! -f "$ARCHIV" ]; then
        echo "# Hippocampus Archiv" > "$ARCHIV"
        echo "" >> "$ARCHIV"
        echo "Alte Sessions zur Referenz." >> "$ARCHIV"
        echo "" >> "$ARCHIV"
        echo "---" >> "$ARCHIV"
        echo "" >> "$ARCHIV"
    fi

    # Alte Sessions (ab Zeile KEEP_LINES+1) ans Archiv anhängen
    tail -n +"$((KEEP_LINES + 1))" "$HIPPO" >> "$ARCHIV"

    # Hippocampus auf KEEP_LINES kürzen
    head -n "$KEEP_LINES" "$HIPPO" > "${HIPPO}.tmp"
    mv "${HIPPO}.tmp" "$HIPPO"

    NEW_LINES=$(wc -l < "$HIPPO")
    echo "Archiviert: $ARCHIVE_LINES Zeilen -> $ARCHIV"
    echo "Hippocampus jetzt: $NEW_LINES Zeilen"
else
    echo "Hippocampus OK: $LINES Zeilen (max $MAX_LINES)"
fi
