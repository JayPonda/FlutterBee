/// This file demonstrates all navigation patterns from the Flutter Navigation Tutorial
/// See NAVIGATION.md for detailed explanations

// ============================================================================
// PATTERN 1: IMPERATIVE NAVIGATION (Push)
// ============================================================================
// File: screens/contacts.dart
// 
// Description: Navigate to a new screen and add it to the navigation stack
// When to use: Simple forward navigation, gesture handlers, callbacks
//
// Example:
void imperativeNavigationExample(BuildContext context, Contact contact) {
  Navigator.of(context).push(
    CupertinoPageRoute<void>(
      builder: (BuildContext context) => ContactDetailPage(contact: contact),
    ),
  );
}

// ============================================================================
// PATTERN 2: NAMED ROUTES
// ============================================================================
// File: screens/app_routes.dart
//
// Description: Define routes by name and use a route generator for centralized navigation
// When to use: Complex apps, easy refactoring, type-safe navigation
//
// Step 1: Define route names
class AppRoutes {
  static const String home = '/';
  static const String contactDetail = '/contact-detail';
}

// Step 2: Create route generator
Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case AppRoutes.contactDetail:
      final contact = settings.arguments as Contact;
      return CupertinoPageRoute<void>(
        builder: (_) => ContactDetailPage(contact: contact),
        settings: settings,
      );
    default:
      return CupertinoPageRoute<void>(builder: (_) => const AdaptiveLayout());
  }
}

// Step 3: Configure in main app
// CupertinoApp(
//   onGenerateRoute: generateRoute,
//   initialRoute: AppRoutes.home,
// )

// Step 4: Navigate using named route
void namedRouteNavigationExample(BuildContext context, Contact contact) {
  Navigator.pushNamed(
    context,
    AppRoutes.contactDetail,
    arguments: contact,
  );
}

// ============================================================================
// PATTERN 3: PUSH REPLACEMENT
// ============================================================================
// File: screens/navigation_example.dart
//
// Description: Replace the current route with a new route
// When to use: Login flows, account switching, one-way navigation
//
// Example:
void pushReplacementExample(BuildContext context, Contact contact) {
  Navigator.of(context).pushReplacement(
    CupertinoPageRoute<void>(
      builder: (context) => ContactDetailPage(contact: contact),
    ),
  );
  // Previous route is removed from stack, back button won't show it
}

// ============================================================================
// PATTERN 4: POP (Back Navigation)
// ============================================================================
// File: screens/navigation_example.dart
//
// Description: Return to the previous screen in the navigation stack
// When to use: Back button, cancel operations, dismissing dialogs
//
// Example:
void popNavigationExample(BuildContext context) {
  Navigator.of(context).pop();
  // Returns to previous screen
}

// Check if there's a page to go back to:
void safePop(BuildContext context) {
  if (Navigator.of(context).canPop()) {
    Navigator.of(context).pop();
  }
}

// ============================================================================
// PATTERN 5: POP UNTIL
// ============================================================================
// File: screens/navigation_example.dart
//
// Description: Pop multiple routes from the stack until a condition is met
// When to use: Reset to home, clear stack, go back to specific screen
//
// Example:
void popUntilExample(BuildContext context) {
  // Pop until we reach the home/first route
  Navigator.of(context).popUntil(
    (route) => route.isFirst,
  );
}

// Pop until a named route:
void popUntilNamedExample(BuildContext context) {
  Navigator.of(context).popUntil(
    ModalRoute.withName(AppRoutes.home),
  );
}

// ============================================================================
// PATTERN 6: PUSH WITH RESULT (Return Values)
// ============================================================================
// File: screens/navigation_example.dart
//
// Description: Navigate to a page and handle the result when returning
// When to use: Form submissions, selections, confirmations
//
// Example:
Future<void> pushWithResultExample(BuildContext context) async {
  // Navigate and wait for result
  final result = await Navigator.of(context).push<String>(
    CupertinoPageRoute<String>(
      builder: (context) => const ContactDetailPage(contact: contact),
    ),
  );

  // Handle result
  if (result != null) {
    print('Returned value: $result');
  }
}

// Return value from a page:
void returnValueExample(BuildContext context) {
  Navigator.of(context).pop('User selected this value');
}

// ============================================================================
// PATTERN 7: TAB NAVIGATION
// ============================================================================
// File: screens/adaptive_layout.dart
//
// Description: Switch between multiple screens using tabs
// When to use: Multi-section apps, quick access to different areas
//
// Example:
class TabNavigationExample extends StatefulWidget {
  const TabNavigationExample({Key? key}) : super(key: key);

