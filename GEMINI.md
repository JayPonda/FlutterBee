# 🚀 Gemini CLI Project Context: basics (Rolodex)

This project is a comprehensive Flutter learning and boilerplate application, primarily focusing on the **PhoneBook (Rolodex)** implementation. It showcases advanced UI patterns, adaptive layouts, multi-pattern navigation, and reactive local storage using Drift (SQLite/IndexedDB).

## 🛠️ Tech Stack & Architecture

- **Framework:** Flutter (Dart)
- **UI Design:** Cupertino (iOS-style) with Adaptive/Responsive support.
- **Architecture:** MVVM (Model-View-ViewModel) + Repository Pattern.
- **Local Storage:** [Drift](https://drift.simonbinder.eu/) (formerly Moor) for reactive SQLite (Native) and IndexedDB (Web) support.
- **State Management:** `ChangeNotifier` / `ValueNotifier` based ViewModels/Stores.

## 🏗️ Project Structure

- `lib/main.dart`: Entry point, currently launching `PhoneBook`.
- `lib/PhoneBook/`: Main feature area.
    - `data/`: Database definitions, models, and repositories.
        - `database/`: Drift database configuration (`database.dart`).
        - `repositories/`: Data access layer.
    - `screens/`: UI components and page layouts.
        - `app_routes.dart`: Centralized named route management.
        - `adaptive_layout.dart`: Root layout handling responsiveness.
    - `stores/`: ViewModels handling business logic and state.
    - `theme/`: App styling and theme providers.
- `lib/BookManagement/`: Wikipedia-style article management feature.
- `lib/Game/`: Interactive game implementation.

## 🚀 Building and Running

### Prerequisites
- Flutter SDK installed and configured.
- `pnpm` (as per user preference, though standard `flutter` commands are used).

### Setup
1. **Fetch dependencies:**
   ```bash
   flutter pub get
   ```

2. **Generate code (Drift/Moor):**
   *Crucial for database operations.*
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

3. **Run the application:**
   ```bash
   flutter run
   ```

4. **Run tests:**
   ```bash
   flutter test
   ```

## 📏 Development Conventions

### Navigation
- **All routes** must be defined in `lib/PhoneBook/screens/app_routes.dart`.
- Use `Navigator.pushNamed` for most navigation to maintain consistency.
- Navigation patterns are documented in `lib/PhoneBook/NAVIGATION.md`.

### Data & State
- **MVVM Flow:** `View` -> `ViewModel (Store)` -> `Repository` -> `Database (Drift)`.
- Use **Reactive Watchers** (`.watch()`) from Drift to keep the UI in sync with the database automatically via `StreamBuilder` or ViewModel listeners.
- Table definitions belong in `lib/PhoneBook/data/database/database.dart`.

### UI & Styling
- Use `LayoutBuilder` and `MediaQuery` for responsive design.
- Adhere to the `AppTheme` defined in `lib/PhoneBook/theme/app_theme.dart`.
- Prefer `Cupertino` widgets as the app follows an iOS-centric design language.

## 📖 Key Documentation
- `LEARNING_PATH_INDEX.md`: Overview of implemented Flutter tutorials.
- `SQLITE_MVVM_PLAN.md`: Detailed plan for the SQLite + MVVM integration.
- `lib/PhoneBook/NAVIGATION.md`: Comprehensive guide to navigation patterns used.
- `lib/PhoneBook/MASTER_DETAIL_GUIDE.md`: Logic for master-detail adaptive layouts.
