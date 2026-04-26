# SQLite Integration & Local-First Architecture Plan

## 1. Feasibility Study: Database Watchers in Dart/Flutter
You asked if Dart has a concept similar to Android's database watchers (like Room with LiveData/Flow) where you can directly "watch" the database for changes. 

**Yes, Flutter has excellent support for this.**
While the base `sqflite` package only provides Future-based CRUD operations, the **`drift`** package (formerly `moor`) provides the exact functionality you are looking for. `Drift` is highly inspired by Android's Room database.

With `drift`, when you query the database, you can use `.watch()` instead of `.get()`. This returns a `Stream`. Any time the underlying tables change, the stream automatically emits the new data. 

**How it connects to MVVM:**
1.  **Repository** returns a `Stream<List<Contact>>`.
2.  **ViewModel** subscribes to this `Stream` and updates its state (e.g., a `ValueNotifier` or `ChangeNotifier`).
3.  **View** listens to the ViewModel (using `ValueListenableBuilder`) and rebuilds automatically.

## 2. Architecture Overview: Separating Database, API, and Business Logic

To achieve your goals of separation and handling both API and SQLite without chaos, we will use a **Local-First (Offline-First) Architecture with a Repository Proxy**.

### The Flow
1.  **The View (UI)** only talks to the **ViewModel**.
2.  **The ViewModel** only talks to the **Repository Interface** (`IContactRepository`).
3.  The **Proxy Repository** (`ContactRepositoryImpl`) implements the interface and coordinates between the **Local Database (`drift`)** and the **Remote API**.

### The Proxy Pattern Strategy (Local-First)
-   **Reads (Watching):** The UI *always* watches the local SQLite database. The Repository returns the `Stream` from the database.
-   **Fetching (Syncing):** The ViewModel asks the Repository to `refresh()`. The Repository fetches data from the API and saves it into the SQLite database. *Because the UI is already watching the database stream, it will automatically update as soon as the database is updated.* The API data is never sent directly to the UI.
-   **Writes (Mutations):** When the user adds a contact, the ViewModel calls the Repository. The Repository:
    1.  Saves to SQLite immediately (Optimistic Update - the UI updates instantly via the watcher).
    2.  Attempts to send the change to the API.
    3.  If the API call fails, it marks the record as "pending sync" in the local database to retry later.

### Handling Pagination, Infinite Scrolling & Pre-fetching
The local-first architecture handles large datasets and seamless experiences very elegantly:

1.  **Pagination / Infinite Scrolling:**
    *   **The Database Query:** Instead of watching *all* contacts, the Repository exposes a method like `watchContacts({int limit, int offset})`. As the user scrolls, the ViewModel updates the limit/offset, and Drift emits a new `Stream` of just the required partial data.
    *   **The API Sync:** The UI does *not* trigger the API call directly. Instead, when the user scrolls near the bottom, the ViewModel tells the Repository to `fetchNextPageFromApi()`. The Repository fetches the next chunk from the remote server and saves it into SQLite. The active Drift stream automatically sees the new rows and updates the UI.
2.  **Pre-fetching for Seamless Experience:**
    *   Because the UI is completely decoupled from the network, a background service or the Repository can pre-fetch data from the API (e.g., fetching the next page before the user even reaches the bottom, or fetching detail data while viewing the list).
    *   This pre-fetched data is quietly saved into the SQLite database. When the user eventually needs it, the local database query returns instantly.

### Tracking and Syncing Offline Changes
To ensure data isn't lost when offline and to sync correctly when the connection returns, we use a "Sync State" column in the SQLite tables.

1.  **The `sync_status` Column:** Every table synced with the API (like `Contacts`) gets a column to track its state. Common states are:
    *   `SYNCED` (0): The local data matches the remote server.
    *   `PENDING_CREATE` (1): Created locally while offline. Needs to be POSTed to the API.
    *   `PENDING_UPDATE` (2): Modified locally while offline. Needs to be PUT/PATCHed to the API.
    *   `PENDING_DELETE` (3): Deleted locally while offline. The UI hides it, but it stays in SQLite until the API confirms the DELETE.
