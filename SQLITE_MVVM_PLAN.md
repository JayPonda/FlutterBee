# SQLite + MVVM Integration Plan (Cross-Platform)

## 1. Goal
Implement a robust, reactive local storage solution using SQLite (Native) and IndexedDB (Web) via the MVVM pattern. This serves as a production-grade boilerplate for local data management.

## 2. Architecture: MVVM + Repository
- **View (UI):** Existing contact screens. They only listen to the ViewModel.
- **ViewModel:** `ContactGroupsModel`. It subscribes to a `Stream` from the Repository.
- **Repository:** `ContactRepository`. Handles Drift operations.
- **Model (Drift):** Type-safe table definitions and generated data classes.

## 3. Key Components

### Reactive Database Watchers
We use `drift`'s `.watch()` feature combined with `drift_flutter` for seamless cross-platform support.
- The Repository returns a `Stream<List<Contact>>`.
- Web support is automatically handled using **IndexedDB**.
- Native support uses **SQLite**.

### Database Migrations
We implement a version-based migration strategy in the `AppDatabase` class.

## 4. Implementation Steps
- [x] Step 1: Add `drift_flutter` for cross-platform support.
- [x] Step 2: Refactor ViewModel to use Repository.
- [x] Step 3: Implement `DriftContactRepository`.
- [x] Step 4: Configure `AppDatabase` with `driftDatabase` for Web/Native compatibility.
- [x] Step 5: Initialize in `AppLoader`.

## 5. Acceptance Criteria
- [x] Contacts persist after closing and reopening the app (Native & Web).
- [x] Adding/Deleting a contact updates the UI instantly via Streams.
- [x] Web support uses IndexedDB automatically.
- [x] Code is separated: UI doesn't know about storage; ViewModel doesn't know about storage.

