#!/bin/bash
# Context-Warning Hook für Claude Code
# Warnt wenn Kontext > 70% gefüllt ist

input=$(cat)

# Context-Daten extrahieren
context_size=$(echo "$input" | jq -r '.context_window.context_window_size // 200000')
current_usage=$(echo "$input" | jq -r '.context_window.current_usage // empty')

if [ -n "$current_usage" ]; then
    input_tokens=$(echo "$current_usage" | jq -r '.input_tokens // 0')
    cache_creation=$(echo "$current_usage" | jq -r '.cache_creation_input_tokens // 0')
    cache_read=$(echo "$current_usage" | jq -r '.cache_read_input_tokens // 0')
    
    # Gesamte Token berechnen
    total_tokens=$((input_tokens + cache_creation + cache_read))
    
    # Prozent berechnen
    if [ "$context_size" -gt 0 ]; then
        percent=$((total_tokens * 100 / context_size))
    else
        percent=0
    fi
    
    # Warnungen ausgeben
    if [ "$percent" -ge 90 ]; then
        echo "🚨 KRITISCH: Context bei ${percent}% - Zusammenfassung steht unmittelbar bevor!"
        echo "Führe JETZT die Feierabend-Routine aus: lies /opt/Claude/01_START/feierabend.md"
    elif [ "$percent" -ge 80 ]; then
        echo "⚠️ WARNUNG: Context bei ${percent}% - Wird eng!"
        echo "Schließe aktuelle Aufgabe ab und führe Feierabend-Routine aus."
    elif [ "$percent" -ge 70 ]; then
        echo "📊 CONTEXT bei ${percent}% - Zeit für Feierabend-Routine!"
        echo "Lies /opt/Claude/01_START/feierabend.md und aktualisiere deine Selbsterhaltung."
    fi
fi

exit 0
