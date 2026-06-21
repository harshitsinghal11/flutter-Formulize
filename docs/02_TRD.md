# 02 — Technical Requirements Document (TRD)

**Product:** Formulize  
**Stack type:** Offline-first Flutter mobile app (no server)

---

## Tech Stack

| Layer | Technology | Version / Notes |
|-------|------------|-----------------|
| **Framework** | Flutter | Material 3 enabled |
| **Language** | Dart | SDK `^3.10.7` |
| **UI** | Flutter Material | `uses-material-design: true` |
| **Math rendering** | `flutter_math_fork` | ^0.7.4 — LaTeX display |
| **Local persistence** | `shared_preferences` | ^2.5.4 — bookmark ID list |
| **Content storage** | Bundled JSON assets | `assets/class9.json` … `class12.json`, `fundamentals.json` |
| **Icons** | `cupertino_icons` | ^1.0.8 |
| **Tooling** | `flutter_launcher_icons`, `rename` | Icons and rename utilities |
| **Linting** | `flutter_lints` | ^6.0.0 (via dev dependencies) |
| **Platforms** | Android, iOS | Standard Flutter platform folders |

**Project not supported:**

| Technology | Status |
|------------|--------|
| Firebase (Auth, Firestore, Storage) | Not integrated |
| REST/GraphQL backend | Not used |
| SQL/NoSQL server database | Not used |
| State management packages (Provider, Riverpod, BLoC) | Not used |
| `go_router` / named routing | Not used |
| Environment variables (`.env`) | Not used |

---

## Project Structure

```
formulize/
├── lib/
│   ├── main.dart                              # App entry, theme, MainScreen
│   ├── data/
│   │   ├── models/
│   │   │   └── formula_model.dart             # JSON → Dart model
│   │   └── source/
│   │       └── formula_local_data_source.dart # Loads & merges JSON assets
│   └── features/
│       ├── home/
│       │   ├── screens/
│       │   │   ├── main_screen.dart           # Bottom nav shell
│       │   │   └── home_screen.dart           # Search, classes, fundamentals
│       │   └── widgets/
│       │       ├── class_card.dart
│       │       └── home_search_bar.dart
│       ├── chapter_list/
│       │   └── screens/
│       │       └── class_detail_screen.dart   # Syllabus browser
│       ├── formula_view/
│       │   └── screens/
│       │       └── formula_view_screen.dart   # FormulaViewScreen + FormulaCard
│       ├── bookmarks/
│       │   └── screens/
│       │       └── bookmarks_screen.dart
│       └── search/
│           └── screens/
│               └── search_results_screen.dart
├── assets/
│   ├── class9.json … class12.json
│   ├── fundamentals.json
│   └── icon/
├── test/
│   └── widget_test.dart                       # Stale default counter test
├── android/ / ios/ / …                        # Standard Flutter platforms
├── pubspec.yaml
└── analysis_options.yaml
```

---

## System Architecture

Formulize is a **single-tier client application**. All business logic and data live on the device.

```
┌─────────────────────────────────────────────────┐
│                  Flutter App                     │
│  ┌─────────────┐    ┌─────────────────────────┐ │
│  │   UI Layer  │───▶│  FormulaLocalDataSource │ │
│  │  (Features) │    │  (loads assets/*.json)  │ │
│  └──────┬──────┘    └───────────┬─────────────┘ │
│         │                       │               │
│         │              ┌────────▼────────┐      │
│         └─────────────▶│  FormulaModel   │      │
│                        └─────────────────┘      │
│         ┌──────────────────────────────────┐    │
│         │  SharedPreferences (bookmarks)   │    │
│         └──────────────────────────────────┘    │
└─────────────────────────────────────────────────┘
```

**Project not supported:** Client-server architecture, microservices, CDN layer, or API gateway.

---

## Frontend Architecture

