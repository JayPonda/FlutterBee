import 'dart:html' as html;

Future<String?> getStorageValue(String key) {
  final storage = html.window.localStorage;
  return Future.value(storage[key]);
}

Future<void> setStorageValue(String key, String value) async {
  final storage = html.window.localStorage;
  storage[key] = value;
}