# Formulize

> **Documentation legend**  
> **[Existing]** — implemented in the codebase today  
> **[Inferred]** — derived from code, assets, or product copy  
> **[Recommended]** — suggested next steps, not built yet

**Tagline:** Smarter Way To Learning  
**Platform:** Android & iOS (Flutter) · **[Existing]** offline-only, no web target configured  
**Version:** `1.0.0+1` (see `pubspec.yaml`)

---

## Table of contents

1. [How the app works](#how-the-app-works)
2. [IDEA](#1-idea)
3. [PRD — Product Requirements](#2-prd--product-requirements)
4. [TRD — Technical Requirements](#3-trd--technical-requirements)
5. [APP FLOW](#4-app-flow)
6. [UI/UX DESIGN](#5-uiux-design)
7. [BACKEND & DATABASE](#6-backend--database)
8. [IMPLEMENTATION](#7-implementation)
9. [Getting started](#getting-started)
10. [Summary](#summary-existing-vs-recommended)

---

## How the app works

**[Existing]** Formulize is an **offline-first** study app for Indian school students (Classes 9–12 + fundamentals). All formula content ships as **bundled JSON** in `assets/`. There is **no backend, no auth, and no network API**.

### Data flow

```
UI (Screens / Widgets)
    → FormulaLocalDataSource.loadFormulas()   [reloads on many screens]
    → FormulaModel
    → SharedPreferences (bookmark IDs only)
```

### User journey

1. App starts at **`MainScreen`** (bottom nav: Home | Bookmarks).
2. **Home** — search, tap Class 9–12, or tap a Fundamentals card.
3. **Class** → **`ClassDetailScreen`** loads JSON, filters by `classLevel`, builds subject → chapter syllabus.
4. **Chapter** with `containsFormulas: true` → **`FormulaViewScreen`** (LaTeX + explanation + bookmark).
5. **Chapter** with `containsFormulas: false` → floating snackbar (theory-only).
6. **Search** on Home → **`SearchResultsScreen`** (matches title, chapter, `searchTags`).
7. **Bookmarks** tab resolves saved formula IDs from device storage.

### Content reality

| Asset file | Status |
|------------|--------|
| `class12.json` | **[Existing]** ~247 formula entries |
| `fundamentals.json` | **[Existing]** ~101 formula entries |
| `class9.json`, `class10.json`, `class11.json` | **[Existing]** empty `[]` → “Content coming soon” UI |

---

## 1. IDEA

### App purpose

**[Existing]** Quick-reference app for **Class 9–12 Math, Physics, and Chemistry** formulas, plus cross-class **fundamentals** (algebraic identities, trigonometry, logarithms). Students browse by class/chapter, search by keyword, read LaTeX-rendered equations with explanations, and bookmark favorites—all **without internet or an account**.

### Target users

| Persona | Detail |
|---------|--------|
| **Primary** | **[Inferred]** Indian secondary/higher-secondary students (ages 14–18), CBSE/NCERT-style syllabus, exam prep (boards, revision before JEE/NEET-style study). |
| **Secondary** | **[Inferred]** Teachers/tutors who want a compact formula sheet on phone during class. |

### Core problem solved

- Formulas are scattered across textbooks, notes, and PDFs.
- Hard to **search** and **revisit** specific equations during homework or exams.
- **[Existing]** Formulize centralizes content, renders math properly, and saves bookmarks locally offline.

### Why existing solutions fall short

**[Inferred]** Generic PDFs and websites are not searchable offline, rarely render LaTeX well on mobile, and do not offer a syllabus-aligned browse path for Indian classes 9–12.

### Assumptions

- English UI; NCERT-aligned chapter naming.
- Mobile-first; no tablet-specific layouts yet.
- Preferred stack in planning docs (Firebase) is **not** integrated—see [TRD](#3-trd--technical-requirements).

---

## 2. PRD — Product Requirements

### 2.1 App identity

| Field | Value |
|-------|--------|
| **App name** | Formulize |
| **Tagline** | Smarter Way To Learning |
| **Platform** | iOS, Android (Flutter) |

### 2.2 Core features (MVP)

| Feature | Description | Status |
|---------|-------------|--------|
| **Home hub** | Brand header, search, class grid (9–12), fundamentals shortcuts | **[Existing]** |
| **Syllabus browser** | Per-class subject → expandable chapters | **[Existing]** |
| **Formula viewer** | Title, LaTeX (`flutter_math_fork`), explanation | **[Existing]** |
| **Search** | Match `title`, `chapter`, `searchTags` | **[Existing]** |
| **Bookmarks** | Save/remove by formula `id`; clear all | **[Existing]** |
| **Theory-only chapters** | `containsFormulas: false` → snackbar, no empty screen | **[Existing]** |
| **Class 9–11 content** | Full syllabus data | **Missing** (empty JSON) |
| **User accounts / sync** | Cross-device bookmarks | **Not in scope today** |

### 2.3 Nice-to-have (post-MVP)

**[Recommended]**

- Remote content updates (Firebase Firestore or CDN-hosted JSON)
- User accounts + cross-device bookmarks
- Recent history, chapter progress
- Share / copy formula
- Practice quizzes
- Hindi or regional languages
- Home-screen widget / quick search
- Firebase Analytics & Crashlytics
- Onboarding, settings, dark mode

### 2.4 User stories

1. As a **Class 12 student**, I want to browse Physics chapters so that I can find board formulas quickly.
2. As a **student**, I want to **search** by keyword (e.g. “Coulomb”) so that I don’t hunt through chapters manually.
3. As a **student**, I want to **bookmark** formulas so that I can review them before exams.
4. As a **student**, I want **LaTeX-rendered** equations so that notation is readable on mobile.
5. As a **student**, I want **fundamentals** without picking a class so that I can revise identities and rules quickly.
6. As a **student**, I want clear feedback when a chapter has **no formulas** so that I’m not confused.
7. As a **content author**, I want to add formulas via **JSON** so that content can ship without app code changes.
8. As a **student** (future), I want bookmarks on **all my devices** after I sign in.

### 2.5 Success metrics

**[Recommended]** — not instrumented yet:

| Metric | Why it matters |
|--------|----------------|
| DAU / MAU | Adoption |
| D1 / D7 retention | Habit during exam season |
| Search → formula view rate | Search usefulness |
| Bookmarks per user | Engagement depth |
| Crash-free sessions | Stability |
| Store rating & reviews | Product-market fit |

---

## 3. TRD — Technical Requirements

### 3.1 Tech stack

| Layer | Detected (actual) | Preferred / future |
|-------|-------------------|---------------------|
| **Frontend** | Flutter (Dart `^3.10.7`), Material 3 | Same |
| **Data** | Bundled JSON in `assets/` | Optional: Firestore or remote JSON |
| **Local persistence** | `shared_preferences` (bookmark IDs) | Same; or user doc in Firestore |
| **Math UI** | `flutter_math_fork` ^0.7.4 | Same |
| **Auth** | None | **[Recommended]** Firebase Auth if sync needed |
| **Backend** | None | **[Recommended]** Firebase only for OTA content / accounts |
| **Deployment** | Google Play / App Store via Flutter build | CI (GitHub Actions) **[Recommended]** |

**Why this stack fits:** Low complexity, full offline MVP, small team, content-heavy app with infrequent app updates if JSON is bundled.

### 3.2 Key dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| `flutter` | SDK | UI framework |
| `cupertino_icons` | ^1.0.8 | iOS-style icons |
| `flutter_math_fork` | ^0.7.4 | LaTeX / math rendering |
| `shared_preferences` | ^2.5.4 | Bookmark ID list |
| `rename` | ^3.1.0 | App rename tooling — **[Recommended]** move to `dev_dependencies` |
| `flutter_launcher_icons` | ^0.13.1 | App icons (dev) |
| `flutter_lints` | ^6.0.0 | Analyzer lints — **[Recommended]** fix placement in `pubspec.yaml` |

**Not present:** `firebase_core`, `cloud_firestore`, `firebase_auth`, `go_router`, `provider`, `flutter_bloc`, etc.

### 3.3 Dependency file (`pubspec.yaml`)

**[Existing]** — core excerpt:

```yaml
name: formulize
description: "The ultimate smart formula app for Class 9-12 Math, Physics, and Chemistry."
version: 1.0.0+1

environment:
  sdk: ^3.10.7

dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  flutter_math_fork: ^0.7.4
  shared_preferences: ^2.5.4
  rename: ^3.1.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_launcher_icons: ^0.13.1

flutter:
  uses-material-design: true
  assets:
    - assets/class9.json
    - assets/class10.json
    - assets/class11.json
    - assets/class12.json
    - assets/fundamentals.json
```

**Known issues:** `flutter_lints` appears nested under `flutter_launcher_icons` (likely misconfigured). Default `widget_test.dart` still tests a counter app.

### 3.4 Project folder structure

**[Existing]** with **[Recommended]** additions noted:

```
formulize/
├── lib/
│   ├── main.dart                              # FormulizeApp → MainScreen
│   ├── data/
│   │   ├── models/
│   │   │   └── formula_model.dart             # JSON → Dart model
│   │   └── source/
│   │       └── formula_local_data_source.dart # Loads & merges all JSON assets
│   └── features/
│       ├── home/
│       │   ├── screens/
│       │   │   ├── main_screen.dart           # Bottom nav shell
│       │   │   └── home_screen.dart           # Search, classes, fundamentals
│       │   └── widgets/
│       │       ├── class_card.dart
│       │       └── home_search_bar.dart
│       ├── chapter_list/screens/
│       │   └── class_detail_screen.dart       # Syllabus expansion tiles
│       ├── formula_view/screens/
│       │   └── formula_view_screen.dart       # FormulaViewScreen + FormulaCard
│       ├── bookmarks/screens/
│       │   └── bookmarks_screen.dart
│       └── search/screens/
│           └── search_results_screen.dart
├── assets/
│   ├── class9.json … class12.json
│   ├── fundamentals.json
│   └── icon/
├── test/
│   └── widget_test.dart                       # Stale counter test
├── android/ / ios/ / …                        # Standard Flutter platforms
├── pubspec.yaml
└── analysis_options.yaml
```

**[Recommended]** additions:

```
lib/core/theme/app_theme.dart
lib/data/repositories/formula_repository.dart    # Single cached load
lib/features/formula_view/widgets/formula_card.dart  # Extract from screen file
```

### 3.5 Architecture pattern

| Aspect | Current | Recommendation |
|--------|---------|----------------|
| **Pattern** | Feature-first folders + thin data layer | Add **Repository** over `FormulaLocalDataSource` |
| **State** | `StatefulWidget` + `FutureBuilder` | **Provider** or **Riverpod** if complexity grows |
| **Navigation** | Imperative `Navigator.push` | **`go_router`** for named routes & deep links |

**Data flow (target):**

```
Client (UI)
  → Repository (cached List<FormulaModel>)     [Recommended]
  → FormulaLocalDataSource
  → assets/*.json
  → FormulaModel

Bookmarks:
  UI → SharedPreferences ('bookmarked_formulas')
```

### 3.6 Environment variables

**[Existing]** None — no `.env`, API keys, or Firebase config in repo.

**[Recommended]** if Firebase is added:

- `google-services.json` (Android)
- `GoogleService-Info.plist` (iOS)
- Firebase project IDs via FlutterFire CLI / `firebase_options.dart`

### 3.7 Third-party integrations

| Integration | Status |
|-------------|--------|
| Firebase (Auth, Firestore, Storage) | Not integrated |
| Analytics / Crashlytics | Not integrated |
| Push notifications / Deep links | Not integrated |
| Maps / Payments | Not applicable |

---

## 4. APP FLOW

### 4.1 Screen inventory

| Screen | One-line description | Status |
|--------|----------------------|--------|
| `MainScreen` | Bottom navigation: Home \| Bookmarks | **[Existing]** |
| `HomeScreen` | Search bar, class grid, fundamentals carousel | **[Existing]** |
| `ClassDetailScreen` | Syllabus: subjects → chapters for one class | **[Existing]** |
| `FormulaViewScreen` | Formulas for one chapter; LaTeX + bookmark | **[Existing]** |
| `SearchResultsScreen` | Global search results | **[Existing]** |
| `BookmarksScreen` | Saved formulas; clear all FAB | **[Existing]** |
| Splash / Onboarding | — | **Missing** |
| Login / Signup | — | **Missing** |
| Settings / Profile | — | **Missing** |

### 4.2 Navigation flow

```
MainScreen
├── Tab 0: HomeScreen
│   ├── HomeSearchBar (submit)
│   │       └── SearchResultsScreen
│   ├── ClassCard ("Class 9" … "Class 12")
│   │       └── ClassDetailScreen
│   │               ├── Chapter (containsFormulas: true)
│   │               │       └── FormulaViewScreen
│   │               └── Chapter (containsFormulas: false)
│   │                       └── SnackBar (theory-only)
│   └── Fundamental card (hardcoded titles on Home)
│           └── FormulaViewScreen (classLevel: Fundamentals)
└── Tab 1: BookmarksScreen
        ├── FormulaCard list
        └── Empty state (no bookmarks)
```

### 4.3 Auth flow

**[Existing]** None — app is fully public; bookmarks are anonymous and device-local.

**[Recommended]** optional flow:

```
Launch → (optional) Firebase Anonymous Auth → Home
         → Link email/Google later for sync
```

### 4.4 Route map

**[Existing]** No named routes — all navigation via `MaterialPageRoute`.

| Logical route | Widget | Access |
|---------------|--------|--------|
| `/` | `MainScreen` | Public |
| `/home` | `HomeScreen` (tab 0) | Public |
| `/bookmarks` | `BookmarksScreen` (tab 1) | Public |
| `/class/:name` | `ClassDetailScreen(className)` | Public |
| `/formulas` | `FormulaViewScreen(className, chapterName)` | Public |
| `/search` | `SearchResultsScreen(query)` | Public |

**[Recommended]** implement with `go_router` for testing and deep links.

### 4.5 Deep links & notification routes

**[Existing]** None configured.

**[Recommended]**

| Deep link | Destination |
|-----------|-------------|
| `formulize://search?q=velocity` | `SearchResultsScreen` |
| `formulize://class/12/chapter/...` | `FormulaViewScreen` |
| `formulize://bookmarks` | Bookmarks tab |

---

## 5. UI/UX DESIGN

### 5.1 Design personality

**[Existing]** **Professional / student-friendly** — bold brand header, colorful gradient cards, rounded corners, Material icons. Feels modern and exam-focused rather than playful.

**[Issue]** Home uses deep purple (`#1C0845`); most other screens use `Colors.blueAccent` — brand feels split.

### 5.2 Color system

| Token | Hex / value | Usage |
|-------|-------------|--------|
| **Brand primary** | `#1C0845` | Home `AppBar`, some snackbars |
| **Action / links** | `Colors.blueAccent` | Most app bars, bookmark icon, search prefix |
| **Background (light)** | `Colors.grey[50]` | Scaffold backgrounds |
| **Class 9** | `Colors.orangeAccent` | Class card gradient |
| **Class 10** | `Colors.green` | Class card |
| **Class 11** | `Colors.purpleAccent` | Class card |
| **Class 12** | `Colors.redAccent` | Class card |
| **Destructive** | `Colors.redAccent` | Clear all bookmarks |
| **Success / Error / Warning** | Not tokenized | **[Recommended]** add semantic colors |

**Theme:** `ThemeData(useMaterial3: true, primarySwatch: Colors.blue)` in `main.dart`.

### 5.3 Typography

**[Existing]** System/Material defaults — no custom fonts in `pubspec.yaml`.

| Role | Style (approximate) |
|------|---------------------|
| Brand title (Home) | 34px, `FontWeight.w900` |
| Section headers | 22px, `FontWeight.w800` |
| App bar titles | Bold, ~default 20px |
| Formula title | 16px bold |
| Explanation | 14px, `Colors.grey[700]` |
| LaTeX | 20px via `Math.tex` |

**[Recommended]** type scale: Display → H1 (22) → H2 (18) → Body (14–16) → Caption (12).

### 5.4 Spacing & layout tokens

**[Existing]** ad hoc padding:

- Screen padding: `20`, `16`
- Card radius: `16`–`20`, home app bar bottom radius `30`
- Class grid: 2 columns, `childAspectRatio: 1.1`
- Fundamentals horizontal list: card width `140`, height `130`

**[Recommended]** 8px grid: xs=4, sm=8, md=16, lg=24, xl=32.

### 5.5 Component style guide

| Component | **[Existing]** behavior |
|-----------|-------------------------|
| **Primary surfaces** | Gradient `ClassCard`, colored fundamental cards |
| **Cards** | `Card` + elevation 1–4, rounded 16–20 |
| **Search input** | White pill, shadow, `TextField` + search action |
| **Buttons** | `IconButton` bookmark; `FloatingActionButton.extended` clear all |
| **Navigation** | `BottomNavigationBar` (Home, Bookmarks) |
| **Loading** | `CircularProgressIndicator` in `FutureBuilder` |
| **Empty state** | Icon + grey text (bookmarks, empty class) |
| **SnackBar** | Floating, purple or red accent, rounded |
| **Dialogs** | `AlertDialog` for clear bookmarks |

**Gaps:** Search results use inline `Card`, not `FormulaCard` (no bookmark in search). No skeleton loaders. No formal disabled/error input states on search.

### 5.6 Dark mode

**[Existing]** Not supported — light theme only.

**[Recommended]** dark overrides:

- Scaffold: `#121212`
- App bar: `#1C0845` or slightly lifted purple
- Cards: `#1E1E1E`
- Text: high-contrast white / grey[300]

---

## 6. BACKEND & DATABASE

### 6.1 Collections / data store

There is **no server database**. **[Existing]** persistence layers:

| Store | Contents |
|-------|----------|
| `assets/*.json` | All formula content (read-only at runtime) |
| `SharedPreferences` | `bookmarked_formulas`: `List<String>` of formula IDs |

### 6.2 Formula entity schema

Each JSON array element maps to **`FormulaModel`**:

| Field | Type | Constraints | Default |
|-------|------|-------------|---------|
| `id` | string | Unique across all files | `''` |
| `classLevel` | string | `"9"`–`"12"` or `"Fundamentals"` | `''` |
| `subject` | string | e.g. Physics, Mathematics | `''` |
| `chapter` | string | Syllabus chapter name | `''` |
| `title` | string | Formula display name | `''` |
| `latexCode` | string | Valid LaTeX for `flutter_math_fork` | `''` |
| `explanation` | string | Plain text | `''` |
| `containsFormulas` | bool | Syllabus navigation flag | `false` |
| `searchTags` | string[] | Search keywords | `[]` |

**Example:**

```json
{
  "id": "12_phy_1_01",
  "classLevel": "12",
  "subject": "Physics",
  "chapter": "Electric Charges and Fields",
  "title": "Quantization of Charge",
  "latexCode": "q = \\pm ne",
  "explanation": "Charge is always an integral multiple of e...",
  "containsFormulas": true,
  "searchTags": ["quantization", "charge", "electron"]
}
```

**Content author notes:**

- Class screens use `className` like `"Class 12"` → code strips to `"12"` for filtering.
- Fundamentals use `classLevel: "Fundamentals"` (matches `FormulaViewScreen` when `className: 'Fundamentals'`).

### 6.3 Entity relationship summary

```
classLevel ──< Formula (many)
subject    ──< Formula (many, within class)
chapter    ──< Formula (many, within subject)

Device (SharedPreferences) ──< bookmarked formula id (many)
                              └── resolves to Formula via id lookup
```

### 6.4 Authentication schema

**[Existing]** None.

**[Recommended]** if Firebase Auth is added:

| Field | Type | Notes |
|-------|------|-------|
| `uid` | string | Firebase UID |
| `email` | string? | Optional |
| `displayName` | string? | Optional |
| `createdAt` | timestamp | Server |

**OAuth:** Google / Apple **[Recommended]** for student sign-in.

**Session:** Firebase ID tokens; no custom JWT.

**RBAC:** Not needed for MVP reader app. **[Recommended]** `admin` role only if CMS for formulas is built.

### 6.5 APIs & services

**[Existing]** None.

**[Recommended]**

- **Option A:** Keep offline JSON; host versioned JSON on Firebase Storage with in-app update check.
- **Option B:** Firestore collection `formulas` with same fields as JSON schema.

### 6.6 Real-time requirements

| Feature | Real-time needed? |
|---------|-------------------|
| Browse / search / view | No — local JSON |
| Bookmarks | No — local prefs |
| Remote content sync | **[Recommended]** one-time fetch or pull-to-refresh, not live subscription |

### 6.7 Security rules

**[Existing]**

- APK/IPA bundles all JSON — content is effectively public in the binary.
- Bookmarks are private to the device (no encryption).

**[Recommended]** Firestore rules example:

```
formulas/{id}     → read: true; write: admin only
users/{uid}/bookmarks/{id} → read, write: request.auth.uid == uid
```

### 6.8 Performance indexes

**[Existing]** In-memory filter after full load — no DB indexes.

**[Recommended]** if moving to Firestore, index:

- `classLevel` + `subject` + `chapter`
- Array-contains on `searchTags`

**[Recommended]** client-side: build `Map<classLevel, Map<subject, Set<chapter>>>` once after load.

---

## 7. IMPLEMENTATION

### 7.1 Current status

| Area | Status |
|------|--------|
| App shell + bottom nav | ✅ Done |
| Home + class navigation | ✅ Done |
| Syllabus expansion UI | ✅ Done |
| Formula view + LaTeX | ✅ Done |
| Bookmarks (local) | ✅ Done |
| Search | ✅ Done (no bookmark on results) |
| Class 12 + Fundamentals content | ✅ Done |
| Class 9–11 content | ❌ Empty JSON |
| Unit / widget tests | ❌ Stale counter test |
| Firebase / Auth | ❌ Not started |
| CI/CD / store listing | ❌ Not in repo |
| Dark mode / settings | ❌ Not started |

### 7.2 Missing features (priority order)

1. Populate `class9.json`, `class10.json`, `class11.json`
2. Cache formula list (single parse per app session)
3. Unify `FormulaCard` in search results; extract widget file
4. Fix `pubspec.yaml` (lints, `rename` as dev dependency)
5. Fix `widget_test.dart`
6. Central theme + consistent app bars
7. Dark mode
8. *(Optional)* Firebase for sync and OTA content

### 7.3 Technical debt

- `FormulaLocalDataSource().loadFormulas()` called on many screens — repeated JSON parse
- `print()` debug logs in data source
- `FormulaCard` defined in `formula_view_screen.dart` but imported by bookmarks — tight coupling
- Fundamentals on Home are **hardcoded** (3 cards), not generated from JSON
- Search UI duplicates formula card layout without bookmarks
- Inconsistent branding (purple vs blue app bars)
- No structured error handling / crash reporting

### 7.4 MVP TODO (gap analysis)

#### Setup

- [ ] Fix `pubspec.yaml` (`flutter_lints`, `rename`)
- [ ] `flutter pub get` && `flutter analyze` clean
- [ ] Replace default widget test with “app loads Formulize” smoke test
- [ ] Add `FormulaRepository` with in-memory cache

#### Content

- [ ] Fill `class9.json`, `class10.json`, `class11.json` (same schema as `class12.json`)
- [ ] Validate JSON in CI (unique `id`, required fields)
- [ ] Optional: JSON schema file for authors

#### Core (mostly done)

- [x] Browse Class 12 syllabus
- [x] View formulas + LaTeX
- [x] Bookmarks
- [x] Search
- [ ] Use `FormulaCard` on `SearchResultsScreen`
- [ ] Optional: drive fundamentals home cards from JSON

#### Polish

- [ ] `AppTheme` with `#1C0845` tokens
- [ ] Dark mode (`ThemeMode.system`)
- [ ] Consistent loading / error UI
- [ ] Remove `print` from data source

#### Post-MVP

- [ ] Firebase Auth + Firestore (or remote JSON)
- [ ] Analytics + Crashlytics
- [ ] Store listing (screenshots, privacy policy)
- [ ] `go_router` + deep links

### 7.5 Development phases

| Phase | Focus |
|-------|--------|
| **Phase 1 — Foundation** | Project setup, routing cleanup, repository cache, fix tests & pubspec |
| **Phase 2 — Core MVP** | Complete Class 9–11 JSON, search/bookmark parity, theme unification |
| **Phase 3 — Polish** | Dark mode, error states, performance, empty states |
| **Phase 4 — Post-MVP** | Firebase, analytics, quizzes, i18n, monetization |

### 7.6 Testing strategy

| Type | What to cover | Status |
|------|---------------|--------|
| **Unit** | `FormulaModel.fromJson`, search filter logic, bookmark add/remove | **[Recommended]** |
| **Widget** | Home renders class cards; empty bookmarks state | **[Recommended]** |
| **Integration** | Load assets → repository → screen shows formulas | **[Recommended]** |
| **E2E** | Home → Class 12 → chapter → bookmark → Bookmarks tab | **[Recommended]** |
| **Manual QA** | Search, theory-only chapter snackbar, clear bookmarks dialog, offline airplane mode | Checklist below |

**Manual QA checklist**

- [ ] Cold start opens Home
- [ ] Class 12 shows syllabus; empty class shows “coming soon”
- [ ] Formula LaTeX renders without overflow crash
- [ ] Bookmark persists after app restart
- [ ] Search returns results; empty query does nothing
- [ ] Clear all bookmarks works with confirmation

### 7.7 Pre-launch checklist

- [ ] All class JSON files populated or hidden in UI
- [ ] `flutter analyze` with no errors
- [ ] Tests passing
- [ ] App icon & splash finalized
- [ ] Privacy policy (even if no data collection—bookmarks are local)
- [ ] Play Console / App Store Connect metadata
- [ ] Release build tested on physical devices
- [ ] **[Recommended]** Crashlytics / analytics

### 7.8 Deployment strategy

**[Existing]** Standard Flutter release builds:

```bash
flutter build appbundle   # Google Play
flutter build ipa         # App Store (macOS + certificates)
```

**[Recommended]**

- GitHub Actions: `flutter analyze`, `flutter test`, optional JSON lint on PR
- Internal testing track on Play Console before production
- Bump `version` in `pubspec.yaml` per content + code releases

### 7.9 Scaling suggestions

| Need | Approach |
|------|----------|
| Larger JSON | Keep per-class files; lazy-load per class in repository |
| Frequent content updates | Remote JSON manifest + download, or Firestore |
| User sync | Firebase Auth + `users/{uid}/bookmarks` |
| Performance | Parse once; optional isolate if JSON grows past ~5MB |
| Maintainability | Riverpod/Provider for repository + bookmark state |
| Many screens | `go_router` + feature modules |

---

## Getting started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (Dart `^3.10.7`)
- Android Studio / Xcode for emulators (optional)

### Commands

```bash
# Install dependencies
flutter pub get

# Run on connected device / emulator
flutter run

# Static analysis
flutter analyze

# Tests (update widget_test first)
flutter test

# Release builds
flutter build appbundle   # Android → Play Store
flutter build ipa         # iOS → App Store
```

### Adding content

1. Edit the appropriate file under `assets/` (`class12.json`, etc.).
2. Ensure each entry has a **unique** `id`.
3. Use `classLevel` `"9"`–`"12"` or `"Fundamentals"`.
4. Set `containsFormulas: false` for theory-only syllabus rows.
5. Rebuild/run — assets are bundled at compile time.

---

## Summary: Existing vs Recommended

| Topic | Today | Next |
|-------|--------|------|
| **Data** | Local JSON assets | Keep offline; optional remote updates |
| **Auth** | None | Only if cross-device sync is required |
| **Architecture** | Feature folders + direct data source | Repository + light state management |
| **Routes** | `Navigator.push` | `go_router` |
| **Content** | Class 12 + Fundamentals | Classes 9–11 |
| **Firebase** | Not integrated | Add when OTA content or accounts are needed |
| **UI** | Purple home + blue elsewhere | Unified `AppTheme` + dark mode |
| **Tests** | Stale counter test | Real smoke + unit tests |

---

## License

Private project — `publish_to: 'none'` in `pubspec.yaml`.