  @override
  State<TabNavigationExample> createState() => _TabNavigationExampleState();
}

class _TabNavigationExampleState extends State<TabNavigationExample> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.book_fill),
            label: 'Contacts',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.list_bullet),
            label: 'Groups',
          ),
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return CupertinoTabView(builder: (context) => const ContactsPage());
          case 1:
            return CupertinoTabView(builder: (context) => const GroupsPage());
          default:
            return CupertinoTabView(builder: (context) => const ContactsPage());
        }
      },
    );
  }
}

// ============================================================================
// PATTERN 8: ADAPTIVE LAYOUT (Responsive Navigation)
// ============================================================================
// File: screens/adaptive_layout.dart
//
// Description: Different navigation patterns for different screen sizes
// When to use: Apps supporting tablets and phones
//
// Example:
Widget adaptiveLayoutExample(BuildContext context) {
  return LayoutBuilder(
    builder: (context, constraints) {
      final isLargeScreen = constraints.maxWidth > 600;

      if (isLargeScreen) {
        // Split view for tablets
        return Row(
          children: [
            SizedBox(
              width: 320,
              child: ContactGroupsPage(),
            ),
            Expanded(
              child: ContactDetailsPage(),
            ),
          ],
        );
      }

      // Full screen for phones
      return ContactListsPage();
    },
  );
}

// ============================================================================
// BEST PRACTICES
// ============================================================================
/*

1. Use Named Routes for Complex Apps
   ✓ Centralized route definitions
   ✓ Easy refactoring
   ✓ Type-safe with arguments

2. Use Imperative Navigation for Simple Cases
   ✓ Direct navigation to known pages
   ✓ Less boilerplate
   ✓ Useful in callbacks

3. Always Check canPop() Before Popping
   if (Navigator.of(context).canPop()) {
     Navigator.of(context).pop();
   }

4. Pass Data Through Route Arguments
   ✓ Avoid passing context between pages
   ✓ Makes pages reusable

5. Use Type-Safe Generic Parameters
   Navigator.of(context).push<String>(...) // Type-safe return value

6. Consider Responsive Navigation
   ✓ Different UX for phones vs tablets
   ✓ Use LayoutBuilder to detect screen size

7. Document Route Structure
   ✓ Keep AppRoutes class organized
   ✓ Make route names clear and consistent

8. Handle Navigation Errors Gracefully
   ✓ Provide default routes
   ✓ Handle missing arguments
   ✓ Show error screens for invalid navigation

*/

// ============================================================================
// REAL WORLD EXAMPLE: COMPLETE NAVIGATION SETUP
// ============================================================================
/*

// 1. Define routes (app_routes.dart)
class AppRoutes {
  static const String home = '/';
  static const String contactDetail = '/contact';
  static const String editContact = '/edit-contact';
  static const String addContact = '/add-contact';
}

// 2. Create route generator (app_routes.dart)
Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case AppRoutes.contactDetail:
      final contact = settings.arguments as Contact;
      return CupertinoPageRoute(
        builder: (_) => ContactDetailPage(contact: contact),
        settings: settings,
      );
    case AppRoutes.editContact:
      final contact = settings.arguments as Contact;
      return CupertinoPageRoute(
        builder: (_) => EditContactPage(contact: contact),
        settings: settings,
      );
    case AppRoutes.addContact:
      return CupertinoPageRoute(
        builder: (_) => const AddContactPage(),
        settings: settings,
      );
    default:
      return CupertinoPageRoute(
        builder: (_) => const HomePage(),
        settings: settings,
      );
  }
}

// 3. Configure in main app (main.dart)
CupertinoApp(
  onGenerateRoute: generateRoute,
  initialRoute: AppRoutes.home,
  title: 'PhoneBook',
)

// 4. Navigate using named routes
Navigator.pushNamed(
  context,
  AppRoutes.contactDetail,
  arguments: contact,
);

// 5. Handle return values
final result = await Navigator.pushNamed<bool>(
  context,
  AppRoutes.editContact,
  arguments: contact,
);

if (result == true) {
  // Contact was edited, refresh list
}

// 6. Responsive navigation based on screen size
Widget adaptiveNav(BuildContext context) {
  return LayoutBuilder(
    builder: (context, constraints) {
      if (constraints.maxWidth > 600) {
        return SplitViewLayout();
      }
      return FullScreenLayout();
    },
  );
}

*/
