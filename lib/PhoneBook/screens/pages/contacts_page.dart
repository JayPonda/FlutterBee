import 'package:flutter/cupertino.dart';

import '../../data/contact_groups_model.dart';
import '../../data/models/contact.dart';
import '../../data/models/contact_group.dart';
import '../../theme/app_theme.dart';
import 'contact_detail_page.dart';

/// Reusable Contacts page for small screen layouts
class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key, required this.listId});

  final int listId;

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: ValueListenableBuilder<List<ContactGroup>>(
        valueListenable: contactGroupsModel.listsNotifier,
        builder: (context, contactGroups, child) {
          final ContactGroup contactList = contactGroupsModel.findContactList(
            widget.listId,
          );
          final AlphabetizedContactMap contacts =
              contactList.alphabetizedContacts;

          return CustomScrollView(
            slivers: [
              CupertinoSliverNavigationBar.search(
                largeTitle: Text(contactList.title),
                searchField: const CupertinoSearchTextField(
                  suffixIcon: Icon(CupertinoIcons.mic_fill),
                  suffixMode: OverlayVisibilityMode.always,
                ),
              ),
              SliverList.list(
                children: [
                  const SizedBox(height: 20),
                  ...contacts.keys.map(
                    (String initial) => _ContactListSection(
                      lastInitial: initial,
                      contacts: contacts[initial]!,
                      onContactSelected: (contact) {
                        // On small screen, we navigate to the detail page
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (context) => ContactDetailPage(
                              contact: contact,
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
  const ContactsContent({super.key, this.listId = 0, this.onContactSelected});

  final int listId;
  final Function(Contact)? onContactSelected;

  @override
  State<ContactsContent> createState() => _ContactsContentState();
}

class _ContactsContentState extends State<ContactsContent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.primaryBackground,
      child: ValueListenableBuilder<List<ContactGroup>>(
        valueListenable: contactGroupsModel.listsNotifier,
        builder: (context, groups, _) {
          final contactList = contactGroupsModel.findContactList(widget.listId);
          final alphabetized = contactList.alphabetizedContacts;

          return CustomScrollView(
            slivers: [
              CupertinoSliverNavigationBar(
                largeTitle: Text(contactList.title),
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
                  trailing: const Icon(CupertinoIcons.chevron_right),
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
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: CupertinoColors.systemGrey,
            ),
          ),
        ),
        for (int i = 0; i < contacts.length; i++) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: i < contacts.length - 1
                      ? BorderSide(color: context.dividerColor, width: 0.5)
                      : BorderSide.none,
                ),
              ),
              child: CupertinoButton(
                padding: const EdgeInsets.symmetric(vertical: 16),
                onPressed: () {
                  debugPrint('Tapped ${contacts[i].fullName}');
                  onContactSelected?.call(contacts[i]);
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            contacts[i].fullName,
                            style: TextStyle(color: context.primaryText),
                          ),
                          if (contacts[i].phoneNumber != null)
                            Text(
                              contacts[i].phoneNumber!,
                              style: TextStyle(
                                color: context.secondaryText,
                                fontSize: 12,
                              ),
                            ),
                        ],
                      ),
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
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: CupertinoColors.systemGrey,
            ),
          ),
        ),
        for (int i = 0; i < contacts.length; i++) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: i < contacts.length - 1
                      ? BorderSide(color: context.dividerColor, width: 0.5)
                      : BorderSide.none,
                ),
              ),
              child: CupertinoButton(
                padding: const EdgeInsets.symmetric(vertical: 16),
                onPressed: () {
                  debugPrint('Tapped ${contacts[i].fullName}');
                  onContactSelected?.call(contacts[i]);
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            contacts[i].fullName,
                            style: TextStyle(color: context.primaryText),
                          ),
                          if (contacts[i].phoneNumber != null)
                            Text(
                              contacts[i].phoneNumber!,
                              style: TextStyle(
                                color: context.secondaryText,
                                fontSize: 12,
                              ),
                            ),
                        ],
                      ),
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
