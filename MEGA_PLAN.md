# EditVerse — Mega Plan

## Nordstern
EditVerse ist **kein zweites TikTok mit Cards**.  
Es ist die **Cut-Room-Arena**: fertige Edits, vertikal, vollflächig, mit Liquid Glass und massiver Progression.

Ein Viewport = **ein Edit**. Keine Karten. Keine Dashboard-Kacheln. Keine Badge-Suppe.

---

## Design-System: Liquid Glass

### Material
- **Glass panes**: blur + Specular-Sheen + feine Edge-Refraction
- **Depth**: Hintergrund ist immer der Edit (Video/Poster), UI schwatt darüber
- **Chrom**: Floating Dock, XP-Orb, Action-Rail — alles Glas, nichts „Card“
- **Licht**: Acid Signal `#C8F542` als einziger Hot-Accent (kein Purple-Glow)

### Typo
- Display: heavy rounded / condensed Impact-Energie
- Meta: monospaced für XP, Timecode, Rank
- Brand **EDITVERSE** immer als hero-level Signal im Feed-Chrome

### Motion (Pflicht)
1. Vertical snap + parallax sheen auf dem Poster  
2. XP-Orb pulse beim Like/Save/Publish  
3. Glass dock morph beim Tab-Wechsel  
4. Beat-rail scrub animation auf jedem Edit

### Verbote
- Weiße/graue Content-Cards im Feed  
- Pill-Cluster / Stat-Strips im ersten Look  
- Floating Promo-Badges auf dem Edit  
- Generisches Social-Layout mit Thumbnail-Grid als Home

---

## Info-Architektur (v1 Shell)

| Surface | Job |
|---|---|
| **Stage (Feed)** | Vertikaler Full-Bleed Player/Poster. Primary home. |
| **Arena (Challenges)** | Immersive challenge stages, nicht Listen-Cards |
| **Drop (Upload)** | Composer als Glass-Sheet über dem Stage-Look |
| **Ladder (Ranks)** | Season ladder, podium, climb animation |
| **Identity (Profile)** | Creator dossier: rank path, streak, edit reel |

Chrome: **Glass Dock** unten (5 destinations), kein dicker System-TabBar-Look.

---

## Gamification (massiv, aber sauber)

### Core loop
Watch → React → Cut → Climb

### Systeme
1. **XP + Ranks**: Cutter → Framer → Syncer → Drop Lord → Timeline God → EditVerse  
2. **Streak Forge**: täglicher Drop hält die Flame  
3. **Arena Seasons**: wöchentliche Briefs mit Prize XP  
4. **Drop Meter**: Beat-Accuracy / Sync-Score (später mit echten Metriken)  
5. **Clan Cuts** (v2): Crews battle in Arenas  
6. **Legacy Reels** (v2): hall-of-fame edits, sealed seasons  

UI-Regel: Gamification lebt als **HUD-Glas**, nicht als Card-Wall.

---

## Product Roadmap

### Phase 0 — Now (dieser Branch)
- Vertical full-bleed feed  
- Liquid Glass chrome + HUD  
- Mock posts, XP, arenas, unsigned IPA CI  

### Phase 1 — Real Media
- Video upload (PHPicker)  
- AVPlayer in Stage  
- Thumbnail + HLS later  
- Local draft vault  

### Phase 2 — Backend
- Auth (Sign in with Apple)  
- Feed API + CDN  
- Likes/saves/comments  
- Rank server-of-truth  

### Phase 3 — Arena Economy
- Challenge submissions  
- Judging / community score  
- Season rewards, cosmetics for glass HUD  

### Phase 4 — Social Graph
- Follow graph, duel cuts, duet timelines  
- Creator verification for editors  

### Phase 5 — Growth
- Share sheets → deep link into Stage  
- Clip SEO / web preview later (App bleibt first)  
- Creator fund / tips (optional)

---

## Engineering Rules
- iOS-first, SwiftUI only for UI  
- Unsigned IPA via GitHub Actions (`macos-14`)  
- Design tokens in `EVTheme` + `LiquidGlass`  
- No third-party UI kit spam  
- Every new surface must pass the **Card Test**: if it looks like a blog card, kill it

---

## Success Metrics (later)
- D1/D7 return via streak  
- Edits uploaded / MAU  
- Arena entry rate  
- Median watch time per Stage swipe  
