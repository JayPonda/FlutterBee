import 'package:flutter/cupertino.dart';

import '../../theme/app_theme.dart';

/// Reusable Favorites page for small screen layouts
class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('Favorites')),
      child: _FavoritesContent(),
    );
  }
}

/// Reusable Favorites content for master-detail layout
class FavoritesContent extends StatelessWidget {
  const FavoritesContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.primaryBackground,
      child: CustomScrollView(
        slivers: [
          const CupertinoSliverNavigationBar(largeTitle: Text('Favorites')),
          SliverFillRemaining(child: _FavoritesContent()),
        ],
      ),
    );
  }
}

class _FavoritesContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
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
            style: TextStyle(fontSize: 14, color: CupertinoColors.systemGrey2),
          ),
        ],
      ),
    );
  }
}
