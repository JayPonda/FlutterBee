import 'package:basics/PhoneBook/screens/app_routes.dart';
import 'package:basics/PhoneBook/screens/adaptive_layout.dart';
import 'package:basics/PhoneBook/theme/app_theme.dart';
import 'package:basics/PhoneBook/theme/theme_provider.dart';
import 'package:flutter/cupertino.dart';

class RolodexApp extends StatefulWidget {
  const RolodexApp({super.key});

  @override
  State<RolodexApp> createState() => _RolodexAppState();

  /// Access the theme provider from anywhere in the app
  /// Using dependOnInheritedWidgetOfExactType ensures that the calling widget
  /// will rebuild when the ThemeProvider notifies listeners.
  static ThemeProvider of(BuildContext context) {
    final inherited =
        context.dependOnInheritedWidgetOfExactType<_ThemeInheritedWidget>();
    return inherited?.themeProvider ?? ThemeProvider();
  }
}

/// InheritedWidget to provide the ThemeProvider and trigger rebuilds
class _ThemeInheritedWidget extends InheritedWidget {
  final ThemeProvider themeProvider;

  const _ThemeInheritedWidget({
    required this.themeProvider,
    required super.child,
  });

  @override
  bool updateShouldNotify(_ThemeInheritedWidget oldWidget) {
    // Rebuild whenever the provider's properties might have changed
    // Since we're using a ChangeNotifier, we actually rely on it notifying its listeners
    // But we still want to return true here to ensure that if the provider instance
    // itself changes (though it shouldn't in this case), children will rebuild.
    return true;
  }
}

class _RolodexAppState extends State<RolodexApp> {
  late ThemeProvider _themeProvider;

  @override
  void initState() {
    super.initState();
    _themeProvider = ThemeProvider();
    _themeProvider.addListener(_onThemeChanged);
  }

  @override
  void dispose() {
    _themeProvider.removeListener(_onThemeChanged);
    _themeProvider.dispose();
    super.dispose();
  }

  void _onThemeChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Get system brightness for theme selection
    final brightness = MediaQuery.platformBrightnessOf(context);
    final isDarkMode = _themeProvider.isDarkMode(brightness);

    return _ThemeInheritedWidget(
      themeProvider: _themeProvider,
      child: CupertinoApp(
        title: 'Rolodex',
        theme: isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme,
        // Configure named routes
        onGenerateRoute: generateRoute,
        // Set initial route
        initialRoute: AppRoutes.home,
        home: const AdaptiveLayout(),
      ),
    );
  }
}
