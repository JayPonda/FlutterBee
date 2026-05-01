import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import 'package:provider/provider.dart';

import 'package:basics/domain/models/contact.dart';
import 'package:basics/ui/core/theme/app_theme.dart';
import 'package:basics/ui/core/utils/dialog_helper.dart';
import 'package:basics/ui/core/utils/url_helper.dart';
import 'package:basics/ui/features/phone_book/view_models/contact_view_model.dart';

Future<Map<String, dynamic>?> showEditContactDialog(
  BuildContext context,
  Contact contact,
) async {
  final viewModel = context.read<ContactViewModel>();
  final groups = viewModel.listsNotifier.value;
  
  // Find current group ID (excluding the virtual "All Contacts" group)
  String? currentGroupId;
  for (final group in groups) {
    if (group.id == '0') continue;
    if (group.contacts.any((c) => c.id == contact.id)) {
      currentGroupId = group.id;
      break;
    }
  }
  currentGroupId ??= groups.isNotEmpty ? groups.first.id : null;

  final firstNameController = TextEditingController(text: contact.firstName);
  final lastNameController = TextEditingController(text: contact.lastName);
  final phoneController = TextEditingController(
    text: contact.phoneNumber ?? '',
  );
  final emailController = TextEditingController(text: contact.email ?? '');
  final selectedGroupIdNotifier = ValueNotifier<String>(currentGroupId ?? '');

  final result = await showCupertinoDialog<Map<String, dynamic>>(
    context: context,
    builder: (context) => CupertinoAlertDialog(
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
                maxLength: 30,
              ),
              const SizedBox(height: 8),
              CupertinoTextField(
                controller: lastNameController,
                placeholder: 'Last Name *',
                padding: const EdgeInsets.all(12),
                textCapitalization: TextCapitalization.words,
                maxLength: 30,
              ),
              const SizedBox(height: 8),
              CupertinoTextField(
                controller: phoneController,
                placeholder: 'Phone Number *',
                keyboardType: TextInputType.phone,
                padding: const EdgeInsets.all(12),
                maxLength: 15,
              ),
              const SizedBox(height: 8),
              CupertinoTextField(
                controller: emailController,
                placeholder: 'Email',
                keyboardType: TextInputType.emailAddress,
                padding: const EdgeInsets.all(12),
                maxLength: 250,
              ),
              const SizedBox(height: 16),
              const Text(
                'Group',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              ValueListenableBuilder<String>(
                valueListenable: selectedGroupIdNotifier,
                builder: (context, selectedId, _) {
                  return CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      showCupertinoModalPopup(
                        context: context,
                        builder: (context) => CupertinoActionSheet(
                          title: const Text('Select Group'),
                          actions: groups
                              .map(
                                (g) => CupertinoActionSheetAction(
                                  onPressed: () {
                                    selectedGroupIdNotifier.value = g.id;
                                    Navigator.pop(context);
                                  },
                                  child: Text(g.title),
                                ),
                              )
                              .toList(),
                          cancelButton: CupertinoActionSheetAction(
                            isDefaultAction: true,
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: CupertinoColors.systemGrey4),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            groups.firstWhere((g) => g.id == selectedId).title,
                            style: TextStyle(color: context.primaryText),
                          ),
                          const Icon(CupertinoIcons.chevron_down, size: 16),
                        ],
                      ),
                    ),
                  );
                },
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
            final firstName = firstNameController.text.trim();
            final lastName = lastNameController.text.trim();
            final phone = phoneController.text.trim();
            final email = emailController.text.trim();

            final tempContact = Contact(
              id: contact.id,
              firstName: firstName,
              lastName: lastName,
              phoneNumber: phone,
              email: email.isEmpty ? null : email,
            );

            final validation = viewModel.validateContact(
              tempContact,
              excludeId: contact.id,
            );

            if (!validation.success) {
              _showValidationError(context, validation.errorMessage!);
              return;
            }

            FocusScope.of(context).unfocus();
            Navigator.pop(context, {
              'contact': tempContact,
              'groupId': selectedGroupIdNotifier.value,
            });
          },
          child: const Text('Save'),
        ),
      ],
    ),
  );

  firstNameController.dispose();
  lastNameController.dispose();
  phoneController.dispose();
  emailController.dispose();
  selectedGroupIdNotifier.dispose();

  return result;
}

