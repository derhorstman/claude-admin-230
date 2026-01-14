# Schnellreferenz - admin-portal (.230)

**Hostname:** admin-portal
**IP:** 192.168.42.230
**Rolle:** Zentrales Admin-Portal für alle VMs

---

## 1. Projektspezifisches

### Was läuft hier?

Das **Admin-Portal** - eine Web-Anwendung zur Verwaltung aller 19 VMs auf DASBIEST.

### Tech-Stack

| Komponente | Technologie |
|------------|-------------|
| Frontend | SvelteKit |
| Backend | FastAPI (Python) |
| Datenbank | PostgreSQL 16 |
| Reverse Proxy | Nginx |
| Container | Docker Compose |

### Ports & URLs

| Port | Service | URL |
|------|---------|-----|
| 80 | Nginx (extern) | http://192.168.42.230 |
| 3000 | Frontend (intern) | - |
| 8000 | Backend API (intern) | http://192.168.42.230/api |
| 5432 | PostgreSQL (intern) | - |
| 2222 | SSH | - |
| 445 | SMB | `\\192.168.42.230\dieterhorst` |

### Docker Container

| Container | Image | Funktion |
|-----------|-------|----------|
| admin-frontend | admin-portal-frontend | SvelteKit UI |
| admin-backend | admin-portal-backend | FastAPI REST |
| admin-db | postgres:16-alpine | PostgreSQL |
| admin-nginx | nginx:alpine | Reverse Proxy |

---

## 2. Häufige Befehle

### Docker Status & Logs

```bash
cd /opt/admin-portal
sudo docker compose ps              # Container-Status
sudo docker compose logs -f         # Alle Logs live
sudo docker compose logs backend    # Nur Backend-Logs
sudo docker compose logs frontend   # Nur Frontend-Logs
```

### Container neu starten

```bash
sudo docker compose restart backend   # Nur Backend
sudo docker compose restart frontend  # Nur Frontend
sudo docker compose up -d             # Alles starten
sudo docker compose down              # Alles stoppen
```

### Nach Code-Änderungen NEU BAUEN (WICHTIG!)

```bash
# Frontend neu bauen (Svelte-Änderungen)
sudo docker compose build --no-cache frontend && sudo docker compose up -d frontend

# Backend neu bauen (Python-Änderungen)
sudo docker compose build --no-cache backend && sudo docker compose up -d backend

# Alles neu bauen
sudo docker compose build --no-cache && sudo docker compose up -d
```

### Claude Code Version prüfen

```bash
claude --version                                    # Aktuelle Version
npm install -g @anthropic-ai/claude-code@2.0.65    # Downgrade falls nötig
```

---

## 3. Fehler und Lösungen

### Container zeigt alte Version nach Code-Änderung

**Problem:** Änderungen am Quellcode nicht sichtbar
**Ursache:** Docker-Container enthält Code vom Build-Zeitpunkt
**Lösung:** `sudo docker compose build --no-cache <service> && sudo docker compose up -d`

### Claude Code 2.0.76 schreibt ungewollte Texte

**Problem:** Version 2.0.76 hat Bug - schreibt automatisch ins Terminal
**Lösung:** Downgrade auf 2.0.65:
```bash
npm install -g @anthropic-ai/claude-code@2.0.65
```

### Sessions-Erkennung False Positive (Session 87)

**Problem:** `todo-autoclaude-watcher.cjs` wurde als "Claude Code" erkannt
**Ursache:** grep nach "claude" matchte Scripts mit "claude" im Namen
**Lösung:** Suche nach `/claude` oder `claude-code`, filtert `-watcher` aus

### RAM-Anzeige zeigt 0 (Session 78)

**Problem:** Deutsche Locale liefert "Speicher" statt "Mem"
**Lösung:** `LANG=C free -b` statt `free -b`

### Dienste-Anzeige leer (Session 78)

**Problem:** DB hat "LINUX", Code prüft auf "linux"
**Lösung:** `.lower()` beim OS-Vergleich

### Nginx Port 80 blockiert nach Neustart

