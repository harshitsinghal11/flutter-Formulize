# 01 — Product Requirements Document (PRD)

**Product:** Formulize  
**Version:** 1.0.0+1  
**Platform:** Android & iOS (Flutter)  
**Tagline:** Smarter Way To Learning

---

## Project Vision

Formulize is an **offline-first** mobile reference app that helps Indian school students (Classes 9–12) quickly find, read, and bookmark Math, Physics, and Chemistry formulas. The app bundles syllabus-aligned content as local JSON, renders equations with LaTeX, and works without internet or user accounts.

---

## Problem Statement

Students preparing for board exams and revision struggle because:

- Formulas are scattered across textbooks, notes, and PDFs.
- Mobile-friendly, searchable formula references are hard to find offline.
- Generic apps rarely follow NCERT/CBSE-style class and chapter structure.
- Poor math rendering on small screens makes notation hard to read.

Formulize centralizes formulas in one browsable, searchable catalog with proper LaTeX display and local bookmarks.

---

## Goals & Objectives

| Goal | Objective |
|------|-----------|
| Fast revision | Browse by class → subject → chapter in under 3 taps |
| Discoverability | Global search across title, chapter, and tags |
| Readability | Render formulas with LaTeX via `flutter_math_fork` |
| Offline access | All content ships in app assets; no network required |
| Personalization | Device-local bookmarks for exam prep |
| Content scalability | Add/update formulas via JSON without code changes |

---

## Target Audience

| Persona | Description |
|---------|-------------|
| **Primary** | Indian secondary/higher-secondary students (ages 14–18) studying CBSE/NCERT-style syllabus |
| **Secondary** | Teachers and tutors who need a compact formula reference on mobile |

**Use cases:** Homework, last-minute board revision, quick lookup during practice problems.

---

## User Roles & Permissions

| Role | Description |
|------|-------------|
| **Anonymous user** | Single role — all users have identical access |

**Project not supported:** Role-based access control, admin panel, or authenticated user roles. The app has no login and no permission tiers.

---

## Core Features

| Feature | Description | Status |
|---------|-------------|--------|
| Home hub | Search bar, class grid (9–12), fundamentals shortcuts | Implemented |
| Syllabus browser | Subject → chapter expansion list per class | Implemented |
| Formula viewer | Title, LaTeX equation, explanation, bookmark toggle | Implemented |
| Search | Match on title, chapter, `searchTags` | Implemented |
| Bookmarks | Save/remove formula IDs; clear all with confirmation | Implemented |
| Theory-only chapters | `containsFormulas: false` shows snackbar instead of empty screen | Implemented |
| Class 9–11 content | Full formula data for classes 9, 10, 11 | Not yet (empty JSON files) |

---

## Functional Requirements

### FR-1: Home screen
- Display app branding and search input.
- Show Class 9, 10, 11, 12 cards in a grid.
- Show fundamentals shortcut cards (Algebraic Identities, Trigonometry, Logarithms).
- Navigate to class detail, formula view, or search results on user action.

### FR-2: Class syllabus
- Load formulas filtered by `classLevel` (e.g. `"12"` from `"Class 12"`).
- Group by subject, then chapter, using expansion tiles.
- If class JSON is empty, show "Content coming soon" empty state.

### FR-3: Formula display
- List all formulas for a selected chapter.
- Render `latexCode` with LaTeX.
- Show `title` and `explanation` for each formula.
- Allow bookmark add/remove per formula.

### FR-4: Search
- Accept query from home search bar.
- Return formulas matching query against title, chapter, or any `searchTags` entry.
- Display results in a dedicated results screen.

### FR-5: Bookmarks
- Persist bookmarked formula IDs in `SharedPreferences` (`bookmarked_formulas`).
- Resolve IDs to full formula records on Bookmarks tab.
- Support "Clear all" with confirmation dialog.
- Show empty state when no bookmarks exist.

### FR-6: Navigation shell
- Bottom navigation with two tabs: **Home** and **Bookmarks**.

---

## Non-Functional Requirements

| Category | Requirement |
|----------|-------------|
| **Offline** | App must function fully without network connectivity |
| **Performance** | Screens should load content within acceptable time on mid-range devices |
| **Compatibility** | Dart SDK `^3.10.7`; standard Flutter Android/iOS targets |
| **Usability** | Material 3 UI; readable typography; clear empty and loading states |
| **Maintainability** | Feature-first folder structure; content separated in JSON assets |
| **Privacy** | No user accounts; bookmarks stored locally on device only |

**Project not supported:** Multi-region deployment, real-time sync SLAs, or server-side availability targets (no backend).

---

## Business Rules

1. Each formula must have a **unique `id`** across all JSON files (used as bookmark key).
2. `classLevel` values: `"9"`, `"10"`, `"11"`, `"12"`, or `"Fundamentals"`.
3. Chapters with `containsFormulas: false` are syllabus placeholders only — tapping shows a snackbar, not a formula list.
4. Class name in UI (e.g. `"Class 12"`) is stripped to numeric level (`"12"`) for filtering.
5. Empty class JSON files result in "Content coming soon" — cards remain visible but content is unavailable.
6. Bookmarks are device-local and are lost if app data is cleared or app is uninstalled.

---

## Assumptions

- English UI and content.
- NCERT/CBSE-aligned chapter naming for Class 12 and Fundamentals content.
- Mobile portrait is the primary layout; tablet/web are not primary targets.
- Content authors maintain JSON files manually or via external tooling.
- Students do not require cross-device sync for MVP.

---

## Constraints

- **No backend** — content updates require app rebuild/redeploy unless remote sync is added later.
- **No authentication** — no user profiles or cloud bookmarks.
- **Bundled assets** — all formula JSON is included in the APK/IPA at build time.
- **Content gaps** — `class9.json`, `class10.json`, `class11.json` are currently empty arrays.
- **Repeated data loading** — each screen currently creates a new `FormulaLocalDataSource` and reloads JSON (technical debt).

---

## Future Enhancements

| Enhancement | Rationale |
|-------------|-----------|
| Populate Class 9–11 JSON | Complete stated product scope |
| In-memory formula cache / repository | Avoid repeated JSON parsing on navigation |
| Unified theme and dark mode | Consistent brand and accessibility |
| Bookmark support in search results | Feature parity with formula viewer |
| Remote content updates | OTA formula updates without full app release |
| User accounts + cross-device bookmarks | Requires backend (e.g. Firebase) |
| Recent history and chapter progress | Improved revision workflow |
| Share/copy formula | Utility for homework and notes |
| Practice quizzes | Engagement beyond reference |
| Analytics and crash reporting | Production monitoring |
| Hindi/regional language | Broader audience |
| Named routes / deep links | Better navigation and testability |
