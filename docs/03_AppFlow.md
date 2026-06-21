# 03 — Application Flow

**Product:** Formulize  
**Navigation type:** Imperative `Navigator.push` (no named routes)

---

## Application Overview

Formulize is a two-tab offline study app:

1. **Home** — browse classes, fundamentals, and search.
2. **Bookmarks** — view saved formulas.

There is no splash screen, onboarding, login, or settings. The app launches directly into `MainScreen`.

**Content availability:**

| Source | Status |
|--------|--------|
| `class12.json` | Populated (~247 entries) |
| `fundamentals.json` | Populated (~101 entries) |
| `class9.json`, `class10.json`, `class11.json` | Empty — "Content coming soon" |

---

## Navigation Structure

```
MainScreen (BottomNavigationBar)
├── Tab 0: HomeScreen
│   ├── HomeSearchBar → SearchResultsScreen
│   ├── ClassCard (Class 9–12) → ClassDetailScreen
│   │   └── Chapter tile → FormulaViewScreen OR SnackBar
│   └── Fundamental card → FormulaViewScreen (classLevel: Fundamentals)
└── Tab 1: BookmarksScreen
    └── FormulaCard list (or empty state)
```

**Navigation mechanism:** `MaterialPageRoute` pushed onto the default `Navigator` stack. Back button pops to previous screen.

**Project not supported:** Named routes, `go_router`, deep links, or tab-based URL routing.

---

## Authentication Flow

**Project not supported.**

The app does not require sign-in. Users open the app and immediately access all features. Bookmarks are stored anonymously on the device.

---

## Role Based Flows

**Project not supported.**

All users follow the same flows. There are no admin, teacher, or student role distinctions.

---

## Feature Workflows

### WF-1: Browse class syllabus

```
HomeScreen
  → User taps Class card (e.g. "Class 12")
  → ClassDetailScreen(className: "Class 12")
  → loadFormulas() → filter classLevel == "12"
  → Build subject → chapter expansion list
  → User taps chapter
      ├── containsFormulas == true  → FormulaViewScreen
      └── containsFormulas == false → SnackBar ("theory-only")
```

### WF-2: View chapter formulas

```
FormulaViewScreen(className, chapterName)
  → loadFormulas() → filter by class + chapter
  → Render FormulaCard for each formula
  → User taps bookmark icon
      → Add/remove id in SharedPreferences
      → Update icon state
```

### WF-3: Browse fundamentals

```
HomeScreen
  → User taps fundamental card (e.g. "Trigonometry")
  → FormulaViewScreen(className: "Fundamentals", chapterName: "...")
  → Filter classLevel == "Fundamentals" + chapter match
```

Fundamental cards on Home are **hardcoded** (3 titles), not generated dynamically from JSON.

### WF-4: Search

```
HomeScreen
  → User enters query in HomeSearchBar and submits
  → SearchResultsScreen(query)
  → loadFormulas() → filter title/chapter/searchTags
  → Display inline Card list (no bookmark toggle on results)
```

Empty query: no navigation (handled in search bar).

### WF-5: Bookmarks

```
MainScreen → Bookmarks tab
  → BookmarksScreen
  → Read bookmarked IDs from SharedPreferences
  → loadFormulas() → resolve IDs to FormulaModel
  → Display FormulaCard list

Clear all:
  → User taps FAB "Clear All"
  → AlertDialog confirmation
  → Remove all IDs from SharedPreferences
  → Refresh list → empty state
```

### WF-6: Empty class content

```
HomeScreen → Class 9/10/11 card
  → ClassDetailScreen
  → loadFormulas() returns empty for that classLevel
  → Show "Content coming soon" empty state
```

---

## Data Flow

```
┌──────────────────┐
│  assets/*.json   │
└────────┬─────────┘
         │ rootBundle.loadString (per loadFormulas call)
         ▼
┌──────────────────────────┐
│ FormulaLocalDataSource   │
│  - load class9…12 +      │
│    fundamentals.json     │
│  - jsonDecode → merge    │
└────────┬─────────────────┘
         ▼
┌──────────────────┐
│  FormulaModel    │
└────────┬─────────┘
         │
    ┌────┴────┐
    ▼         ▼
 Screens   SharedPreferences
 (filter)  (bookmark IDs only)
```

**Bookmark resolution flow:**

```
SharedPreferences.getStringList('bookmarked_formulas')
  → List<formula id>
  → Full formula list loaded again
  → Filter where formula.id in bookmarked ids
  → Display on BookmarksScreen
```

---

## Error Handling Flow

| Scenario | Behavior |
|----------|----------|
| JSON load in progress | `FutureBuilder` shows `CircularProgressIndicator` |
| JSON load failure | Generic error `Text` widget (minimal handling) |
| Empty class content | Dedicated empty state UI ("Content coming soon") |
| No bookmarks | Empty state with icon and message on BookmarksScreen |
| Theory-only chapter | Floating `SnackBar` — user stays on syllabus screen |
| LaTeX parse error | Handled by `flutter_math_fork` (may show error widget) |
| Clear bookmarks | Confirmation dialog before destructive action |

**Project not supported:** Global error boundary, retry with exponential backoff, crash reporting, or structured error codes.

---

## Edge Cases

| Edge case | Expected behavior |
|-----------|-------------------|
| Duplicate formula `id` across JSON files | Undefined — content authors must ensure uniqueness |
| Bookmark ID no longer exists in JSON | Formula silently omitted from bookmarks list |
| App data cleared | All bookmarks lost |
| Search with special characters | String contains match — no regex escaping |
| Very long LaTeX string | May cause layout overflow — no scroll constraint documented |
| Class card tapped for empty JSON | Empty state on ClassDetailScreen, not crash |
| Rapid tab switching | Each tab rebuilds; Home may reload data |
| Offline mode | Fully supported — no network dependency |
| Rotation / tablet width | Mobile layout only — no adaptive grid |

---

## User Journey Maps

### Journey 1: Board exam revision (Class 12 Physics)

```
Open app → Home tab
  → Tap "Class 12"
  → Expand "Physics"
  → Tap "Electric Charges and Fields"
  → Read formulas with LaTeX
  → Bookmark key formulas
  → Switch to Bookmarks tab
  → Review saved formulas before exam
```

### Journey 2: Quick formula lookup via search

```
Open app → Home tab
  → Type "Coulomb" in search
  → Submit
  → Scan SearchResultsScreen
  → Tap result context (navigate if linked) or read inline card
```

### Journey 3: Fundamentals refresh

```
Open app → Home tab
  → Scroll fundamentals row
  → Tap "Trigonometry"
  → View all fundamental trig formulas
  → Bookmark identities for quick access
```

### Journey 4: Discovering unavailable content

```
Open app → Tap "Class 9"
  → ClassDetailScreen loads empty data
  → See "Content coming soon"
  → User returns to Home to use Class 12 or Fundamentals instead
```

**Project not supported:** Journeys involving login, profile setup, cloud sync, push notification deep links, or settings customization.
