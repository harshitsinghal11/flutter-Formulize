# 04 — UI/UX Design Specification

**Product:** Formulize  
**Design system maturity:** Ad hoc (colors and spacing inline in widgets; no centralized theme tokens file)

---

## Design Principles

| Principle | Application |
|-----------|-------------|
| **Student-first** | Bold headers, colorful class cards, exam-focused layout |
| **Clarity** | Formula title + LaTeX + plain-text explanation per card |
| **Speed** | Bottom nav for Home/Bookmarks; search accessible from Home |
| **Offline trust** | No login friction; immediate content access |
| **Feedback** | Loading spinners, empty states, snackbars for theory-only chapters |

**Personality:** Professional and modern — not playful or luxurious. Optimized for quick reference during study.

---

## Brand Guidelines

| Element | Value |
|---------|--------|
| **App name** | Formulize |
| **Tagline** | Smarter Way To Learning |
| **Primary brand color** | `#1C0845` (deep purple) — Home app bar, some snackbars |
| **Logo** | App icon in `assets/icon/` (via `flutter_launcher_icons`) |

**Brand inconsistency (known issue):** Home uses purple (`#1C0845`); most other screens use `Colors.blueAccent` for app bars and accents. Global theme sets `primarySwatch: Colors.blue`.

---

## Color System

| Token | Value | Usage |
|-------|--------|--------|
| **Brand primary** | `#1C0845` | Home `AppBar`, some snackbars |
| **Action / links** | `Colors.blueAccent` | App bars (most screens), bookmark icon, search prefix |
| **Background (light)** | `Colors.grey[50]` | Scaffold backgrounds |
| **Class 9 card** | `Colors.orangeAccent` | Gradient class card |
| **Class 10 card** | `Colors.green` | Gradient class card |
| **Class 11 card** | `Colors.purpleAccent` | Gradient class card |
| **Class 12 card** | `Colors.redAccent` | Gradient class card |
| **Destructive** | `Colors.redAccent` | Clear all bookmarks FAB |
| **Body text** | Default black / `Colors.grey[700]` | Explanations, secondary text |
| **Card surface** | `Colors.white` | Cards, search pill |

**Semantic colors (Error / Success / Warning / Info):** Not tokenized — ad hoc use of red accent for destructive actions only.

**Dark mode:** **Project not supported** — light theme only (`ThemeData(useMaterial3: true)`).

---

## Typography

**Fonts:** System/Material defaults — no custom fonts declared in `pubspec.yaml`.

| Role | Style (approximate) | Location |
|------|---------------------|----------|
| Brand title | 34px, `FontWeight.w900` | Home app bar |
| Section headers | 22px, `FontWeight.w800` | Home sections |
| App bar title | Bold, ~20px | Secondary screens |
| Formula title | 16px bold | `FormulaCard` |
| Explanation | 14px, grey | `FormulaCard` |
| LaTeX | 20px | `Math.tex` rendering |
| Empty state | 16px, grey | Bookmarks, empty class |

**Type scale (Display → Caption):** Not formally defined — values are inline per widget.

---

## Spacing & Layout

| Pattern | Value |
|---------|--------|
| Screen horizontal padding | 16–20 px |
| Card border radius | 16–20 px |
| Home app bar bottom radius | 30 px |
| Class grid columns | 2 |
| Class grid aspect ratio | 1.1 |
| Fundamentals card size | 140 × 130 px (horizontal list) |
| Card elevation | 1–4 |

**Grid system:** No formal 4px/8px token file — spacing is ad hoc but generally multiples of 4 or 8.

---

## Design Tokens

**Project not supported** as a centralized token system.

There is no `AppTheme`, `ThemeExtension`, or design token file. Colors, radii, and spacing are hardcoded in individual widgets.

**Recommended future tokens:**

| Token | Suggested value |
|-------|-----------------|
| `colorBrandPrimary` | `#1C0845` |
| `spacingSm` / `Md` / `Lg` | 8 / 16 / 24 |
| `radiusCard` | 16 |
| `radiusAppBar` | 30 |

---

## Component Library

