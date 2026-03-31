import 'package:flutter/cupertino.dart';

import '../data/contact_groups_model.dart';
import '../data/models/contact.dart';
import '../data/models/contact_group.dart';
import '../theme/app_theme.dart';

// ============= CONTACTS =============

/// Reusable Contacts page for small screen layouts
class ContactsPage extends StatelessWidget {
  const ContactsPage({super.key, required this.listId});

  final int listId;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: ValueListenableBuilder<List<ContactGroup>>(
        valueListenable: contactGroupsModel.listsNotifier,
        builder: (context, contactGroups, child) {
          final ContactGroup contactList = contactGroupsModel.findContactList(
            listId,
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
                    (String initial) => ContactListSection(
                      lastInitial: initial,
                      contacts: contacts[initial]!,
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
                    widget.onContactSelected?.call(contact);
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

// ============= GROUPS =============

/// Reusable Groups page for small screen layouts
class GroupsPage extends StatelessWidget {
  const GroupsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _GroupsView(
      selectedListId: 0,
      onListSelected: (list) {
        debugPrint(list.toString());
      },
    );
  }
}

class _GroupsView extends StatelessWidget {
  const _GroupsView({required this.onListSelected, this.selectedListId});

  final int? selectedListId;
  final Function(ContactGroup) onListSelected;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: context.primaryBackground,
      child: CustomScrollView(
        slivers: [
          const CupertinoSliverNavigationBar(largeTitle: Text('Lists')),
          SliverFillRemaining(
            child: ValueListenableBuilder<List<ContactGroup>>(
              valueListenable: contactGroupsModel.listsNotifier,
              builder: (context, contactLists, child) {
                const groupIcon = Icon(
                  CupertinoIcons.group,
                  weight: 900,
                  size: 32,
                );

                const pairIcon = Icon(
                  CupertinoIcons.person_2,
                  weight: 900,
                  size: 24,
                );

                return CupertinoListSection.insetGrouped(
                  header: const Text('iPhone'),
                  children: [
                    for (final ContactGroup contactList in contactLists)
                      CupertinoListTile(
                        leading: contactList.id == 0 ? groupIcon : pairIcon,
                        title: Text(contactList.label),
                        trailing: _buildTrailing(contactList.contacts, context),
                        onTap: () => onListSelected(contactList),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrailing(List<Contact> contacts, BuildContext context) {
    final TextStyle style = CupertinoTheme.of(
      context,
    ).textTheme.textStyle.copyWith(color: CupertinoColors.systemGrey);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(contacts.length.toString(), style: style),
        const SizedBox(width: 8),
        Icon(
          CupertinoIcons.forward,
          color: CupertinoColors.systemGrey,
          size: 16,
        ),
      ],
    );
  }
}

/// Reusable Groups content for master-detail layout
class GroupsContent extends StatelessWidget {
  const GroupsContent({super.key, this.onGroupSelected});

  final Function(ContactGroup)? onGroupSelected;

  @override
  Widget build(BuildContext context) {
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
                          onGroupSelected?.call(group);
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
}

// ============= NAVIGATION =============

/// Reusable Navigation page for small screen layouts
class NavigationPage extends StatelessWidget {
  const NavigationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('Navigation')),
      child: _NavigationContent(),
    );
  }
}

/// Reusable Navigation content for master-detail layout
class NavigationContent extends StatelessWidget {
  const NavigationContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.primaryBackground,
      child: CustomScrollView(
        slivers: [
          const CupertinoSliverNavigationBar(largeTitle: Text('Navigation')),
          SliverFillRemaining(child: _NavigationContent()),
        ],
      ),
    );
  }
}

class _NavigationContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            CupertinoIcons.forward,
            size: 60,
            color: CupertinoColors.systemGrey3,
          ),
          const SizedBox(height: 12),
          Text(
            'Navigation Examples',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: CupertinoColors.systemGrey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap items to navigate',
            style: TextStyle(fontSize: 14, color: CupertinoColors.systemGrey2),
          ),
        ],
      ),
    );
  }
}

// ============= FAVORITES & RECENT =============

/// Reusable Favorites content for both layouts
class FavoritesContent extends StatelessWidget {
  final bool useLargeTitle;

  const FavoritesContent({super.key, this.useLargeTitle = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.primaryBackground,
      child: CustomScrollView(
        slivers: [
          if (useLargeTitle)
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
}

/// Reusable Recent content for both layouts
class RecentContent extends StatelessWidget {
  final bool useLargeTitle;

  const RecentContent({super.key, this.useLargeTitle = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.primaryBackground,
      child: CustomScrollView(
        slivers: [
          if (useLargeTitle)
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
}

// ============= HELPER WIDGETS =============

/// Contact list section for Contacts page
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
