import 'package:shared_preferences/shared_preferences.dart';

class PreferenceManager {
  static SharedPreferences? _prefs;
  static Future<void> initialize() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static String? getString(String key) {
    return _prefs?.getString(key);
  }

  static SharedPreferences getPref() {
    return _prefs!;
  }

  static Future<bool> setString(String key, String value) {
    return _prefs?.setString(key, value) ?? Future.value(false);
  }

  static bool? getBool(String key) {
    return _prefs?.getBool(key);
  }

  static Future<bool> setBool(String key, bool value) {
    return _prefs?.setBool(key, value) ?? Future.value(false);
  }
}
