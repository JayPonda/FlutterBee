import 'package:shared_preferences/shared_preferences.dart';

Future<String?> getStorageValue(String key) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(key);
}

Future<void> setStorageValue(String key, String value) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(key, value);
}