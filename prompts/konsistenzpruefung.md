# Konsistenzprüfung Frontend/Backend (NUR ANALYSE)

**WICHTIG: Dies ist eine reine Analyse. Ändere NICHTS am Code!**

## Sicherheitsregeln

1. **NUR LESEN** - Keine Dateien ändern
2. **KEINE Container-Neustarts**
3. **KEINE Fixes durchführen** - nur dokumentieren
4. Am Ende: Report erstellen, auf Mac Desktop legen

---

## Phase 0: Projekt-Erkennung

1. Erkenne das Framework:
   - Backend: FastAPI? NestJS? Express? Flask? Django?
   - Frontend: SvelteKit? React? Vue? Next.js?
2. Finde die Haupt-Dateien:
   - Backend: Router/Controller-Dateien
   - Frontend: API-Service/Client-Datei
3. Dokumentiere den Tech-Stack im Report-Header

---

## Phase 1: Endpoint-Inventar

### Backend (je nach Framework)
- FastAPI: `@router.get|post|put|delete|patch`
- NestJS: `@Get|Post|Put|Delete|Patch`
- Express: `router.get|post|put|delete`
- Flask: `@app.route` oder `@bp.route`

Erfasse für JEDEN Endpoint:
- HTTP-Methode
- Pfad (inkl. Parameter wie `{id}`)
- Query-Parameter (optional)
- Request-Body-Schema
- Response-Schema
- Auth erforderlich? (Depends, Guards, Middleware)

### Frontend
- Suche alle `fetch()` und API-Helper-Aufrufe
- Erfasse Pfad, Methode, gesendete Daten

### WebSocket-Endpoints
- Suche nach WS-Verbindungen (`ws://`, `wss://`, WebSocket)
- Dokumentiere separat

---

## Phase 2: Mapping-Vergleich

Erstelle eine Tabelle:

| Backend Endpoint | Frontend Call | Status |
|-----------------|---------------|--------|
| GET /api/users | getUsers() | ✓ Match |
| POST /api/auth/register | - | ⚠️ Ungenutzt |
| - | fetchOldApi() | ⚠️ Backend fehlt |

---

## Phase 3: Schema-Tiefenanalyse

Für die TOP 10 meistgenutzten Endpoints:

1. Extrahiere Backend-Response-Schema (Pydantic, DTO, Interface)
2. Extrahiere Frontend-Erwartung (TypeScript Interface, Destructuring)
3. Vergleiche JEDEN Feldtyp:
   - `number` vs `string` (häufiger Bug!)
   - `null` vs `undefined`
   - Optional vs Required
   - Array vs Single Object
   - Date-Format (ISO String vs Timestamp)

---

## Phase 4: Auth-Konsistenz

| Endpoint | Backend Auth | Frontend sendet Token | Status |
|----------|-------------|----------------------|--------|
| GET /api/users | ✓ Required | ✓ Bearer | 🟢 OK |
| GET /api/health | ✗ Public | ✗ Keinen | 🟢 OK |
| POST /api/admin | ✓ Required | ✗ Fehlt | 🔴 BUG |

---

## Phase 5: Query-Parameter-Check

Prüfe für jeden Endpoint mit Query-Params:
- Werden alle Backend-Parameter im Frontend genutzt?
- Sendet Frontend Parameter, die Backend ignoriert?
- Sind Default-Werte konsistent?

---

## Phase 6: Error-Handling

1. Backend: Welche HTTP-Status-Codes werden geworfen?
2. Frontend: Werden alle Status-Codes behandelt?
3. Fehlermeldungen: Konsistente Sprache? (DE/EN gemischt?)

---

## Phase 7: Deprecated/Legacy-Code

Suche nach:
- Auskommentiertem Code
- `// TODO`, `// FIXME`, `// DEPRECATED`
- Funktionen die nirgends importiert werden
- Alte API-Versionen (`/v1/` neben `/v2/`)

---

## Output-Format

```markdown
# Konsistenz-Report: [PROJEKTNAME]

**Datum:** YYYY-MM-DD
**Tech-Stack:** [Backend] + [Frontend]
**Analysiert von:** Claude

## Zusammenfassung
| Kategorie | 🔴 Bug | 🟡 Minor | 🟢 OK |
|-----------|--------|----------|-------|
| Endpoints | X | Y | Z |
| Schemas | X | Y | Z |
| Auth | X | Y | Z |
| Errors | X | Y | Z |

## Kritische Bugs (🔴)
[Tabelle mit Details]

## Minor Issues (🟡)
[Tabelle mit Details]

## Vorgeschlagene Fixes
[Beschreibung - NICHT durchführen!]
```

---

## Ablage

```bash
scp /tmp/report.md dieterhorst@192.168.42.17:~/Desktop/konsistenz-report-[HOSTNAME].md
```

**KEINE CODE-ÄNDERUNGEN - NUR REPORT!**
