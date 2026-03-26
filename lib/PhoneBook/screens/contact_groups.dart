import 'package:flutter/cupertino.dart';

import '../data/contact_groups_model.dart';
import '../data/models/contact.dart';
import '../data/models/contact_group.dart';
import '../theme/app_theme.dart';

class ContactGroupsPage extends StatelessWidget {
  const ContactGroupsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _ContactGroupsView(
      selectedListId: 0,
      onListSelected: (list) {
        debugPrint(list.toString());
      },
    );
  }
}

// New
class _ContactGroupsView extends StatelessWidget {
  const _ContactGroupsView({required this.onListSelected, this.selectedListId});

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
                // New from here:
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

  // Inside _ContactGroupsView:

  Widget _buildTrailing(List<Contact> contacts, BuildContext context) {
    final TextStyle style = CupertinoTheme.of(
      context,
    ).textTheme.textStyle.copyWith(color: CupertinoColors.systemGrey);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(contacts.length.toString(), style: style),
        const Icon(
          CupertinoIcons.forward,
          color: CupertinoColors.systemGrey3,
          size: 18,
        ),
      ],
    );
  }
}