2.  **The Write Flow (Offline):** When a user edits a contact while offline:
    *   The Repository updates the SQLite row and sets `sync_status = PENDING_UPDATE`.
    *   The UI updates instantly because it's watching the database.
    *   The API call fails (no connection), but the data is safely stored locally.
3.  **The Sync Process (Coming Back Online):**
    *   When the app detects a network connection (using a package like `connectivity_plus`), or on application startup, a background sync process is triggered.
    *   The Repository queries SQLite for all rows where `sync_status != SYNCED`.
    *   It loops through these pending changes and executes the appropriate API calls.
    *   Upon a successful API response, the Repository updates the row in SQLite, setting `sync_status = SYNCED`.

### Conflict Resolution Strategy (Handling Clashes)
When operating offline or with high latency, conflicts are inevitable. 

**Scenario A: The Update-Delete Clash**
(User edits locally offline, but the record was deleted on the server).
*   **Resolution (Server Wins):** The background sync attempts a `PUT` and gets a `404 Not Found`. The local repository accepts the remote truth, deletes the pending row from SQLite, and the UI instantly updates to remove the contact.

**Scenario B: The Concurrent Update Clash (Update-Update)**
(User edits locally offline, but someone else—or the user on another device—edited the *same* record on the server at the exact same time).
If the local app blindly sends a `PUT` request with its offline data, it will overwrite and destroy the changes made on the server.

To prevent this data loss, we must implement **Optimistic Concurrency Control**:
1.  **Versioning / ETags:** Every record in the database needs a `version` integer or an `updated_at` timestamp. When the local app fetches a contact, it saves this version locally.
2.  **The Fenced API Call:** When the app comes back online and tries to sync its offline edit, it sends the *original* version number it had alongside the new data (e.g., `PUT /contacts/123 { name: 'New Name', version: 1 }`).
3.  **Detecting the Collision:** The server sees the request has `version: 1`, but the server's database is already on `version: 2` (because of the concurrent remote edit). The server rejects the sync with a `409 Conflict` or `412 Precondition Failed` error.
4.  **Client-Side Resolution Strategies:** When the Repository catches this `409 Conflict`, it must decide how to fix it:
    *   **Server Wins (Safest):** The Repository drops the local offline edit, fetches the latest `version: 2` from the server, and saves it to SQLite. The UI updates to show the remote changes.
    *   **Prompt the User (Best UX, Hardest to build):** The Repository marks the row with a `sync_error = 'conflict'` flag. The UI shows a "Conflict Detected" banner. If the user clicks it, a dialog shows the Local Version vs. the Server Version and asks the user to manually pick which one to keep.
    *   **Granular Merge (Backend):** The server handles the conflict by merging the fields (e.g., keeping the local phone number change and the remote email change) and returning the merged `version: 3`.

For our initial scope, we will rely on **Server Wins** for concurrent updates to prevent data corruption, with the architecture built to support manual user resolution in the future.

### Advanced Edge Cases & Production Considerations
To make this architecture truly production-ready, we must handle these specific scenarios:

1.  **The ID Collision Problem (Client vs Server IDs):** 
    If SQLite generates an auto-incrementing integer ID (e.g., `id: 5`) while offline, and the server concurrently generates `id: 5` for a different record, we get a massive collision during sync.
    *   **The Fix (Client-Generated UUIDs):** We completely abandon integer auto-incrementing IDs. Instead, the local app generates a **UUIDv4** (a globally unique string) the moment a user creates a contact offline. When the app syncs (`POST /contacts { id: 'uuid-1234...' }`), the server accepts the client's UUID as the primary key. This completely eliminates ID collisions and the need to map temporary local IDs to permanent server IDs.

2.  **Version Branching & 3-Way Merging:**
    You asked how the system knows *from which point* the versions diverged to perform a merge. If local has version 2, and remote has version 2 (from a different change), how do we reconcile?
    *   **The Fix (Base State Tracking):** To perform a true merge, the client cannot just store the "current" state. It must store the **Last Known Server State** (the "Base") alongside the **Pending Local State**.
    *   When the client syncs, it sends: `PUT /contacts { base_version: 1, updates: { phone: 'new-phone' } }`.
    *   The server looks at its current state (say, `version: 2` where email changed). Because the server knows the client's `base_version` was 1, it can perform a **3-Way Merge**: It compares Base (v1) -> Client (v1+phone) -> Server (v2+email). The server safely merges them into `version: 3` (has both phone and email updates) and returns it to the client. If both changed the *same* field (e.g., both changed the phone number), the server rejects it and forces the client to resolve the conflict manually.

