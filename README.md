# EditVerse (iOS)

Native SwiftUI app — Feed nur für fertige Edits, Challenges, XP/Ranks, Upload-MVP.

**Zielplattform:** iOS 27  
**Bundle ID:** `app.editverse.EditVerse`  
**Signing:** unsigned (CI baut eine unsigned IPA)

## Private GitHub Repo + Unsigned IPA

### 1. Private Repo anlegen

```bash
cd EditVerse
git init
git checkout -b BFeditverse-ios-99fb
git add .
git commit -m "Initial EditVerse iOS app + unsigned IPA workflow"

# Private Repo (GitHub CLI):
gh repo create EditVerse --private --source=. --remote=origin --push
```

Oder manuell auf GitHub ein **Private** Repository erstellen und pushen:

```bash
git remote add origin git@github.com:<USER>/EditVerse.git
git push -u origin BFeditverse-ios-99fb
```

Empfohlen: Default-Branch `main` setzen und den Workflow dort laufen lassen (Workflow triggert auf `main`/`master` + PRs + manuell).

### 2. GitHub Actions

Workflow: [`.github/workflows/build-unsigned-ipa.yml`](.github/workflows/build-unsigned-ipa.yml)

- Runner: `macos-15`
- Build: `xcodebuild` für `iphoneos` mit `CODE_SIGNING_ALLOWED=NO`
- Packt `Payload/EditVerse.app` → `EditVerse-unsigned.ipa`
- Artifact-Name: **`EditVerse-unsigned-ipa`** (14 Tage Retention)

Manuell starten: **Actions → Build Unsigned IPA → Run workflow**  
Optional Input: `deployment_target` (Default `27.0`). Wenn das Runner-SDK älter ist, clamped der Workflow automatisch auf die verfügbare SDK-Version.

### 3. IPA herunterladen

Nach grünem Run: **Artifacts → EditVerse-unsigned-ipa**

### 4. Install (unsigned)

Eine unsigned IPA läuft **nicht** ohne erneutes Signieren / Sideload-Tool (z. B. Sideloadly, AltStore, eigene Certs). Das ist Absicht für 0-€-Dev ohne Apple Developer Program.

## Lokal (Mac + Xcode)

```bash
open EditVerse.xcodeproj
# oder
./scripts/package-unsigned-ipa.sh
```

Voraussetzung: Xcode mit iOS-27-SDK (sonst Deployment Target im Script/Projekt anpassen).

## App-MVP

| Tab | Inhalt |
|---|---|
| Feed | Edit-Cards, Like/Save → XP |
| Challenges | Weekly Arenas + XP-Preise |
| Upload | Title/Caption/Tags → Feed (+80 XP) |
| Ranks | Leaderboard |
| Profile | XP-Bar, Achievements, eigene Edits |

Nächste Ausbaustufen (nicht in diesem MVP): echter Video-Upload, Backend, Auth, Push, Moderation.
