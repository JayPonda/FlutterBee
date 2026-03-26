import 'package:flutter/cupertino.dart';

import 'contact_groups.dart';

// New
const largeScreenMinWidth = 600;

class AdaptiveLayout extends StatefulWidget {
  const AdaptiveLayout({super.key});

  @override
  State<AdaptiveLayout> createState() => _AdaptiveLayoutState();
}

class _AdaptiveLayoutState extends State<AdaptiveLayout> {
  int selectedListId = 0;

  void _onContactListSelected(int listId) {
    setState(() {
      selectedListId = listId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isLargeScreen = constraints.maxWidth > largeScreenMinWidth;

        if (isLargeScreen) {
          return const Center(
            child: Text(
              'Large screen layout',
              style: TextStyle(color: CupertinoColors.darkBackgroundGray),
            ),
          );
        }

        return const ContactGroupsPage();
      },
    ); // Temporary placeholder
  }

  // New
  Widget _buildLargeScreenLayout() {
    return const CupertinoPageScaffold(
      backgroundColor: CupertinoColors.extraLightBackgroundGray,
      child: SafeArea(
        child: Row(
          children: [
            // Contact groups list:
            Text('Sidebar'),
            // List detail view:
            Text('Details'),
          ],
        ),
      ),
    );
  }
}
