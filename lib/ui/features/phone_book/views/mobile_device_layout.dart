import 'adaptive_layout.dart';
import 'package:flutter/cupertino.dart';
import 'pages/contacts_page.dart';
import 'pages/groups_page.dart';
import 'pages/favorites_page.dart';
import 'pages/recent_page.dart';
import 'settings.dart';

/// Mobile layout with tab bar for small screens
class MobileDeviceLayout extends StatelessWidget {
  const MobileDeviceLayout({
    super.key,
    required this.selectedSection,
    required this.onSectionTap,
    required this.selectedGroupId,
  });

  final NavigationSection selectedSection;
  final ValueChanged<int> onSectionTap;
  final String selectedGroupId;

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        currentIndex: selectedSection.index,
        onTap: onSectionTap,
        items: [
          for (final section in NavigationSection.values)
            BottomNavigationBarItem(
              icon: Icon(section.icon),
              label: section.label,
            ),
        ],
      ),
      tabBuilder: (context, index) {
        final section = NavigationSection.values[index];
        return CupertinoTabView(
          builder: (context) {
            switch (section) {
              case NavigationSection.allContacts:
                return ContactsPage(listId: selectedGroupId);
              case NavigationSection.groups:
                return const GroupsPage();
              case NavigationSection.favorites:
                return const FavoritesPage();
              case NavigationSection.recent:
                return const RecentPage();
              case NavigationSection.settings:
                return const SettingsPage();
            }
          },
        );
      },
    );
  }
}
