import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../data/models/contact.dart';

/// Detail page for a single contact
/// Demonstrates route navigation with parameters
class ContactDetailPage extends StatelessWidget {
  const ContactDetailPage({super.key, required this.contact});

  final Contact contact;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(contact.fullName),
        previousPageTitle: 'Back',
      ),
      child: SafeArea(
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
                  color: CupertinoColors.systemBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: CupertinoColors.separator),
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
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Contact information section
              const Text(
                'CONTACT INFORMATION',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: CupertinoColors.systemGrey,
                ),
              ),
              const SizedBox(height: 12),
              // Phone number
              if (contact.phoneNumber != null)
                _ContactInfoTile(
                  icon: CupertinoIcons.phone_fill,
                  label: 'Phone',
                  value: contact.phoneNumber!,
                  onTap: () {
                    debugPrint('Call ${contact.phoneNumber}');
                  },
                ),
              if (contact.phoneNumber != null) const SizedBox(height: 12),
              // Email
              if (contact.email != null)
                _ContactInfoTile(
                  icon: CupertinoIcons.mail_solid,
                  label: 'Email',
                  value: contact.email!,
                  onTap: () {
                    debugPrint('Email ${contact.email}');
                  },
                ),
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
    );
  }
}

/// Reusable contact info tile widget
class _ContactInfoTile extends StatelessWidget {
  const _ContactInfoTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: CupertinoColors.extraLightBackgroundGray,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: CupertinoColors.separator),
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
                    style: const TextStyle(
                      fontSize: 12,
                      color: CupertinoColors.systemGrey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              CupertinoIcons.chevron_right,
              color: CupertinoColors.systemGrey3,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
