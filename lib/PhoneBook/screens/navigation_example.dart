import 'package:flutter/cupertino.dart';

import '../data/contact_groups_model.dart';
import '../main.dart';
import '../theme/app_theme.dart';
import '../theme/theme_provider.dart';
import 'contact_detail.dart';

/// Navigation example page demonstrating different navigation patterns
/// Follows the Flutter navigation tutorial patterns
class NavigationExamplePage extends StatelessWidget {
  const NavigationExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Navigation Examples'),
        trailing: _buildThemeToggleButton(context),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Theme Selector Section
              _buildThemeSelectorSection(context),
              const SizedBox(height: 24),

              // Example 1: Imperative Navigation (push)
              _NavSection(
                title: '1. Imperative Navigation (Push)',
                description:
                    'Navigate to a new screen and add it to the navigation stack.',
                onTap: () {
                  final firstContact = contactGroupsModel
                      .listsNotifier
                      .value
                      .first
                      .contacts
                      .first;
                  Navigator.of(context).push(
                    CupertinoPageRoute<void>(
                      builder: (context) =>
                          ContactDetailPage(contact: firstContact),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),

              // Example 2: Named Routes (push)
              _NavSection(
                title: '2. Named Routes (Push)',
                description:
                    'Navigate using named routes with optional arguments.',
                onTap: () {
                  final firstContact =
                      contactGroupsModel.listsNotifier.value.first.contacts[1];
                  Navigator.pushNamed(
                    context,
                    '/contact-detail',
                    arguments: firstContact,
                  );
                },
              ),
              const SizedBox(height: 16),

              // Example 3: Replace Navigation
              _NavSection(
                title: '3. Replace Navigation',
                description:
                    'Replace the current route with a new route (removes previous from stack).',
                onTap: () {
                  final firstContact =
                      contactGroupsModel.listsNotifier.value.first.contacts[2];
                  Navigator.of(context).pushReplacement(
                    CupertinoPageRoute<void>(
                      builder: (context) =>
                          ContactDetailPage(contact: firstContact),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),

              // Example 4: Pop Navigation
              _NavSection(
                title: '4. Pop Navigation (Back)',
                description:
                    'Return to the previous screen in the navigation stack.',
                enabled: Navigator.of(
                  context,
                ).canPop(), // Only show if there's a page to go back to
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              const SizedBox(height: 16),

              // Example 5: PopUntil Navigation
              _NavSection(
                title: '5. Pop Until Navigation',
                description:
                    'Pop routes from the stack until a condition is met.',
                enabled: Navigator.of(
                  context,
                ).canPop(), // Only show if there's a page to go back to
                onTap: () {
                  // Pop until we reach the home route
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
              ),
              const SizedBox(height: 16),

              // Example 6: Push and Pop Result
              _NavSection(
                title: '6. Push with Result',
                description:
                    'Navigate to a page and handle the result when returning.',
                onTap: () async {
                  final firstContact =
                      contactGroupsModel.listsNotifier.value.first.contacts[3];
                  final result = await Navigator.of(context).push<String>(
                    CupertinoPageRoute<String>(
                      builder: (context) =>
                          ContactDetailPage(contact: firstContact),
                    ),
                  );
                  // Handle result here
                  if (result != null) {
                    debugPrint('Result from navigation: $result');
                  }
                },
              ),
              const SizedBox(height: 24),

              // Info section
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: context.tertiaryBackground,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: context.dividerColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Navigation Patterns Demonstrated:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '• push(): Add a new route to the stack\n'
                      '• pushNamed(): Push a named route with arguments\n'
                      '• pushReplacement(): Replace current route\n'
                      '• pop(): Return to previous screen\n'
                      '• popUntil(): Pop multiple routes conditionally\n'
                      '• Returning values from routes',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build theme toggle button for the navigation bar
  Widget _buildThemeToggleButton(BuildContext context) {
    final themeProvider = RolodexApp.of(context);
    return CupertinoButton(
      padding: const EdgeInsets.all(8),
      onPressed: () => _showThemeOptions(context, themeProvider),
      child: Icon(
        themeProvider.themeMode == ThemeMode.dark
            ? CupertinoIcons.moon_fill
            : themeProvider.themeMode == ThemeMode.light
            ? CupertinoIcons.sun_max_fill
            : CupertinoIcons.circle_fill,
      ),
    );
  }

  /// Build theme selector section
  Widget _buildThemeSelectorSection(BuildContext context) {
    final themeProvider = RolodexApp.of(context);
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: context.secondaryBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Theme Settings',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: context.primaryText,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                'Current: ${themeProvider.themeMode.label}',
                style: TextStyle(color: context.secondaryText),
              ),
              const Spacer(),
              CupertinoButton(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                color: CupertinoColors.systemBlue,
                onPressed: () => _showThemeOptions(context, themeProvider),
                child: const Text('Change'),
              ),
            ],
          ),
        ],
      ),
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

/// Reusable navigation section widget
class _NavSection extends StatelessWidget {
  const _NavSection({
    required this.title,
    required this.description,
    required this.onTap,
    this.enabled = true,
  });

  final String title;
  final String description;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: enabled
              ? CupertinoColors.systemBlue
              : context.secondaryBackground,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: enabled ? CupertinoColors.white : context.secondaryText,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(
                fontSize: 12,
                color: enabled
                    ? CupertinoColors.white.withOpacity(0.9)
                    : context.secondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