| Component | File / Location | Description |
|-----------|-----------------|-------------|
| `ClassCard` | `features/home/widgets/class_card.dart` | Gradient card for Class 9–12 |
| `HomeSearchBar` | `features/home/widgets/home_search_bar.dart` | White pill search with shadow |
| `FormulaCard` | `features/formula_view/screens/formula_view_screen.dart` | Title, LaTeX, explanation, bookmark |
| Fundamental card | Inline in `home_screen.dart` | Colored horizontal shortcut cards |
| Syllabus expansion tile | `class_detail_screen.dart` | Subject → chapter list |
| Search result card | Inline in `search_results_screen.dart` | Simpler card — **no bookmark** |
| Empty state | Multiple screens | Icon + grey message text |
| Confirm dialog | `bookmarks_screen.dart` | `AlertDialog` for clear all |
| SnackBar | `class_detail_screen.dart` | Theory-only chapter feedback |
| Bottom nav | `main_screen.dart` | Home \| Bookmarks |

**Project not supported:** Formal design system package, Storybook/widget catalog, or shared button/input component library.

---

## Page Inventory

| Screen | Route type | Tab / Stack |
|--------|------------|-------------|
| `MainScreen` | Root shell | Bottom nav container |
| `HomeScreen` | Tab 0 | Home content |
| `BookmarksScreen` | Tab 1 | Saved formulas |
| `ClassDetailScreen` | Pushed | Syllabus for one class |
| `FormulaViewScreen` | Pushed | Formulas for one chapter |
| `SearchResultsScreen` | Pushed | Search results list |

**Project not supported:** Splash, onboarding, login, signup, forgot password, settings, profile pages.

---

## Page Specifications

### MainScreen
- **Layout:** `Scaffold` + `BottomNavigationBar` + body switches by index.
- **Tabs:** Home (icon + label), Bookmarks (icon + label).

### HomeScreen
- **App bar:** Purple (`#1C0845`), rounded bottom, large "Formulize" title + tagline.
- **Sections:** Search bar → "Select Your Class" grid → "Fundamentals" horizontal list.
- **Actions:** Search submit, class tap, fundamental tap.

### ClassDetailScreen
- **App bar:** Blue accent, title = class name.
- **Body:** `FutureBuilder` → expansion tiles grouped by subject/chapter.
- **Empty:** "Content coming soon" when no formulas for class.

### FormulaViewScreen
- **App bar:** Blue accent, title = chapter name.
- **Body:** Scrollable list of `FormulaCard` widgets.
- **Actions:** Per-formula bookmark toggle.

### SearchResultsScreen
- **App bar:** Blue accent, title includes query.
- **Body:** Filtered formula cards (inline layout, no bookmark).

### BookmarksScreen
- **App bar:** Blue accent, "My Bookmarks" title.
- **Body:** List of bookmarked `FormulaCard` or empty state.
- **FAB:** "Clear All" (red extended FAB) when bookmarks exist.

---

## Responsive Design Rules

| Breakpoint | Behavior |
|------------|----------|
| Mobile portrait | Primary target — 2-column class grid |
| Tablet / landscape | Same layout — no multi-column adaptation |
| Web / desktop | **Project not supported** — not configured as target |

**Project not supported:** Formal breakpoints, `LayoutBuilder`-based adaptive grids, or web-specific layout rules.

---

## Loading States

| Screen | Loading UI |
|--------|------------|
| ClassDetailScreen | Centered `CircularProgressIndicator` |
| FormulaViewScreen | Centered `CircularProgressIndicator` |
| SearchResultsScreen | Centered `CircularProgressIndicator` |
| BookmarksScreen | Centered `CircularProgressIndicator` |
| HomeScreen | No async load on initial render (static layout) |

**Project not supported:** Skeleton loaders, shimmer placeholders, or progressive loading indicators.

---

## Empty States

| Context | UI |
|---------|-----|
| Empty class JSON | Icon + "Content coming soon" message |
| No bookmarks | Icon + message encouraging user to bookmark formulas |
| No search results | Message indicating no matches (if implemented) |

---

## Error States

| Context | UI |
|---------|-----|
| JSON load failure | Generic error text in `FutureBuilder` error branch |
| LaTeX render failure | `flutter_math_fork` default error display |

**Project not supported:** Illustrated error pages, retry buttons, or error code display.

---

## Accessibility Guidelines

| Area | Current state |
|------|---------------|
| **Semantic labels** | Partial — relies on default Material widget semantics |
| **Touch targets** | Material defaults for icons and cards |
| **Color contrast** | Not formally audited |
| **Screen reader** | Not explicitly tested or optimized |
| **Font scaling** | Respects system text scale via Flutter defaults |
| **Dark mode / high contrast** | **Project not supported** |

**Recommendations:** Add `Semantics` labels on bookmark toggles, ensure LaTeX alternatives via `explanation` text, audit purple/blue contrast ratios.
