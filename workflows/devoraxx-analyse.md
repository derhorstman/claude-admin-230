# Workflow: VM-Projekt durch devoraxx analysieren

**Ziel:** projekt.yaml für eine VM erstellen, damit sie im Admin-Portal unter "Konzepte" erscheint.

---

## Schnellstart (Copy & Paste)

### 1. Code auf devoraxx kopieren

```bash
# VM-IP und Projektname anpassen
VM_IP="192.168.42.XXX"
PROJEKT="projektname"
PROJEKT_PFAD="/opt/$PROJEKT"

# Code kopieren (ohne node_modules, .git, etc.)
ssh -p 2222 dieterhorst@$VM_IP "cd /opt && tar czf - --exclude='node_modules' --exclude='.git' --exclude='__pycache__' --exclude='.next' --exclude='dist' --exclude='build' --exclude='.svelte-kit' $PROJEKT 2>/dev/null" | ssh -p 2222 dieterhorst@192.168.42.214 "cd /opt/devoraxx/code-uploads && rm -rf $PROJEKT && tar xzf -"
```

### 2. devoraxx Dienste starten (falls nicht laufen)

```bash
ssh -p 2222 dieterhorst@192.168.42.214 "cd /opt/devoraxx && docker-compose -f docker-compose.dev.yml up -d && pnpm dev &"
```

Warten bis Port 3001 verfügbar:
```bash
ssh -p 2222 dieterhorst@192.168.42.214 "ss -tlnp | grep 3001"
```

### 3. JWT-Token holen

```bash
TOKEN=$(ssh -p 2222 dieterhorst@192.168.42.214 "curl -s -X POST http://localhost:3001/auth/login -H 'Content-Type: application/json' -d '{\"email\": \"admin@devoraxx.de\", \"password\": \"admin123\"}'" | jq -r '.accessToken')
echo $TOKEN
```

### 4. Lokales Repository erstellen

```bash
PROJEKT="projektname"  # Muss mit Ordnername in code-uploads übereinstimmen!

RESULT=$(ssh -p 2222 dieterhorst@192.168.42.214 "curl -s -X POST 'http://localhost:3001/code-analysis/local?title=$PROJEKT&folder=$PROJEKT' -H 'Authorization: Bearer $TOKEN'")
echo $RESULT

# Analyse-ID extrahieren
ANALYSIS_ID=$(echo $RESULT | jq -r '.analysis.id')
echo "Analyse-ID: $ANALYSIS_ID"
```

### 5. Analyse starten (approve)

```bash
ssh -p 2222 dieterhorst@192.168.42.214 "curl -s -X POST 'http://localhost:3001/code-analysis/analyses/$ANALYSIS_ID/approve' -H 'Authorization: Bearer $TOKEN'"
```

### 6. Auf Ergebnis warten (~30-60 Sekunden)

```bash
# Status prüfen (COMPLETED = fertig)
ssh -p 2222 dieterhorst@192.168.42.214 "curl -s 'http://localhost:3001/code-analysis/analyses/$ANALYSIS_ID' -H 'Authorization: Bearer $TOKEN'" | jq '.status'

# Vollständiges Ergebnis
ssh -p 2222 dieterhorst@192.168.42.214 "curl -s 'http://localhost:3001/code-analysis/analyses/$ANALYSIS_ID' -H 'Authorization: Bearer $TOKEN'" | jq .
```

### 7. projekt.yaml auf Ziel-VM erstellen

Basierend auf den Analyse-Ergebnissen die `/opt/Claude/projekt.yaml` erstellen.

Template siehe: `/opt/Claude/templates/projekt_template.yaml`

---

## Wichtige Infos

### devoraxx Zugangsdaten
- **API:** http://192.168.42.214:3001
- **Frontend:** http://192.168.42.214:3000
- **Login:** admin@devoraxx.de / admin123

### Score-Mapping
| Score | Note | Bedeutung |
|-------|------|-----------|
| 5 | A | Exzellent |
| 4 | B | Gut |
| 3 | C | Durchschnitt |
| 2 | D | Verbesserungswürdig |
| 1 | F | Kritisch |

### API-Endpoints
| Endpoint | Methode | Zweck |
|----------|---------|-------|
| `/auth/login` | POST | JWT-Token holen |
| `/code-analysis/local?title=X&folder=Y` | POST | Lokales Repo erstellen |
| `/code-analysis/analyses/:id/approve` | POST | Analyse starten |
| `/code-analysis/analyses/:id` | GET | Ergebnis abrufen |
| `/code-analysis/repositories` | GET | Alle Repos auflisten |

### Voraussetzungen auf Ziel-VM
- `/opt/Claude/` Verzeichnis muss existieren
- SSH-Zugang über Port 2222

---

## Troubleshooting

**API antwortet nicht:**
```bash
ssh -p 2222 dieterhorst@192.168.42.214 "cd /opt/devoraxx && docker-compose -f docker-compose.dev.yml up -d"
# Warten, dann nochmal pnpm dev starten
```

**Token abgelaufen (401):**
```bash
# Neuen Token holen (siehe Schritt 3)
```

**Analyse hängt auf ANALYZING:**
- Logs prüfen: `ssh -p 2222 dieterhorst@192.168.42.214 "tail -50 /opt/devoraxx/apps/api/logs/*.log"`
- Eventuell API-Key-Problem (ANTHROPIC_API_KEY in .env prüfen)

**Ordner nicht gefunden:**
```bash
# Verfügbare Ordner auflisten
ssh -p 2222 dieterhorst@192.168.42.214 "ls /opt/devoraxx/code-uploads/"
```