3.  **Stale Data & Cache Invalidation:** If the app is open and online, how do we know if *another* device changed the data? We cannot rely only on scrolling to trigger fetches. We must implement a "Pull-to-Refresh" that forces the Repository to fetch the latest from the API and overwrite SQLite, OR implement background polling/WebSockets to invalidate the cache.

4.  **Perpetual Sync Failures & UI Feedback:** If an offline edit is synced but rejected by the server (e.g., a validation error like "Phone number already in use"), it will be stuck in `PENDING_UPDATE` forever. The UI (watching the database) currently assumes the optimistic update was successful. We need a `sync_error` column in SQLite so the UI can show a visual indicator (like a red warning icon) on that specific contact, allowing the user to fix or discard the local change.

5.  **The "Cold Start" Empty State Problem:** On a fresh install, the local database is empty. The watcher instantly returns an empty list, and the UI might show "No Contacts Found" before the API has a chance to return data. We need to expose an `isSyncing` boolean stream from the Repository alongside the data stream so the UI knows to show a loading spinner during the initial hydration of the database.

6.  **Database Migrations:** As the app grows, models will change (e.g., adding an `avatar_url` field). We must establish a clear Drift migration strategy from Day 1 to prevent app crashes when users update the app to a new version with a modified schema.

## 3. Scope of Implementation

*   **Database:** Integrate `drift` and `sqlite3_flutter_libs` to manage local storage.
*   **Models:** Create Drift table definitions (`ContactsTable`, `GroupsTable`) and map them to the existing domain models (`Contact`, `ContactGroup`).
*   **Repository Pattern:**
    *   Create an `IContactRepository` interface.
    *   Create a `LocalContactDataSource` (Drift operations).
    *   Create a `RemoteContactDataSource` (Mock API operations for now).
    *   Create a `ProxyContactRepository` that implements the syncing logic.
*   **ViewModel Refactoring:** Modify `ContactGroupsModel` to consume the `IContactRepository` stream instead of holding in-memory lists.
*   **Dependency Injection:** Set up a simple DI mechanism (or just pass instances) so the UI doesn't know about the database directly.

## 4. Acceptance Criteria

*   [ ] The application can create, read, update, and delete contacts, and changes persist across app restarts (verified via SQLite).
*   [ ] The UI automatically updates when a database change occurs without manual state management re-fetching (verified via Drift streams).
*   [ ] A "Simulate API Fetch" button fetches dummy data from a mock service, saves it to SQLite, and the UI updates automatically.
*   [ ] The `ContactGroupsModel` (ViewModel) has no direct dependency on `drift` or SQL commands; it only knows about `IContactRepository`.

## 5. Implementation Steps

**Step 1: Dependencies**
Add `drift`, `sqlite3_flutter_libs`, `path_provider`, and `path` to `dependencies`. Add `drift_dev` and `build_runner` to `dev_dependencies`.

**Step 2: Database Setup (Drift)**
*   Define the `Contacts` and `Groups` tables in Dart.
*   Generate the database code using `build_runner`.
*   Implement the Drift database class with `watchAllContacts()` and CRUD operations.

**Step 3: Repositories & Proxy**
*   Create `IContactRepository`.
*   Create the proxy implementation that manages the flow between local and remote sources.

**Step 4: Refactor ViewModel**
*   Update `ContactGroupsModel` to accept `IContactRepository`.
*   Subscribe to the repository's `Stream` in the constructor and update the `ValueNotifier` when new data arrives.

**Step 5: UI Integration**
*   Provide the updated `ContactGroupsModel` to the application.
*   Ensure the existing `ValueListenableBuilder` in `contacts.dart` functions seamlessly with the new reactive backend.