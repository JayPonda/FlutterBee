# Master-Detail Layout for Large Screens

## 📱 Overview

The `MasterDetailLayout` widget implements a professional master-detail (split-view) pattern for large screens like tablets. This is a best-practice UI pattern for displaying hierarchical data across different screen sizes.

---

## 🏗️ Architecture

### Components

**Master Panel (Left - 320dp)**
- Contact groups list
- Shows group icons and contact count
- Selection highlighting
- Scrollable with large title

**Detail Panel (Right - Expandable)**
- Shows either:
  - Contact list for selected group
  - Contact details for selected contact
- Back button to return to list
- Full contact information display

**Divider**
- Subtle separator between panels
- Visual hierarchy

---

## 🎯 Features

### Master Panel
- ✅ Contact groups list with icons
- ✅ Group count display
- ✅ Selection state highlighting
- ✅ iOS-style navigation bar
- ✅ Inset grouped layout

### Detail Panel (List View)
- ✅ Alphabetized contact list
- ✅ Large title navigation bar
- ✅ Add contact button
- ✅ Scrollable content
- ✅ Tap to view details

### Detail Panel (Detail View)
- ✅ Full contact card
- ✅ Contact initials in circle
- ✅ Phone and email information
- ✅ Edit/Delete action buttons
- ✅ Back button to list
- ✅ Responsive scroll content

---

## 💾 State Management

The widget uses local state to track:

```dart
int _selectedGroupId = 0;        // Currently selected group
Contact? _selectedContact;        // Currently selected contact (null = show list)
```

**State Transitions:**
```
[Master Panel Selected] 
        ↓
   [Detail: List View]
        ↓
[Contact Tapped]
        ↓
   [Detail: Detail View]
        ↓
[Back Button Tapped]
        ↓
   [Detail: List View]
```

---

## 🔄 Navigation Flow

### Scenario 1: Group Selection
```
User taps group in Master Panel
↓
setState() updates _selectedGroupId
↓
_selectedContact is reset to null
↓
Detail panel shows contact list for that group
```

### Scenario 2: Contact Selection
```
User taps contact in Detail List
↓
setState() updates _selectedContact
↓
Detail panel switches to Contact Detail View
↓
Shows full contact information
```

### Scenario 3: Back to List
```
User taps Back button in Detail View
↓
setState() sets _selectedContact to null
↓
Detail panel shows Contact List again
```

---

## 📦 Key Methods

### `_buildMasterPanel()`
Creates the left panel with contact groups.

```dart
Widget _buildMasterPanel() {
  // Shows groups in a scrollable list
  // Uses ValueListenableBuilder for reactive updates
  // Each group is tappable to select
}
```

### `_buildDetailPanel()`
Switches between contact list and detail views.

```dart
Widget _buildDetailPanel() {
  if (_selectedContact == null) {
    return _buildContactList(selectedGroup);
  } else {
    return _buildContactDetailView(_selectedContact!);
  }
}
```

### `_buildContactList()`
Displays alphabetized contacts for selected group.

```dart
Widget _buildContactList(ContactGroup group) {
  // Shows contacts organized by first letter
  // Each contact is tappable
  // Has add button in navigation bar
}
```

### `_buildContactDetailView()`
Displays full contact information inline.

```dart
Widget _buildContactDetailView(Contact contact) {
  // Shows contact avatar, info, and actions
  // Back button integrated in navigation bar
  // Edit and Delete buttons available
}
```

---

## 🎨 Visual Layout

```
┌─────────────────────────────────────────────────┐
│ Navigation Bar: PhoneBook                        │
├──────────────┬────────────────────────────────────┤
│              │                                    │
│ Master Panel │ Detail Panel (List or Detail)     │
│ (320dp)      │ (Flexible width)                  │
│              │                                    │
│ • Groups     │ • Contact List                     │
│ • Selection  │   - Alphabetized                  │
│ • Highlight  │   - Tappable                      │
│              │                                    │
│              │ OR                                 │
│              │                                    │
│              │ • Contact Detail                   │
│              │   - Avatar                         │
│              │   - Information                    │
│              │   - Actions                        │
│              │                                    │
└──────────────┴────────────────────────────────────┘
```

