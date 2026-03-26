import 'package:flutter/cupertino.dart';

import '../data/contact_groups_model.dart';
import '../data/models/contact.dart';
import '../data/models/contact_group.dart';
import '../main.dart';
import '../theme/app_theme.dart';
import '../theme/theme_provider.dart';

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
            ? CupertinoColors.systemBlue.withOpacity(0.15)
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
      return _buildContactDetailView(_selectedContact!);
    }

    // Otherwise, show content based on selected section
    switch (_selectedSection) {
      case NavigationSection.allContacts:
        return _buildAllContactsContent();
      case NavigationSection.groups:
        return _buildGroupsContent();
      case NavigationSection.favorites:
        return _buildFavoritesContent();
      case NavigationSection.recent:
        return _buildRecentContent();
      case NavigationSection.settings:
        return _buildSettingsContent();
    }
  }

  /// All Contacts content
  Widget _buildAllContactsContent() {
    return Container(
      color: context.primaryBackground,
      child: ValueListenableBuilder<List<ContactGroup>>(
        valueListenable: contactGroupsModel.listsNotifier,
        builder: (context, groups, _) {
          final allGroup = groups.first;
          final alphabetized = allGroup.alphabetizedContacts;

          return CustomScrollView(
            slivers: [
              CupertinoSliverNavigationBar(
                largeTitle: Text(allGroup.title),
                trailing: CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: const Icon(CupertinoIcons.add),
                  onPressed: () {
                    debugPrint('Add contact');
                  },
                ),
              ),
              SliverList.list(
                children: [
                  const SizedBox(height: 12),
                  for (final initial in alphabetized.keys) ...[
                    _buildAlphabetSection(
                      initial: initial,
                      contacts: alphabetized[initial]!,
                    ),
                  ],
                  const SizedBox(height: 24),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  /// Groups content
  Widget _buildGroupsContent() {
    return Container(
      color: context.primaryBackground,
      child: ValueListenableBuilder<List<ContactGroup>>(
        valueListenable: contactGroupsModel.listsNotifier,
        builder: (context, groups, _) {
          return CustomScrollView(
            slivers: [
              const CupertinoSliverNavigationBar(largeTitle: Text('Groups')),
              SliverFillRemaining(
                child: CupertinoListSection.insetGrouped(
                  header: const Text('Contact Groups'),
                  children: [
                    for (final group in groups)
                      CupertinoListTile(
                        leading: Icon(
                          group.id == 0
                              ? CupertinoIcons.group
                              : CupertinoIcons.person_2,
                          weight: 900,
                          size: 32,
                        ),
                        title: Text(group.label),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              group.contacts.length.toString(),
                              style: const TextStyle(
                                color: CupertinoColors.systemGrey,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(CupertinoIcons.chevron_right),
                          ],
                        ),
                        onTap: () {
                          setState(() {
                            _selectedGroupId = group.id;
                            _selectedSection = NavigationSection.allContacts;
                          });
                        },
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Favorites content
  Widget _buildFavoritesContent() {
    return Container(
      color: context.primaryBackground,
      child: CustomScrollView(
        slivers: [
          const CupertinoSliverNavigationBar(largeTitle: Text('Favorites')),
          SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    CupertinoIcons.star,
                    size: 60,
                    color: CupertinoColors.systemGrey3,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No Favorites Yet',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: CupertinoColors.systemGrey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add contacts to favorites',
                    style: TextStyle(
                      fontSize: 14,
                      color: CupertinoColors.systemGrey2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Recent content
  Widget _buildRecentContent() {
    return Container(
      color: context.primaryBackground,
      child: CustomScrollView(
        slivers: [
          const CupertinoSliverNavigationBar(largeTitle: Text('Recent')),
          SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    CupertinoIcons.clock,
                    size: 60,
                    color: CupertinoColors.systemGrey3,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No Recent Calls',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: CupertinoColors.systemGrey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Recent calls will appear here',
                    style: TextStyle(
                      fontSize: 14,
                      color: CupertinoColors.systemGrey2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Settings content
  Widget _buildSettingsContent() {
    return Container(
      color: context.primaryBackground,
      child: CustomScrollView(
        slivers: [
          const CupertinoSliverNavigationBar(largeTitle: Text('Settings')),
          SliverFillRemaining(
            child: CupertinoListSection.insetGrouped(
              header: const Text('App Settings'),
              children: [
                CupertinoListTile(
                  title: const Text('Notifications'),
                  trailing: CupertinoSwitch(value: true, onChanged: (value) {}),
                ),
                CupertinoListTile(
                  title: const Text('Sort Order'),
                  trailing: const Text('Last Name'),
                ),
                _buildThemeSelector(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Theme selector tile with dropdown-like functionality
  Widget _buildThemeSelector() {
    final themeProvider = RolodexApp.of(context);
    final currentMode = themeProvider.themeMode;

    return CupertinoListTile(
      title: const Text('Theme'),
      trailing: GestureDetector(
        onTap: () => _showThemeOptions(context, themeProvider),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              currentMode.label,
              style: TextStyle(color: context.secondaryText, fontSize: 16),
            ),
            const SizedBox(width: 8),
            Icon(
              CupertinoIcons.chevron_right,
              color: context.secondaryText,
              size: 18,
            ),
          ],
        ),
      ),
      onTap: () => _showThemeOptions(context, themeProvider),
    );
  }

  /// Show theme selection options
  void _showThemeOptions(BuildContext context, ThemeProvider themeProvider) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Select Theme'),
        actions: <CupertinoActionSheetAction>[
          for (final mode in ThemeMode.values)
            CupertinoActionSheetAction(
              isDefaultAction: themeProvider.themeMode == mode,
              onPressed: () {
                themeProvider.setThemeMode(mode);
                Navigator.pop(context);
              },
              child: Text(mode.label),
            ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDestructiveAction: true,
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ),
    );
  }

  /// Contact detail view for inline display on large screens
  Widget _buildContactDetailView(Contact contact) {
    return Container(
      color: context.primaryBackground,
      child: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: Text(contact.fullName),
            previousPageTitle: 'Back',
            trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                setState(() {
                  _selectedContact = null;
                });
              },
              child: const Text('Done'),
            ),
          ),
          SliverFillRemaining(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Contact header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: context.secondaryBackground,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: context.dividerColor),
                    ),
                    child: Column(
                      children: [
                        // Initials circle
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: CupertinoColors.systemBlue,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${contact.firstName[0]}${contact.lastName[0]}',
                              style: const TextStyle(
                                color: CupertinoColors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          contact.fullName,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: context.primaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Contact information section
                  Text(
                    'CONTACT INFORMATION',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: context.secondaryText,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Phone number
                  if (contact.phoneNumber != null) ...[
                    _buildInfoTile(
                      icon: CupertinoIcons.phone_fill,
                      label: 'Phone',
                      value: contact.phoneNumber!,
                    ),
                    const SizedBox(height: 12),
                  ],
                  // Email
                  if (contact.email != null) ...[
                    _buildInfoTile(
                      icon: CupertinoIcons.mail_solid,
                      label: 'Email',
                      value: contact.email!,
                    ),
                    const SizedBox(height: 12),
                  ],
                  const SizedBox(height: 24),
                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: CupertinoButton(
                          color: CupertinoColors.systemBlue,
                          onPressed: () {
                            debugPrint('Edit ${contact.fullName}');
                          },
                          child: const Text('Edit'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: CupertinoButton(
                          color: CupertinoColors.systemRed,
                          onPressed: () {
                            debugPrint('Delete ${contact.fullName}');
                          },
                          child: const Text('Delete'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Reusable info tile widget
  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: context.tertiaryBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.dividerColor),
      ),
      child: Row(
        children: [
          Icon(icon, color: CupertinoColors.systemBlue, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: context.secondaryText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: context.primaryText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Alphabetic section for contacts
  Widget _buildAlphabetSection({
    required String initial,
    required List<Contact> contacts,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              initial,
              style: TextStyle(
                color: context.secondaryText,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          CupertinoListSection(
            backgroundColor: context.primaryBackground,
            dividerMargin: 0,
            topMargin: 4,
            children: [
              for (final contact in contacts)
                CupertinoListTile(
                  title: Text(contact.fullName),
                  trailing: const Icon(CupertinoIcons.chevron_right),
                  onTap: () {
                    setState(() {
                      _selectedContact = contact;
                    });
                  },
                ),
            ],
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