**Problem:** System-Nginx blockiert Docker-Nginx
**Lösung:** System-Nginx stoppen: `sudo systemctl stop nginx && sudo systemctl disable nginx`

---

## 4. Credentials & Config-Pfade

### Portal-Login

- **Pfad:** Datenbank (users-Tabelle)
- **User:** superadmin

### Wichtige Config-Dateien

| Was | Pfad |
|-----|------|
| Docker Compose | `/opt/admin-portal/docker-compose.yml` |
| Backend Config | `/opt/admin-portal/backend/app/core/config.py` |
| Frontend Config | `/opt/admin-portal/frontend/src/lib/config.ts` |
| Nginx Config | `/opt/admin-portal/nginx/nginx.conf` |
| Claude Settings | `~/.claude.json` |
| Claude Credentials | `~/.claude/` |
| SMB Credentials | `/etc/samba/smb.conf` |
| QNAP Credentials | `/root/.qnap-credentials` |

### GitHub

- **Account:** derhorstman
- **Repo:** https://github.com/derhorstman/claude-selbsterhaltung (privat)
- **Auth:** `gh auth status`

---

## 5. Kontakte zu anderen Servern

### SSH-Verbindungen (alle Port 2222)

```bash
# Haupt-VMs
ssh -p 2222 dieterhorst@192.168.42.15    # MIRA/EVY - AI-System
ssh -p 2222 dieterhorst@192.168.42.214   # devoraxx - Next.js + NestJS
ssh -p 2222 dieterhorst@192.168.42.216   # dns-portal - FreeBSD DNS/DHCP
ssh -p 2222 dieterhorst@192.168.42.254   # proxy-portal - Reverse Proxy
ssh -p 2222 dieterhorst@192.168.42.253   # office - Office-Server
ssh -p 2222 dieterhorst@192.168.42.252   # thea - Pflegedoku
ssh -p 2222 dieterhorst@192.168.42.246   # edo - Email
ssh -p 2222 dieterhorst@192.168.42.166   # cant - Chor-Software (PRODUKTION!)
ssh -p 2222 dieterhorst@192.168.42.174   # cant_DEV - Entwicklung

# Standalone
ssh dieterhorst@192.168.42.17            # Mac Pro (Port 22)
ssh dieterhorst@192.168.42.16            # DASBIEST Hyper-V Host (Port 22)
ssh -p 2222 dieterhorst@192.168.42.126   # NASHORST QNAP
```

### Kollegen-Terminal fernsteuern

```bash
# Kontext lesen
/opt/Claude/scripts/kollege-kontext.sh 166

# Ins Terminal schreiben
/opt/Claude/scripts/kollege-schreiben.sh 166 "Text hier"
```

### Dateien zum Mac kopieren

```bash
scp /pfad/datei dieterhorst@192.168.42.17:~/Desktop/
```

### Screenshot vom Mac holen

```bash
/opt/Claude/screenshot.sh
# Dann lesen: /opt/Claude/screenshots/latest.png
```

---

## 6. Wichtige Pfade

```
/opt/Claude/                           # Selbsterhaltung
/opt/Claude/01_START/                  # Session-Start Dateien
/opt/Claude/templates/                 # VM-Deploy-Schablonen
/opt/Claude/deploy-selbsterhaltung.sh  # Deploy-Script
/opt/Claude/scripts/                   # Helper-Scripts
/opt/Claude/hooks/                     # Claude Hooks

/opt/admin-portal/                     # Admin-Portal Projekt
/opt/admin-portal/backend/             # FastAPI
/opt/admin-portal/frontend/            # SvelteKit
/opt/admin-portal/docs/                # Dokumentation
```

---

## 7. Lernpunkte

- **NIEMALS** `sudo docker compose down` ohne Grund - Portal geht offline!
- **IMMER** nach Code-Änderungen Container neu bauen mit `--no-cache`
- **Version 2.0.65** ist stabil, 2.0.76 hat Bugs
- **cant (.166)** ist PRODUKTION - keine Code-Änderungen ohne Absprache!
- Container-Alter prüfen: `sudo docker compose ps` (Spalte CREATED)
