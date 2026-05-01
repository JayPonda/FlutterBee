import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import 'package:provider/provider.dart';

import 'package:basics/domain/models/contact.dart';
import 'package:basics/ui/core/theme/app_theme.dart';
import 'package:basics/ui/core/utils/url_helper.dart';
import 'package:basics/ui/features/phone_book/view_models/contact_view_model.dart';

class ContactDetailPage extends StatefulWidget {
  const ContactDetailPage({super.key, required this.contact});

  final Contact contact;

  @override
  State<ContactDetailPage> createState() => _ContactDetailPageState();
}

class _ContactDetailPageState extends State<ContactDetailPage> {
  late Contact _currentContact;
  bool _isDeleted = false;

  @override
  void initState() {
    super.initState();
    _currentContact = widget.contact;
  }

  @override
  void didUpdateWidget(ContactDetailPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.contact != oldWidget.contact) {
      _currentContact = widget.contact;
      _isDeleted = false;
    }
  }

  void _showToast(String message) {
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

  Future<void> _handleDelete() async {
    final confirmed = await showCupertinoDialog<bool>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Delete Contact'),
        content: Text(
          'Are you sure you want to delete ${_currentContact.fullName}?',
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

    if (confirmed == true && mounted) {
      await context.read<ContactViewModel>().deleteContact(_currentContact);
      if (mounted) {
        setState(() {
          _isDeleted = true;
        });
      }
    }
  }

  Future<void> _handleRestore() async {
    await context.read<ContactViewModel>().restoreContact(_currentContact);
    if (mounted) {
      setState(() {
        _isDeleted = false;
      });
      _showToast('Contact restored');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width > 600;
    return CupertinoPageScaffold(
      navigationBar: isLargeScreen
          ? null
          : CupertinoNavigationBar(
              middle: Text(_currentContact.fullName),
              previousPageTitle: 'Back',
            ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                    Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        color: CupertinoColors.systemBlue,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${_currentContact.firstName[0]}${_currentContact.lastName[0]}',
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
                      _currentContact.fullName,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: context.primaryText,
                      ),
                    ),
                    if (_currentContact.phoneNumber != null &&
                        _currentContact.phoneNumber!.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      CupertinoButton(
                        color: CupertinoColors.systemGreen,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        borderRadius: BorderRadius.circular(24),
                        onPressed: () =>
                            UrlHelper.makeCall(_currentContact.phoneNumber!),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(CupertinoIcons.phone_fill, size: 20),
                            SizedBox(width: 8),
                            Text('Call'),
                          ],
                        ),
                      ),
                    ],
                    if (_isDeleted) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: CupertinoColors.systemRed.withValues(
                            alpha: 0.1,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Deleted',
                          style: TextStyle(
                            color: CupertinoColors.systemRed,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'CONTACT INFORMATION',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: context.secondaryText,
                ),
              ),
              const SizedBox(height: 12),
              if (_currentContact.phoneNumber != null) ...[
                _ContactInfoTile(
                  icon: CupertinoIcons.phone_fill,
                  label: 'Phone',
                  value: _currentContact.phoneNumber!,
                  onTap: () => UrlHelper.makeCall(_currentContact.phoneNumber!),
                  onLongPress: () {
                    Clipboard.setData(
                      ClipboardData(text: _currentContact.phoneNumber!),
                    );
                    _showToast('Phone number copied');
                  },
                ),
                const SizedBox(height: 12),
              ],
              if (_currentContact.email != null) ...[
                _ContactInfoTile(
                  icon: CupertinoIcons.mail_solid,
                  label: 'Email',
                  value: _currentContact.email!,
                  onTap: () {
                    Clipboard.setData(
                      ClipboardData(text: _currentContact.email!),
                    );
                    _showToast('Email copied');
                  },
                ),
                const SizedBox(height: 12),
              ],
              const SizedBox(height: 24),
              if (_isDeleted)
                SizedBox(
                  width: double.infinity,
                  child: CupertinoButton(
                    color: CupertinoColors.systemGreen,
                    onPressed: _handleRestore,
                    child: const Text(
                      'Restore Contact',
                      style: TextStyle(color: CupertinoColors.white),
                    ),
                  ),
                )
              else ...[
                Row(
                  children: [
                    Expanded(
                      child: CupertinoButton(
                        color: CupertinoColors.systemBlue,
                        onPressed: () async {
                          final resultData = await _showEditDialog(
                            _currentContact,
                          );
                          if (resultData != null && mounted) {
                            final updated = resultData['contact'] as Contact;
                            final newGroupId = resultData['groupId'] as String;
                            
                            final result = await context.read<ContactViewModel>()
                                .updateContactWithValidation(
                                  _currentContact,
                                  updated,
                                  newGroupId: newGroupId,
                                );
                            if (result.success) {
                              setState(() {
                                _currentContact = updated;
                              });
                              _showToast('Contact updated successfully');
                            } else {
                              _showToast(result.errorMessage!);
                            }
                          }
                        },
                        child: const Text(
                          'Edit',
                          style: TextStyle(color: CupertinoColors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: CupertinoButton(
                        color: CupertinoColors.systemRed,
                        onPressed: _handleDelete,
                        child: const Text(
                          'Delete',
                          style: TextStyle(color: CupertinoColors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<Map<String, dynamic>?> _showEditDialog(Contact contact) async {
    final viewModel = context.read<ContactViewModel>();
    final groups = viewModel.listsNotifier.value;
    
    // Find current group ID
    String? currentGroupId;
    for (final group in groups) {
      if (group.contacts.any((c) => c.id == contact.id)) {
        currentGroupId = group.id;
        break;
      }
    }
    
    // Default to first group if not found
    currentGroupId ??= groups.isNotEmpty ? groups.first.id : null;

    final firstNameController = TextEditingController(text: contact.firstName);
    final lastNameController = TextEditingController(text: contact.lastName);
    final phoneController = TextEditingController(
      text: contact.phoneNumber ?? '',
    );
    final emailController = TextEditingController(text: contact.email ?? '');
    String selectedGroupId = currentGroupId ?? '';

    final result = await showCupertinoDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return CupertinoAlertDialog(
              title: const Text('Edit Contact'),
              content: Padding(
                padding: const EdgeInsets.only(top: 16),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CupertinoTextField(
                        controller: firstNameController,
                        placeholder: 'First Name *',
                        padding: const EdgeInsets.all(12),
                        textCapitalization: TextCapitalization.words,
                      ),
                      const SizedBox(height: 8),
                      CupertinoTextField(
                        controller: lastNameController,
                        placeholder: 'Last Name *',
                        padding: const EdgeInsets.all(12),
                        textCapitalization: TextCapitalization.words,
                      ),
                      const SizedBox(height: 8),
                      CupertinoTextField(
                        controller: phoneController,
                        placeholder: 'Phone Number *',
                        keyboardType: TextInputType.phone,
                        padding: const EdgeInsets.all(12),
                      ),
                      const SizedBox(height: 8),
                      CupertinoTextField(
                        controller: emailController,
                        placeholder: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        padding: const EdgeInsets.all(12),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Select Group',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 100,
                        child: CupertinoPicker(
                          itemExtent: 32,
                          scrollController: FixedExtentScrollController(
                            initialItem: groups.indexWhere((g) => g.id == selectedGroupId),
                          ),
                          onSelectedItemChanged: (index) {
                            selectedGroupId = groups[index].id;
                          },
                          children: groups.map((g) => Text(g.title)).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                CupertinoDialogAction(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                CupertinoDialogAction(
                  isDefaultAction: true,
                  onPressed: () {
                    if (firstNameController.text.trim().isEmpty ||
                        lastNameController.text.trim().isEmpty ||
                        phoneController.text.trim().isEmpty) {
                      return;
                    }
                    final newContact = contact.copyWith(
                      firstName: firstNameController.text.trim(),
                      lastName: lastNameController.text.trim(),
                      phoneNumber: phoneController.text.trim(),
                      email: emailController.text.trim().isEmpty
                          ? null
                          : emailController.text.trim(),
                    );
                    Navigator.pop(context, {
                      'contact': newContact,
                      'groupId': selectedGroupId,
                    });
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );

    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    emailController.dispose();

    return result;
  }
}

class _ContactInfoTile extends StatelessWidget {
  const _ContactInfoTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
    this.onLongPress,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
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
            const Icon(
              CupertinoIcons.chevron_right,
              color: CupertinoColors.systemGrey,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
