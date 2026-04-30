import 'package:flutter/foundation.dart';

import 'package:basics/data/services/store.dart'
    if (dart.library.js_interop) 'package:basics/data/services/store_web.dart';

const _themeModeKey = 'theme_mode';

enum ThemeMode {
  light('Light'),
  dark('Dark'),
  system('System');

  final String label;
  const ThemeMode(this.label);

  static ThemeMode fromString(String value) {
    return ThemeMode.values.firstWhere(
      (mode) => mode.name == value,
      orElse: () => ThemeMode.system,
    );
  }
}

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  Future<void> init() async {
    final saved = await getStorageValue(_themeModeKey);
    if (saved != null) {
      _themeMode = ThemeMode.fromString(saved);
    }
    notifyListeners();
  }

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

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode != mode) {
      _themeMode = mode;
      await setStorageValue(_themeModeKey, mode.name);
      notifyListeners();
    }
  }

  void toggleTheme() {
    if (_themeMode == ThemeMode.light) {
      setThemeMode(ThemeMode.dark);
    } else if (_themeMode == ThemeMode.dark) {
      setThemeMode(ThemeMode.light);
    } else {
      setThemeMode(ThemeMode.light);
    }
  }
}