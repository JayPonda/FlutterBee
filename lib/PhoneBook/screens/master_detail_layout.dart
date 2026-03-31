import 'package:flutter/cupertino.dart';

import '../data/models/contact.dart';
import '../theme/app_theme.dart';
import 'pages/contact_detail_page.dart';
import 'pages/contacts_page.dart';
import 'pages/favorites_page.dart';
import 'pages/groups_page.dart';
import 'pages/recent_page.dart';
import 'settings.dart';

/// Master-Detail layout for large screens (tablets)
/// Shows navigation sidebar on the left and content on the right
/// Demonstrates responsive navigation patterns for iPad-sized screens
class MasterDetailLayout extends StatefulWidget {
  const MasterDetailLayout({super.key});

  @override
  State<MasterDetailLayout> createState() => _MasterDetailLayoutState();
}

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

class _MasterDetailLayoutState extends State<MasterDetailLayout> {
  NavigationSection _selectedSection = NavigationSection.allContacts;
  // ignore: unused_field
  int _selectedGroupId = 0;
  // ignore: unused_field
  Contact? _selectedContact;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('PhoneBook')),
      child: SafeArea(
        child: Row(
          children: [
            // Left panel: Navigation Sidebar
            _buildNavigationSidebar(),

            // Divider
            Container(width: 1, color: context.dividerColor),

            // Right panel: Content Area
            Expanded(child: _buildContentArea()),
          ],
        ),
      ),
    );
  }

  /// Left panel: Navigation Sidebar
  Widget _buildNavigationSidebar() {
    return SizedBox(
      width: 280,
      child: Container(
        color: context.primaryBackground,
        child: Column(
          children: [
            // App Logo/Header
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: context.dividerColor, width: 0.5),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemBlue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Icon(
                        CupertinoIcons.person_crop_circle_fill,
                        color: CupertinoColors.white,
                        size: 32,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Rolodex',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: context.primaryText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Contact Manager',
                    style: TextStyle(
                      fontSize: 12,
                      color: CupertinoColors.systemGrey,
                    ),
                  ),
                ],
              ),
            ),

            // Navigation Items
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Column(
                  children: [
                    for (final section in NavigationSection.values)
                      _buildNavItem(section),
                  ],
                ),
              ),
            ),

            // Footer
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: context.dividerColor, width: 0.5),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemGrey5,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(CupertinoIcons.person, size: 20),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'User Name',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: context.primaryText,
                          ),
                        ),
                        Text(
                          'Premium',
                          style: TextStyle(
                            fontSize: 10,
                            color: context.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Individual navigation item
  Widget _buildNavItem(NavigationSection section) {
    final isSelected = _selectedSection == section;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: isSelected
            ? CupertinoColors.systemBlue.withValues(alpha: 0.2)
            : context.primaryBackground,
        borderRadius: BorderRadius.circular(10),
      ),
      child: CupertinoButton(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
        onPressed: () {
          setState(() {
            _selectedSection = section;
            _selectedContact = null;
            _selectedGroupId = 0;
          });
        },
        child: Row(
          children: [
            Icon(
              section.icon,
              color: isSelected
                  ? CupertinoColors.systemBlue
                  : CupertinoColors.systemGrey,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                section.label,
                style: TextStyle(
                  color: isSelected
                      ? CupertinoColors.systemBlue
                      : context.primaryText,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  fontSize: 16,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                CupertinoIcons.checkmark,
                color: CupertinoColors.systemBlue,
                size: 16,
              ),
          ],
        ),
      ),
    );
  }

  /// Right panel: Content Area
  Widget _buildContentArea() {
    // If a contact is selected, show the detail view
    if (_selectedContact != null) {
      return ContactDetailContent(
        contact: _selectedContact!,
        onBack: () {
          setState(() {
            _selectedContact = null;
          });
        },
      );
    }

    // Otherwise, show content based on selected section
    switch (_selectedSection) {
      case NavigationSection.allContacts:
        return ContactsContent(
          listId: _selectedGroupId,
          onContactSelected: (contact) {
            setState(() {
              _selectedContact = contact;
            });
          },
        );
      case NavigationSection.groups:
        return GroupsContent(
          onGroupSelected: (group) {
            setState(() {
              _selectedSection = NavigationSection.allContacts;
              _selectedGroupId = group.id;
            });
          },
        );
      case NavigationSection.favorites:
        return const FavoritesContent();
      case NavigationSection.recent:
        return const RecentContent();
      case NavigationSection.settings:
        return const SettingsContent();
    }
  }
}