Future<Map<String, dynamic>?> showCreateContactDialog(
  BuildContext context, {
  String? initialGroupId,
}) async {
  final viewModel = context.read<ContactViewModel>();
  final groups = viewModel.listsNotifier.value;
  
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final selectedGroupIdNotifier = ValueNotifier<String>(
    initialGroupId ?? (groups.isNotEmpty ? groups.first.id : ''),
  );

  final result = await showCupertinoDialog<Map<String, dynamic>>(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: const Text('New Contact'),
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
                maxLength: 30,
              ),
              const SizedBox(height: 8),
              CupertinoTextField(
                controller: lastNameController,
                placeholder: 'Last Name *',
                padding: const EdgeInsets.all(12),
                textCapitalization: TextCapitalization.words,
                maxLength: 30,
              ),
              const SizedBox(height: 8),
              CupertinoTextField(
                controller: phoneController,
                placeholder: 'Phone Number *',
                keyboardType: TextInputType.phone,
                padding: const EdgeInsets.all(12),
                maxLength: 15,
              ),
              const SizedBox(height: 8),
              CupertinoTextField(
                controller: emailController,
                placeholder: 'Email',
                keyboardType: TextInputType.emailAddress,
                padding: const EdgeInsets.all(12),
                maxLength: 250,
              ),
              const SizedBox(height: 16),
              const Text(
                'Group',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              ValueListenableBuilder<String>(
                valueListenable: selectedGroupIdNotifier,
                builder: (context, selectedId, _) {
                  return CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      showCupertinoModalPopup(
                        context: context,
                        builder: (context) => CupertinoActionSheet(
                          title: const Text('Select Group'),
                          actions: groups
                              .map(
                                (g) => CupertinoActionSheetAction(
                                  onPressed: () {
                                    selectedGroupIdNotifier.value = g.id;
                                    Navigator.pop(context);
                                  },
                                  child: Text(g.title),
                                ),
                              )
                              .toList(),
                          cancelButton: CupertinoActionSheetAction(
                            isDefaultAction: true,
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: CupertinoColors.systemGrey4),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            groups.firstWhere((g) => g.id == selectedId).title,
                            style: TextStyle(color: context.primaryText),
                          ),
                          const Icon(CupertinoIcons.chevron_down, size: 16),
                        ],
                      ),
                    ),
                  );
                },
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
            final firstName = firstNameController.text.trim();
            final lastName = lastNameController.text.trim();
            final phone = phoneController.text.trim();
            final email = emailController.text.trim();

            final newContact = Contact(
              id: const Uuid().v4(),
              firstName: firstName,
              lastName: lastName,
              phoneNumber: phone,
              email: email.isEmpty ? null : email,
            );

            final validation = viewModel.validateContact(newContact);

            if (!validation.success) {
              _showValidationError(context, validation.errorMessage!);
              return;
            }

            FocusScope.of(context).unfocus();
            Navigator.pop(context, {
              'contact': newContact,
              'groupId': selectedGroupIdNotifier.value,
            });
          },
          child: const Text('Save'),
        ),
      ],
    ),
  );

  firstNameController.dispose();
  lastNameController.dispose();
  phoneController.dispose();
  emailController.dispose();
  selectedGroupIdNotifier.dispose();

  return result;
}

class ContactDetailPage extends StatefulWidget {
  const ContactDetailPage({
    super.key,
    required this.contact,
    this.onBack,
    this.onContactUpdated,
    this.onContactDeleted,
  });

  final Contact contact;
  final VoidCallback? onBack;
  final Function(Contact, Contact)? onContactUpdated;
  final Function(Contact)? onContactDeleted;

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
      FocusScope.of(context).unfocus();
      final contactToDelete = _currentContact;
      final viewModel = context.read<ContactViewModel>();
      await viewModel.deleteContact(contactToDelete);
      
