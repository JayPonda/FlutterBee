import 'package:flutter/foundation.dart';

/// Enum to represent theme mode options
enum ThemeMode {
  light('Light'),
  dark('Dark'),
  system('System');

  final String label;
  const ThemeMode(this.label);
}

/// Provider for managing app theme state
/// Allows toggling between light, dark, and system theme modes
class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  /// Current theme mode
  ThemeMode get themeMode => _themeMode;

  /// Check if dark mode is currently active (based on system or user preference)
  bool isDarkMode(Brightness systemBrightness) {
    switch (_themeMode) {
      case ThemeMode.light:
        return false;
      case ThemeMode.dark:
        return true;
      case ThemeMode.system:
        return systemBrightness == Brightness.dark;
    }
  }

  /// Set the theme mode
  void setThemeMode(ThemeMode mode) {
    if (_themeMode != mode) {
      _themeMode = mode;
      notifyListeners();
    }
  }

  /// Toggle between light and dark modes
  void toggleTheme() {
    if (_themeMode == ThemeMode.light) {
      setThemeMode(ThemeMode.dark);
    } else if (_themeMode == ThemeMode.dark) {
      setThemeMode(ThemeMode.light);
    } else {
      // If system, switch to light
      setThemeMode(ThemeMode.light);
    }
  }
}
