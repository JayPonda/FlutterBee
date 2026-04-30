import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';

/// App-wide theme configuration supporting light and dark modes
class AppTheme {
  // Private constructor
  AppTheme._();

  /// Light theme for CupertinoApp
  static CupertinoThemeData get lightTheme {
    return const CupertinoThemeData(
      brightness: Brightness.light,
      primaryColor: CupertinoColors.systemBlue,
      barBackgroundColor: CupertinoColors.systemBackground,
      scaffoldBackgroundColor: CupertinoColors.systemBackground,
      textTheme: CupertinoTextThemeData(
        navTitleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: CupertinoColors.black,
        ),
      ),
    );
  }

  /// Dark theme for CupertinoApp
  static CupertinoThemeData get darkTheme {
    return const CupertinoThemeData(
      brightness: Brightness.dark,
      primaryColor: CupertinoColors.systemBlue,
      barBackgroundColor: CupertinoColors.black,
      scaffoldBackgroundColor: CupertinoColors.black,
      textTheme: CupertinoTextThemeData(
        navTitleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: CupertinoColors.white,
        ),
      ),
    );
  }
}

/// Semantic colors for Light Mode
class LightModeColors {
  static const Color primaryText = CupertinoColors.black;
  static const Color secondaryText = CupertinoColors.systemGrey;
  static const Color tertiaryText = CupertinoColors.systemGrey2;

  static const Color primaryBackground = CupertinoColors.white;
  static const Color secondaryBackground = CupertinoColors.systemGrey6;
  static const Color tertiaryBackground = CupertinoColors.systemGrey5;

  static const Color divider = CupertinoColors.systemGrey4;
  static const Color accent = CupertinoColors.systemBlue;
  static const Color success = CupertinoColors.systemGreen;
  static const Color warning = CupertinoColors.systemOrange;
  static const Color error = CupertinoColors.systemRed;
}

/// Semantic colors for Dark Mode
class DarkModeColors {
  static const Color primaryText = CupertinoColors.white;
  static const Color secondaryText = CupertinoColors.systemGrey;
  static const Color tertiaryText = CupertinoColors.systemGrey2;

  static const Color primaryBackground = CupertinoColors.black;
  static const Color secondaryBackground = Color(0xFF1C1C1E); // iOS systemBackground
  static const Color tertiaryBackground = Color(0xFF2C2C2E); // iOS secondarySystemBackground

  static const Color divider = Color(0xFF38383A);
  static const Color accent = CupertinoColors.systemBlue;
  static const Color success = CupertinoColors.systemGreen;
  static const Color warning = CupertinoColors.systemOrange;
  static const Color error = CupertinoColors.systemRed;
}

/// Extension for easy theme-aware color access
extension ThemeAwareColors on BuildContext {
  /// Check if dark mode is enabled based on the app's theme setting
  bool get isDarkMode {
    try {
      // Get the app's theme provider using Provider
      final themeProvider = read<ThemeProvider>();
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
