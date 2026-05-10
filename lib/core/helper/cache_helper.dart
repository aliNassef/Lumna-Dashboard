import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static SharedPreferences? _prefs;

  /// Initialize SharedPreferences (call in main)
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ---------------- Save ----------------
  Future<void> saveData({
    required String key,
    required dynamic value,
  }) async {
    if (value is String) await _prefs!.setString(key, value);
    if (value is int) await _prefs!.setInt(key, value);
    if (value is bool) await _prefs!.setBool(key, value);
    if (value is double) await _prefs!.setDouble(key, value);
  }

  // ---------------- Get ----------------
  dynamic getData(
    String key,
  ) async {
    return _prefs!.get(key);
  }

  // ---------------- Remove ----------------
  Future<void> removeData(
    String key,
  ) async {
    await _prefs!.remove(key);
  }

  // ---------------- Clear ----------------
  Future<void> clearAll() async {
    await _prefs!.clear();
  }
}
