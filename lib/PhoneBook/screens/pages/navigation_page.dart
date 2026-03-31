import 'package:flutter/cupertino.dart';

import '../../theme/app_theme.dart';

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