| Aspect | Implementation |
|--------|----------------|
| **Organization** | Feature-first folders under `lib/features/` |
| **Data layer** | `lib/data/models/` + `lib/data/source/` |
| **UI pattern** | `StatefulWidget` + `FutureBuilder` for async JSON load |
| **Navigation** | Imperative `Navigator.push` with `MaterialPageRoute` |
| **Shell** | `MainScreen` with `BottomNavigationBar` (Home \| Bookmarks) |
| **Reusable widgets** | `ClassCard`, `HomeSearchBar`, `FormulaCard` (inside formula_view screen file) |

**Data flow (current):**

```
Screen → FormulaLocalDataSource.loadFormulas()
      → Parse & merge JSON assets
      → List<FormulaModel>
      → Filter/display in UI
```

**Known gap:** No repository abstraction or shared in-memory cache — each screen may reload and re-parse all JSON.

---

## Backend Architecture

**Project not supported.**

Formulize has no backend server, cloud database, or remote API. All content is read from bundled assets at runtime.

---

## Authentication & Authorization

**Project not supported.**

- No login, signup, or session management.
- No OAuth providers.
- No Firebase Auth or token handling.
- All screens are publicly accessible within the app.
- Bookmarks are anonymous and device-local.

---

## API Design Standards

**Project not supported.**

There are no HTTP endpoints, REST conventions, or API versioning. The only data interface is local asset loading via `rootBundle.loadString`.

---

## State Management

| Concern | Approach |
|---------|----------|
| Formula data | `FutureBuilder` per screen; reload on navigation |
| Bookmarks | `SharedPreferences` read/write in widget `setState` |
| Tab selection | `MainScreen` local state (`_selectedIndex`) |
| Search query | Passed via constructor to `SearchResultsScreen` |

**Project not supported:** Provider, Riverpod, BLoC, GetX, or global app state containers.

---

## Caching Strategy

| Data | Strategy |
|------|----------|
| Formula JSON | Loaded from assets on each `loadFormulas()` call — **no in-memory cache** |
| Bookmarks | Persisted in `SharedPreferences` key `bookmarked_formulas` |
| Parsed models | Not cached across screens (re-parsed each navigation) |

**Improvement opportunity:** Single `FormulaRepository` with one parse per app session.

**Project not supported:** HTTP caching, Redis, CDN cache headers, or disk cache for remote data.

---

## Security Considerations

| Area | Current state |
|------|---------------|
| **Network** | No network calls — no TLS/API key exposure |
| **Content** | JSON bundled in APK/IPA — effectively public in binary |
| **Bookmarks** | Stored in plain SharedPreferences — private to device, not encrypted |
| **Auth** | N/A |
| **Input validation** | Search query used for string matching only; no injection surface |

**Project not supported:** Firestore security rules, RLS, JWT validation, or server-side input sanitization.

---

## Performance Strategy

| Technique | Status |
|-----------|--------|
| Per-class JSON files | Implemented — split by class reduces single-file size |
| Lazy load per class | Not implemented — all files merged on every load |
| Isolate for JSON parse | Not implemented |
| Widget rebuild optimization | Basic `FutureBuilder` usage |

**Recommendations for scale:**

- Parse JSON once per session in a repository.
- Optionally lazy-load only the class file needed for current screen.
- Use isolates if total JSON exceeds ~5 MB.

---

## Logging & Monitoring

| Capability | Status |
|------------|--------|
| Debug `print()` in data source | Present (should be removed for production) |
| Structured logging | **Project not supported** |
| Firebase Crashlytics | **Project not supported** |
| Firebase Analytics | **Project not supported** |
| Remote logging / APM | **Project not supported** |

---

## Deployment Strategy

| Target | Command / Method |
|--------|------------------|
| **Android (Play Store)** | `flutter build appbundle` |
| **iOS (App Store)** | `flutter build ipa` (requires macOS + Apple certificates) |
| **Local dev** | `flutter pub get` → `flutter run` |
| **Quality gate** | `flutter analyze`, `flutter test` |

**Project not supported:** CI/CD pipeline in repo, Firebase Hosting, web deployment, or containerized backend deployment.

**Release notes:**

- Content changes require asset update + version bump in `pubspec.yaml`.
- App version: `1.0.0+1`.
- `publish_to: 'none'` — private project.
