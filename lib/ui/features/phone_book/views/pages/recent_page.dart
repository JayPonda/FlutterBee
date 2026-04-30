import 'package:flutter/cupertino.dart';

import 'package:basics/ui/core/theme/app_theme.dart';

/// Reusable Recent page for small screen layouts
class RecentPage extends StatelessWidget {
  const RecentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('Recent')),
      child: _RecentContent(),
    );
  }
}

/// Reusable Recent content for master-detail layout
class RecentContent extends StatelessWidget {
  const RecentContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.primaryBackground,
      child: CustomScrollView(
        slivers: [
          const CupertinoSliverNavigationBar(largeTitle: Text('Recent')),
          SliverFillRemaining(child: _RecentContent()),
        ],
      ),
    );
  }
}

class _RecentContent extends StatelessWidget {
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
