# 05 — Backend & Data Schema

**Product:** Formulize  
**Storage type:** Local JSON assets + SharedPreferences (no server database)

---

## Database Overview

Formulize does **not** use a server-side or client-side SQL/NoSQL database.

| Store | Type | Purpose |
|-------|------|---------|
| `assets/*.json` | Read-only bundled files | All formula content |
| `SharedPreferences` | Key-value local storage | Bookmarked formula IDs |

Content is loaded at runtime via `rootBundle.loadString`, parsed with `jsonDecode`, and mapped to `FormulaModel`.

**Project not supported:** PostgreSQL, Firestore, SQLite, Hive, Isar, Drift, or any remote database.

---

## ER Diagram

Logical entity relationships (not a physical DB schema):

```
classLevel ──< Formula (many)
    │
    ├── subject ──< Formula (many, within class)
    │       │
    │       └── chapter ──< Formula (many, within subject)
    │
    └── (Fundamentals is a special classLevel value)

Device (SharedPreferences)
    └── bookmarked_formulas: List<formula_id>
            └── resolves to ──> Formula (by id lookup)
```

**Text ERD:**

```
┌─────────────┐       ┌──────────────────┐
│  classLevel │───1:N─│     Formula      │
│  (9-12,     │       │  id, title,      │
│ Fundamentals)│       │  latexCode, ...  │
└─────────────┘       └────────┬─────────┘
                               │
                               │ referenced by id
                               ▼
                    ┌──────────────────────┐
                    │ bookmarked_formulas  │
                    │ (SharedPreferences)  │
                    └──────────────────────┘
```

---

## Tables

**Project not supported** — no relational tables.

### Logical entity: Formula (JSON object)

Each element in a JSON array maps to `FormulaModel`:

| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `id` | string | Yes | `''` | Unique identifier; bookmark key |
| `classLevel` | string | Yes | `''` | `"9"`, `"10"`, `"11"`, `"12"`, or `"Fundamentals"` |
| `subject` | string | Yes | `''` | e.g. Physics, Mathematics, Chemistry |
| `chapter` | string | Yes | `''` | Syllabus chapter name |
| `title` | string | Yes | `''` | Formula display name |
| `latexCode` | string | Yes | `''` | LaTeX string for `flutter_math_fork` |
| `explanation` | string | Yes | `''` | Plain-text description |
| `containsFormulas` | bool | Yes | `false` | Syllabus flag: navigable vs theory-only |
| `searchTags` | string[] | Yes | `[]` | Additional search keywords |

**Example record:**

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

### Logical store: Bookmarks (SharedPreferences)

| Key | Type | Description |
|-----|------|-------------|
| `bookmarked_formulas` | `List<String>` | Ordered list of formula `id` values |

**Project not supported:** User table, session table, or audit log table.

---

## Relationships

| From | To | Cardinality | Mechanism |
|------|-----|-------------|-----------|
| `classLevel` | Formula | 1:N | Filter `formula.classLevel` |
| `subject` | Formula | 1:N | Filter within class |
| `chapter` | Formula | 1:N | Filter within subject |
| Device bookmarks | Formula | N:M (by id) | ID list resolved against full formula load |

No foreign keys — relationships are implicit via string field matching at runtime.

---

## Constraints

| Constraint | Enforcement |
|------------|-------------|
| Unique `id` across all JSON files | Content author responsibility — not validated in app |
| Valid JSON syntax | App crashes/fails on parse error |
| `classLevel` must match UI filter logic | `"12"` for Class 12; `"Fundamentals"` for fundamentals flow |
| `containsFormulas: false` | UI blocks navigation to formula screen |
| Bookmark IDs must exist in loaded data | Orphan IDs silently skipped on Bookmarks screen |

**Project not supported:** DB-level UNIQUE, NOT NULL, CHECK constraints, or schema migration versioning.

---

## Indexes

**Project not supported.**

There is no database index layer. All filtering (by class, subject, chapter, search) happens in memory after full JSON load and merge.

**Client-side optimization opportunity:** Build lookup maps once after parse:

- `Map<classLevel, List<Formula>>`
- `Map<id, Formula>`

**Project not supported (future Firestore):** Composite indexes on `classLevel + subject + chapter` or array-contains on `searchTags`.

---

## RLS Policies

**Project not supported.**

Row-level security applies to server databases (e.g. Supabase, Firestore). Formulize has no authenticated multi-tenant data store.

All JSON content is bundled in the app binary and is effectively public.

---

## Triggers

**Project not supported.**

No database triggers. Bookmark changes are written directly to SharedPreferences from UI code.

---

## Functions

**Project not supported** — no server-side or SQL functions.

### Client-side data functions (Dart)

| Function | Location | Purpose |
|----------|----------|---------|
| `FormulaModel.fromJson` | `formula_model.dart` | Deserialize JSON object |
| `FormulaLocalDataSource.loadFormulas` | `formula_local_data_source.dart` | Load and merge all asset files |
| Screen-level filters | Various screens | Filter by class, chapter, search query |
| Bookmark read/write | `FormulaCard`, `BookmarksScreen` | SharedPreferences get/set |

---

## Storage Structure

### Asset files (`assets/`)

| File | Content status |
|------|----------------|
| `class9.json` | Empty array `[]` |
| `class10.json` | Empty array `[]` |
| `class11.json` | Empty array `[]` |
| `class12.json` | Populated (~247 formulas) |
| `fundamentals.json` | Populated (~101 formulas) |
| `icon/` | App launcher icons |

Declared in `pubspec.yaml` under `flutter.assets`.

### Local persistence

| Key | Storage | Lifetime |
|-----|---------|----------|
| `bookmarked_formulas` | SharedPreferences | Until app data cleared or uninstalled |

**Project not supported:** Firebase Storage, cloud file buckets, or CDN-hosted content manifests.

---

## API Models

**Project not supported** — no REST/GraphQL API models.

The only data transfer format is **JSON assets** deserialized into:

```dart
class FormulaModel {
  final String id;
  final String classLevel;
  final String subject;
  final String chapter;
  final String title;
  final String latexCode;
  final String explanation;
  final bool containsFormulas;
  final List<String> searchTags;
}
```

Serialization: `FormulaModel.fromJson(Map<String, dynamic> json)`.

**Project not supported:** DTOs for API requests/responses, pagination models, or error response schemas.

---

## Audit Strategy

**Project not supported.**

There is no logging of data changes, content versioning, or user action audit trail.

| Capability | Status |
|------------|--------|
| Content change history | Git history of JSON files only (manual) |
| Bookmark change log | Not recorded |
| User activity tracking | Not implemented |
| Admin audit for formula edits | Not applicable (no admin CMS) |

**Privacy note:** Bookmarks are local-only; no data is transmitted to a server.
