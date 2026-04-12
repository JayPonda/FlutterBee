import 'package:flutter/cupertino.dart';

import '../data/contact_groups_model.dart';
import '../data/models/contact.dart';
import '../data/models/contact_group.dart';
import '../theme/app_theme.dart';
import 'pages/contact_detail_page.dart';

class ContactListsPage extends StatelessWidget {
  const ContactListsPage({super.key, required this.listId});

  final int listId;

  @override
  Widget build(BuildContext context) {
    return _ContactListView(listId: listId);
  }
}

class _ContactListView extends StatefulWidget {
  const _ContactListView({required this.listId});

  final int listId;

  @override
  State<_ContactListView> createState() => _ContactListViewState();
}

class _ContactListViewState extends State<_ContactListView> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  AlphabetizedContactMap _filterContacts(List<Contact> contacts) {
    final query = _searchQuery.toLowerCase().trim();
    if (query.isEmpty) {
      return _alphabetizeContacts(contacts);
    }

    final filtered = contacts.where((contact) {
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
    return CupertinoPageScaffold(
      child: ValueListenableBuilder<List<ContactGroup>>(
        valueListenable: contactGroupsModel.listsNotifier,
        builder: (context, contactGroups, child) {
          final ContactGroup contactList = contactGroupsModel.findContactList(
            widget.listId,
          );

          final allContacts = contactList.contacts;
          final filteredContacts = _filterContacts(allContacts);

          return CustomScrollView(
            slivers: [
              CupertinoSliverNavigationBar.search(
                largeTitle: Text(contactList.title),
                searchField: CupertinoSearchTextField(
                  controller: _searchController,
                  suffixIcon: const Icon(CupertinoIcons.mic_fill),
                  suffixMode: OverlayVisibilityMode.always,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
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
                        Text(
                          'No contacts found',
                          style: TextStyle(
                            fontSize: 18,
                            color: CupertinoColors.systemGrey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
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
                      (String initial) => ContactListSection(
                        lastInitial: initial,
                        contacts: filteredContacts[initial]!,
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

// ...

class ContactListSection extends StatelessWidget {
  const ContactListSection({
    super.key,
    required this.lastInitial,
    required this.contacts,
  });

  final String lastInitial;
  final List<Contact> contacts;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
      child: Column(
        children: [
          const SizedBox(height: 15),
          Align(
            alignment: AlignmentDirectional.bottomStart,
            child: Text(
              lastInitial,
              style: TextStyle(
                color: context.secondaryText,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          CupertinoListSection(
            backgroundColor: context.primaryBackground,
            dividerMargin: 0,
            additionalDividerMargin: 0,
            topMargin: 4,
            children: [
              for (final Contact contact in contacts)
                CupertinoListTile(
                  padding: EdgeInsets.all(0),
                  title: Text('${contact.firstName} ${contact.lastName}'),
                  onTap: () {
                    // Navigate to contact detail page
                    Navigator.of(context).push(
                      CupertinoPageRoute<void>(
                        builder: (BuildContext context) =>
                            ContactDetailPage(contact: contact),
                      ),
                    );
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }
}
