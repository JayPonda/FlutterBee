import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'package:basics/ui/core/theme/app_theme.dart';
import 'package:basics/ui/core/theme/theme_provider.dart';

/// Reusable Settings page that can be used in both small and large screen layouts
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('Settings')),
      child: _buildSettingsContent(context),
    );
  }

  Widget _buildSettingsContent(BuildContext context) {
    return Container(
      color: context.primaryBackground,
      child: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            child: CupertinoListSection.insetGrouped(
              header: const Text('App Settings'),
              children: [
                CupertinoListTile(
                  title: const Text('Notifications'),
                  trailing: CupertinoSwitch(value: true, onChanged: (value) {}),
                ),
                CupertinoListTile(
                  title: const Text('Sort Order'),
                  trailing: const Text('Last Name'),
                ),
                _buildThemeSelector(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Theme selector tile with dropdown-like functionality
  Widget _buildThemeSelector(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final currentMode = themeProvider.themeMode;

    return CupertinoListTile(
      title: const Text('Theme'),
      trailing: GestureDetector(
        onTap: () => _showThemeOptions(context, themeProvider),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              currentMode.label,
              style: TextStyle(color: context.secondaryText, fontSize: 16),
            ),
            const SizedBox(width: 8),
            Icon(
              CupertinoIcons.chevron_right,
              color: context.secondaryText,
              size: 18,
            ),
          ],
        ),
      ),
      onTap: () => _showThemeOptions(context, themeProvider),
    );
  }

  /// Show theme selection options
  void _showThemeOptions(BuildContext context, ThemeProvider themeProvider) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Select Theme'),
        actions: <CupertinoActionSheetAction>[
          for (final mode in ThemeMode.values)
            CupertinoActionSheetAction(
              isDefaultAction: themeProvider.themeMode == mode,
              onPressed: () {
                themeProvider.setThemeMode(mode);
                Navigator.pop(context);
              },
              child: Text(mode.label),
            ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDestructiveAction: true,
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ),
    );
  }
}

/// Reusable Settings content widget for master-detail layout
class SettingsContent extends StatelessWidget {
  const SettingsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.primaryBackground,
      child: CustomScrollView(
        slivers: [
          const CupertinoSliverNavigationBar(largeTitle: Text('Settings')),
          SliverFillRemaining(
            child: CupertinoListSection.insetGrouped(
              header: const Text('App Settings'),
              children: [
                CupertinoListTile(
                  title: const Text('Notifications'),
                  trailing: CupertinoSwitch(value: true, onChanged: (value) {}),
                ),
                CupertinoListTile(
                  title: const Text('Sort Order'),
                  trailing: const Text('Last Name'),
                ),
                _buildThemeSelector(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Theme selector tile with dropdown-like functionality
  Widget _buildThemeSelector(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final currentMode = themeProvider.themeMode;

    return CupertinoListTile(
      title: const Text('Theme'),
      trailing: GestureDetector(
        onTap: () => _showThemeOptions(context, themeProvider),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              currentMode.label,
              style: TextStyle(color: context.secondaryText, fontSize: 16),
            ),
            const SizedBox(width: 8),
            Icon(
              CupertinoIcons.chevron_right,
              color: context.secondaryText,
              size: 18,
            ),
          ],
        ),
      ),
      onTap: () => _showThemeOptions(context, themeProvider),
    );
  }

  /// Show theme selection options
  void _showThemeOptions(BuildContext context, ThemeProvider themeProvider) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Select Theme'),
        actions: <CupertinoActionSheetAction>[
          for (final mode in ThemeMode.values)
            CupertinoActionSheetAction(
              isDefaultAction: themeProvider.themeMode == mode,
              onPressed: () {
                themeProvider.setThemeMode(mode);
                Navigator.pop(context);
              },
              child: Text(mode.label),
            ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDestructiveAction: true,
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ),
    );
  }
}