---

## 🛠️ Customization

### Change Master Panel Width
```dart
SizedBox(
  width: 350,  // Change from 320
  child: _buildMasterPanel(),
)
```

### Customize Group Selection Color
```dart
color: isSelected
    ? CupertinoColors.systemGreen  // Change color
    : CupertinoColors.systemBackground,
```

### Add More Details to Contact
```dart
_buildInfoTile(
  icon: CupertinoIcons.location_fill,
  label: 'Address',
  value: contact.address ?? 'N/A',
),
```

---

## 📊 Responsive Behavior

**Small Screens (<600dp)**
- Tabbed interface in `adaptive_layout.dart`
- Full-screen contact list
- Full-screen contact detail
- Back button for navigation

**Large Screens (≥600dp)**
- Master-detail layout
- Persistent group sidebar
- Inline contact selection
- No full-screen transitions

---

## 🎓 Best Practices

1. **Separation of Concerns**
   - Each method builds a specific part
   - Easy to maintain and test

2. **State Management**
   - Local state for UI state only
   - ValueNotifier for reactive data updates
   - Clear state transitions

3. **User Experience**
   - Visual feedback on selection
   - No jarring transitions
   - Persistent context (groups visible)
   - Inline details without full navigation

4. **Responsive Design**
   - Different layouts for different screen sizes
   - Proper widget composition
   - Flex and Expanded for responsive sizing

5. **Accessibility**
   - Clear visual hierarchy
   - Readable font sizes
   - Good color contrast
   - Semantic widget structure

---

## 🔗 Integration

This widget is used in `adaptive_layout.dart`:

```dart
Widget _buildLargeScreenLayout() {
  return const MasterDetailLayout();
}
```

Called when screen width > 600dp:

```dart
final isLargeScreen = constraints.maxWidth > largeScreenMinWidth;

if (isLargeScreen) {
  return _buildLargeScreenLayout();  // Uses MasterDetailLayout
}
```

---

## 📚 Similar Patterns

This implements the master-detail pattern seen in:
- Apple Mail (iPad)
- Contacts app (iPad)
- Settings app (iPad)
- Files app (iPad)

---

## 🚀 Future Enhancements

1. **Drag to Resize**
   ```dart
   // Allow user to resize master/detail panes
   ResizablePane(
     minWidth: 250,
     initialWidth: 320,
     child: _buildMasterPanel(),
   )
   ```

2. **Animations**
   ```dart
   // Smooth transitions when switching views
   AnimatedSwitcher(
     duration: Duration(milliseconds: 300),
     child: _selectedContact == null
         ? _buildContactList()
         : _buildContactDetailView(),
   )
   ```

3. **Context Menu**
   ```dart
   // Long-press for edit/delete on master panel
   CupertinoContextMenu(
     actions: [...],
     child: CupertinoListTile(...),
   )
   ```

4. **Search in Master**
   ```dart
   // Filter groups in master panel
   CupertinoSearchTextField(
     onChanged: (value) {
       filterGroups(value);
     },
   )
   ```

5. **Persistent Selection**
   ```dart
   // Save/restore selected items on app resume
   if (savedGroupId != null) {
     _selectedGroupId = savedGroupId;
     _selectedContact = savedContact;
   }
   ```

---

## ✅ Testing Checklist

- [ ] Tap group in master → detail list updates
- [ ] Tap contact in detail → switches to detail view
- [ ] Tap back button → returns to list
- [ ] Group highlighting works correctly
- [ ] Scroll in master panel works
- [ ] Scroll in detail panel works
- [ ] All contact info displays correctly
- [ ] Edit/Delete buttons are responsive
- [ ] Layout responsive at different widths
- [ ] Navigation bar titles update correctly

---

## 📝 Code Quality

- ✅ No compilation errors
- ✅ Type-safe navigation
- ✅ Proper state management
- ✅ Clear method organization
- ✅ Readable code structure
- ✅ Follows Flutter conventions

