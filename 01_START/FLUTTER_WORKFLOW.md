# Flutter iOS Apps - Build Workflow

## Gemeinsame Einstellungen

| Einstellung | Wert |
|-------------|------|
| **Mac (Build)** | 192.168.42.17 - `~/Developer/` |
| **iPhone Device ID** | `00008150-0008399E0EBA401C` |
| **Team ID** | `58LU7ZPY87` |
| **Flutter auf Mac** | `/opt/homebrew/bin/flutter` |

---

## App 1: Office App (.253)

| Info | Wert |
|------|------|
| Server | 192.168.42.253 |
| Quellcode | `/opt/office_app/` |
| Mac-Pfad | `~/Developer/office_app/` |
| API Backend | `https://alexa.mukupi.art` |

**Sync:**
```bash
scp -r /opt/office_app/* dieterhorst@192.168.42.17:~/Developer/office_app/
```

**Build (Mac Terminal):**
```bash
cd ~/Developer/office_app && flutter run -d "00008150-0008399E0EBA401C" --release
```

**Features:** Erinnerungen, Akten, Mail, Schreibstube, Dropfolder, Terminal

---

## App 2: Admin Portal App (.230)

| Info | Wert |
|------|------|
| Server | 192.168.42.230 |
| Quellcode | `/opt/admin-portal-app/` |
| Mac-Pfad | `~/Developer/admin-portal-app/` |
| API Backend | `http://192.168.42.230` |

**Sync:**
```bash
scp -r /opt/admin-portal-app/* dieterhorst@192.168.42.17:~/Developer/admin-portal-app/
```

**Build (Mac Terminal):**
```bash
cd ~/Developer/admin-portal-app && flutter run -d "00008150-0008399E0EBA401C" --release
```

**Features:** Dashboard, Server-Detail (Health/Docker/Services), Sessions, Terminal, Snippets

---

## Erstmaliges Setup (neue App)

Im Mac Terminal:
```bash
cd ~/Developer/APP_NAME
flutter create . --platforms=ios
flutter pub get
```

---

## Problemlösungen

### Package-Fehler
```bash
flutter clean && flutter pub get
flutter run -d "00008150-0008399E0EBA401C" --release
```

### Development Team Fehler
```bash
open ios/Runner.xcworkspace
```
→ Runner > Signing & Capabilities > Team: `58LU7ZPY87`

### Code Signing Fehler
```bash
cd ios
sed -i '' 's/SWIFT_VERSION = 5.0;/SWIFT_VERSION = 5.0; DEVELOPMENT_TEAM = 58LU7ZPY87; CODE_SIGN_STYLE = Automatic;/g' Runner.xcodeproj/project.pbxproj
```

---

## App Icons generieren

```bash
# Auf dem jeweiligen Server mit ImageMagick
convert BILD.png -resize 1024x1024^ -gravity center -extent 1024x1024 Icon-App-1024x1024@1x.png
convert BILD.png -resize 180x180^ -gravity center -extent 180x180 Icon-App-60x60@3x.png
# ... etc für alle Größen
```

Benötigte Größen: 1024, 180, 167, 152, 120, 87, 80, 76, 60, 58, 40, 29, 20

---

## WICHTIG

- Build muss im **lokalen Mac Terminal** laufen (Keychain für Code Signing)
- SSH zum Mac funktioniert NICHT für flutter build
- Nicht `--delete` bei rsync/scp verwenden (löscht Xcode-Einstellungen)
- **Nach Code-Änderungen:** Immer den Build-Befehl für den User ausgeben!

---

## Nach Code-Änderungen an einer App

**IMMER dem User den passenden Build-Befehl mitgeben:**

Office App:
```bash
cd ~/Developer/office_app && flutter run -d "00008150-0008399E0EBA401C" --release
```

Admin Portal App:
```bash
cd ~/Developer/admin-portal-app && flutter run -d "00008150-0008399E0EBA401C" --release
```
