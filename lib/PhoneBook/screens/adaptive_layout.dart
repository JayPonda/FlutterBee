import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'contact_groups.dart';
import 'contacts.dart';
import 'master_detail_layout.dart';
import 'navigation_example.dart';

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
            icon: Icon(CupertinoIcons.forward),
            label: 'Navigation',
          ),
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return CupertinoTabView(
              builder: (context) => const ContactListsPage(listId: 0),
            );
          case 1:
            return CupertinoTabView(
              builder: (context) => const ContactGroupsPage(),
            );
          case 2:
            return CupertinoTabView(
              builder: (context) => const NavigationExamplePage(),
            );
          default:
            return CupertinoTabView(
              builder: (context) => const ContactListsPage(listId: 0),
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
