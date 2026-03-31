import 'package:flutter/cupertino.dart';

import '../data/models/contact.dart';
import '../theme/app_theme.dart';
import 'adaptive_layout.dart';
import 'pages/contact_detail_page.dart';
import 'pages/contacts_page.dart';
import 'pages/favorites_page.dart';
import 'pages/groups_page.dart';
import 'pages/recent_page.dart';
import 'settings.dart';

/// Master-Detail layout for large screens (tablets)
class MasterDetailLayout extends StatelessWidget {
  const MasterDetailLayout({
    super.key,
    required this.selectedSection,
    required this.selectedGroupId,
    this.selectedContact,
    required this.onSectionChanged,
    required this.onContactSelected,
    required this.onGroupSelected,
    required this.onBackToContacts,
  });

  final NavigationSection selectedSection;
  final int selectedGroupId;
  final Contact? selectedContact;
  final ValueChanged<NavigationSection> onSectionChanged;
  final ValueChanged<Contact> onContactSelected;
  final ValueChanged<int> onGroupSelected;
  final VoidCallback onBackToContacts;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('PhoneBook')),
      child: SafeArea(
        child: Row(
          children: [
            // Left panel: Navigation Sidebar
            _buildNavigationSidebar(context),

            // Divider
            Container(width: 1, color: context.dividerColor),

            // Right panel: Content Area
            Expanded(child: _buildContentArea(context)),
          ],
        ),
      ),
    );
  }

  /// Left panel: Navigation Sidebar
  Widget _buildNavigationSidebar(BuildContext context) {
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
                  const Text(
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
                      _buildNavItem(context, section),
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
  Widget _buildNavItem(BuildContext context, NavigationSection section) {
    final isSelected = selectedSection == section;

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
        onPressed: () => onSectionChanged(section),
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
              const Icon(
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
  Widget _buildContentArea(BuildContext context) {
    // If a contact is selected, show the detail view
    if (selectedContact != null) {
      return ContactDetailContent(
        contact: selectedContact!,
        onBack: onBackToContacts,
      );
    }

    // Otherwise, show content based on selected section
    switch (selectedSection) {
      case NavigationSection.allContacts:
        return ContactsContent(
          listId: selectedGroupId,
          onContactSelected: onContactSelected,
        );
      case NavigationSection.groups:
        return GroupsContent(
          onGroupSelected: (group) => onGroupSelected(group.id),
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
