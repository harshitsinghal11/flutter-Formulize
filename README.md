# Formulize 📱
> Smarter Way To Learning

Formulize is a feature-rich, **offline-first mobile reference application** designed to help Indian school students (Classes 9–12) quickly find, study, and bookmark mathematical, physical, and chemical formulas. Built with Flutter, it delivers high-performance LaTeX formula rendering, device-local bookmarks, and instant search capabilities, working entirely without internet access or user account configuration.

---

## Table of Contents
- [Overview](#overview)
- [Key Features](#key-features)
- [Tech Stack](#tech-stack)
- [Screenshots (Optional)](#screenshots-optional)
- [Project Structure](#project-structure)
- [Documentation](#documentation)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
  - [Environment Variables](#environment-variables)
  - [Running Locally](#running-locally)
- [Available Scripts](#available-scripts)
- [Deployment](#deployment)
- [Project Status](#project-status)
- [Contributing](#contributing)
- [License](#license)
- [Contact](#contact)

---

## Overview
Students preparing for board exams and revision struggle because formulas are scattered across textbooks and notes. Furthermore, searchable, mobile-friendly resources that work offline are difficult to find, and standard math displays look cluttered on small screens. 

Formulize centralizes these formulas in one browsable, searchable catalog with proper CBSE/NCERT-aligned class and chapter structures. It works 100% offline, storing bookmarks locally without registering accounts or requiring login authentication.

---

## Key Features
- **Syllabus Browser**: Browse formulas organized by class (9–12), subjects (Math, Physics, Chemistry), and chapters in under 3 taps.
- **LaTeX Math Rendering**: Formulas are rendered in crisp, scalable vector format using `flutter_math_fork`.
- **Global Search**: Search instantly across titles, chapters, and keywords (`searchTags`).
- **Device-Local Bookmarks**: Save important formulas locally using `SharedPreferences` for last-minute revisions, with a clear all confirmation prompt.
- **Fundamentals Shortcuts**: Fast access to key mathematical fundamentals (Algebraic Identities, Trigonometry, Logarithms) directly from the Home screen.
- **Offline-First Architecture**: All content is shipped as local JSON assets; the app functions entirely offline.

---

## Tech Stack
- **Framework**: [Flutter](https://flutter.dev/) (Material 3 enabled)
- **Language**: [Dart](https://dart.dev/) (SDK version `^3.10.7`)
- **Math Rendering**: `flutter_math_fork` (^0.7.4) for high-fidelity LaTeX equation rendering.
- **Local Persistence**: `shared_preferences` (^2.5.4) for saving bookmark IDs locally.
- **Asset Storage**: Structured local JSON files (`assets/class9.json` to `assets/class12.json`, `assets/fundamentals.json`).
- **Icons**: `cupertino_icons` (^1.0.8).
- **Development/Build Tools**: `flutter_launcher_icons` (^0.13.1) and `rename` (^3.1.0).

---

## Screenshots (Optional)
*(Include screenshots or GIFs of the app running in portrait mode here to showcase the Home hub, Syllabus Browser, Formula Viewer, and Bookmarks screens)*

| Home Screen | Syllabus Browser | Formula Viewer | Bookmarks |
| :---: | :---: | :---: | :---: |
| *[Screenshot Placeholder]* | *[Screenshot Placeholder]* | *[Screenshot Placeholder]* | *[Screenshot Placeholder]* |

---

## Project Structure
```text
formulize/
├── lib/
│   ├── main.dart                              # App entry point, global theme, and MainScreen initializer
│   ├── data/
│   │   ├── models/
│   │   │   └── formula_model.dart             # Dart serialization model for JSON data
│   │   └── source/
│   │       └── formula_local_data_source.dart # Handles local JSON asset loading and merging
│   └── features/
│       ├── home/
│       │   ├── screens/
│       │   │   ├── main_screen.dart           # Bottom navigation shell screen
│       │   │   └── home_screen.dart           # Home hub containing search and class cards
│       │   └── widgets/
│       │       ├── class_card.dart            # Interactive class card with color gradients
│       │       └── home_search_bar.dart       # Stylized search bar widget
│       ├── chapter_list/
│       │   └── screens/
│       │       └── class_detail_screen.dart   # Interactive subject and chapter expansion list
│       ├── formula_view/
│       │   └── screens/
│       │       └── formula_view_screen.dart   # Main formula list viewer page and FormulaCard implementation
│       ├── bookmarks/
│       │   └── screens/
│       │       └── bookmarks_screen.dart      # Bookmark manager list with clear all FAB
│       └── search/
│           └── screens/
│               └── search_results_screen.dart # Screen displaying search result formulas
├── assets/
│   ├── class9.json                            # Class 9 formulas (Syllabus placeholder)
│   ├── class10.json                           # Class 10 formulas (Syllabus placeholder)
│   ├── class11.json                           # Class 11 formulas (Syllabus placeholder)
│   ├── class12.json                           # Class 12 formulas (Populated)
│   ├── fundamentals.json                      # Fundamentals formulas (Populated)
│   └── icon/                                  # App launcher icons
├── test/
│   └── widget_test.dart                       # UI testing files
├── android/                                   # Android native configuration
├── ios/                                       # iOS native configuration
├── pubspec.yaml                               # Flutter project dependencies and metadata configuration
└── analysis_options.yaml                      # Code quality rules and lint settings
```

---

## Documentation
Detailed design and architecture specifications can be found under the [docs/](docs/) folder:
* 📄 [01_PRD.md](docs/01_PRD.md) – Product Requirements Document: Vision, target audience, core features, functional & non-functional requirements, and future enhancements.
* 📄 [02_TRD.md](docs/02_TRD.md) – Technical Requirements Document: Tech stack detail, application architecture, front-end design patterns, caching, security, performance, and deployment strategy.
* 📄 [03_AppFlow.md](docs/03_AppFlow.md) – Application Flow: Screen navigation map, detailed feature workflows, data flow (especially for Bookmarks and local assets), error handling, and user journey maps.
* 📄 [04_UI_UX.md](docs/04_UI_UX.md) – UI/UX Design Specification: Brand guidelines, typography hierarchy, ad-hoc color system, screen layout specifications, and loading/empty/error states UI rules.
* 📄 [05_BackendSchema.md](docs/05_BackendSchema.md) – Backend & Data Schema: JSON model structure, logic entity relationships, local persistence schema, constraint enforcement, and api models.

---

## Getting Started

### Prerequisites
To build and run the application locally, make sure you have the following installed on your machine:
* [Flutter SDK](https://docs.flutter.dev/get-started/install) (`^3.10.7` or later)
* [Dart SDK](https://dart.dev/get-started) (compatible with environment `^3.10.7`)
* An IDE with Flutter extensions installed (e.g. [VS Code](https://code.visualstudio.com/) or [Android Studio](https://developer.android.com/studio))
* Target setups:
  * Android SDK & Emulator / connected Android Device (for Android builds)
  * macOS with Xcode & CocoaPods (only if targeting iOS builds)

### Installation
1. Clone the repository to your local machine:
   ```bash
   git clone https://github.com/harshitsinghal11/flutter-Formulize.git
   cd formulize
   ```
2. Fetch and install package dependencies:
   ```bash
   flutter pub get
   ```

### Environment Variables
Since **Formulize** is an offline-first client application with no external backend server integrations or remote API keys, **there are no environment variables or `.env` configuration files required** to run the project.

### Running Locally
To launch the app on your connected device or emulator in debug mode:
```bash
flutter run
```

---

## Available Scripts
You can use the following commands inside the project root for development and build tasks:
* **Fetch Dependencies**: `flutter pub get`
* **Run Development App**: `flutter run`
* **Lint Check**: `flutter analyze`
* **Run Tests**: `flutter test`
* **Generate Launcher Icons**: `flutter pub run flutter_launcher_icons`
* **Rename Package**: `flutter pub run rename`
* **Clean Build Cache**: `flutter clean`

---

## Deployment
To build production-ready packages for deployment to the App Stores:

### Android
Build a release Android App Bundle (AAB) to upload to Google Play Console:
```bash
flutter build appbundle
```
Or build a standalone APK:
```bash
flutter build apk
```

### iOS
Build a release iOS bundle (requires a macOS environment with Xcode certificates configured):
```bash
flutter build ipa
```

---

## Project Status
**Formulize** is currently in active development:
* **Class 12 Content**: Fully populated and navigable (approx. 247 formulas).
* **Fundamentals Content**: Fully populated and navigable (approx. 101 formulas).
* **Classes 9, 10, and 11 Content**: Structural placeholders configured. Content is currently in empty JSON files, showing a "Content coming soon" screen when accessed.

---

## Contributing
Contributions are welcome! Since the app is built on a modular, feature-first folder structure:
1. Fork the repository and create a descriptive feature branch (e.g., `feature/class10-content`).
2. Implement your changes. Ensure new formulas conform to the `FormulaModel` structure defined in [05_BackendSchema.md](docs/05_BackendSchema.md).
3. Ensure no lint errors exist by running:
   ```bash
   flutter analyze
   ```
4. Submit a Pull Request describing your implementation and validation.

---

## License
This is a **private project** (`publish_to: 'none'`). All rights are reserved. Unauthorized reproduction, modification, or distribution is prohibited unless explicitly permitted.

---

## Contact

Built by **Harshit** — B.Tech CSE, Manav Rachna University

- [GitHub](https://github.com/harshitsinghal11)
- [LinkedIn](https://linkedin.com/in/harshitsinghal11)

> _Feel free to reach out if you're building something similar or have questions about the implementation._