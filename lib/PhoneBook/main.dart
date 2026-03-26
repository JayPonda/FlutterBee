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
  static ThemeProvider of(BuildContext context) {
    final state = context.findAncestorStateOfType<_RolodexAppState>();
    return state?._themeProvider ?? ThemeProvider();
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

    return CupertinoApp(
      title: 'Rolodex',
      theme: isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme,
      // Configure named routes
      onGenerateRoute: generateRoute,
      // Set initial route
      initialRoute: AppRoutes.home,
      home: const AdaptiveLayout(),
    );
  }
}
