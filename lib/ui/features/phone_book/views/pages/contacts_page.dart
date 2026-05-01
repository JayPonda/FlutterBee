import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'package:basics/domain/models/contact.dart';
import 'package:basics/domain/models/contact_group.dart';
import 'package:basics/ui/core/theme/app_theme.dart';
import 'package:basics/ui/core/utils/dialog_helper.dart';
import 'package:basics/ui/core/utils/url_helper.dart';
import 'package:basics/ui/features/phone_book/view_models/contact_view_model.dart';
import 'contact_detail_page.dart';

typedef AlphabetizedContactMap = Map<String, List<Contact>>;

/// Reusable Contacts page for small screen layouts
class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key, required this.listId});

  final String listId;

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  AlphabetizedContactMap _filterContacts(List<Contact> contacts) {
    // Only show non-deleted contacts
    final activeContacts = contacts.where((c) => c.deletedAt == null).toList();
    
    final query = _searchQuery.toLowerCase().trim();
    if (query.isEmpty) {
      return _alphabetizeContacts(activeContacts);
    }

    final filtered = activeContacts.where((contact) {
      return contact.fullName.toLowerCase().contains(query) ||
          (contact.phoneNumber?.contains(query) ?? false) ||
          (contact.email?.toLowerCase().contains(query) ?? false);
    }).toList();

    return _alphabetizeContacts(filtered);
  }

  AlphabetizedContactMap _alphabetizeContacts(List<Contact> contacts) {
    final Map<String, List<Contact>> grouped = {};
    for (final contact in contacts) {
      final key = contact.alphabeticalKey;
      grouped.putIfAbsent(key, () => []);
      grouped[key]!.add(contact);
    }
    final sortedKeys = grouped.keys.toList()..sort();
    return Map.fromEntries(
      sortedKeys.map((key) => MapEntry(key, grouped[key]!)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ContactViewModel>();
    
    return CupertinoPageScaffold(
      child: ValueListenableBuilder<List<ContactGroup>>(
        valueListenable: viewModel.listsNotifier,
        builder: (context, contactGroups, child) {
          if (contactGroups.isEmpty) {
             return const Center(child: CupertinoActivityIndicator());
          }

          final ContactGroup contactList = viewModel.findContactList(
            widget.listId,
          );
          final allContacts = contactList.contacts;
          final filteredContacts = _filterContacts(allContacts);

          return CustomScrollView(
            slivers: [
              CupertinoSliverNavigationBar.search(
                largeTitle: Text(contactList.title),
                trailing: CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: const Icon(CupertinoIcons.add),
                  onPressed: () async {
                    final resultData = await showCreateContactDialog(
                      context,
                      initialGroupId: widget.listId,
                    );
                    if (resultData != null && context.mounted) {
                      final newContact = resultData['contact'] as Contact;
                      final selectedGroupId = resultData['groupId'] as String;
                      
                      // Safety for Web: unfocus and small delay before DB update
                      FocusScope.of(context).unfocus();
                      await Future.delayed(const Duration(milliseconds: 100));
                      
                      if (context.mounted) {
                        await viewModel.addContact(selectedGroupId, newContact);
                      }
                    }
                  },
                ),
                searchField: CupertinoSearchTextField(
                  controller: _searchController,
                  suffixIcon: const Icon(CupertinoIcons.mic_fill),
                  suffixMode: OverlayVisibilityMode.always,
                  onChanged: (value) {
                    if (mounted) {
                      setState(() {
                        _searchQuery = value;
                      });
                    }
                  },
                ),
              ),
              if (_searchQuery.isNotEmpty && filteredContacts.isEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          CupertinoIcons.search,
                          size: 64,
                          color: CupertinoColors.systemGrey,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No contacts found',
                          style: TextStyle(
                            fontSize: 18,
                            color: CupertinoColors.systemGrey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Try a different search term',
                          style: TextStyle(
                            fontSize: 14,
                            color: CupertinoColors.systemGrey2,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                SliverList.list(
                  children: [
                    const SizedBox(height: 20),
                    ...filteredContacts.keys.map(
                      (String initial) => _ContactListSection(
                        lastInitial: initial,
                        contacts: filteredContacts[initial]!,
                        onContactSelected: (contact) {
                          Navigator.of(context).push(
                            CupertinoPageRoute(
                              builder: (context) => ContactDetailPage(
                                contact: contact,
                                onContactDeleted: (deletedContact) {
                                  // Go back to the list on mobile after deletion
                                  if (Navigator.of(context).canPop()) {
                                    Navigator.of(context).pop();
                                  }
                                },
                                onContactUpdated: (oldC, newC) {
                                  // The model update is already handled by ContactDetailPage
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
            ],
          );
        },
      ),
    );
  }
}

/// Reusable Contacts content for master-detail layout
class ContactsContent extends StatefulWidget {
  const ContactsContent({super.key, this.listId = '0', this.onContactSelected});

  final String listId;
  final Function(Contact)? onContactSelected;

  @override
  State<ContactsContent> createState() => _ContactsContentState();
}

class _ContactsContentState extends State<ContactsContent> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  AlphabetizedContactMap _filterContacts(List<Contact> contacts) {
    // Only show non-deleted contacts
    final activeContacts = contacts.where((c) => c.deletedAt == null).toList();
    
    final query = _searchQuery.toLowerCase().trim();
    if (query.isEmpty) {
      return _alphabetizeContacts(activeContacts);
    }

    final filtered = activeContacts.where((contact) {
      return contact.fullName.toLowerCase().contains(query) ||
          (contact.phoneNumber?.contains(query) ?? false) ||
          (contact.email?.toLowerCase().contains(query) ?? false);
    }).toList();

    return _alphabetizeContacts(filtered);
  }

  AlphabetizedContactMap _alphabetizeContacts(List<Contact> contacts) {
    final Map<String, List<Contact>> grouped = {};
    for (final contact in contacts) {
      final key = contact.alphabeticalKey;
      grouped.putIfAbsent(key, () => []);
      grouped[key]!.add(contact);
    }
    final sortedKeys = grouped.keys.toList()..sort();
    return Map.fromEntries(
      sortedKeys.map((key) => MapEntry(key, grouped[key]!)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ContactViewModel>();
    
    return Container(
      color: context.primaryBackground,
      child: ValueListenableBuilder<List<ContactGroup>>(
        valueListenable: viewModel.listsNotifier,
        builder: (context, groups, _) {
          if (groups.isEmpty) {
             return const Center(child: CupertinoActivityIndicator());
          }
          final contactList = viewModel.findContactList(widget.listId);
          final allContacts = contactList.contacts;
          final filteredContacts = _filterContacts(allContacts);

          return CustomScrollView(
            slivers: [
              CupertinoSliverNavigationBar.search(
                largeTitle: Text(contactList.title),
                trailing: CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: const Icon(CupertinoIcons.add),
                  onPressed: () async {
                    final resultData = await showCreateContactDialog(
                      context,
                      initialGroupId: widget.listId,
                    );
                    if (resultData != null && context.mounted) {
                      final newContact = resultData['contact'] as Contact;
                      final selectedGroupId = resultData['groupId'] as String;
                      
                      // Safety for Web: unfocus and small delay before DB update
                      FocusScope.of(context).unfocus();
                      await Future.delayed(const Duration(milliseconds: 100));
                      
                      if (context.mounted) {
                        await viewModel.addContact(selectedGroupId, newContact);
                      }
                    }
                  },
                ),
                searchField: CupertinoSearchTextField(
                  controller: _searchController,
                  onChanged: (value) {
                    if (mounted) {
                      setState(() {
                        _searchQuery = value;
                      });
                    }
                  },
                ),
              ),
              if (_searchQuery.isNotEmpty && filteredContacts.isEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          CupertinoIcons.search,
                          size: 64,
                          color: CupertinoColors.systemGrey,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No contacts found',
                          style: TextStyle(
                            fontSize: 18,
                            color: CupertinoColors.systemGrey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Try a different search term',
                          style: TextStyle(
                            fontSize: 14,
                            color: CupertinoColors.systemGrey2,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                SliverList.list(
                  children: [
                    const SizedBox(height: 12),
                    for (final initial in filteredContacts.keys) ...[
                      _buildAlphabetSection(
                        initial: initial,
                        contacts: filteredContacts[initial]!,
                        onContactSelected: widget.onContactSelected,
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

  Widget _buildAlphabetSection({
    required String initial,
    required List<Contact> contacts,
    Function(Contact)? onContactSelected,
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
                  trailing: contact.phoneNumber != null && contact.phoneNumber!.isNotEmpty
                      ? CupertinoButton(
                          padding: EdgeInsets.zero,
                          child: const Icon(CupertinoIcons.phone_fill),
                          onPressed: () async {
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
                        )
                      : const Icon(CupertinoIcons.chevron_right),
                  onTap: () {
                    onContactSelected?.call(contact);
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

/// Contact list section for Contacts page
class _ContactListSection extends StatelessWidget {
  const _ContactListSection({
    required this.lastInitial,
    required this.contacts,
    this.onContactSelected,
  });

  final String lastInitial;
  final List<Contact> contacts;
  final Function(Contact)? onContactSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 8, bottom: 8),
          child: Text(
            lastInitial,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: CupertinoColors.systemGrey,
            ),
          ),
        ),
        for (final (index, contact) in contacts.indexed) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: index < contacts.length - 1
                      ? BorderSide(color: context.dividerColor, width: 0.5)
                      : BorderSide.none,
                ),
              ),
              child: CupertinoButton(
                padding: const EdgeInsets.symmetric(vertical: 16),
                onPressed: () {
                  debugPrint('Tapped ${contact.fullName}');
                  onContactSelected?.call(contact);
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            contact.fullName,
                            style: TextStyle(color: context.primaryText),
                          ),
                          if (contact.phoneNumber != null)
                            Text(
                              contact.phoneNumber!,
                              style: TextStyle(
                                color: context.secondaryText,
                                fontSize: 12,
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (contact.phoneNumber != null && contact.phoneNumber!.isNotEmpty)
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: const Icon(CupertinoIcons.phone_fill),
                        onPressed: () async {
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
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// Contact list section helper
class ContactListSection extends StatelessWidget {
  const ContactListSection({
    super.key,
    required this.lastInitial,
    required this.contacts,
    this.onContactSelected,
  });

  final String lastInitial;
  final List<Contact> contacts;
  final Function(Contact)? onContactSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 8, bottom: 8),
          child: Text(
            lastInitial,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: CupertinoColors.systemGrey,
            ),
          ),
        ),
        for (final (index, contact) in contacts.indexed) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: index < contacts.length - 1
                      ? BorderSide(color: context.dividerColor, width: 0.5)
                      : BorderSide.none,
                ),
              ),
              child: CupertinoButton(
                padding: const EdgeInsets.symmetric(vertical: 16),
                onPressed: () {
                  debugPrint('Tapped ${contact.fullName}');
                  onContactSelected?.call(contact);
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            contact.fullName,
                            style: TextStyle(color: context.primaryText),
                          ),
                          if (contact.phoneNumber != null)
                            Text(
                              contact.phoneNumber!,
                              style: TextStyle(
                                color: context.secondaryText,
                                fontSize: 12,
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (contact.phoneNumber != null && contact.phoneNumber!.isNotEmpty)
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: const Icon(CupertinoIcons.phone_fill),
                        onPressed: () async {
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
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
