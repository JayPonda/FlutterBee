import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'package:basics/domain/models/recent_call.dart';
import 'package:basics/ui/core/theme/app_theme.dart';
import 'package:basics/ui/core/utils/dialog_helper.dart';
import 'package:basics/ui/core/utils/url_helper.dart';
import 'package:basics/ui/features/phone_book/view_models/contact_view_model.dart';
import 'contact_detail_page.dart';

/// Reusable Recent page for small screen layouts
class RecentPage extends StatelessWidget {
  const RecentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('Recent')),
      child: const RecentContent(),
    );
  }
}

/// Reusable Recent content for master-detail layout
class RecentContent extends StatelessWidget {
  const RecentContent({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ContactViewModel>();

    return Container(
      color: context.primaryBackground,
      child: ValueListenableBuilder<List<RecentCall>>(
        valueListenable: viewModel.recentsNotifier,
        builder: (context, recents, child) {
          if (recents.isEmpty) {
            return _EmptyRecent();
          }

          final groupedRecents = _groupCallsByDate(recents);
          final sortedDates = groupedRecents.keys.toList()
            ..sort((a, b) => b.compareTo(a));

          return CustomScrollView(
            slivers: [
              const CupertinoSliverNavigationBar(largeTitle: Text('Recent')),
              for (final date in sortedDates)
                SliverToBoxAdapter(
                  child: CupertinoListSection.insetGrouped(
                    backgroundColor: context.primaryBackground,
                    margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    header: Text(
                      _getDateHeader(date),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: context.primaryText,
                      ),
                    ),
                    children: [
                      for (final recent in groupedRecents[date]!)
                        CupertinoListTile(
                          title: Text(recent.contact.fullName),
                          subtitle: Text(
                            _formatTime(recent.calledAt),
                            style: TextStyle(
                              fontSize: 12,
                              color: context.secondaryText,
                            ),
                          ),
                          trailing: CupertinoButton(
                            padding: EdgeInsets.zero,
                            child: const Icon(CupertinoIcons.phone_fill),
                            onPressed: () async {
                              final confirmed =
                                  await DialogHelper.showCallConfirmation(
                                context,
                                recent.contact.fullName,
                              );
                              if (confirmed && context.mounted) {
                                await viewModel
                                    .addRecentCall(recent.contact.id);
                                UrlHelper.makeCall(
                                    recent.contact.phoneNumber!);
                              }
                            },
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              CupertinoPageRoute<void>(
                                builder: (BuildContext context) =>
                                    ContactDetailPage(contact: recent.contact),
                              ),
                            );
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

  Map<DateTime, List<RecentCall>> _groupCallsByDate(List<RecentCall> calls) {
    final Map<DateTime, List<RecentCall>> grouped = {};
    for (final call in calls) {
      final date = DateTime(
          call.calledAt.year, call.calledAt.month, call.calledAt.day);
      if (grouped[date] == null) {
        grouped[date] = [];
      }
      grouped[date]!.add(call);
    }
    return grouped;
  }

  String _getDateHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    if (date == today) return 'Today';
    if (date == yesterday) return 'Yesterday';

    final monthNames = [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return '${date.day} ${monthNames[date.month]} ${date.year}';
  }

  String _formatTime(DateTime date) {
    final hour = date.hour == 0
        ? 12
        : (date.hour > 12 ? date.hour - 12 : date.hour);
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }
}

class _EmptyRecent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
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
            style: TextStyle(fontSize: 14, color: CupertinoColors.systemGrey2),
          ),
        ],
      ),
    );
  }
}
