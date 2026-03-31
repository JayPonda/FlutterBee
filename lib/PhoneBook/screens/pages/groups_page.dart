import 'package:flutter/cupertino.dart';

import '../../data/contact_groups_model.dart';
import '../../data/models/contact_group.dart';
import '../../theme/app_theme.dart';
import 'contacts_page.dart';

/// Reusable Groups page for small screen layouts
class GroupsPage extends StatelessWidget {
  const GroupsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _GroupsView(
      selectedListId: 0,
      onListSelected: (list) {
        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (context) => ContactsPage(listId: list.id),
          ),
        );
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
                return CupertinoListSection.insetGrouped(
                  header: const Text('iPhone'),
                  children: [
                    for (final ContactGroup contactList in contactLists)
                      CupertinoListTile(
                        leading: Icon(
                          contactList.id == 0
                              ? CupertinoIcons.group
                              : CupertinoIcons.person_2,
                          weight: 900,
                          size: 32,
                        ),
                        title: Text(contactList.label),
                        trailing: _buildTrailing(
                          contactList.contacts,
                          context,
                        ),
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

  Widget _buildTrailing(List<dynamic> contacts, BuildContext context) {
    final TextStyle style = CupertinoTheme.of(context)
        .textTheme
        .textStyle
        .copyWith(color: CupertinoColors.systemGrey);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(contacts.length.toString(), style: style),
        const SizedBox(width: 8),
        const Icon(
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
                        onTap: () => onGroupSelected?.call(group),
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
