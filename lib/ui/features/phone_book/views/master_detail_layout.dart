import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'package:basics/domain/models/contact.dart';
import 'package:basics/ui/core/theme/app_theme.dart';
import 'package:basics/ui/features/phone_book/view_models/contact_view_model.dart';
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
    this.onContactUpdated,
    this.onContactDeleted,
  });

  final NavigationSection selectedSection;
  final String selectedGroupId;
  final Contact? selectedContact;
  final ValueChanged<NavigationSection> onSectionChanged;
  final ValueChanged<Contact> onContactSelected;
  final ValueChanged<String> onGroupSelected;
  final VoidCallback onBackToContacts;
  final Function(Contact, Contact)? onContactUpdated;
  final Function(Contact)? onContactDeleted;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
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

  Widget _buildContentArea(BuildContext context) {
    final viewModel = context.read<ContactViewModel>();
    
    if (selectedContact != null) {
      return ContactDetailContent(
        key: ValueKey('detail_${selectedContact!.id}'),
        contact: selectedContact!,
        onBack: onBackToContacts,
        onEdit: (oldContact) async {
          final resultData = await showEditContactDialog(context, oldContact);
          if (resultData != null && context.mounted) {
            final updated = resultData['contact'] as Contact;
            final newGroupId = resultData['groupId'] as String;
            
            // 1. Perform validation and DB update FIRST
            final result = await viewModel.updateContactWithValidation(
              oldContact,
              updated,
              newGroupId: newGroupId,
            );
            
            // 2. Only if the DB update was successful, notify the UI
            if (result.success) {
              if (context.mounted) {
                onContactUpdated?.call(oldContact, updated);
                _showToast(context, 'Contact updated successfully');
              }
            } else {
              // 3. If it failed, the UI state is NOT updated, and we show the error
              if (context.mounted) {
                _showToast(context, result.errorMessage!);
              }
            }
          }
        },
        onDelete: () async {
          final confirmed = await showCupertinoDialog<bool>(
            context: context,
            builder: (context) => CupertinoAlertDialog(
              title: const Text('Delete Contact'),
              content: Text(
                'Are you sure you want to delete ${selectedContact!.fullName}?',
              ),
              actions: [
                CupertinoDialogAction(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
                CupertinoDialogAction(
                  isDestructiveAction: true,
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Delete'),
                ),
              ],
            ),
          );
          if (confirmed == true && context.mounted) {
            // Unfocus to prevent focus/keyboard issues during transition on Web
            FocusScope.of(context).unfocus();
            
            final contactToDelete = selectedContact!;
            await viewModel.deleteContact(contactToDelete);
            
            if (context.mounted) {
              // Wait for animations and DB stream to settle
              await Future.delayed(const Duration(milliseconds: 150));
              
              if (context.mounted) {
                onContactDeleted?.call(contactToDelete);
              }
            }
          }
        },
      );
    }

    // Otherwise, show content based on selected section
    final sectionKey = ValueKey('section_${selectedSection.index}_$selectedGroupId');
    
    switch (selectedSection) {
      case NavigationSection.allContacts:
        return ContactsContent(
          key: sectionKey,
          listId: selectedGroupId,
          onContactSelected: onContactSelected,
        );
      case NavigationSection.groups:
        return GroupsContent(
          key: sectionKey,
          onGroupSelected: (group) => onGroupSelected(group.id),
        );
      case NavigationSection.favorites:
        return FavoritesContent(key: sectionKey);
      case NavigationSection.recent:
        return RecentContent(key: sectionKey);
      case NavigationSection.settings:
        return SettingsContent(key: sectionKey);
    }
  }

  void _showToast(BuildContext context, String message) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        message: Text(message),
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: const Text('OK'),
        ),
      ),
    );
  }
}
