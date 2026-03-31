import 'package:flutter/cupertino.dart';

import 'master_detail_layout.dart';
import 'pages/contacts_page.dart';
import 'pages/favorites_page.dart';
import 'pages/groups_page.dart';
import 'pages/recent_page.dart';
import 'settings.dart';

// New
const largeScreenMinWidth = 600;

class AdaptiveLayout extends StatefulWidget {
  const AdaptiveLayout({super.key});

  @override
  State<AdaptiveLayout> createState() => _AdaptiveLayoutState();
}

class _AdaptiveLayoutState extends State<AdaptiveLayout> {
  int selectedListId = 0;
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isLargeScreen = constraints.maxWidth > largeScreenMinWidth;

        if (isLargeScreen) {
          return _buildLargeScreenLayout();
        }

        return _buildSmallScreenLayout();
      },
    );
  }

  Widget _buildSmallScreenLayout() {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        currentIndex: _selectedTabIndex,
        onTap: (int index) {
          setState(() {
            _selectedTabIndex = index;
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
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.star_fill),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.clock),
            label: 'Recent',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.settings),
            label: 'Settings',
          ),
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return CupertinoTabView(
              builder: (context) => const ContactsPage(listId: 0),
            );
          case 1:
            return CupertinoTabView(builder: (context) => const GroupsPage());
          case 2:
            return CupertinoTabView(
              builder: (context) => const FavoritesPage(),
            );
          case 3:
            return CupertinoTabView(builder: (context) => const RecentPage());
          case 4:
            return CupertinoTabView(builder: (context) => const SettingsPage());
          default:
            return CupertinoTabView(
              builder: (context) => const ContactsPage(listId: 0),
            );
        }
      },
    );
  }

  // New
  Widget _buildLargeScreenLayout() {
    return const MasterDetailLayout();
  }
}
