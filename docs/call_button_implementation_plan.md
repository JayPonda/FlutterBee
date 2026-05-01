# Planning Document: Functional Call Button Implementation

## Goal
Add a functional "Call" button to each contact in the PhoneBook. The button should initiate a phone call using the device's native dialer when a phone number is available.

## Tasks
- [ ] **Research & Setup**
    - [ ] Add `url_launcher` to `pubspec.yaml`.
    - [ ] Run `flutter pub get`.
    - [ ] Configure `url_launcher` for Android (queries in `AndroidManifest.xml`) and iOS (`LSApplicationQueriesSchemes` in `Info.plist`).
- [ ] **Implementation - Business Logic**
    - [ ] Create a utility class or service `lib/ui/core/utils/url_helper.dart` to handle launching phone calls safely.
- [ ] **Implementation - UI**
    - [ ] **Contact List (`contacts.dart`)**
        - [ ] Add a trailing `CupertinoButton` with a phone icon to `CupertinoListTile` for contacts with phone numbers.
        - [ ] Ensure the button is small and doesn't interfere with the list item's tap gesture (which navigates to details).
    - [ ] **Contact Detail (`contact_detail.dart`)**
        - [ ] Update `_ContactInfoTile` for phone numbers to initiate a call.
        - [ ] Add a prominent call button in the contact header section for quick access.
- [ ] **Validation**
    - [ ] Verify the button appears only for contacts with phone numbers.
    - [ ] Verify the "Call" action works (simulated in tests or manually verified).
    - [ ] Add unit/widget tests for the new UI components.

## Technical Details
- **Package:** `url_launcher`
- **URI Scheme:** `tel:<phone_number>`
- **Android Configuration:**
  ```xml
  <queries>
    <intent>
      <action android:name="android.intent.action.DIAL" />
      <data android:scheme="tel" />
    </intent>
  </queries>
  ```
- **iOS Configuration:**
  ```xml
  <key>LSApplicationQueriesSchemes</key>
  <array>
    <string>tel</string>
  </array>
  ```

## Design Considerations
- **Visuals:** Use `CupertinoIcons.phone_fill` or `CupertinoIcons.phone_circle_fill`.
- **Feedback:** Show an error message (toast/dialog) if the call cannot be initiated (e.g., on a device without telephony support).
- **Consistency:** Maintain the Cupertino/iOS aesthetic of the app.