      if (mounted) {
        widget.onContactDeleted?.call(contactToDelete);
        
        // Wait a frame before updating local state to avoid disposal errors on Web
        await Future.delayed(const Duration(milliseconds: 50));
        
        if (mounted) {
          setState(() {
            _isDeleted = true;
          });
        }
      }
    }
  }

  Future<void> _handleRestore() async {
    final viewModel = context.read<ContactViewModel>();
    await viewModel.restoreContact(_currentContact);
    if (mounted) {
      widget.onContactUpdated?.call(_currentContact, _currentContact);
      _showToast('Contact restored');
      setState(() {
        _isDeleted = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
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
                          '${_currentContact.firstName.isNotEmpty ? _currentContact.firstName[0].toUpperCase() : ''}${_currentContact.lastName.isNotEmpty ? _currentContact.lastName[0].toUpperCase() : ''}',
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
                        onPressed: () async {
                          final confirmed =
                              await DialogHelper.showCallConfirmation(
                            context,
                            _currentContact.fullName,
                          );
                          if (confirmed && context.mounted) {
                            final viewModel = context.read<ContactViewModel>();
                            await viewModel.addRecentCall(_currentContact.id);
                            UrlHelper.makeCall(_currentContact.phoneNumber!);
                          }
                        },
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
                _buildInfoTile(
                  context,
                  icon: CupertinoIcons.phone_fill,
                  label: 'Phone',
                  value: _currentContact.phoneNumber!,
                  onTap: () async {
                    final confirmed = await DialogHelper.showCallConfirmation(
                      context,
                      _currentContact.fullName,
                    );
                    if (confirmed && context.mounted) {
                      final viewModel = context.read<ContactViewModel>();
                      await viewModel.addRecentCall(_currentContact.id);
                      UrlHelper.makeCall(_currentContact.phoneNumber!);
                    }
                  },
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
                _buildInfoTile(
                  context,
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
              else
                Row(
                  children: [
                    Expanded(
                      child: CupertinoButton(
                        color: CupertinoColors.systemBlue,
                        onPressed: () async {
                          final resultData = await showEditContactDialog(
                            context,
                            _currentContact,
                          );
                          if (resultData != null && mounted) {
                            final updated = resultData['contact'] as Contact;
                            final newGroupId = resultData['groupId'] as String;
                            
                            final viewModel = context.read<ContactViewModel>();
                            final result = await viewModel
                                .updateContactWithValidation(
                                  _currentContact,
                                  updated,
                                  newGroupId: newGroupId,
                                );
                            if (result.success) {
                              // Only update the UI state if the DB/Validation succeeded
                              setState(() {
                                _currentContact = updated;
                              });
                              widget.onContactUpdated?.call(
                                _currentContact,
                                updated,
                              );
                              _showToast('Contact updated successfully');
                            } else {
                              // Keep old data and show error
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
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
  }) {
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
            if (onTap != null)
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
  final Function(Contact)? onEdit;
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

class _ContactDetailContent extends StatelessWidget {
  const _ContactDetailContent({
    required this.contact,
    this.onEdit,
    this.onDelete,
  });

  final Contact contact;
  final Function(Contact)? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                      '${contact.firstName.isNotEmpty ? contact.firstName[0].toUpperCase() : ''}${contact.lastName.isNotEmpty ? contact.lastName[0].toUpperCase() : ''}',
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
          Text(
            'CONTACT INFORMATION',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: context.secondaryText,
            ),
          ),
          const SizedBox(height: 12),
          if (contact.phoneNumber != null) ...[
            _buildInfoTile(
              context,
              icon: CupertinoIcons.phone_fill,
              label: 'Phone',
              value: contact.phoneNumber!,
              onTap: () async {
                final confirmed = await DialogHelper.showCallConfirmation(
                  context,
                  contact.fullName,
                );
                if (confirmed && context.mounted) {
                  final viewModel = context.read<ContactViewModel>();
                  await viewModel.addRecentCall(contact.id);
                  UrlHelper.makeCall(contact.phoneNumber!);
                }
              },
              onLongPress: () {
                Clipboard.setData(ClipboardData(text: contact.phoneNumber!));
                _showSnackBar(context, 'Phone number copied');
              },
            ),
            const SizedBox(height: 12),
          ],
          if (contact.email != null) ...[
            _buildInfoTile(
              context,
              icon: CupertinoIcons.mail_solid,
              label: 'Email',
              value: contact.email!,
              onTap: () {
                Clipboard.setData(ClipboardData(text: contact.email!));
                _showSnackBar(context, 'Email copied');
              },
            ),
            const SizedBox(height: 12),
          ],
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: CupertinoButton(
                  color: CupertinoColors.systemBlue,
                  onPressed: () async {
                    if (onEdit != null) {
                      onEdit!(contact);
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
                  onPressed: onDelete,
                  child: const Text(
                    'Delete',
                    style: TextStyle(color: CupertinoColors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
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

  Widget _buildInfoTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
  }) {
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
            if (onTap != null)
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

void _showValidationError(BuildContext context, String message) {
  showCupertinoDialog(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: const Text('Validation Error'),
      content: Text(message),
      actions: [
        CupertinoDialogAction(
          onPressed: () => Navigator.pop(context),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}
