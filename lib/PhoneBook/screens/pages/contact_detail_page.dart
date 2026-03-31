import 'package:flutter/cupertino.dart';

import '../../data/models/contact.dart';
import '../../theme/app_theme.dart';

/// Reusable Contact Detail page for small screen layouts
class ContactDetailPage extends StatelessWidget {
  const ContactDetailPage({super.key, required this.contact, this.onBack});

  final Contact contact;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(contact.fullName),
        previousPageTitle: 'Back',
      ),
      child: _ContactDetailContent(contact: contact),
    );
  }
}

/// Reusable Contact Detail content for master-detail layout
class ContactDetailContent extends StatelessWidget {
  const ContactDetailContent({
    super.key,
    required this.contact,
    this.onBack,
    this.onEdit,
    this.onDelete,
  });

  final Contact contact;
  final VoidCallback? onBack;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.primaryBackground,
      child: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: Text(contact.fullName),
            previousPageTitle: 'Back',
            trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: onBack ?? () {},
              child: const Text('Done'),
            ),
          ),
          SliverFillRemaining(
            child: _ContactDetailContent(
              contact: contact,
              onEdit: onEdit,
              onDelete: onDelete,
            ),
          ),
        ],
      ),
    );
  }
}

/// Shared contact detail content widget
class _ContactDetailContent extends StatelessWidget {
  const _ContactDetailContent({
    required this.contact,
    this.onEdit,
    this.onDelete,
  });

  final Contact contact;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
              context,
              icon: CupertinoIcons.phone_fill,
              label: 'Phone',
              value: contact.phoneNumber!,
            ),
            const SizedBox(height: 12),
          ],
          // Email
          if (contact.email != null) ...[
            _buildInfoTile(
              context,
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
                  onPressed:
                      onEdit ?? () => debugPrint('Edit ${contact.fullName}'),
                  child: const Text('Edit'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: CupertinoButton(
                  color: CupertinoColors.systemRed,
                  onPressed:
                      onDelete ??
                      () => debugPrint('Delete ${contact.fullName}'),
                  child: const Text('Delete'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Reusable info tile widget
  Widget _buildInfoTile(
    BuildContext context, {
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
}
