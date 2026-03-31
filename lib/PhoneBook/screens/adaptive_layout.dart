import 'package:flutter/cupertino.dart';

import '../data/models/contact.dart';
import 'master_detail_layout.dart';
import 'mobile_device_layout.dart';

// Constants for layout thresholds
const largeScreenMinWidth = 600.0;

/// Shared navigation sections used across all layouts
enum NavigationSection {
  allContacts('All Contacts', CupertinoIcons.person_fill),
  groups('Groups', CupertinoIcons.group),
  favorites('Favorites', CupertinoIcons.star_fill),
  recent('Recent', CupertinoIcons.clock),
  settings('Settings', CupertinoIcons.settings);

  final String label;
  final IconData icon;

  const NavigationSection(this.label, this.icon);
}

/// The main entry point that switches between mobile and master-detail layouts
class AdaptiveLayout extends StatefulWidget {
  const AdaptiveLayout({super.key});

  @override
  State<AdaptiveLayout> createState() => _AdaptiveLayoutState();
}

class _AdaptiveLayoutState extends State<AdaptiveLayout> {
  NavigationSection _selectedSection = NavigationSection.allContacts;
  int _selectedGroupId = 0;
  Contact? _selectedContact;

  void _handleSectionChanged(NavigationSection section) {
    setState(() {
      _selectedSection = section;
      _selectedContact = null;
      _selectedGroupId = 0;
    });
  }

  void _handleContactSelected(Contact contact) {
    setState(() {
      _selectedContact = contact;
    });
  }

  void _handleGroupSelected(int groupId) {
    setState(() {
      _selectedSection = NavigationSection.allContacts;
      _selectedGroupId = groupId;
      _selectedContact = null;
    });
  }

  void _handleBackToContacts() {
    setState(() {
      _selectedContact = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > largeScreenMinWidth) {
          return MasterDetailLayout(
            selectedSection: _selectedSection,
            selectedGroupId: _selectedGroupId,
            selectedContact: _selectedContact,
            onSectionChanged: _handleSectionChanged,
            onContactSelected: _handleContactSelected,
            onGroupSelected: _handleGroupSelected,
            onBackToContacts: _handleBackToContacts,
          );
        }

        return MobileDeviceLayout(
          selectedSection: _selectedSection,
          selectedGroupId: _selectedGroupId,
          onSectionTap: (index) {
            _handleSectionChanged(NavigationSection.values[index]);
          },
        );
      },
    );
  }
}
