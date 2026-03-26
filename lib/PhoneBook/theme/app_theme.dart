import 'package:flutter/cupertino.dart';

import '../main.dart';

/// App-wide theme configuration supporting light and dark modes
class AppTheme {
  // Private constructor
  AppTheme._();

  /// Light theme for CupertinoApp
  static CupertinoThemeData get lightTheme {
    return CupertinoThemeData(
      brightness: Brightness.light,
      primaryColor: CupertinoColors.systemBlue,
      barBackgroundColor: CupertinoColors.systemBackground,
      scaffoldBackgroundColor: CupertinoColors.systemBackground,
      textTheme: CupertinoTextThemeData(
        navTitleTextStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: CupertinoColors.black,
          inherit: false,
        ),
        navLargeTitleTextStyle: const TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.w700,
          color: CupertinoColors.black,
          inherit: false,
        ),
        tabLabelTextStyle: const TextStyle(
          fontSize: 10,
          color: CupertinoColors.systemGrey,
          inherit: false,
        ),
        pickerTextStyle: const TextStyle(
          fontSize: 21,
          color: CupertinoColors.black,
          inherit: false,
        ),
        dateTimePickerTextStyle: const TextStyle(
          fontSize: 21,
          color: CupertinoColors.black,
          inherit: false,
        ),
      ),
    );
  }

  /// Dark theme for CupertinoApp
  static CupertinoThemeData get darkTheme {
    return CupertinoThemeData(
      brightness: Brightness.dark,
      primaryColor: CupertinoColors.systemBlue,
      barBackgroundColor: const Color(0xFF1C1C1E),
      scaffoldBackgroundColor: CupertinoColors.black,
      textTheme: CupertinoTextThemeData(
        navTitleTextStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: CupertinoColors.white,
          inherit: false,
        ),
        navLargeTitleTextStyle: const TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.w700,
          color: CupertinoColors.white,
          inherit: false,
        ),
        tabLabelTextStyle: const TextStyle(
          fontSize: 10,
          color: CupertinoColors.systemGrey,
          inherit: false,
        ),
        pickerTextStyle: const TextStyle(
          fontSize: 21,
          color: CupertinoColors.white,
          inherit: false,
        ),
        dateTimePickerTextStyle: const TextStyle(
          fontSize: 21,
          color: CupertinoColors.white,
          inherit: false,
        ),
      ),
    );
  }
}

/// Color palette for light mode
class LightModeColors {
  static const Color primaryBackground = CupertinoColors.systemBackground;
  static const Color secondaryBackground = Color(0xFFF2F2F7);
  static const Color tertiaryBackground = Color(0xFFFFFFFF);

  static const Color primaryText = CupertinoColors.black;
  static const Color secondaryText = CupertinoColors.systemGrey;
  static const Color tertiaryText = CupertinoColors.systemGrey2;

  static const Color divider = CupertinoColors.separator;
  static const Color accent = CupertinoColors.systemBlue;
  static const Color success = CupertinoColors.systemGreen;
  static const Color warning = CupertinoColors.systemOrange;
  static const Color error = CupertinoColors.systemRed;
}

/// Color palette for dark mode
class DarkModeColors {
  static const Color primaryBackground = CupertinoColors.black;
  static const Color secondaryBackground = Color(0xFF1C1C1E);
  static const Color tertiaryBackground = Color(0xFF2C2C2E);

  static const Color primaryText = CupertinoColors.white;
  static const Color secondaryText = CupertinoColors.systemGrey;
  static const Color tertiaryText = CupertinoColors.systemGrey3;

  static const Color divider = Color(0xFF3A3A3C);
  static const Color accent = CupertinoColors.systemBlue;
  static const Color success = CupertinoColors.systemGreen;
  static const Color warning = CupertinoColors.systemOrange;
  static const Color error = CupertinoColors.systemRed;
}

/// Extension for easy theme-aware color access
extension ThemeAwareColors on BuildContext {
  /// Import theme_provider to access the actual app theme mode
  // import '../main.dart' is needed to use RolodexApp.of(context)

  /// Check if dark mode is enabled based on the app's theme setting
  bool get isDarkMode {
    try {
      // Get the app's theme provider
      final themeProvider = RolodexApp.of(this);
      final systemBrightness = MediaQuery.platformBrightnessOf(this);
      return themeProvider.isDarkMode(systemBrightness);
    } catch (e) {
      // Fallback to system brightness if theme provider is not available
      return MediaQuery.platformBrightnessOf(this) == Brightness.dark;
    }
  }

  /// Get appropriate background color based on theme
  Color get primaryBackground {
    return isDarkMode
        ? DarkModeColors.primaryBackground
        : LightModeColors.primaryBackground;
  }

  Color get secondaryBackground {
    return isDarkMode
        ? DarkModeColors.secondaryBackground
        : LightModeColors.secondaryBackground;
  }

  Color get tertiaryBackground {
    return isDarkMode
        ? DarkModeColors.tertiaryBackground
        : LightModeColors.tertiaryBackground;
  }

  /// Get appropriate text color based on theme
  Color get primaryText {
    return isDarkMode
        ? DarkModeColors.primaryText
        : LightModeColors.primaryText;
  }

  Color get secondaryText {
    return isDarkMode
        ? DarkModeColors.secondaryText
        : LightModeColors.secondaryText;
  }

  Color get tertiaryText {
    return isDarkMode
        ? DarkModeColors.tertiaryText
        : LightModeColors.tertiaryText;
  }

  /// Get semantic colors
  Color get dividerColor {
    return isDarkMode ? DarkModeColors.divider : LightModeColors.divider;
  }

  Color get accentColor {
    return isDarkMode ? DarkModeColors.accent : LightModeColors.accent;
  }
}
